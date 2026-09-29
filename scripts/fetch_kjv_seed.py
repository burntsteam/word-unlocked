#!/usr/bin/env python3
"""Regenerate the full KJV seed (seed_verses_kjv.json) from the public-domain
aruljohn/Bible-kjv dataset — clean text (no {} italics/notes, no acrostic
headings), canonical 31,102 verses across all 66 books.

Verse ids <= 665 in the existing seed are the original curated set that
topic_verses / favorites reference, so they are PRESERVED (matched by
book_id/chapter/verse); all other verses get new ids from 1,000,000+.
Derived fields (char_count/word_count/fit_category/excerpt/segment_count) are
computed here, exactly replicating LongVerseService (excerpt cap 132, segment
110, fit thresholds 70/130/210).

Usage:  python3 scripts/fetch_kjv_seed.py
"""
import json, os, tempfile, time, urllib.error

from _download import fetch_verified

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(ROOT, "WordUnlocked", "Resources")
CACHE = os.path.join(tempfile.gettempdir(), "aruljohn_kjv"); os.makedirs(CACHE, exist_ok=True)
COMMIT = "a9aa4e55afbb3e095f57e4b14cd1f22c5ee8d7c9"  # master as of 2026-09-27
BASE = f"https://raw.githubusercontent.com/aruljohn/Bible-kjv/{COMMIT}/"
# SHA-256 of every file fetched from BASE (pinned 2026-09-27).
SHA256 = {
    "Books.json": "de2bae17dbb965d13eda0a72a360b8ace6dbe51a354dcbcf23d2394da38f5b7e",
    "Genesis.json": "5c1bf791d2bb98857982f92e7151c13886684e882e1728cf9e60ca197cdede0e",
    "Exodus.json": "97b553da7cc92b11ba282fbe6a1e02e4b4e46282130db57ad342297f83dcc89a",
    "Leviticus.json": "bc2c76e1a4a3dce377c515480c245e319b3fd0ca46ace9644b22ab700d91e16c",
    "Numbers.json": "03ac3a25f18cd740030baf185cfc7847e17d868397e11f20c174b4a065ddc9dc",
    "Deuteronomy.json": "82116f948cbbec3e5bc893a9d3da9b04f91eb91e2037aadc786d2793363eb5fb",
    "Joshua.json": "e5f63c9ccd0cb74cec1ffdcea0f12aadf1c57aa6059f2ac15aec975befda49fa",
    "Judges.json": "6fe6e671702a2654e87b9d779f8fca83231c12ffe185a0ae05c0c173763d1545",
    "Ruth.json": "62fcc87bca40ca8fa9af8ad7e9cff07ca632cffed56a73fb7822adc027cdc395",
    "1Samuel.json": "aa99b351d90bbb4cc9a9007b7f8f3a3b50e3bb25a2d672e254d1d3c08a817b26",
    "2Samuel.json": "f006e63ff95d353a4f3b6a0ecd35be17098dd33d55a7465ef25e53151c852a35",
    "1Kings.json": "cbcfd9ffca4b29741ea999aac6c66d75f6e380763a174bd2402e4a04adb89bd5",
    "2Kings.json": "c37f44dffa656a52615fadcf26125be04c89e8ada9b590da297038d1383bdbc4",
    "1Chronicles.json": "25165eb1413a10902590e1240b81692c8db13146bbfc7ba3afba54c88a35089d",
    "2Chronicles.json": "1fb4e360b4de0b6905de2b62638c059f23b9eef48ff74edcb898fced4e3c32e4",
    "Ezra.json": "f5730fafe18464f5d9c70c023f93a3fe767e44266e0a03c93f0d0d94a30eac8a",
    "Nehemiah.json": "19f34c333551e4c5b8bdac3e0f3afb637a179aaa187df7f83c5b6b7f46d4ead7",
    "Esther.json": "7688e25ad9fe19a0ab21956ccfbe1e4ad0c4c9735f8647e8cc2fea811eadd66c",
    "Job.json": "c671b8e94b78b2c9dad6378ddab070275f46df0c59adf1c8b694eddd4a8fc6ae",
    "Psalms.json": "9e4c2e0f4be2745a82cc90089e0eb387df41e9e5915e0f89d82d8e354db923c6",
    "Proverbs.json": "4ec57e5f26580496bfa5bfc481e42b75214609fb62839be725bd61f10282a2a4",
    "Ecclesiastes.json": "fa45784f0c188dab11a8ea25b4aede923e496352eeb9a0901fdb3541238f05b8",
    "SongofSolomon.json": "1a200dabcee23157f5f328f728781d8bf59dfc90adad4a8eeb3facb14d9c346a",
    "Isaiah.json": "c413e5595ca8d985a8eb79d478ad43aa11dc679801afc12e98e7baec4c9a072b",
    "Jeremiah.json": "5886fc0c0e132c54f6ba42b3fd81fe61a4c0d29ae457e8a5f03a1ddefa71a647",
    "Lamentations.json": "091eec66fcca1b2cf5da07a04ab7fc92b36fa8f96298429358401e3fed2cdd94",
    "Ezekiel.json": "c4b9f5d729e7c93f9e510af0bf28c3056bc231720f036d28e5536a6925c0ba7a",
    "Daniel.json": "34c54d29bffca57f31452e28843c1103da4d8aa1ba6f07eb67c84d9cbe48457c",
    "Hosea.json": "d9c67c8cdf20844557401b4f3f16d52fa9f72060705f6b6ac97b276ec8f8994d",
    "Joel.json": "4a8293c96744d9d51bc8d55081532594d12b338492d06073d62acb09945fce52",
    "Amos.json": "acb639acdc0f2b4d584d2abe9080d85697280f2dd49a07bdfdaaa10350d319e4",
    "Obadiah.json": "67a4f779ee2630c9e0668ef3c5709a83edb7e6cae71a2f8d9f4db6485c6d1599",
    "Jonah.json": "e30559595ba5ed892e164fafeed3823f0ce8046f720fc7e65ee0cd823cfe0238",
    "Micah.json": "94418c225788ac61bca5f7ea13588ee231dac68f6bae3f5f15ea94da2c67cb1c",
    "Nahum.json": "960a702ce1eed37dd7516bbd515150514bd0cf00cb2beeed9c05db2b371b4539",
    "Habakkuk.json": "71733a00259ccd15708e86b4ef5b9eb0a8065a87568d9e40ac1c17839b3d832a",
    "Zephaniah.json": "8d9fc5bec582fba06d56edfe4a4f014618743f6acdd7bb45c7da074810aeb203",
    "Haggai.json": "5a7e68fde7de9771b676e76bdc61252a40cf630ef5744b01f3432a277ab1f607",
    "Zechariah.json": "69e7b5820ac62ea6b84a18e7bf98c96a400753f82fcbd223b86e488ee330eeec",
    "Malachi.json": "534ec3cd6507b2e6611dc54a3b39c817615597c3e303fad3881d9e9871cc5678",
    "Matthew.json": "85bf22b56a4b55b5e5f138dc270e7b0b36edf3c87541ca27fbbe73b756bb59ff",
    "Mark.json": "551fa749843ca44d1093406a35a47d354d7614498bdf744389d62041f2adf732",
    "Luke.json": "a4439cd14cd1dd637ae614bd556499dca8df92db4f5d9f4a69c3c571969c5576",
    "John.json": "3d4e92a877e26de12c0baebb99c5196e73d999b2e0bebe2e442e6bb54cadedfb",
    "Acts.json": "f05ff6ef777c1b82ca5e87ae250d846b3a6a1fc54971ee06bdc86d698c9b2790",
    "Romans.json": "64eef20e95187668ae50802e0cbb79c1e3243f84c045cab8b724cdd991a5220f",
    "1Corinthians.json": "42b0074cbf342b3d0bbbf1223d544b055379a3ecbcc531d77ba2e3c41d32f22a",
    "2Corinthians.json": "d1c3fb6e1cf7db9a1d6de8ba763d74cbf4eed6281093d053f6aae6334eafc35c",
    "Galatians.json": "d350ced53a4543370f85b61ae924de6818fdd6f53be35fea831130fe3d12de9b",
    "Ephesians.json": "59dd5a6f05566a19e9db55f470cf14ff0f16386ee9ea092a507f9291ac737399",
    "Philippians.json": "4ea89097c7fd52ff2410bb6b26f97f693c23c801e0fa428422a7c049d767dd52",
    "Colossians.json": "97f45325dea44f51efabcb12aca79a57736d5d861866b3b7aad6daa21c33d20f",
    "1Thessalonians.json": "e7d5e020f709eb8021c668c56ce49d244d08548ecccd7bfc563e6762e9d0846b",
    "2Thessalonians.json": "f179518752119e4ba556cd99ec2a7281d1adf5ac7892c0d7f34df03e259d4dbb",
    "1Timothy.json": "ab2597f24a493985a337dc4082dda9aefcb6c8093700fde4572175172ec590e4",
    "2Timothy.json": "175c8aaac571330b4f46775f42263f78942259a2de39167793ca33f3bdfd0816",
    "Titus.json": "a70045f3e7726b8331a9def9fc59c4eafb108cc7715cda9459d311a1f73be002",
    "Philemon.json": "5408fba49172369e7ae594a3e462a396ba0d96cbf316718efe23b376bf9eed4a",
    "Hebrews.json": "14ce09626492f8735044b7cc04098e3d94458bcf35f5e735b03885201e5048a1",
    "James.json": "a6f5a9a8f4944ff8fbed8b14e8a43b156cd96710a5aa54ed301faf9b12416250",
    "1Peter.json": "f4f9ff5134ab95b69d01a56aa9d8e8056782af7f16f79398796e6679c9f97363",
    "2Peter.json": "4d6936d17c6e450ac28c0c908e4cd35a7d31431c6ca811424432a05997a6d7ae",
    "1John.json": "3eaec1d16b6a97650a7066b592640516e77cb024bf8f968b9de8bdd260356e90",
    "2John.json": "2efb9221bd6f85e71c27ab698f420c281d1d5d59e1d85309cb6bd86d700cba56",
    "3John.json": "44a3b69f9d9d1d867204b6cc56f468cd070954b0c6ce654c37a157f0cb57335c",
    "Jude.json": "7fb2040934402909689a290dfe0e27aee55a1b5a301b50074df264328a8631b1",
    "Revelation.json": "434c7384316589704862dce4387e42aeaa3ee17f24162410b6cc67544f42f45e",
}


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


