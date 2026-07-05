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
import json, os, tempfile, time, urllib.request, urllib.error

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(ROOT, "WordUnlocked", "Resources")
CACHE = os.path.join(tempfile.gettempdir(), "aruljohn_kjv"); os.makedirs(CACHE, exist_ok=True)
BASE = "https://raw.githubusercontent.com/aruljohn/Bible-kjv/master/"


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
    dest = os.path.join(CACHE, fn)
    if os.path.exists(dest) and os.path.getsize(dest) > 50:
        return json.loads(open(dest, encoding="utf-8-sig").read())
    for attempt in range(4):
        try:
            with urllib.request.urlopen(BASE + fn, timeout=30) as r:
                data = r.read()
            open(dest, "wb").write(data)
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
