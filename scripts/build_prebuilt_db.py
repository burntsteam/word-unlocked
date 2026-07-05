#!/usr/bin/env python3
"""Build the pre-seeded SQLite database that ships in the app bundle.

Instead of parsing ~74MB of seed JSON and running ~155k INSERTs on the main
thread at first launch (a ~12s hang), the app bundles this ready-made database
and copies it into the App Group container on first launch (see
ScriptureDatabase.provisionDatabaseIfNeeded). This script reproduces EXACTLY
what ScriptureDatabase's seeders produce, so the bundled DB is identical to the
old runtime-seeded one.

Sources: WordUnlocked/Resources/seed_*.json (+ the two constant tables mirrored
from ScriptureDatabase.swift: chapterCounts and topic symbols). RV is DEBUG-only
and LSM-licensed, so it is deliberately NOT included here.

Output: WordUnlocked/Resources/wordunlocked_seed.sqlite3 (user_version = 4).

Usage:  python3 scripts/build_prebuilt_db.py
"""
import json, os, sqlite3

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(ROOT, "WordUnlocked", "Resources")
OUT = os.path.join(RES, "wordunlocked_seed.sqlite3")
DATA_VERSION = 4  # must match ScriptureDatabase.currentDataVersion

VERSE_FILES = [  # (seed file, translation_code)
    ("seed_verses_kjv", "KJV"),
    ("seed_verses_web", "WEB"),
    ("seed_verses_bsb", "BSB"),
    ("seed_verses_asv", "ASV"),
    ("seed_verses_lsv", "LSV"),
]

# Mirrored from ScriptureDatabase.swift (chapterCounts).
CHAPTER_COUNTS = {
    1: 50, 2: 40, 3: 27, 4: 36, 5: 34, 6: 24, 7: 21, 8: 4, 9: 31, 10: 24,
    11: 22, 12: 25, 13: 29, 14: 36, 15: 10, 16: 13, 17: 10, 18: 42, 19: 150,
    20: 31, 21: 12, 22: 8, 23: 66, 24: 52, 25: 5, 26: 48, 27: 12, 28: 14,
    29: 3, 30: 9, 31: 1, 32: 4, 33: 7, 34: 3, 35: 3, 36: 3, 37: 2, 38: 14,
    39: 4, 40: 28, 41: 16, 42: 24, 43: 21, 44: 28, 45: 16, 46: 16, 47: 13,
    48: 6, 49: 6, 50: 4, 51: 4, 52: 5, 53: 3, 54: 6, 55: 4, 56: 3, 57: 1,
    58: 13, 59: 5, 60: 5, 61: 3, 62: 5, 63: 1, 64: 1, 65: 1, 66: 22,
}

# Mirrored from ScriptureDatabase.swift (topic symbols); default "book".
SYMBOLS = {
    "anxiety": "heart.fill", "fear": "shield.fill", "strength": "bolt.fill",
    "discipline": "target", "faith": "star.fill", "wisdom": "lightbulb.fill",
    "gratitude": "hand.thumbsup.fill", "forgiveness": "arrow.counterclockwise",
    "grief": "cloud.rain.fill", "patience": "clock.fill", "purpose": "map.fill",
    "prayer": "hands.sparkles.fill", "hope": "sun.horizon.fill", "peace": "leaf.fill",
    "leadership": "person.3.fill", "marriage": "heart.circle.fill", "family": "house.fill",
    "temptation": "exclamationmark.triangle.fill", "work": "wrench.fill",
    "humility": "arrow.down.heart.fill", "courage": "flag.fill", "endurance": "figure.walk",
    "joy": "face.smiling.fill", "rest": "moon.fill", "obedience": "checkmark.seal.fill",
    "love": "heart.fill",
}

