# WordUnlockedTests

swift-testing suites (`import Testing`) for the `WordUnlockedTests` target, run through
the shared `WordUnlocked` scheme:

```bash
cd WordUnlocked
xcodebuild test -project WordUnlocked.xcodeproj -scheme WordUnlocked \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -collect-test-diagnostics never
```

Without `-collect-test-diagnostics never`, a run with a failing test waits up to ten
minutes for `simctl diagnose` before it reports.

Put `TEST_RUNNER_LIVE_API_TESTS=1` in front to also run the two tests that call the real
ESV and Recovery Version APIs. They are skipped otherwise, because each run spends the
shared keys' quota.

The target is hosted by the app (`TEST_HOST`). Two consequences shape every test:

- The app module's generated `LiveAPIKeys` carries the real values from the gitignored
  `Config/Secrets.xcconfig`. Only the live tests read keys from it. Every other test builds
  `ESVBibleService` and `RVBibleService` with test credentials and a `URLSession` whose
  requests `StubURLProtocol` answers, and gives `ESVBibleService` a scratch `UserDefaults`
  suite instead of the App Group the widget reads.
- The app provisions the bundled SQLite database into the App Group container on first
  use, so database-backed tests read real data. Nothing writes to it, and tests that read
  or write settings use throwaway `UserDefaults` suites from `TestDefaults.swift` instead
  of the shared one.

## Suites

- **LongVerseServiceTests** — `fitCategory`, `excerpt`, `segments` and `firstLetters`:
  pure string logic, every boundary, and first letters past an opening quotation mark.
- **SharedModelsTests** — `LiveCachedVerse` JSON round-trips, pinned wire keys, and the
  stored ESV verses read back, with corrupt data coming back empty; `VerseReference`
  writing out book names ("1 Kings 2:2", "Psalm 23:1") and falling back when it can't.
- **ESVBibleServiceTests** — Crossway's limits (500 verses and half of any book, counting
  ESV favorites), the single request's id list fitting the API's request line, a passage
  turned into verse text (verse number, psalm title and poetry layout removed), widened
  passages dropped, the plan for a mode, and downloads against a stubbed API: kept in plan
  order, no second download within 48 hours, no request when nothing is missing, a refused
  request still waiting, being offline or failing to set up a secure connection not
  starting the wait, the wait recorded before the request goes out, and a download
  finishing when the screen that started it goes away. `LiveAPISession` keeps no cache.
  Live: John 3:16 and Psalm 23:1.
- **RVBibleServiceTests** — the request and its Basic authentication, a loaded verse
  carrying LSM's attribution and landing in no `UserDefaults` suite, the second look
  answered from memory, rejected credentials, and no request without a token. Live: John
  3:16.
- **VerseSelectionServiceTests** — the pure `stableIndex`, `slot`, `slotStartDates`,
  `weeklyIndex`, `shuffledOrder` and `pick`, then selection against the database: every
  topic has verses in every offline translation, Exclude Long keeps daily verses short
  while still rotating, ESV and RV rotate through the KJV reference set, Chapter mode's
  Repeat / Stop / Next Chapter (including Revelation wrapping to Genesis) and rotation
  speed, Weekly Plan from a theme, chapter, book or your own list (repeating its seven
  verses or moving on seven a week), Favorites in saved order, shuffled once per pass, and
  without long verses, Daily Verse drawn from the curated list in a shuffled order and
  narrowed by its testament choices, the upcoming verses a live translation downloads,
  live text keeping its verse and measured for the Lock Screen, a favorite saved with ESV
  text, the built-in verse being John 3:16's real row, and search treating `%`, `_` and
  quotes literally.
- **WidgetTimelineServiceTests** — the widget's timeline: daily entries from now then at
  each midnight, the next timeline asked for at midnight, favorites with written-out
  references in the translation each was saved in, Reference Only, Segmented parts taking
  turns every 20 minutes (and picking up mid-turn), each memorization step on its day,
  chapter progress notes, and downloaded ESV text standing in only for KJV verses.
- **ReferenceParserTests** — references as people type them ("Psalm 23", "1 Kings 2",
  "First John 4:8", "Rom 8:28–30", "Jude 3"), words and impossible references left to word
  search, and search returning a reference's verses in order.
- **SettingsStoreTests** — an unreadable favorite skipped without the rest being lost or
  rewritten, Recovery Version favorites becoming KJV, references written out, the stored
  Recovery Version verse removed at launch, favorites keeping their own translation, and
  reordering saved.
- **MemorizationServiceTests** — one step per local calendar day, a paused plan, each
  step's text, and difficulty setting how many words are blanked.

## Not covered

- SwiftUI views and the widget extension's own views. `WidgetTimelineService` is
  compiled into the app as well, so its timeline is tested here.
