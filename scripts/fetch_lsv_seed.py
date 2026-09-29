#!/usr/bin/env python3
"""Regenerate the full LSV (Literal Standard Version, 2020) seed from the
Covenant Press USFM release (BibleCorps/ENG-B-LSV2022-CC-CCC on GitHub).

The LSV is NOT public domain: it is © Covenant Press / Covenant Christian
Coalition, released under Creative Commons Attribution-ShareAlike (CC BY-SA).
Bundling the verbatim text with attribution is permitted; the app registers it
with license_status "cc_by_sa" and the required attribution notice.

Output: seed_verses_lsv.json, translation_id 5, ids 5,000,001+, verse_ref built
from the app's book short-names. A minimal USFM parser extracts verse text:
footnotes (\\f..\\f*), cross-refs (\\x..\\x*) and headings (\\s,\\d,..) are
dropped; character markers (\\add supplied words, \\nd, \\wj, \\w) keep their
inner text. Derived fields replicate LongVerseService.

Usage:  python3 scripts/fetch_lsv_seed.py
"""
import json, os, re, tempfile, urllib.parse

from _download import download, fetch_verified

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(ROOT, "WordUnlocked", "Resources")
REPO = "BibleCorps/ENG-B-LSV2022-CC-CCC"
COMMIT = "0f9ad6b97b2dc19efc21194ba9d92f3c97345960"  # main as of 2026-09-27
TRANSLATION_ID = 5
ID_BASE = 5_000_000

# Canonical 66-book USFM codes in Protestant order -> book_id = index + 1
USFM_ORDER = [
    "GEN","EXO","LEV","NUM","DEU","JOS","JDG","RUT","1SA","2SA","1KI","2KI",
    "1CH","2CH","EZR","NEH","EST","JOB","PSA","PRO","ECC","SNG","ISA","JER",
    "LAM","EZK","DAN","HOS","JOL","AMO","OBA","JON","MIC","NAM","HAB","ZEP",
    "HAG","ZEC","MAL","MAT","MRK","LUK","JHN","ACT","ROM","1CO","2CO","GAL",
    "EPH","PHP","COL","1TH","2TH","1TI","2TI","TIT","PHM","HEB","JAS","1PE",
    "2PE","1JN","2JN","3JN","JUD","REV",
]
CODE_TO_BOOKID = {c: i + 1 for i, c in enumerate(USFM_ORDER)}