SCHEMA = """
CREATE TABLE IF NOT EXISTS translations (
    id INTEGER PRIMARY KEY, code TEXT NOT NULL UNIQUE, display_name TEXT NOT NULL,
    publisher TEXT NOT NULL, copyright_notice TEXT NOT NULL, license_status TEXT NOT NULL,
    attribution TEXT NOT NULL, offline_available INTEGER NOT NULL, enabled INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS books (
    id INTEGER PRIMARY KEY, name TEXT NOT NULL, abbreviation TEXT NOT NULL,
    testament TEXT NOT NULL, chapter_count INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS topics (
    id INTEGER PRIMARY KEY, slug TEXT NOT NULL UNIQUE, name TEXT NOT NULL,
    symbol_name TEXT NOT NULL, summary TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS verses (
    id INTEGER PRIMARY KEY, translation_id INTEGER NOT NULL, translation_code TEXT NOT NULL,
    book_id INTEGER NOT NULL, book_name TEXT NOT NULL, chapter INTEGER NOT NULL,
    verse INTEGER NOT NULL, verse_ref TEXT NOT NULL, text TEXT NOT NULL,
    char_count INTEGER NOT NULL, word_count INTEGER NOT NULL, fit_category TEXT NOT NULL,
    excerpt TEXT NOT NULL, segment_count INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS topic_verses (
    topic_slug TEXT NOT NULL, verse_id INTEGER NOT NULL, PRIMARY KEY (topic_slug, verse_id)
);
CREATE INDEX IF NOT EXISTS idx_verses_translation ON verses(translation_code);
CREATE INDEX IF NOT EXISTS idx_verses_book_chapter ON verses(translation_code, book_id, chapter);
CREATE INDEX IF NOT EXISTS idx_topic_verses_verse ON topic_verses(verse_id);
"""


def load(name):
    return json.load(open(os.path.join(RES, f"{name}.json"), encoding="utf-8"))


def main():
    if os.path.exists(OUT):
        os.remove(OUT)
    db = sqlite3.connect(OUT)
    db.executescript(SCHEMA)

    # translations
    for t in load("seed_translations"):
        db.execute(
            "INSERT INTO translations VALUES (?,?,?,?,?,?,?,?,?)",
            (t["id"], t["code"], t["display_name"], t["publisher"], t["copyright_notice"],
             t["license_status"], t["attribution"], 1 if t["offline_available"] else 0,
             1 if t["enabled"] else 0))

    # books  (name=display_name, abbreviation=short_name, testament old/new, chapter_count)
    books = load("seed_books")
    book_name = {}
    for b in books:
        name = b["display_name"]
        book_name[b["id"]] = name
        testament = "old" if b["testament"] == "OT" else "new"
        db.execute("INSERT INTO books VALUES (?,?,?,?,?)",
                   (b["id"], name, b["short_name"], testament, CHAPTER_COUNTS.get(b["id"], 0)))

    # topics  (symbol_name from SYMBOLS else "book", summary=description)
    slug_by_id = {}
    for t in load("seed_topics"):
        slug_by_id[t["id"]] = t["slug"]
        db.execute("INSERT INTO topics VALUES (?,?,?,?,?)",
                   (t["id"], t["slug"], t["name"], SYMBOLS.get(t["slug"], "book"), t["description"]))

    # verses  (book_name from books table; translation_code per file)
    for fname, code in VERSE_FILES:
        rows = load(fname)
        db.executemany(
            "INSERT OR IGNORE INTO verses VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
            [(r["id"], r["translation_id"], code, r["book_id"], book_name.get(r["book_id"], ""),
              r["chapter"], r["verse"], r["verse_ref"], r["text"], r["char_count"],
              r["word_count"], r["fit_category"], r["excerpt"], r["segment_count"]) for r in rows])

    # topic_verses  (topic_slug from topic_id)
    for tv in load("seed_verse_topics"):
        slug = slug_by_id.get(tv["topic_id"])
        if slug:
            db.execute("INSERT OR IGNORE INTO topic_verses VALUES (?,?)", (slug, tv["verse_id"]))

    db.execute(f"PRAGMA user_version = {DATA_VERSION};")
    db.commit()
    db.execute("VACUUM;")
    db.close()

    size = os.path.getsize(OUT)
    print(f"Wrote {OUT} ({size/1_048_576:.1f} MB), user_version={DATA_VERSION}")


if __name__ == "__main__":
    main()
