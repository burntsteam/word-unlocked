# Graph Report - .  (2026-08-31)

## Corpus Check
- Corpus is ~30,154 words - fits in a single context window. You may not need a graph.

## Summary
- 492 nodes · 782 edges · 58 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output
- Edge kinds: contains: 175 · method: 165 · inherits: 155 · calls: 140 · MODIFIES: 71 · case_of: 56 · ON_BRANCH: 10 · PARENT_OF: 9 · rationale_for: 1


## Input Scope
- Requested: auto
- Resolved: committed (source: default-auto)
- Included files: 72 · Candidates: 100
- Excluded: 13 untracked · 518 ignored · 1 sensitive · 0 missing committed
- Recommendation: Use --scope all or graphify.yaml inputs.corpus for a knowledge-base folder.

## Graph Freshness
- Built from Git commit: `1166ef5`
- Compare this hash to `git rev-parse HEAD` before trusting freshness-sensitive graph output.
## God Nodes (most connected - your core abstractions)
1. `ScriptureDatabase` - 25 edges
2. `LongVerseServiceTests` - 21 edges
3. `SettingsStore` - 17 edges
4. `WidgetTimelineService` - 17 edges
5. `DatabaseService` - 15 edges
6. `VerseSelectionService` - 11 edges
7. `ESVBibleServiceTests` - 9 edges
8. `VerseSelectionServiceTests` - 9 edges
9. `VerseMode` - 9 edges
10. `WidgetTheme` - 9 edges

## Surprising Connections (you probably didn't know these)
- `676cef0 Initial commit: Word Unlocked — iOS scripture Lock Screen widget` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 3 → community 0_
- `OnboardingTranslationCard` --inherits--> `Identifiable`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Onboarding/OnboardingTranslationView.swift →   _Bridges community 43 → community 5_
- `OnboardingTranslationView` --inherits--> `View`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Onboarding/OnboardingTranslationView.swift →   _Bridges community 43 → community 11_
- `OnboardingProgressDots` --inherits--> `View`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Onboarding/OnboardingView.swift →   _Bridges community 50 → community 11_
- `Testament` --inherits--> `Codable`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Models/Book.swift →   _Bridges community 10 → community 5_

## Communities

### Community 0 - "LSV import pipeline"
Cohesion: 0.09
Nodes (12): main, 1166ef5 test: add a unit test target covering the cache and selection rules, 1524b07 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline, 3f7b263 chore: track durable graphify + engram state, 606b9f4 Add future translation roadmap to submission notes, 6c96c57 feat: add an app icon, 7f5482d chore(graphify): fingerprint community membership in the label sidecar, 8c91015 feat(translations): hide ESV until its API key is configured (+4 more)

### Community 1 - "ASV import pipeline"
Cohesion: 0.18
Nodes (1): ScriptureDatabase

### Community 2 - "KJV import pipeline"
Cohesion: 0.10
Nodes (1): LongVerseServiceTests

### Community 3 - "Web seed fetcher"
Cohesion: 0.11
Nodes (8): 676cef0 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, OnboardingWelcomeView, LockScreenWidgetGuideView, CircularWidgetView, HomeScreenWidgetView, InlineWidgetView, RectangularWidgetView, WidgetEntryView

### Community 4 - "iOS app build tools"
Cohesion: 0.24
Nodes (1): WidgetTimelineService

### Community 5 - "BSB import pipeline"
Cohesion: 0.26
Nodes (15): Codable, Equatable, Identifiable, Book, Favorite, LiveCachedVerse, SharedBookRecord, SharedTopicRecord (+7 more)

### Community 6 - "ESV API fetcher"
Cohesion: 0.16
Nodes (1): SettingsStore

### Community 7 - "Community 7"
Cohesion: 0.16
Nodes (7): Decodable, ObservableObject, ESVBibleService, ESVResponse, LSMResponse, LSMVerse, RVBibleService

### Community 8 - "Community 8"
Cohesion: 0.21
Nodes (1): DatabaseService

### Community 9 - "Community 9"
Cohesion: 0.13
Nodes (14): Int, Difficulty, easy, hard, medium, MemorizationPlan, MemorizationPlan.Difficulty, MemorizationPlan.Phase (+6 more)

### Community 10 - "Community 10"
Cohesion: 0.14
Nodes (13): Testament, new, old, ChapterEndBehavior, nextChapter, repeatChapter, stop, ChapterModeView (+5 more)

### Community 11 - "Community 11"
Cohesion: 0.26
Nodes (11): PrivacyPolicyView, PrivacyRow, SettingsView, ThemeSwatch, BibleLicensesView, ESVTranslationRow, LicenseRow, RVTranslationRow (+3 more)