def fetch_json(fn):
    dest, sha256 = os.path.join(CACHE, fn), SHA256[fn]
    for attempt in range(4):
        try:        # TLS and hash failures raise SystemExit, so they are not retried
            data = fetch_verified(BASE + fn, sha256, dest, timeout=30)
            return json.loads(data.decode("utf-8-sig"))
        except urllib.error.HTTPError as e:
            if e.code == 404:
                raise SystemExit(f"404 for {fn}")
            time.sleep(2 * (attempt + 1))
        except Exception:
            time.sleep(2 * (attempt + 1))
    raise SystemExit("failed: " + fn)


def main():
    names = fetch_json("Books.json")
    app_books = {b["id"]: b for b in json.load(open(os.path.join(RES, "seed_books.json")))}
    current = json.load(open(os.path.join(RES, "seed_verses_kjv.json")))
    preserve = {(v["book_id"], v["chapter"], v["verse"]): v["id"] for v in current if v["id"] <= 665}

    out, new_id, preserved_used = [], 1_000_000, 0
    for i, name in enumerate(names):
        book_id = i + 1
        meta = app_books[book_id]
        short = meta.get("short_name") or meta["display_name"]
        dname = meta["display_name"]
        book = fetch_json(name.replace(" ", "") + ".json")
        for ch in book["chapters"]:
            chapter = int(ch["chapter"])
            for v in ch["verses"]:
                verse = int(v["verse"])
                text = v["text"].strip()
                key = (book_id, chapter, verse)
                if key in preserve:
                    vid = preserve[key]; preserved_used += 1
                else:
                    new_id += 1; vid = new_id
                row = {"id": vid, "translation_id": 1, "book_id": book_id, "book_name": dname,
                       "chapter": chapter, "verse": verse, "verse_ref": f"{short} {chapter}:{verse}", "text": text}
                row.update(derived(text))
                out.append(row)

    assert len({r["id"] for r in out}) == len(out), "duplicate ids"
    assert preserved_used == len(preserve), f"preserved {preserved_used} of {len(preserve)}"
    json.dump(out, open(os.path.join(RES, "seed_verses_kjv.json"), "w"), ensure_ascii=False)
    print(f"Wrote {len(out)} KJV verses ({preserved_used} preserved ids) to seed_verses_kjv.json")


if __name__ == "__main__":
    main()