# SHA-256 of each book's USFM file at COMMIT, by USFM code (pinned 2026-09-27).
SHA256 = {
    "GEN": "e3c67da44c74abe95a07068d9f57b284fe03d2bc71ab2b9ff7971c7f1c4a9b08",
    "EXO": "cec5250245845291ff0d85533fcd78b30367a08b32f7924846d3c285b6d27e4a",
    "LEV": "daf303c75449c8a9bafa96642a19aca6657e6296f56f6de1f2d75ad677a148a7",
    "NUM": "e7dbfa25770c3a11df19fe0eac3efef2fa1c75fdeaf08df4b1d3235186f7384e",
    "DEU": "4a5b6de9349464f6d5fc06a0aa0c1c8876a92db0ca7c9ca7e13a4d91cb19e635",
    "JOS": "dc3eeb3df801cd131d92327a26d331f5651fd200fbc30e13d52a6aa2e0699234",
    "JDG": "9d4fd6b64f9416fb807150367fb2b459e5016f3301abbdbfa766c77b8d7ab210",
    "RUT": "5e0296b4b59346a3c9d83cba3c0faf1d294e5d6effaf017fe2d190d30e8ac1d3",
    "1SA": "000a22e8eb614342e9ccf4b045b5f354d31476acf760eb071552c549f2a4dd39",
    "2SA": "f3bdd473bd31160a584b276d4e504bc96a0277152d022c45b21904dd2dc5726b",
    "1KI": "c18d0a24db3199401233dab78a2b99839e0cdee2c47168a734ce7ba61f0d56ed",
    "2KI": "cd4335583d2e1fde6857bd41348c7eca252568049b3baab489b79d5bcb3f7d11",
    "1CH": "e4bbc7975cb8895c5a7f2f3ff5db979031451cfbec0cce36f34a3278f0670aaa",
    "2CH": "b9b2d8c9143170accfc19aeb963f7d7b34a4536a07fbb1a979f7d688a0fd4506",
    "EZR": "2069021241de6a1e523fcdd5f1a6fb5d8f7028d7fb01898eac156c03bafb9d06",
    "NEH": "847215278dc5c9b88c9d07518942febd7555e0040fbe6120a069619d5e50f2d3",
    "EST": "f3456146197d4d1167a3cc6b4611a5d26c14a3d2fcb215b4bba24ba2e6e1423f",
    "JOB": "928ce6bd335df3d26f89101237db5816c6d6086a4c64fdd14fe2b98bd5b30197",
    "PSA": "a1fcd70b39a439bdf915fee31d1bee7b1558f272b6e99761eb780fe54de1239b",
    "PRO": "7bb712b1751e52304b9c89c50b9a6e26a21b576ef2672855adac830a80d8d95e",
    "ECC": "a5c40d2cb9ec6e9040635b0380b36adb74e642f7bb5ee9e04768f4d469598144",
    "SNG": "aed568629cdbe994d776af2c3e798d71788985b7e6e1675b08871731d498c0b1",
    "ISA": "7851e364e9aa5c68879b21abeab373a06a9e7adf4e9473cb71f68ff66cbabfe7",
    "JER": "00484c8db379f082f1b969be26d907a392b1367cb952ac4d73a1bf7ade8de1d0",
    "LAM": "b086e9a3f6bddde7f06d5c69b1453dbbe1875540d21b94498806b91ea7498228",
    "EZK": "78ac758f05f97e796abc3cab3c1483cab67f9629cc066882dd89594c6d470e02",
    "DAN": "ec6890121797316cf49e2d30f5aa5771c313fe9628c35ddaf8041c32013c4077",
    "HOS": "c5872774e398cdeb962fe0360914c6d2ad53b736698f5eba0d80816432c45028",
    "JOL": "42717ba45a5c5381dc7818042b2b55cb74901e61d2ebdaca743e9a7985b6ed67",
    "AMO": "86f91492efc9b28878e3ce58b36753dc3832f60a3668a5badc76059afdf2213f",
    "OBA": "26d8b0f1cbffcc968d60b6786e1c1583d3fd9715547bd84ae57b601df29d9dbc",
    "JON": "1b6ffea856574fe41ac5ab78a22cc7a24e7e44157b35d7f5b09ac3d496d4ca57",
    "MIC": "add257b6dbb322d3f61ababf807bb14c3c5f8d705d7f21b35f34264a1ca87b0f",
    "NAM": "29c32dad0b8ad768287ec5631c3dcd823cbbaad82617c0342f59f049779305a9",
    "HAB": "3d823d5297ab3372eaa3fcee6dc242d8f79596e3f859999587df688f4bfa80db",
    "ZEP": "47f665c28409ea7e9b854ba6679c40b67bbfc45d6098661ee6e6bd98106b3349",
    "HAG": "b11571475878672d6322f3194ceab0f7fbf57e5bd4e934f2f325c30f5996e44a",
    "ZEC": "6f37bf948d18b4a550d5225e306026cd1650a9e15694fe3ed3d046f617a99d61",
    "MAL": "f20f8e5e979b73b45d41927653660b37fc7a69941881fc3a103bebc113b8cde3",
    "MAT": "f13696c21ec4284a025ccbc9114fdef67cfd3a9e94010c34daf4ddb23b9b6fad",
    "MRK": "2e07f55e366ac34cdccf9c397b4bf96bc6e0e853146888238457e9af64d76e67",
    "LUK": "d7620bfd63de4f54d98e4a6f8c6692bf392c709b0b5a4deedab26b78206a2cea",
    "JHN": "540a71fb0a0d316820cdf16c6ae87b6114204564497aca9a9f60b31bcffe2802",
    "ACT": "6ed5ece78abe9e8d5c3a3d2c5bfcd80c182609ced23d7eaa67f9a7c70f309af6",
    "ROM": "3bcbc2d97d8e5dc291150856d9ec22a0eaf4e4500d1dd07cc6b0dbd2763eeeb9",
    "1CO": "6e8cc317aeacffebfad3ee8e5da66f569f1f7d183b8dc45161a8c853310d7102",
    "2CO": "3c1f31aff5d34c532bb2adeeeaa62ceda6e1b8d5d61f7bb0298445835282317a",
    "GAL": "3f0ed6c78918b28d8fe9089d78330907a937e46cddfea1c23f0c44cc0173c156",
    "EPH": "97d41189fbd8ab57819cd36964ea4668622bedc7ea13640587df87ea3d3f8712",
    "PHP": "00c3f963203cbd33c369e2faa6e53bf2c46c8c0b8919f47bcde5f1d8ad1883e3",
    "COL": "bb89db21ec3b79e8b023606572eb0a9ce9e241e66079ac316dbdf5d1ab25c49a",
    "1TH": "3a2339799465465bd2e0f2bb919a4c8e2c28434f46c5957819216203aef86a2e",
    "2TH": "38f614a57c4375e2a84ff975fa025cdcf9d5bda6b1bbcd41bab43f4f06b3625c",
    "1TI": "481b3fa538ab8f420b981e6e8f31c1ff810fa3c04aa3e852f90cdcec53413cf1",
    "2TI": "b20bdeb83af7d77a511ba1d7f983b8021a3a370727bdb5d1efd5e008b28f4d37",
    "TIT": "c3c8675df6dd0d9e5c2ccdb5cb89030e2f77658cafd0ce98b52f607a27c7c9c8",
    "PHM": "e9d375a0dffbd3ceb28bff68b5347fb4479bd3f54848e884f5687568838bae2c",
    "HEB": "9300b7d127c367ac003bfc2d558164c538a50ffbd7e1d03cbf0766d20d64fcd4",
    "JAS": "5eb26cf8cc36f2d1e117ff8a8ed92a824d7e42917a7bcc254b828e34880829d4",
    "1PE": "5fa0387b3d59712797d5340afc75a83825ee5428b2e7af7df1bffadebcd59887",
    "2PE": "3afe4aaba7c8feae6504be641fd2304328593f852ac1947f253466fe5b184743",
    "1JN": "4be7b321f200fedc6d4d165a5d1464ac73507e5eebe643acdbb62f7e6907d9eb",
    "2JN": "a2f4ee11e1d471338414d68ac04f5786c2cb29dccfe885bb14b65559e16e142e",
    "3JN": "a1b95d7e018d97657af4cf9c9761e9431ac81148861b486df2461107987ae6fd",
    "JUD": "accece036aa569de4ee40a9067595cd51406a88d3a4e98174c5f76fcf63eb87a",
    "REV": "9ee93e95760897df03321f54279bdf2c6f21de7fe266e94bb55ba9527bb7284b",
}

