# WordUnlockedTests

swift-testing suites (`import Testing`) for the `WordUnlockedTests` target, run through
the shared `WordUnlocked` scheme:

```bash
cd WordUnlocked
xcodebuild test -project WordUnlocked.xcodeproj -scheme WordUnlocked \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

The target is hosted by the app (`TEST_HOST`). Two consequences shape every test:

- `Bundle.main` is the app bundle, so it carries the real values from the gitignored
  `Config/Secrets.xcconfig`. Tests never read keys from it: `ESVBibleService` is built
  with `init(apiKey: "")`, so no test reaches the network.
- The app provisions the bundled SQLite database into the App Group container on first
  use, so database-backed tests read real data. Nothing writes to it, and selection
  tests pass an empty `UserDefaults` suite instead of the shared one.

## Suites

- **LongVerseServiceTests** — `fitCategory`, `excerpt`, `segments` and `firstLetters`:
  pure string logic, every boundary.
- **SharedModelsTests** — `LiveCachedVerse` JSON round-trips, pinned wire keys, and a
  malformed payload throwing.
- **ESVBibleServiceTests** — the 500-verse license cap, `isConfigured`, the fetch guard
  clauses (a fetch for a new reference is not dropped while another is in flight), and
  the pure eviction rule `applyingStore(_:to:)`.
- **VerseSelectionServiceTests** — the pure `stableIndex`, `slot`, `slotStartDates`,
  `weeklyIndex`, `shuffledOrder` and `pick`, then selection against the database: every
  topic has verses in every offline translation, Exclude Long keeps daily verses short
  while still rotating, ESV and RV rotate through the KJV reference set, Chapter mode's
  Repeat / Stop / Next Chapter (including Revelation wrapping to Genesis) and rotation
  speed, Weekly Theme without auto-repeat moving one theme per week, Favorites in saved
  order, shuffled once per pass, and without long verses, the built-in verse being John
  3:16's real row, and search treating `%`, `_` and quotes literally. Mode settings are
  written to throwaway `UserDefaults` suites that are removed after each test.

## Not covered

- The network success paths of `ESVBibleService` and `RVBibleService`.
- SwiftUI views, and the widget extension (`WidgetTimelineService` is compiled only into
  the extension, so it is out of the app module's reach).
