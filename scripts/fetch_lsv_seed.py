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
import json, os, re, ssl, tempfile, urllib.parse, urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(ROOT, "WordUnlocked", "Resources")
REPO = "BibleCorps/ENG-B-LSV2022-CC-CCC"

try:                                    # python.org builds ship without CA certs
    import certifi
    CTX = ssl.create_default_context(cafile=certifi.where())
except Exception:
    CTX = ssl._create_unverified_context()
BRANCH = "main"
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


def fetch(url):
    req = urllib.request.Request(url, headers={"User-Agent": "wordunlocked-seed"})
    with urllib.request.urlopen(req, timeout=90, context=CTX) as r:
        return r.read().decode("utf-8")


def main():
    app_books = {b["id"]: b for b in json.load(open(os.path.join(RES, "seed_books.json")))}

    tree = json.loads(fetch(f"https://api.github.com/repos/{REPO}/git/trees/{BRANCH}?recursive=1"))
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
            REPO, BRANCH, urllib.parse.quote(files[code]))
        for chapter, first, vnum, text in parse_usfm(fetch(url)):
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
