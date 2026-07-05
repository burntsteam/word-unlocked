#!/usr/bin/env python3
"""Fetch the ESV text for the app's 665 seed references and write seed_verses_esv.json.

ESV text is © Crossway and is used here under the app owner's license. This is a
build-time tool: it pulls each verse from the official ESV API (api.esv.org) so the
bundled text is authoritative and verbatim — nothing is hand-typed or AI-generated.

The output mirrors the KJV reference set exactly (same book_id/chapter/verse/verse_ref,
same order) with ESV ids 30001..30665 and translation_id 4. Derived fields
(char_count/excerpt/fit_category/segment_count) are intentionally omitted — the app's
ScriptureDatabase computes them at seed time via LongVerseService so they never drift.

API key resolution (never printed):
  1. env var  ESV_API_KEY
  2. WordUnlocked/Config/Secrets.xcconfig   (line:  ESV_API_KEY = ...)

Usage:
  python3 scripts/fetch_esv_seed.py            # fetch all, resumable
Re-running skips references already present in the output file.
"""
import json
import os
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(ROOT, "WordUnlocked", "Resources")
KJV_PATH = os.path.join(RES, "seed_verses_kjv.json")
BOOKS_PATH = os.path.join(RES, "seed_books.json")
OUT_PATH = os.path.join(RES, "seed_verses_esv.json")
SECRETS_PATH = os.path.join(ROOT, "WordUnlocked", "Config", "Secrets.xcconfig")

ESV_TRANSLATION_ID = 4
ESV_ID_BASE = 30000  # ESV verse id = 30000 + KJV verse id  ->  30001..30665

API_URL = "https://api.esv.org/v3/passage/text/"
# Clean single-verse text: strip references, verse numbers, footnotes, headings,
# and the short "(ESV)" copyright suffix (attribution is shown in-app instead).
API_PARAMS = {
    "include-passage-references": "false",
    "include-verse-numbers": "false",
    "include-first-verse-numbers": "false",
    "include-footnotes": "false",
    "include-headings": "false",
    "include-short-copyright": "false",
    "include-passage-horizontal-lines": "false",
    "include-heading-horizontal-lines": "false",
}

# Throttle: ESV API allows 60/min, 1000/hr, 5000/day. ~1.15s/verse keeps us under
# ~55/min, so all 665 finish in ~13 min well within limits.
SLEEP_SECONDS = 1.15
SAVE_EVERY = 25


def resolve_api_key():
    key = os.environ.get("ESV_API_KEY", "").strip()
    if key:
        return key
    try:
        with open(SECRETS_PATH, encoding="utf-8") as f:
            for line in f:
                stripped = line.strip()
                if stripped.startswith("//"):
                    continue
                m = re.match(r"ESV_API_KEY\s*=\s*(.+?)\s*$", stripped)
                if m:
                    value = m.group(1).strip()
                    if value and value != "YOUR_ESV_API_KEY_HERE":
                        return value
    except FileNotFoundError:
        pass
    return ""


def load_json(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def fetch_text(query, key):
    """Return the ESV text for a single-verse reference, or raise on hard failure."""
    url = API_URL + "?" + urllib.parse.urlencode(dict(API_PARAMS, q=query))
    req = urllib.request.Request(url, headers={"Authorization": "Token " + key})
    for attempt in range(4):
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                data = json.loads(resp.read().decode("utf-8"))
            passages = data.get("passages") or []
            text = (passages[0] if passages else "").strip()
            return text, (data.get("canonical") or "").strip()
        except urllib.error.HTTPError as e:
            if e.code == 429 or 500 <= e.code < 600:
                wait = 5 * (attempt + 1)
                print(f"  HTTP {e.code}; backing off {wait}s...", file=sys.stderr)
                time.sleep(wait)
                continue
            if e.code in (401, 403):
                print("ERROR: ESV API key rejected (401/403). Check your key.", file=sys.stderr)
                sys.exit(2)
            raise
        except (urllib.error.URLError, TimeoutError) as e:
            wait = 5 * (attempt + 1)
            print(f"  network error ({e}); retrying in {wait}s...", file=sys.stderr)
            time.sleep(wait)
    raise RuntimeError(f"Failed to fetch after retries: {query}")


def main():
    key = resolve_api_key()
    if not key:
        print(
            "ERROR: No ESV API key found.\n"
            "  Add it to WordUnlocked/Config/Secrets.xcconfig as:\n"
            "    ESV_API_KEY = <your key from api.esv.org>\n"
            "  or export ESV_API_KEY in the environment.",
            file=sys.stderr,
        )
        sys.exit(1)

    kjv = load_json(KJV_PATH)
    books = {b["id"]: b["display_name"] for b in load_json(BOOKS_PATH)}

    # Resume: keep verses already fetched, refetch only what's missing/empty.
    existing = {}
    if os.path.exists(OUT_PATH):
        for row in load_json(OUT_PATH):
            if row.get("text"):
                existing[row["verse_ref"]] = row

    out = []
    total = len(kjv)
    fetched = 0
    for i, v in enumerate(kjv, start=1):
        ref = v["verse_ref"]
        book_name = books.get(v["book_id"], "")
        if ref in existing:
            out.append(existing[ref])
            continue
        # Query with the full book name (e.g. "Genesis 1:1"), which the ESV
        # reference parser handles more reliably than the seed's abbreviations.
        query = f"{book_name} {v['chapter']}:{v['verse']}"
        text, canonical = fetch_text(query, key)
        if not text:
            print(f"[{i}/{total}] WARN empty text for {query} ({ref})", file=sys.stderr)
        out.append({
            "id": ESV_ID_BASE + v["id"],
            "translation_id": ESV_TRANSLATION_ID,
            "book_id": v["book_id"],
            "book_name": book_name,
            "chapter": v["chapter"],
            "verse": v["verse"],
            "verse_ref": ref,
            "text": text,
        })
        fetched += 1
        print(f"[{i}/{total}] {query} -> {len(text)} chars")
        if fetched % SAVE_EVERY == 0:
            with open(OUT_PATH, "w", encoding="utf-8") as f:
                json.dump(out, f, ensure_ascii=False, indent=2)
        time.sleep(SLEEP_SECONDS)

    with open(OUT_PATH, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)

    empties = sum(1 for r in out if not r["text"])
    print(f"\nWrote {len(out)} verses to {OUT_PATH} ({empties} empty).")
    if empties:
        print("Re-run to retry the empty ones.", file=sys.stderr)
    print("Reminder: ESV text is © Crossway; bundle it only under your license.")


if __name__ == "__main__":
    main()
