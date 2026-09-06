# Graph Report - .  (2026-08-31)

## Corpus Check
- Corpus is ~32,439 words - fits in a single context window. You may not need a graph.

## Summary
- 499 nodes · 795 edges · 59 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output
- Edge kinds: contains: 177 · method: 165 · inherits: 155 · calls: 140 · MODIFIES: 74 · case_of: 56 · ON_BRANCH: 14 · PARENT_OF: 13 · rationale_for: 1


## Input Scope
- Requested: auto
- Resolved: committed (source: default-auto)
- Included files: 75 · Candidates: 104
- Excluded: 1 untracked · 518 ignored · 1 sensitive · 0 missing committed
- Recommendation: Use --scope all or graphify.yaml inputs.corpus for a knowledge-base folder.

## Graph Freshness
- Built from Git commit: `3cc4c76`
- Compare this hash to `git rev-parse HEAD` before trusting freshness-sensitive graph output.
## God Nodes (most connected - your core abstractions)
1. `ScriptureDatabase` - 25 edges
2. `LongVerseServiceTests` - 21 edges
3. `SettingsStore` - 17 edges
4. `WidgetTimelineService` - 17 edges
5. `DatabaseService` - 15 edges
6. `VerseSelectionService` - 11 edges
7. `VerseMode` - 9 edges
8. `WidgetTheme` - 9 edges
9. `ESVBibleServiceTests` - 9 edges
10. `VerseSelectionServiceTests` - 9 edges

## Surprising Connections (you probably didn't know these)
- `676cef0 Initial commit: Word Unlocked — iOS scripture Lock Screen widget` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 3 → community 0_
- `Testament` --inherits--> `Codable`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Models/Book.swift →   _Bridges community 10 → community 5_
- `Difficulty` --inherits--> `Codable`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Models/MemorizationPlan.swift →   _Bridges community 9 → community 5_
- `Difficulty` --inherits--> `String`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Models/MemorizationPlan.swift →   _Bridges community 9 → community 10_
- `MemorizationPlan.Difficulty` --inherits--> `CaseIterable`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Models/MemorizationPlan.swift →   _Bridges community 9 → community 15_

## Communities

### Community 0 - "LSV import pipeline"
Nodes (36): .applyingStoreEvictsExactlyTheOldestPastTheCapKeepingOldestFirst(), .applyingStoreOnAnEmptyCacheYieldsASingleEntry(), .applyingStoreUpsertsByFetchedRefInsteadOfDuplicating(), .arrayOfVersesRoundTripsThroughJSON(), .cachedVerseReturnsNilForAReferenceThatWasNeverFetched(), .decodingFailsWhenARequiredKeyIsMissing(), .decodingLocksTheExpectedWireKeys(), .fetchReturnsImmediatelyWhenAlreadyFetching(), .fetchWithoutAnAPIKeyFailsWithAConfigurationErrorAndNeverStartsFetching(), .isConfiguredIsFalseWithoutAnAPIKey(), .maxCacheCountMatchesTheESVLicenseCap(), .rvCachedVerseRoundTripsThroughJSON(), .singleVerseRoundTripsThroughJSON(), 1166ef5 test: add a unit test target covering the cache and selection rules, 1524b07 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline, 2879ff0 chore: declare export compliance and tidy repo hygiene, 3cc4c76 chore(graphify): refresh the graph and stop stray caches reaching git, 3f7b263 chore: track durable graphify + engram state, 606b9f4 Add future translation roadmap to submission notes, 6c96c57 feat: add an app icon, 7f5482d chore(graphify): fingerprint community membership in the label sidecar, 829ec96 docs: publish privacy, support, and landing pages, 8c91015 feat(translations): hide ESV until its API key is configured, 9c3ef43 docs(marketing): correct the RV listing and trim over-limit keywords, ESVBibleServiceTests, ESVBibleServiceTests.swift, LongVerseServiceTests.swift, SharedModelsTests, SharedModelsTests.swift, VerseSelectionService.swift, aa2cf1f fix(onboarding): offer every bundled translation, not just KJV, c5336f0 chore(graphify): stop the graph from indexing its own output, generate-app-icon.swift, main, page(), rgb()

### Community 1 - "ASV import pipeline"
Nodes (26): .allVerses(), .books(), .boolColumn(), .createSchema(), .deinit(), .execute(), .hasVerses(), .init(), .intColumn(), .intValue(), .loadSeedRows(), .openDatabase(), .provisionDatabaseIfNeeded(), .query(), .queryVerses(), .quoted(), .scalarInt(), .seedRVTestingIfNeeded(), .stringColumn(), .stringValue(), .topics(), .translations(), .verse(), .verses(), ScriptureDatabase, ScriptureDatabase.swift