### Community 12 - "Community 12"
Cohesion: 0.20
Nodes (7): SaveState, error, idle, saved, saving, WallpaperCanvas, WallpaperExportView

### Community 13 - "Community 13"
Cohesion: 0.47
Nodes (1): VerseSelectionService

### Community 14 - "Community 14"
Cohesion: 0.18
Nodes (1): VerseSelectionServiceTests

### Community 15 - "Community 15"
Cohesion: 0.24
Nodes (9): CaseIterable, WidgetKind, circular, inline, rectangular, WidgetSettings, WidgetSettings.LongVerseStrategy, WidgetSettings.VerseMode (+1 more)

### Community 16 - "Community 16"
Cohesion: 0.42
Nodes (9): clean_inline(), derived(), excerpt(), fetch(), fit_category(), main(), parse_usfm(), segments() (+1 more)

### Community 17 - "Community 17"
Cohesion: 0.22
Nodes (5): ActionArea, Chip, InfoRow, MiniWidgetPreview, TodayView

### Community 18 - "Community 18"
Cohesion: 0.25
Nodes (8): CodingKey, CodingKeys, accentHex, backgroundHex, fontDesign, id, name, textHex

### Community 19 - "Community 19"
Cohesion: 0.29
Nodes (5): FavoritesModeView, FavoritesRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 20 - "Community 20"
Cohesion: 0.54
Nodes (7): clean(), derived(), excerpt(), fit_category(), main(), segments(), words()

### Community 21 - "Community 21"
Cohesion: 0.54
Nodes (7): derived(), excerpt(), fetch_json(), fit_category(), main(), segments(), words()

### Community 22 - "Community 22"
Cohesion: 0.54
Nodes (7): clean(), derived(), excerpt(), fit_category(), main(), segments(), words()

### Community 23 - "Community 23"
Cohesion: 0.29
Nodes (6): FitCategory, long, medium, short, veryLong, Verse

### Community 24 - "Community 24"
Cohesion: 0.29
Nodes (7): VerseMode, chapter, daily, favorites, memorization, topic, weeklyTheme

### Community 25 - "Community 25"
Cohesion: 0.33
Nodes (4): DailyVerseModeView, DailyVerseUpdateInterval, daily, everyEightHours

### Community 26 - "Community 26"
Cohesion: 0.29
Nodes (6): TopicModeOption, TopicModeView, TopicRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 27 - "Community 27"
Cohesion: 0.62
Nodes (6): derived(), excerpt(), fit_category(), main(), segments(), words()

### Community 28 - "Community 28"
Cohesion: 0.29
Nodes (2): SearchView, VerseDetailSheet

### Community 29 - "Community 29"
Cohesion: 0.29
Nodes (1): WidgetTheme

### Community 30 - "Community 30"
Cohesion: 0.33
Nodes (5): LicenseStatus, ccBySA, comingSoon, licensed, publicDomain

### Community 31 - "Community 31"
Cohesion: 0.33
Nodes (6): LongVerseStrategy, excerpt, excludeLong, referenceOnly, segmented, smartFit

### Community 32 - "Community 32"
Cohesion: 0.40
Nodes (4): weeklyPreview(), WeeklyThemeModeView, WeeklyThemePlan, WeeklyVersePreview

### Community 33 - "Community 33"
Cohesion: 0.53
Nodes (5): fetch_text(), load_json(), main(), Return the ESV text for a single-verse reference, or raise on hard failure., resolve_api_key()

### Community 34 - "Community 34"
Cohesion: 0.33
Nodes (1): LongVerseService

### Community 35 - "Community 35"
Cohesion: 0.33
Nodes (4): FavoriteDetailView, FavoriteRow, FavoritesView, String

### Community 36 - "Community 36"
Cohesion: 0.40
Nodes (2): TimelineProvider, VerseProvider

### Community 37 - "Community 37"
Cohesion: 0.60
Nodes (1): MemorizationService

### Community 38 - "Community 38"
Cohesion: 0.40
Nodes (3): ModeRow, ModeRowData, ModesView

### Community 39 - "Community 39"
Cohesion: 0.50
Nodes (3): OnboardingCompleteView, OnboardingHeader, OnboardingPageLayout

### Community 40 - "Community 40"
Cohesion: 0.50
Nodes (3): ModeChoiceCard, OnboardingModeCard, OnboardingModeView

### Community 41 - "Community 41"
Cohesion: 0.50
Nodes (3): OnboardingTranslationCard, OnboardingTranslationView, TranslationChoiceCard

