# WordUnlockedTests

Test **source files** only — this directory is not wired into
`WordUnlocked.xcodeproj` as a target yet. Written against the swift-testing
framework (`import Testing`, `@Test`, `#expect`, `@testable import WordUnlocked`).

## What's covered

**`LongVerseServiceTests.swift`** — all four static functions on
`LongVerseService` (pure string logic, no DB/UserDefaults/dates):
- `fitCategory(charCount:)` — every boundary of the four bands (0/70/71/130/131/210/211/well-past).
- `excerpt(from:maxChars:)` — empty string, shorter-than-limit, exactly-at-limit,
  far-over-limit (word-boundary truncation), and a run with no whitespace to
  break on (falls back to hard character truncation).
- `segments(from:maxCharsPerSegment:)` — the same five shapes. Notably, a run
  with **no whitespace** can't be split mid-word, so it comes back as a single
  segment that overflows `maxCharsPerSegment` — see
  `segmentsWithNoWhitespaceCannotSplitAndOverflowsSingleSegment`. That's a real
  limitation worth knowing about for widget layout, not a bug in the test.
- `firstLetters(from:)` — basic case + empty string.

**`SharedModelsTests.swift`** — `LiveCachedVerse` (and its `RVCachedVerse`
alias) round-tripped through `JSONEncoder`/`JSONDecoder`, both as a single
value and as the `[LiveCachedVerse]` array shape `ESVBibleService` actually
persists. Also pins the exact JSON keys (`ref`/`text`/`fetchedRef` — there's no
`CodingKeys` override) and confirms a malformed payload throws `DecodingError`
rather than silently producing a half-populated value — exactly the failure
mode that makes `ESVBibleService.init()`'s `try?` come back with an empty cache.

**`ESVBibleServiceTests.swift`**:
- `ESVBibleService.maxCacheCount == 500` (the ESV API license cap).
- `ESVBibleService.isConfigured == false` in the test bundle (no `ESVApiKey`).
- `cachedVerse(for:)` returns `nil` for a reference that was never fetched.
- `fetch(reference:)`'s two guard clauses: no API key configured (always true
  in a test bundle — there's no `ESVApiKey` in its Info.plist) sets the "not
  configured" error and never flips `isFetching`; calling `fetch` while
  `isFetching` is already `true` returns immediately without starting a
  second fetch.