### Community 2 - "KJV import pipeline"
Nodes (21): .excerptExactlyAtLimitIsUnchanged(), .excerptFarOverLimitBreaksOnWholeWords(), .excerptOfEmptyStringIsEmpty(), .excerptShorterThanLimitIsUnchanged(), .excerptWithNoWhitespaceFallsBackToHardTruncation(), .firstLettersExtractsAndUppercasesInitials(), .firstLettersOfEmptyStringIsEmpty(), .fitCategoryAtLongUpperBoundIsLong(), .fitCategoryAtMediumUpperBoundIsMedium(), .fitCategoryAtShortUpperBoundIsShort(), .fitCategoryAtZeroIsShort(), .fitCategoryJustPastLongIsVeryLong(), .fitCategoryJustPastMediumIsLong(), .fitCategoryJustPastShortIsMedium(), .fitCategoryWellPastLongIsVeryLong(), .segmentsExactlyAtLimitReturnsSingleSegment(), .segmentsFarOverLimitSplitsOnWordBoundaries(), .segmentsOfEmptyStringReturnsSingleEmptySegment(), .segmentsShorterThanLimitReturnsSingleSegment(), .segmentsWithNoWhitespaceCannotSplitAndOverflowsSingleSegment(), LongVerseServiceTests

### Community 3 - "Web seed fetcher"
Nodes (19): 676cef0 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, CircularWidgetView, CircularWidgetView.swift, Favorite.swift, HomeScreenWidgetView, HomeScreenWidgetView.swift, InlineWidgetView, InlineWidgetView.swift, LockScreenWidgetGuideView, LockScreenWidgetGuideView.swift, OnboardingWelcomeView, OnboardingWelcomeView.swift, RectangularWidgetView, RectangularWidgetView.swift, Topic.swift, VerseSegment.swift, WeeklyPlan.swift, WidgetEntryView, WidgetEntryView.swift

### Community 4 - "iOS app build tools"
Nodes (18): .bool(), .builtInVerse(), .chapterVerse(), .dailyVerse(), .favoriteVerse(), .generateTimeline(), .init(), .makeEntry(), .makeRVEntry(), .pick(), .readESVCache(), .readFavorites(), .readSettings(), .selectVerse(), .stableIndex(), .topicVerse(), WidgetTimelineService, WidgetTimelineService.swift

### Community 5 - "BSB import pipeline"
Nodes (17): .init(), Book, Codable, Equatable, Favorite, Identifiable, LiveCachedVerse, SharedBookRecord, SharedModels.swift, SharedTopicRecord, SharedTranslationRecord, SharedVerseRecord, Topic, Translation, VerseSegment, WallpaperBackground, WeeklyPlan

### Community 6 - "ESV API fetcher"
Nodes (17): .addFavorite(), .apply(), .currentSettings(), .init(), .isFavorite(), .loadFavorites(), .loadMemorizationPlan(), .persistDefaults(), .reloadWidgetTimelines(), .removeFavorite(), .removeFavorites(), .resetWidgetSettings(), .save(), .saveFavorites(), .saveMemorizationPlan(), SettingsStore, SettingsStore.swift

### Community 7 - "ESV Bible Data Fetching"
Nodes (16): .applyingStore(), .cachedVerse(), .fetch(), .fetch(), .init(), .init(), .store(), Decodable, ESVBibleService, ESVBibleService.swift, ESVResponse, LSMResponse, LSMVerse, ObservableObject, RVBibleService, RVBibleService.swift

### Community 8 - "Database Query Operations"
Nodes (16): .allVerses(), .book(), .books(), .fitCategory(), .init(), .search(), .topic(), .topics(), .translation(), .translations(), .verse(), .verseForToday(), .verses(), .weeklyPlanVerses(), DatabaseService, DatabaseService.swift

### Community 9 - "Memorization Plan Logic"
Nodes (15): Difficulty, Int, MemorizationPlan, MemorizationPlan.Difficulty, MemorizationPlan.Phase, MemorizationPlan.swift, Phase, easy, firstLetters, fullVerse, hard, medium, partialBlank, referenceOnly, review

### Community 10 - "Chapter Reading Configuration"
Nodes (15): Book.swift, ChapterEndBehavior, ChapterModeView, ChapterModeView.swift, ChapterRotationSpeed, String, Testament, daily, everySixHours, everyTwelveHours, new, nextChapter, old, repeatChapter, stop