# Heading/identification markers whose text runs to end of line and is NOT verse
# content (superscriptions \d included — they are unnumbered titles, not verses).
HEADING = re.compile(
    r"\\(id|ide|usfm|h|toc\d?|toca\d?|mt\d?|mte\d?|ms\d?|mr|s\d?|sr|sp|sd\d?|"
    r"r|d|cl|cp|rem|sts|ip|iot|is\d?|io\d?|ie|imt\d?|periph)\b[^\n]*")


def words(t): return [w for w in t.split(" ") if w != ""]
def fit_category(cc):
    if cc <= 70: return "short"
    if cc <= 130: return "medium"
    if cc <= 210: return "long"
    return "veryLong"
def excerpt(t, m=132):
    if len(t) <= m: return t
    r = ""
    for w in words(t):
        c = w if r == "" else f"{r} {w}"
        if len(c) + 1 > m: break
        r = c
    return (t[:m].strip() + "...") if r == "" else (r + "...")
def segments(t, m=110):
    if len(t) <= m: return [t]
    segs, cur = [], ""
    for w in words(t):
        c = w if cur == "" else f"{cur} {w}"
        if len(c) > m and cur != "": segs.append(cur); cur = w
        else: cur = c
    if cur != "": segs.append(cur)
    return segs
def derived(t):
    cc = len(t)
    return {"char_count": cc, "word_count": len(words(t)), "fit_category": fit_category(cc),
            "excerpt": excerpt(t), "segment_count": len(segments(t))}