### Community 42 - "Community 42"
Cohesion: 0.50
Nodes (3): OnboardingWidgetInstructionsView, WidgetInstructionRow, WidgetInstructionStep

### Community 43 - "Community 43"
Cohesion: 0.50
Nodes (3): OnboardingTranslationCard, OnboardingTranslationView, TranslationChoiceCard

### Community 44 - "Community 44"
Cohesion: 0.50
Nodes (2): Color, ThemeColors

### Community 45 - "Community 45"
Cohesion: 0.67
Nodes (2): App, WordUnlockedApp

### Community 47 - "Community 47"
Cohesion: 0.67
Nodes (2): MemorizationModeView, VerseSearchRow

### Community 48 - "Community 48"
Cohesion: 0.67
Nodes (2): OnboardingThemeView, ThemeChoiceSwatch

### Community 49 - "Community 49"
Cohesion: 0.67
Nodes (2): OnboardingProgressDots, OnboardingView

### Community 50 - "Community 50"
Cohesion: 0.67
Nodes (2): OnboardingProgressDots, OnboardingView

### Community 51 - "Community 51"
Cohesion: 1.00
Nodes (2): load(), main()

### Community 52 - "Community 52"
Cohesion: 0.67
Nodes (1): ThemeService

### Community 53 - "Community 53"
Cohesion: 0.67
Nodes (1): TranslationService

### Community 54 - "Community 54"
Cohesion: 0.67
Nodes (2): AppGroupSettings, Keys

### Community 55 - "Community 55"
Cohesion: 0.67
Nodes (2): TimelineEntry, VerseEntry

### Community 56 - "Community 56"
Cohesion: 0.67
Nodes (2): WidgetBundle, WordUnlockedWidgetBundle

### Community 57 - "Community 57"
Cohesion: 0.67
Nodes (2): Widget, WordUnlockedWidget

### Community 58 - "Community 58"
Cohesion: 0.67
Nodes (2): ContentView, MainTabView

## Knowledge Gaps
- **60 isolated node(s):** `old`, `new`, `easy`, `medium`, `hard` (+55 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `ASV import pipeline`** (1 nodes): `ScriptureDatabase`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `KJV import pipeline`** (1 nodes): `LongVerseServiceTests`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `iOS app build tools`** (1 nodes): `WidgetTimelineService`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `ESV API fetcher`** (1 nodes): `SettingsStore`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 8`** (1 nodes): `DatabaseService`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 13`** (1 nodes): `VerseSelectionService`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 14`** (1 nodes): `VerseSelectionServiceTests`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 28`** (2 nodes): `SearchView`, `VerseDetailSheet`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 29`** (1 nodes): `WidgetTheme`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 34`** (1 nodes): `LongVerseService`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 36`** (2 nodes): `TimelineProvider`, `VerseProvider`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 37`** (1 nodes): `MemorizationService`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 44`** (2 nodes): `Color`, `ThemeColors`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 45`** (2 nodes): `App`, `WordUnlockedApp`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 47`** (2 nodes): `MemorizationModeView`, `VerseSearchRow`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 48`** (2 nodes): `OnboardingThemeView`, `ThemeChoiceSwatch`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 49`** (2 nodes): `OnboardingProgressDots`, `OnboardingView`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 50`** (2 nodes): `OnboardingProgressDots`, `OnboardingView`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 51`** (2 nodes): `load()`, `main()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 52`** (1 nodes): `ThemeService`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 53`** (1 nodes): `TranslationService`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 54`** (2 nodes): `AppGroupSettings`, `Keys`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 55`** (2 nodes): `TimelineEntry`, `VerseEntry`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 56`** (2 nodes): `WidgetBundle`, `WordUnlockedWidgetBundle`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 57`** (2 nodes): `Widget`, `WordUnlockedWidget`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 58`** (2 nodes): `ContentView`, `MainTabView`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LongVerseServiceTests` connect `KJV import pipeline` to `LSV import pipeline`?**
  _High betweenness centrality (0.079) - this node is a cross-community bridge._
- **What connects `old`, `new`, `easy` to the rest of the system?**
  _60 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `LSV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.08866995073891626 - nodes in this community are weakly interconnected._
- **Should `KJV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.09523809523809523 - nodes in this community are weakly interconnected._
- **Should `Web seed fetcher` be split into smaller, more focused modules?**
  _Cohesion score 0.10526315789473684 - nodes in this community are weakly interconnected._
- **Should `Community 9` be split into smaller, more focused modules?**
  _Cohesion score 0.13333333333333333 - nodes in this community are weakly interconnected._
- **Should `Community 10` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._