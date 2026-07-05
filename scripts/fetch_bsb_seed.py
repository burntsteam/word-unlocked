#!/usr/bin/env python3
"""Regenerate the full BSB (Berean Standard Bible) seed from the public-domain
bereanbible.com plain-text export. BSB is dedicated to the public domain — no
license, fully offline, modern readable English.

Output: seed_verses_bsb.json, translation_id 3, ids 3,000,001+, verse_ref built
from the app's book short-names. Source is tab-delimited "Book C:V<TAB>text".
Derived fields replicate LongVerseService (excerpt cap 132, segment 110, fit
thresholds 70/130/210).

Usage:  python3 scripts/fetch_bsb_seed.py
"""
import json, os, re, ssl, tempfile, urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(ROOT, "WordUnlocked", "Resources")
SRC_URL = "https://bereanbible.com/bsb.txt"

try:                                    # python.org builds ship without CA certs
    import certifi
    CTX = ssl.create_default_context(cafile=certifi.where())
except Exception:
    CTX = ssl._create_unverified_context()
TRANSLATION_ID = 3
ID_BASE = 3_000_000


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


def main():
    books = json.load(open(os.path.join(RES, "seed_books.json")))
    byname = {b["display_name"].lower(): b for b in books}
    byname["psalm"] = byname["psalms"]  # BSB uses the singular "Psalm"

    cache = os.path.join(tempfile.gettempdir(), "bsb.txt")
    if os.path.exists(cache) and os.path.getsize(cache) > 1_000_000:
        raw = open(cache, encoding="utf-8-sig").read()
    else:
        with urllib.request.urlopen(SRC_URL, timeout=90, context=CTX) as r:
            data = r.read()
        open(cache, "wb").write(data)
        raw = data.decode("utf-8-sig")

    out, vid = [], ID_BASE
    ref_re = re.compile(r"^(.+?)\s+(\d+):(\d+)$")
    for line in raw.split("\n"):
        if "\t" not in line:
            continue
        ref, text = line.split("\t", 1)
        m = ref_re.match(ref.strip())
        if not m:                       # header row ("Verse"), notes
            continue
        name, ch, vs = m.group(1), int(m.group(2)), int(m.group(3))
        b = byname.get(name.lower())
        if not b:
            raise SystemExit(f"unmapped book: {name!r}")
        text = " ".join(text.replace("¶", " ").split()).strip()
        if not text:                    # omitted (critical-text) verses
            continue
        vid += 1
        short = b["short_name"]
        row = {"id": vid, "translation_id": TRANSLATION_ID, "book_id": b["id"],
               "book_name": b["display_name"], "chapter": ch, "verse": vs,
               "verse_ref": f"{short} {ch}:{vs}", "text": text}
        row.update(derived(text))
        out.append(row)

    assert len({r["id"] for r in out}) == len(out)
    assert len({b["book_id"] for b in out}) == 66, "expected all 66 books"
    json.dump(out, open(os.path.join(RES, "seed_verses_bsb.json"), "w"), ensure_ascii=False)
    print(f"Wrote {len(out)} BSB verses to seed_verses_bsb.json")


if __name__ == "__main__":
    main()
