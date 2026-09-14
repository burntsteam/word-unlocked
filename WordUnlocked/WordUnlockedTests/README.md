# WordUnlockedTests

swift-testing suites (`import Testing`) for the `WordUnlockedTests` target, run through
the shared `WordUnlocked` scheme:

```bash
cd WordUnlocked
xcodebuild test -project WordUnlocked.xcodeproj -scheme WordUnlocked \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Put `TEST_RUNNER_LIVE_API_TESTS=1` in front to also run the two tests that call the real
ESV and Recovery Version APIs. They are skipped otherwise, because each run spends the
shared keys' quota.

The target is hosted by the app (`TEST_HOST`). Two consequences shape every test:

- `Bundle.main` is the app bundle, so it carries the real values from the gitignored
  `Config/Secrets.xcconfig`. Only the live tests read keys from it. Every other test builds
  `ESVBibleService` and `RVBibleService` with test credentials and a `URLSession` whose
  requests `StubURLProtocol` answers, and gives `ESVBibleService` a scratch `UserDefaults`
  suite instead of the App Group the widget reads.
- The app provisions the bundled SQLite database into the App Group container on first
  use, so database-backed tests read real data. Nothing writes to it, and selection
  tests pass an empty `UserDefaults` suite instead of the shared one.

## Suites

- **LongVerseServiceTests** — `fitCategory`, `excerpt`, `segments` and `firstLetters`:
  pure string logic, every boundary.
- **SharedModelsTests** — `LiveCachedVerse` JSON round-trips, pinned wire keys, and the
  stored ESV verses read back, with corrupt data coming back empty.
- **ESVBibleServiceTests** — Crossway's limits (500 verses and half of any book, counting
  ESV favorites), the single request's id list fitting the API's request line, a passage
  turned into verse text (verse number, psalm title and poetry layout removed), widened
  passages dropped, the plan for a mode, and downloads against a stubbed API: kept in plan
  order, no second download within 48 hours, no request when nothing is missing, a refused
  request still waiting, and being offline not starting the wait. Live: John 3:16 and
  Psalm 23:1.
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
  without long verses, the upcoming verses a live translation downloads, live text measured
  for the Lock Screen, the built-in verse being John 3:16's real row, and search treating
  `%`, `_` and quotes literally. Mode settings are written to throwaway `UserDefaults`
  suites that are removed after each test.

## Not covered

- SwiftUI views, and the widget extension (`WidgetTimelineService` is compiled only into
  the extension, so it is out of the app module's reach).
