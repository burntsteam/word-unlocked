#!/usr/bin/env python3
"""Regenerate the full WEB (World English Bible) seed from the public-domain
getbible v2 dataset. WEB is public domain — no license, fully offline.

Output: seed_verses_web.json, translation_id 2, ids 2,000,001+, verse_ref built
from the app's book short-names. getbible embeds a couple of inline footnotes
(/f + note /f*) which are stripped. Derived fields replicate LongVerseService
(excerpt cap 132, segment 110, fit thresholds 70/130/210). WEB uses its own
versification (~31,095 verses, a few fewer than KJV's 31,102).

Usage:  python3 scripts/fetch_web_seed.py
"""
import json, os, re, tempfile, urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(ROOT, "WordUnlocked", "Resources")
SRC_URL = "https://api.getbible.net/v2/web.json"


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


def clean(t):
    t = re.sub(r"/f\b.*?/f\*", "", t or "")   # strip getbible inline footnotes
    return " ".join(t.split()).strip()


def main():
    cache = os.path.join(tempfile.gettempdir(), "getbible_web.json")
    if os.path.exists(cache) and os.path.getsize(cache) > 1_000_000:
        web = json.loads(open(cache, encoding="utf-8").read())
    else:
        with urllib.request.urlopen(SRC_URL, timeout=60) as r:
            data = r.read()
        open(cache, "wb").write(data)
        web = json.loads(data.decode("utf-8"))

    books_data = web["books"]
    app_books = {b["id"]: b for b in json.load(open(os.path.join(RES, "seed_books.json")))}
    assert len(books_data) == 66 and sorted(b["nr"] for b in books_data) == list(range(1, 67))

    out, vid = [], 2_000_000
    for b in books_data:
        book_id = b["nr"]
        meta = app_books[book_id]
        short = meta.get("short_name") or meta["display_name"]
        dname = meta["display_name"]
        for ch in b["chapters"]:
            chapter = int(ch["chapter"])
            for v in ch["verses"]:
                text = clean(v["text"])
                vid += 1
                row = {"id": vid, "translation_id": 2, "book_id": book_id, "book_name": dname,
                       "chapter": chapter, "verse": int(v["verse"]),
                       "verse_ref": f"{short} {chapter}:{int(v['verse'])}", "text": text}
                row.update(derived(text))
                out.append(row)

    assert len({r["id"] for r in out}) == len(out)
    assert "".join(r["text"] for r in out).count("/f") == 0
    json.dump(out, open(os.path.join(RES, "seed_verses_web.json"), "w"), ensure_ascii=False)
    print(f"Wrote {len(out)} WEB verses to seed_verses_web.json")


if __name__ == "__main__":
    main()
