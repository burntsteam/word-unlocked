#!/usr/bin/env python3
"""Regenerate the full ASV (American Standard Version, 1901) seed from the
public-domain getbible v2 dataset. ASV is public domain — no license, fully
offline.

Output: seed_verses_asv.json, translation_id 4, ids 4,000,001+, verse_ref built
from the app's book short-names, mapped by canonical book number (position).
getbible occasionally embeds inline footnotes (/f ... /f*) which are stripped.
Derived fields replicate LongVerseService (excerpt cap 132, segment 110, fit
thresholds 70/130/210).

Usage:  python3 scripts/fetch_asv_seed.py
"""
import json, os, re, ssl, tempfile, urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(ROOT, "WordUnlocked", "Resources")
SRC_URL = "https://api.getbible.net/v2/asv.json"

try:                                    # python.org builds ship without CA certs
    import certifi
    CTX = ssl.create_default_context(cafile=certifi.where())
except Exception:
    CTX = ssl._create_unverified_context()
TRANSLATION_ID = 4
ID_BASE = 4_000_000


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
    app_books = {b["id"]: b for b in json.load(open(os.path.join(RES, "seed_books.json")))}

    cache = os.path.join(tempfile.gettempdir(), "getbible_asv.json")
    if os.path.exists(cache) and os.path.getsize(cache) > 1_000_000:
        asv = json.loads(open(cache, encoding="utf-8").read())
    else:
        req = urllib.request.Request(SRC_URL, headers={"User-Agent": "wordunlocked-seed"})
        with urllib.request.urlopen(req, timeout=90, context=CTX) as r:
            data = r.read()
        open(cache, "wb").write(data)
        asv = json.loads(data.decode("utf-8"))

    books_data = asv["books"]
    assert len(books_data) == 66 and sorted(b["nr"] for b in books_data) == list(range(1, 67))

    out, vid = [], ID_BASE
    for b in books_data:
        book_id = b["nr"]                 # getbible numbers match Protestant order
        meta = app_books[book_id]
        short = meta["short_name"]
        for ch in b["chapters"]:
            chapter = int(ch["chapter"])
            for v in ch["verses"]:
                text = clean(v["text"])
                if not text:
                    continue
                vid += 1
                row = {"id": vid, "translation_id": TRANSLATION_ID, "book_id": book_id,
                       "book_name": meta["display_name"], "chapter": chapter, "verse": int(v["verse"]),
                       "verse_ref": f"{short} {chapter}:{int(v['verse'])}", "text": text}
                row.update(derived(text))
                out.append(row)

    assert len({r["id"] for r in out}) == len(out)
    assert "".join(r["text"] for r in out).count("/f") == 0
    json.dump(out, open(os.path.join(RES, "seed_verses_asv.json"), "w"), ensure_ascii=False)
    print(f"Wrote {len(out)} ASV verses to seed_verses_asv.json")


if __name__ == "__main__":
    main()