### Community 11 - "Settings and Translations UI"
Nodes (13): BibleLicensesView, ESVTranslationRow, LicenseRow, PrivacyPolicyView, PrivacyRow, RVTranslationRow, SettingsView, SettingsView.swift, ThemeSwatch, TranslationRow, TranslationsView, TranslationsView.swift, View

### Community 12 - "Wallpaper Export Workflow"
Nodes (12): .init(), .renderWallpaper(), .saveToPhotos(), .stepRow(), SaveState, WallpaperCanvas, WallpaperExportView, WallpaperView.swift, error, idle, saved, saving

### Community 13 - "Verse Selection Strategies"
Nodes (11): .builtInVerse(), .chapterVerse(), .datedVerse(), .favoriteVerse(), .memorizationVerse(), .pick(), .referenceCode(), .stableIndex(), .topicVerse(), .verse(), VerseSelectionService

### Community 14 - "Verse Selection Tests"
Nodes (11): .pickReturnsNilForAnEmptyArray(), .pickReturnsTheElementAtStableIndex(), .pickStaysConsistentWithStableIndexAcrossManyDates(), .stableIndexIsDeterministicForTheSameInputs(), .stableIndexStaysInBoundsForDayComponentAcrossExtremeDates(), .stableIndexStaysInBoundsForWeekOfYearComponentAcrossExtremeDates(), .stableIndexWithZeroCountReturnsZeroInsteadOfCrashing(), .stableIndexYieldsDifferentValuesForDifferentDays(), VerseSelectionServiceTests, VerseSelectionServiceTests.swift, makeVerse()

### Community 15 - "Widget Settings Model"
Nodes (10): CaseIterable, WidgetKind, WidgetSettings, WidgetSettings.LongVerseStrategy, WidgetSettings.VerseMode, WidgetSettings.WidgetKind, WidgetSettings.swift, circular, inline, rectangular

### Community 16 - "LSV import pipeline"
Nodes (10): clean_inline(), derived(), excerpt(), fetch(), fetch_lsv_seed.py, fit_category(), main(), parse_usfm(), segments(), words()

### Community 17 - "Today's Verse Display"
Nodes (9): .computeCurrentVerse(), .init(), .toggleFavorite(), ActionArea, Chip, InfoRow, MiniWidgetPreview, TodayView, TodayView.swift

### Community 18 - "Coding Key Definitions"
Nodes (8): CodingKey, CodingKeys, accentHex, backgroundHex, fontDesign, id, name, textHex

### Community 19 - "Favorites Mode View"
Nodes (8): .loadPreferences(), .savePreferences(), FavoritesModeView, FavoritesModeView.swift, FavoritesRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 20 - "ASV import pipeline"
Nodes (8): clean(), derived(), excerpt(), fetch_asv_seed.py, fit_category(), main(), segments(), words()

### Community 21 - "KJV import pipeline"
Nodes (8): derived(), excerpt(), fetch_json(), fetch_kjv_seed.py, fit_category(), main(), segments(), words()

### Community 22 - "Web seed fetcher"
Nodes (8): clean(), derived(), excerpt(), fetch_web_seed.py, fit_category(), main(), segments(), words()

### Community 23 - "Verse Length Categories"
Nodes (7): FitCategory, Verse, Verse.swift, long, medium, short, veryLong

### Community 24 - "Daily Verse Mode Options"
Nodes (7): VerseMode, chapter, daily, favorites, memorization, topic, weeklyTheme

### Community 25 - "Daily Verse Mode View"
Nodes (7): .loadPreferences(), .savePreferences(), DailyVerseModeView, DailyVerseModeView.swift, DailyVerseUpdateInterval, daily, everyEightHours

### Community 26 - "Topic Mode View"
Nodes (7): TopicModeOption, TopicModeView, TopicModeView.swift, TopicRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 27 - "BSB import pipeline"
Nodes (7): derived(), excerpt(), fetch_bsb_seed.py, fit_category(), main(), segments(), words()

### Community 28 - "Search and Favorite Actions"
Nodes (7): .performSearch(), .toggleFavorite(), .toggleFavorite(), .useForMemorization(), SearchView, SearchView.swift, VerseDetailSheet

### Community 29 - "Widget Theme Encoding"
Nodes (7): .encode(), .fontDesign(), .init(), .name(), .theme(), WidgetTheme, WidgetTheme.swift

### Community 30 - "Translation License Status"
Nodes (6): LicenseStatus, Translation.swift, ccBySA, comingSoon, licensed, publicDomain

### Community 31 - "Long Verse Handling Strategy"
Nodes (6): LongVerseStrategy, excerpt, excludeLong, referenceOnly, segmented, smartFit