- **`store(_:)` eviction**, now that it's `internal` instead of `private`:
  re-storing an existing `fetchedRef` with different text upserts in place
  (no duplicate, count doesn't grow) and moves that entry to the end
  (most-recent); and, driven all the way to the cap, storing one more brand-new
  entry evicts *exactly* `refs[0]` — proven by filling the cache with `cap`
  known refs first (which provably flushes out anything left over from a
  previous run) and then asserting the entire resulting array by value, not
  just its length. See the note at the bottom of `ESVBibleServiceTests.swift`
  for why this unavoidably writes real data to `AppGroupSettings.defaults`
  and how the tests stay correct anyway — summarized in "A real, honest
  side effect" below.

No network call is made in any test, and no SQLite database is touched.
`ESVBibleService.shared` does unavoidably read `AppGroupSettings.defaults`
once on first access (its `init()` does that regardless of which test touches
it first) — that's a harmless `UserDefaults` read on its own, separate from
the real write the eviction tests now perform (see below).

**`VerseSelectionServiceTests.swift`** — `stableIndex(for:component:count:)`
and `pick(from:date:component:)` only, now that they're `internal` instead of
`private`. Both are pure (`Foundation.Calendar` arithmetic, no DB, no
UserDefaults):
- `stableIndex` is deterministic for identical inputs, and stays within
  `0..<count` for counts 1 through 20 checked against `Date.distantPast`,
  `Date.distantFuture`, and "now" — for both the `.day` branch and the
  `.weekOfYear` branch (`stableIndex` computes each differently).
- Two dates exactly one calendar day apart (built via `Calendar`'s own
  `.day` arithmetic so a DST transition can't interfere) yield different
  indices — provably so, since consecutive days differ by exactly 1 in the
  underlying day-ordinality and a difference of 1 mod a count > 1 is never 0.
- `count == 0` doesn't crash: `max(count, 1)` in the implementation makes
  the modulo well-defined, and it returns `0` — pinned directly rather than
  left as an unstated assumption. (`pick` never actually triggers this path:
  it returns `nil` for an empty array before computing an index at all.)
- `pick` returns `nil` for an empty array, and otherwise returns exactly the
  element at `stableIndex`'s result — checked both for one date and across
  40 consecutive days.

`VerseSelectionService.verse(for:date:favorites:)` itself — the only
*public* entry point — is still not covered; see below for why.

## What's deliberately NOT covered, and why

**A real, honest side effect: `ESVBibleServiceTests`' eviction tests write to
real UserDefaults.** `store(_:)` ends with an unconditional
`AppGroupSettings.defaults.set(data, forKey: ...)` — there is no test seam
around that, and no way to seed or clear `cache` directly instead (its setter
is still `private`). So exercising the real eviction algorithm at all means
real writes to the `group.com.rippre.wordunlocked` UserDefaults suite (or
`.standard`, if that suite doesn't resolve in whatever process runs this).
Concretely, `storeEvictsExactlyTheOldestPastTheCapAndKeepsOldestFirstOrdering`
doesn't just add a couple of test records — proving cap-triggered eviction
means actually filling the cache to capacity at least once, so that test
leaves the suite holding `maxCacheCount` (500) fake
`__TEST_EVICTION_FILL__<uuid>-<n>` entries, replacing whatever was there.
This is bounded, not unbounded (store()'s own cap logic means it can never
hold more than 500 entries no matter how many times these tests run) and
every fake value is tagged with a random UUID so it can never collide with
real data or with a previous run's leftovers — every assertion is written
against a measured baseline, not an assumed-empty cache, so this is not
flaky, just persistent. It is real pollution of a real shared resource,
though, not merely simulated, and is called out here rather than hidden
behind passing assertions. The actual fix would be a production change this
test-only pass intentionally doesn't make: inject the `UserDefaults` instance
(or a persistence protocol) into `ESVBibleService` instead of hardcoding
`AppGroupSettings.defaults`, so tests could point it at a throwaway suite.

**`VerseSelectionService.verse(for:date:favorites:)` (and `TranslationService`)
— still not covered.** Widening `stableIndex`/`pick` unblocked those two pure
functions (see above), but `verse(for:date:favorites:)` — the only
*public* entry point — calls into `datedVerse`/`topicVerse`/`chapterVerse`/
`memorizationVerse`/`favoriteVerse`, and **every one of those** — including
`.favorites` mode, which still calls `DatabaseService.shared.verse(id:)`
before falling back to building a `Verse` from a `Favorite` — is still
`private` and unconditionally touches `DatabaseService.shared` /
`ScriptureDatabase.shared`. That's a real singleton that opens a real SQLite
file on disk (App Group container, falling back to Application Support) and,
on the app target, provisions it from the bundled ~50MB
`wordunlocked_seed.sqlite3`. `TranslationService.allTranslations`/
`translation(code:)` have the same shape: nothing beyond a
`DatabaseService.shared.translations()` call and a filter, with no pure logic
to isolate.

Per the brief for this pass, this is reported as an untested area rather than
papered over with a test that either (a) touches the real SQLite-backed
singleton (fragile: depends on disk I/O, App Group container resolution, and
`Bundle.main` resource lookup succeeding in whatever process eventually runs
the test target), or (b) re-implements the remaining `private` helpers inside
the test file to check them in isolation (that tests a copy of the logic, not
the actual code — worse than no test). If this last piece of coverage is
wanted, the same pattern that already unblocked `stableIndex`/`pick` applies:
widen `datedVerse`/`topicVerse`/`chapterVerse`/`memorizationVerse`/
`favoriteVerse` to `internal` and inject a fake in place of
`DatabaseService.shared` (there's currently no protocol seam for that — it's
a concrete `final class` singleton, not injected anywhere).

**Everything else DB-backed.** `DatabaseService`, `ScriptureDatabase`, and
anything that reads through them (most of
`VerseSelectionService`/`TranslationService`, part of `RVBibleService`'s
`#if DEBUG` local lookup) require the real bundled SQLite database and/or App
Group container for meaningful results, for the same reason as above.

**Network paths.** `ESVBibleService.fetch(reference:)`'s success path and all
of `RVBibleService.fetch(reference:)` hit real HTTPS endpoints; untested
beyond the guard clauses above.

**SwiftUI views.** Everything under `Modes/`, `Onboarding/`, `Tabs/`,
`Theme/`, plus `ContentView.swift`/`WordUnlockedApp.swift` — view/binding code
with no isolable logic; UI testing wasn't in scope here.

**Widget target.** `WordUnlockedWidget/*` (timeline provider, entry views) —
untested; this pass adds no widget test target/plan.

## Verification

No test target is wired into `WordUnlocked.xcodeproj` yet, so these files
can't be run through Xcode directly. Two independent checks were run instead:

1. **Type-check against the real app target.** All 46 files that make up
   `WordUnlocked.xcodeproj`'s actual `WordUnlocked` target `Sources` build
   phase (read directly from `project.pbxproj`, not guessed) were compiled
   into a real `.swiftmodule` with
   `swiftc -emit-module -enable-testing -DDEBUG -sdk <iphonesimulator SDK> -target arm64-apple-ios17.0-simulator`
   — the same SDK, deployment target, and `ENABLE_TESTABILITY`/`DEBUG` flags
   the project itself uses. All four test files above then
   type-checked (`swiftc -typecheck`) against that module with
   `@testable import WordUnlocked`, requiring `-F` to Xcode's `Testing.framework`
   and `-plugin-path` to `libTestingMacros.dylib` for the `@Test`/`@Suite`/
   `#expect` macros. **Result: zero errors.** Every symbol, signature, and
   type referenced in these tests is real. Re-run after `store(_:)`/`pick`/
   `stableIndex` were widened to `internal` and after `ESVBibleServiceTests.swift`/
   `VerseSelectionServiceTests.swift` were added, against the current on-disk
   state of the production files each time — still zero errors.
2. **Actually executed.** To also confirm the assertions themselves are
   correct (not just that they compile — e.g. the hand-counted character
   offsets in the `excerpt`/`segments` boundary cases, and the exact
   before/after arrays in the eviction tests), the non-UI files these tests
   depend on (`Models/`, `Services/`, `Settings/`, `Theme/`, `Shared/`) were
   copied verbatim into a throwaway local Swift package and built for native
   macOS, and the test files were copied alongside with only
   `@testable import WordUnlocked` changed to
   `@testable import WordUnlockedCore` to match the throwaway package's
   module name — no other line was touched. `swift test` then really ran
   them. This is a copy run in a scratch package, not the iOS target itself,
   but it's the same source and the same assertions, actually executed
   rather than just type-checked. **Result: 40/40 tests passed** (18 in
   `LongVerseServiceTests`, 5 in `SharedModelsTests`, 8 in
   `ESVBibleServiceTests`, 9 in `VerseSelectionServiceTests`), including the
   eviction test's 500-iteration fill-to-cap sequence, which ran in ~0.2s.

Both checks used throwaway build directories, deleted afterward, and made no
network calls. The execution pass (2) is a *real* singleton, though, and its
one side effect was observed directly: it wrote an actual 111KB
`~/Library/Preferences/group.com.rippre.wordunlocked.plist` on the machine
that ran it, holding the fake `__TEST_EVICTION_FILL__` entries described
above -- confirming empirically, not just in theory, that `store(_:)` really
does perform a real, unsandboxed UserDefaults write with no test seam around
it. That file was deleted immediately after being confirmed (it's not part
of this repo and not real user data), but the same write will happen for
real once this suite runs for real too -- against the iOS Simulator's own
copy of that UserDefaults suite when the test target is wired in, which is
the whole point of documenting it above rather than being surprised by it
later.

Nothing here should be taken as proof the files will compile unmodified once
wired into the real test target (build settings, other target membership,
etc. could still surface something), but every symbol and every assertion
value has now been checked against the real production source rather than
assumed.

## Eviction side effect (resolved)

The eviction tests originally called `ESVBibleService.store(_:)` directly, which
unconditionally persists to the `group.com.rippre.wordunlocked` UserDefaults suite —
the same store the Lock Screen widget reads. A test run therefore left up to 500
synthetic verses in the real cache.

That is fixed: the eviction rule is now `ESVBibleService.applyingStore(_:to:)`, a pure
static function, and `store(_:)` is private again and just calls it before persisting.
The tests exercise the pure function, so they have no side effects and need no baseline
measurement or UUID-tagged refs.