def clean_inline(t):
    # \w word|lemma\w* -> keep the visible word
    t = re.sub(r"\\\+?w\s+([^\\|]+?)(?:\|[^\\]*?)?\\\+?w\*", r"\1", t)
    # drop all closing character markers (\add*, \+add*, \nd*, ...)
    t = re.sub(r"\\\+?[a-z]+\d*\*", "", t)
    # drop all remaining opening/standalone markers, keeping following text
    t = re.sub(r"\\\+?[a-z]+\d*\b\*?", "", t)
    t = t.replace("~", " ").replace("//", " ")   # non-breaking space, line break
    return " ".join(t.split()).strip()


def parse_usfm(text):
    # remove note spans first (they can contain \v-like tokens)
    for tag in ("f", "fe", "x", "fig"):
        text = re.sub(rf"\\{tag}\b.*?\\{tag}\*", "", text, flags=re.S)
    text = HEADING.sub("", text)                 # drop heading/id lines
    rows = []
    chap_parts = re.split(r"\\c\s+(\d+)", text)  # [pre, num, body, num, body, ...]
    for i in range(1, len(chap_parts), 2):
        chapter = int(chap_parts[i])
        body = chap_parts[i + 1]
        vparts = re.split(r"\\v\s+([\d\-,]+)", body)
        for j in range(1, len(vparts), 2):
            vnum = vparts[j]
            vtext = clean_inline(vparts[j + 1])
            if not vtext:
                continue
            first = int(re.match(r"\d+", vnum).group())
            rows.append((chapter, first, vnum, vtext))
    return rows


def main():
    app_books = {b["id"]: b for b in json.load(open(os.path.join(RES, "seed_books.json")))}

    # The tree listing only maps book codes to paths inside the pinned commit. It is
    # GitHub API JSON, not a byte-stable file, so it is not hash-pinned; every file
    # it points to is checked against SHA256 before parsing.
    tree = json.loads(download(f"https://api.github.com/repos/{REPO}/git/trees/{COMMIT}?recursive=1"))
    paths = [t["path"] for t in tree["tree"] if t["path"].lower().endswith(".sfm")]
    # map each file to its USFM code via the trailing "-CODE.p.sfm" segment
    files = {}
    for p in paths:
        m = re.search(r"-(\d+)-([0-9A-Z]{3})\.", p)
        if m and m.group(2) in CODE_TO_BOOKID:
            files[m.group(2)] = p
    missing = [c for c in USFM_ORDER if c not in files]
    if missing:
        raise SystemExit(f"missing USFM books: {missing}")

    out, vid = [], ID_BASE
    for code in USFM_ORDER:
        book_id = CODE_TO_BOOKID[code]
        meta = app_books[book_id]
        short = meta["short_name"]
        url = "https://raw.githubusercontent.com/{}/{}/{}".format(
            REPO, COMMIT, urllib.parse.quote(files[code]))
        usfm = fetch_verified(url, SHA256[code]).decode("utf-8")
        for chapter, first, vnum, text in parse_usfm(usfm):
            vid += 1
            row = {"id": vid, "translation_id": TRANSLATION_ID, "book_id": book_id,
                   "book_name": meta["display_name"], "chapter": chapter, "verse": first,
                   "verse_ref": f"{short} {chapter}:{vnum}", "text": text}
            row.update(derived(text))
            out.append(row)

    assert len({r["id"] for r in out}) == len(out)
    assert len({r["book_id"] for r in out}) == 66, "expected all 66 books"
    leftover = [r for r in out if "\\" in r["text"]]
    assert not leftover, f"USFM markers survived in {len(leftover)} verses, e.g. {leftover[:1]}"
    json.dump(out, open(os.path.join(RES, "seed_verses_lsv.json"), "w"), ensure_ascii=False)
    print(f"Wrote {len(out)} LSV verses to seed_verses_lsv.json")


if __name__ == "__main__":
    main()