### Community 32 - "Weekly Theme Preview View"
Nodes (6): .loadPreview(), WeeklyThemeModeView, WeeklyThemeModeView.swift, WeeklyThemePlan, WeeklyVersePreview, weeklyPreview()

### Community 33 - "ESV API fetcher"
Nodes (6): Return the ESV text for a single-verse reference, or raise on hard failure., fetch_esv_seed.py, fetch_text(), load_json(), main(), resolve_api_key()

### Community 34 - "Long Verse Text Processing"
Nodes (6): .excerpt(), .firstLetters(), .fitCategory(), .segments(), LongVerseService, LongVerseService.swift

### Community 35 - "Favorites List Interface"
Nodes (6): .prefixText(), FavoriteDetailView, FavoriteRow, FavoritesView, FavoritesView.swift, String

### Community 36 - "Widget Data Provider"
Nodes (6): .getSnapshot(), .getTimeline(), .placeholder(), TimelineProvider, VerseProvider, WidgetProvider.swift

### Community 37 - "Memorization Display Logic"
Nodes (5): .currentPhase(), .displayText(), .partialBlank(), MemorizationService, MemorizationService.swift

### Community 38 - "Mode Selection Interface"
Nodes (5): .detailView(), ModeRow, ModeRowData, ModesView, ModesView.swift

### Community 39 - "Onboarding Completion Screen"
Nodes (4): OnboardingCompleteView, OnboardingCompleteView.swift, OnboardingHeader, OnboardingPageLayout

### Community 40 - "Onboarding Mode Selection"
Nodes (4): ModeChoiceCard, OnboardingModeCard, OnboardingModeView, OnboardingModeView.swift

### Community 41 - "Onboarding Translation Selection"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 42 - "Widget Instructions View"
Nodes (4): OnboardingWidgetInstructionsView, OnboardingWidgetInstructionsView.swift, WidgetInstructionRow, WidgetInstructionStep

### Community 43 - "Translation Selection View"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 44 - "Theme Color Definitions"
Nodes (4): .init(), Color, ThemeColors, ThemeColors.swift

### Community 45 - "App Entry Point"
Nodes (3): App, WordUnlockedApp, WordUnlockedApp.swift

### Community 46 - "App Icon Generator"
Nodes (3): generate-app-icon.swift, page(), rgb()

### Community 47 - "Memorization Mode View"
Nodes (3): MemorizationModeView, MemorizationModeView.swift, VerseSearchRow

### Community 48 - "Onboarding Theme Selection"
Nodes (3): OnboardingThemeView, OnboardingThemeView.swift, ThemeChoiceSwatch

### Community 49 - "Main Onboarding Flow"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 50 - "Onboarding Progress Screen"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 51 - "Database Build Script"
Nodes (3): build_prebuilt_db.py, load(), main()

### Community 52 - "Theme Configuration Service"
Nodes (3): .theme(), ThemeService, ThemeService.swift

### Community 53 - "Translation Lookup Service"
Nodes (3): .translation(), TranslationService, TranslationService.swift

### Community 54 - "App Group Settings Keys"
Nodes (3): AppGroupSettings, AppGroupSettings.swift, Keys

### Community 55 - "Widget Timeline Entries"
Nodes (3): TimelineEntry, VerseEntry, WidgetEntry.swift

### Community 56 - "Widget Bundle Entry"
Nodes (3): WidgetBundle, WordUnlockedWidgetBundle, WordUnlockedWidgetBundle.swift

### Community 57 - "Widget Display Component"
Nodes (3): Widget, WordUnlockedWidget, WordUnlockedWidget.swift

### Community 58 - "Main App Views"
Nodes (3): ContentView, ContentView.swift, MainTabView

## Knowledge Gaps
- **60 isolated node(s):** `old`, `new`, `easy`, `medium`, `hard` (+55 more)
  These have ≤1 connection - possible missing edges or undocumented components.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LongVerseServiceTests` connect `KJV import pipeline` to `LSV import pipeline`?**
  _High betweenness centrality (0.079) - this node is a cross-community bridge._
- **What connects `old`, `new`, `easy` to the rest of the system?**
  _60 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `LSV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.0746031746031746 - nodes in this community are weakly interconnected._
- **Should `KJV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.09523809523809523 - nodes in this community are weakly interconnected._
- **Should `Web seed fetcher` be split into smaller, more focused modules?**
  _Cohesion score 0.10526315789473684 - nodes in this community are weakly interconnected._
- **Should `Memorization Plan Logic` be split into smaller, more focused modules?**
  _Cohesion score 0.13333333333333333 - nodes in this community are weakly interconnected._
- **Should `Chapter Reading Configuration` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._