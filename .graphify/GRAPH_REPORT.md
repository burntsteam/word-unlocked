# Graph Report - .  (2026-09-13)

## Corpus Check
- 87 files · ~116,775 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 559 nodes · 934 edges · 72 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output
- Edge kinds: method: 199 · calls: 182 · contains: 182 · inherits: 158 · MODIFIES: 93 · case_of: 60 · ON_BRANCH: 30 · PARENT_OF: 29 · rationale_for: 1


## Input Scope
- Requested: auto
- Resolved: committed (source: default-auto)
- Included files: 87 · Candidates: 117
- Excluded: 2 untracked · 1439 ignored · 1 sensitive · 0 missing committed
- Recommendation: Use --scope all or graphify.yaml inputs.corpus for a knowledge-base folder.

## Graph Freshness
- Built from Git commit: `7b57407`
- Compare this hash to `git rev-parse HEAD` before trusting freshness-sensitive graph output.
## God Nodes (most connected - your core abstractions)
1. `ScriptureDatabase` - 30 edges
2. `LongVerseServiceTests` - 21 edges
3. `VerseSelectionService` - 20 edges
4. `WidgetTimelineService` - 20 edges
5. `VerseSelectionServiceTests` - 20 edges
6. `SettingsStore` - 17 edges
7. `DatabaseService` - 15 edges
8. `ESVBibleServiceTests` - 11 edges
9. `VerseMode` - 9 edges
10. `WidgetTheme` - 9 edges

## Surprising Connections (you probably didn't know these)
- `3a44839 Give Lock Screen widget views a container background` --PARENT_OF--> `4ebcbf9 Choose verses in one database-backed selector shared by app and widget`  [EXTRACTED]
  git → git  _Bridges community 0 → community 11_
- `Books` --inherits--> `Equatable`  [EXTRACTED]
  WordUnlocked/Shared/Database/ScriptureDatabase.swift →   _Bridges community 23 → community 7_
- `FitCategory` --inherits--> `Codable`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Models/Verse.swift →   _Bridges community 25 → community 7_
- `FitCategory` --inherits--> `String`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Models/Verse.swift →   _Bridges community 25 → community 8_
- `MemorizationModeView` --inherits--> `View`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Modes/MemorizationModeView.swift →   _Bridges community 62 → community 10_

## Communities

### Community 0 - "Community 0"
Nodes (46): .arrayOfVersesRoundTripsThroughJSON(), .decodingFailsWhenARequiredKeyIsMissing(), .decodingLocksTheExpectedWireKeys(), .rvCachedVerseRoundTripsThroughJSON(), .singleVerseRoundTripsThroughJSON(), 1166ef5 test: add a unit test target covering the cache and selection rules, 126ee46 engram: Word Unlocked ship status 2026-09-12, 1524b07 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline, 2879ff0 chore: declare export compliance and tidy repo hygiene, 2b17ec3 graphify: name 46 placeholder communities via local model, 35537ab docs: add session handoff, 3a44839 Give Lock Screen widget views a container background, 3cc4c76 chore(graphify): refresh the graph and stop stray caches reaching git, 3f7b263 chore: track durable graphify + engram state, 5f4af3d docs: record Pages URLs, screenshot location, and 2026-09-12 status, 606b9f4 Add future translation roadmap to submission notes, 6552c8d chore(graphify): absorb post-commit hook output from the ESV batch, 6c96c57 feat: add an app icon, 701981f engram: test-host secrets gotcha; ESV enabled in ship status, 7b57407 Keep live-verse fetches from dropping, clobbering, or repeating, 7f5482d chore(graphify): fingerprint community membership in the label sidecar, 829ec96 docs: publish privacy, support, and landing pages, 8c91015 feat(translations): hide ESV until its API key is configured, 9c3ef43 docs(marketing): correct the RV listing and trim over-limit keywords, Decodable, ESVBibleService.swift, ESVBibleServiceTests.swift, ESVResponse, LSMResponse, LSMVerse, RVBibleService.swift, SharedModelsTests, SharedModelsTests.swift, a5b7d50 docs: use privacy@rippre.com contact; add 6.9" App Store screenshots, aa2cf1f fix(onboarding): offer every bundled translation, not just KJV, ad994f4 docs: ship ESV - seven translations across listing, site, and screenshots, c5336f0 chore(graphify): stop the graph from indexing its own output, d078d61 chore(graphify): commit the re-rendered report and track the description sidecar, e5e5323 Bundle the privacy manifests and declare the App Group defaults reason, ed5eb1d chore(graphify): absorb post-commit hook output from the release batch, fa28332 Inject the ESV API key so tests stop depending on build secrets, ffb162b Restore the curated community names in GRAPH_REPORT.md, generate-app-icon.swift, main, page(), rgb()

### Community 1 - "Community 1"
Nodes (30): .allVerses(), .books(), .boolColumn(), .conditions(), .connection(), .createSchema(), .deinit(), .execute(), .hasVerses(), .init(), .intColumn(), .intValue(), .likeEscaped(), .loadSeedRows(), .openDatabase(), .provisionDatabaseIfNeeded(), .query(), .queryVerses(), .quoted(), .scalarInt(), .searchVerses(), .seedRVTestingIfNeeded(), .stringColumn(), .stringValue(), .topics(), .translations(), .verse(), .verseCount(), .verses(), ScriptureDatabase

### Community 2 - "Community 2"
Nodes (28): .addFavorite(), .apply(), .applyingStore(), .cachedVerse(), .currentSettings(), .fetch(), .fetch(), .init(), .init(), .init(), .isFavorite(), .loadFavorites(), .loadMemorizationPlan(), .persistDefaults(), .reloadWidgetTimelines(), .removeFavorite(), .removeFavorites(), .report(), .report(), .resetWidgetSettings(), .save(), .saveFavorites(), .saveMemorizationPlan(), .store(), ESVBibleService, ObservableObject, RVBibleService, SettingsStore

### Community 3 - "Community 3"
Nodes (24): .builtInVerseIsJohn316WithItsRealDatabaseId(), .everyTopicHasVersesInEveryOfflineTranslation(), .excludeLongKeepsEveryDailyVerseShortWhileStillRotating(), .liveTranslationsRotateThroughTheKJVReferenceSet(), .pickReturnsNilForAnEmptyArray(), .pickReturnsTheElementAtStableIndex(), .pickReturnsTheElementAtStableIndexAcrossManyDates(), .pickStaysConsistentWithStableIndexAcrossManyDates(), .searchMatchesTextAndTreatsWildcardsAndQuotesLiterally(), .stableIndexAdvancesByOneEachDay(), .stableIndexIsDeterministicForTheSameInputs(), .stableIndexStaysInBoundsAcrossExtremeDates(), .stableIndexStaysInBoundsForDayComponentAcrossExtremeDates(), .stableIndexStaysInBoundsForWeekOfYearComponentAcrossExtremeDates(), .stableIndexWithZeroCountReturnsZeroInsteadOfCrashing(), .stableIndexYieldsDifferentValuesForDifferentDays(), .topicModeReturnsTheSelectedTranslation(), .weeklyIndexWalksTheFirstSevenVersesThroughAWeekSpanningNewYear(), .weeklyIndexWrapsWhenATopicHasFewerThanSevenVerses(), VerseSelectionServiceTests, VerseSelectionServiceTests.swift, emptyDefaults(), makeVerse(), settings()

### Community 4 - "Community 4"
Nodes (22): .excerptExactlyAtLimitIsUnchanged(), .excerptFarOverLimitBreaksOnWholeWords(), .excerptOfEmptyStringIsEmpty(), .excerptShorterThanLimitIsUnchanged(), .excerptWithNoWhitespaceFallsBackToHardTruncation(), .firstLettersExtractsAndUppercasesInitials(), .firstLettersOfEmptyStringIsEmpty(), .fitCategoryAtLongUpperBoundIsLong(), .fitCategoryAtMediumUpperBoundIsMedium(), .fitCategoryAtShortUpperBoundIsShort(), .fitCategoryAtZeroIsShort(), .fitCategoryJustPastLongIsVeryLong(), .fitCategoryJustPastMediumIsLong(), .fitCategoryJustPastShortIsMedium(), .fitCategoryWellPastLongIsVeryLong(), .segmentsExactlyAtLimitReturnsSingleSegment(), .segmentsFarOverLimitSplitsOnWordBoundaries(), .segmentsOfEmptyStringReturnsSingleEmptySegment(), .segmentsShorterThanLimitReturnsSingleSegment(), .segmentsWithNoWhitespaceCannotSplitAndOverflowsSingleSegment(), LongVerseServiceTests, LongVerseServiceTests.swift

### Community 5 - "Verse Selection Strategies"
Nodes (20): .bool(), .builtInVerse(), .chapterVerse(), .dailyBooks(), .dailyRecord(), .datedVerse(), .favoriteRecord(), .favoriteVerse(), .fitting(), .matching(), .memorizationVerse(), .pick(), .record(), .referenceCode(), .referenceTranslationCode(), .stableIndex(), .topicVerse(), .verse(), .weeklyIndex(), VerseSelectionService

### Community 6 - "Community 6"
Nodes (20): .bool(), .builtInVerse(), .cachedEntry(), .chapterVerse(), .dailyVerse(), .entryDates(), .favoriteVerse(), .generateTimeline(), .init(), .makeEntry(), .makeRVEntry(), .pick(), .readESVCache(), .readFavorites(), .readRVCache(), .readSettings(), .selectVerse(), .stableIndex(), .topicVerse(), WidgetTimelineService

### Community 7 - "Community 7"
Nodes (18): .init(), Book, Codable, Equatable, Favorite, Identifiable, LiveCachedVerse, SharedBookRecord, SharedModels.swift, SharedTopicRecord, SharedTranslationRecord, SharedVerseRecord, Topic, Translation, VerseSegment, WallpaperBackground, WeeklyPlan, WeeklyPlan.swift

### Community 8 - "Chapter Reading Configuration"
Nodes (15): Book.swift, ChapterEndBehavior, ChapterModeView, ChapterModeView.swift, ChapterRotationSpeed, String, Testament, daily, everySixHours, everyTwelveHours, new, nextChapter, old, repeatChapter, stop

### Community 9 - "Database Query Operations"
Nodes (15): .allVerses(), .book(), .books(), .fitCategory(), .init(), .search(), .topic(), .topics(), .translation(), .translations(), .verse(), .verseForToday(), .verses(), .weeklyPlanVerses(), DatabaseService

### Community 10 - "Settings and Translations UI"
Nodes (14): BibleLicensesView, ESVTranslationRow, LicenseRow, PrivacyPolicyView, PrivacyRow, RVTranslationRow, SettingsView, SettingsView.swift, ThemeSwatch, TranslationRow, TranslationsView, TranslationsView.swift, VerseSearchRow, View

### Community 11 - "Community 11"
Nodes (13): 4ebcbf9 Choose verses in one database-backed selector shared by app and widget, 676cef0 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, DatabaseService.swift, Favorite.swift, MemorizationModeView.swift, SearchView.swift, SettingsStore.swift, Topic.swift, Verse.swift, VerseSegment.swift, VerseSelectionService.swift, WidgetProvider.swift, WidgetTimelineService.swift

### Community 12 - "Wallpaper Export Workflow"
Nodes (12): .init(), .renderWallpaper(), .saveToPhotos(), .stepRow(), SaveState, WallpaperCanvas, WallpaperExportView, WallpaperView.swift, error, idle, saved, saving

### Community 13 - "Community 13"
Nodes (11): .applyingStoreEvictsExactlyTheOldestPastTheCapKeepingOldestFirst(), .applyingStoreOnAnEmptyCacheYieldsASingleEntry(), .applyingStoreUpsertsByFetchedRefInsteadOfDuplicating(), .cachedVerseReturnsNilForAReferenceThatWasNeverFetched(), .fetchForAnotherReferenceIsNotDroppedWhileOneIsInFlight(), .fetchReturnsImmediatelyWhenAlreadyFetching(), .fetchWithoutAnAPIKeyFailsWithAConfigurationErrorAndNeverStartsFetching(), .isConfiguredIsFalseWithoutAnAPIKey(), .isConfiguredOnlyWithANonEmptyAPIKey(), .maxCacheCountMatchesTheESVLicenseCap(), ESVBibleServiceTests

### Community 14 - "Widget Settings Model"
Nodes (10): CaseIterable, WidgetKind, WidgetSettings, WidgetSettings.LongVerseStrategy, WidgetSettings.VerseMode, WidgetSettings.WidgetKind, WidgetSettings.swift, circular, inline, rectangular

### Community 15 - "LSV import pipeline"
Nodes (10): clean_inline(), derived(), excerpt(), fetch(), fetch_lsv_seed.py, fit_category(), main(), parse_usfm(), segments(), words()

### Community 16 - "Today's Verse Display"
Nodes (9): .computeCurrentVerse(), .init(), .toggleFavorite(), ActionArea, Chip, InfoRow, MiniWidgetPreview, TodayView, TodayView.swift

### Community 17 - "Coding Key Definitions"
Nodes (8): CodingKey, CodingKeys, accentHex, backgroundHex, fontDesign, id, name, textHex

### Community 18 - "Memorization Plan Logic"
Nodes (8): Difficulty, MemorizationPlan, MemorizationPlan.Difficulty, MemorizationPlan.Phase, MemorizationPlan.swift, easy, hard, medium

### Community 19 - "Favorites Mode View"
Nodes (8): .loadPreferences(), .savePreferences(), FavoritesModeView, FavoritesModeView.swift, FavoritesRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 20 - "ASV import pipeline"
Nodes (8): clean(), derived(), excerpt(), fetch_asv_seed.py, fit_category(), main(), segments(), words()

### Community 21 - "KJV import pipeline"
Nodes (8): derived(), excerpt(), fetch_json(), fetch_kjv_seed.py, fit_category(), main(), segments(), words()

### Community 22 - "Web seed fetcher"
Nodes (8): clean(), derived(), excerpt(), fetch_web_seed.py, fit_category(), main(), segments(), words()

### Community 23 - "Community 23"
Nodes (7): Books, ScriptureDatabase.swift, VerseFilter, all, newTestament, oldTestament, psalmsAndProverbs

### Community 24 - "Community 24"
Nodes (7): Int, Phase, firstLetters, fullVerse, partialBlank, referenceOnly, review

### Community 25 - "Verse Length Categories"
Nodes (7): .init(), FitCategory, Verse, long, medium, short, veryLong

### Community 26 - "Daily Verse Mode Options"
Nodes (7): VerseMode, chapter, daily, favorites, memorization, topic, weeklyTheme

### Community 27 - "Daily Verse Mode View"
Nodes (7): .loadPreferences(), .savePreferences(), DailyVerseModeView, DailyVerseModeView.swift, DailyVerseUpdateInterval, daily, everyEightHours

### Community 28 - "BSB import pipeline"
Nodes (7): derived(), excerpt(), fetch_bsb_seed.py, fit_category(), main(), segments(), words()

### Community 29 - "Widget Theme Encoding"
Nodes (7): .encode(), .fontDesign(), .init(), .name(), .theme(), WidgetTheme, WidgetTheme.swift

### Community 30 - "Translation License Status"
Nodes (6): LicenseStatus, Translation.swift, ccBySA, comingSoon, licensed, publicDomain

### Community 31 - "Long Verse Handling Strategy"
Nodes (6): LongVerseStrategy, excerpt, excludeLong, referenceOnly, segmented, smartFit

### Community 32 - "ESV API fetcher"
Nodes (6): Return the ESV text for a single-verse reference, or raise on hard failure., fetch_esv_seed.py, fetch_text(), load_json(), main(), resolve_api_key()

### Community 33 - "Long Verse Text Processing"
Nodes (6): .excerpt(), .firstLetters(), .fitCategory(), .segments(), LongVerseService, LongVerseService.swift

### Community 34 - "Favorites List Interface"
Nodes (6): .prefixText(), FavoriteDetailView, FavoriteRow, FavoritesView, FavoritesView.swift, String

### Community 35 - "Memorization Display Logic"
Nodes (5): .currentPhase(), .displayText(), .partialBlank(), MemorizationService, MemorizationService.swift

### Community 36 - "Mode Selection Interface"
Nodes (5): .detailView(), ModeRow, ModeRowData, ModesView, ModesView.swift

### Community 37 - "Widget Data Provider"
Nodes (5): .getSnapshot(), .getTimeline(), .placeholder(), TimelineProvider, VerseProvider

### Community 38 - "Topic Mode View"
Nodes (4): TopicRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 39 - "Weekly Theme Preview View"
Nodes (4): WeeklyThemeModeView.swift, WeeklyThemePlan, WeeklyVersePreview, weeklyPreview()

### Community 40 - "Onboarding Completion Screen"
Nodes (4): OnboardingCompleteView, OnboardingCompleteView.swift, OnboardingHeader, OnboardingPageLayout

### Community 41 - "Onboarding Mode Selection"
Nodes (4): ModeChoiceCard, OnboardingModeCard, OnboardingModeView, OnboardingModeView.swift

### Community 42 - "Onboarding Translation Selection"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 43 - "Widget Instructions View"
Nodes (4): OnboardingWidgetInstructionsView, OnboardingWidgetInstructionsView.swift, WidgetInstructionRow, WidgetInstructionStep

### Community 44 - "Translation Selection View"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 45 - "Theme Color Definitions"
Nodes (4): .init(), Color, ThemeColors, ThemeColors.swift

### Community 46 - "App Entry Point"
Nodes (3): App, WordUnlockedApp, WordUnlockedApp.swift

### Community 47 - "App Icon Generator"
Nodes (3): generate-app-icon.swift, page(), rgb()

### Community 48 - "Community 48"
Nodes (3): TopicModeOption, TopicModeView, TopicModeView.swift

### Community 49 - "Onboarding Theme Selection"
Nodes (3): OnboardingThemeView, OnboardingThemeView.swift, ThemeChoiceSwatch

### Community 50 - "Main Onboarding Flow"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 51 - "Onboarding Progress Screen"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 52 - "Database Build Script"
Nodes (3): build_prebuilt_db.py, load(), main()

### Community 53 - "Theme Configuration Service"
Nodes (3): .theme(), ThemeService, ThemeService.swift

### Community 54 - "Translation Lookup Service"
Nodes (3): .translation(), TranslationService, TranslationService.swift

### Community 55 - "App Group Settings Keys"
Nodes (3): AppGroupSettings, AppGroupSettings.swift, Keys

### Community 56 - "Search and Favorite Actions"
Nodes (3): .performSearch(), .toggleFavorite(), SearchView

### Community 57 - "Community 57"
Nodes (3): .toggleFavorite(), .useForMemorization(), VerseDetailSheet

### Community 58 - "Widget Timeline Entries"
Nodes (3): TimelineEntry, VerseEntry, WidgetEntry.swift

### Community 59 - "Widget Bundle Entry"
Nodes (3): WidgetBundle, WordUnlockedWidgetBundle, WordUnlockedWidgetBundle.swift

### Community 60 - "Widget Display Component"
Nodes (3): Widget, WordUnlockedWidget, WordUnlockedWidget.swift

### Community 61 - "Main App Views"
Nodes (3): ContentView, ContentView.swift, MainTabView

### Community 62 - "Community 62"
Nodes (2): .search(), MemorizationModeView

### Community 63 - "Community 63"
Nodes (2): .loadPreview(), WeeklyThemeModeView

### Community 64 - "Community 64"
Nodes (2): OnboardingWelcomeView, OnboardingWelcomeView.swift

### Community 65 - "Community 65"
Nodes (2): LockScreenWidgetGuideView, LockScreenWidgetGuideView.swift

### Community 66 - "Community 66"
Nodes (2): WidgetEntryView, WidgetEntryView.swift

### Community 67 - "Community 67"
Nodes (2): CircularWidgetView, CircularWidgetView.swift

### Community 68 - "Community 68"
Nodes (2): HomeScreenWidgetView, HomeScreenWidgetView.swift

### Community 69 - "Community 69"
Nodes (2): InlineWidgetView, InlineWidgetView.swift

### Community 70 - "Community 70"
Nodes (2): RectangularWidgetView, RectangularWidgetView.swift

### Community 71 - "Community 71"
Nodes (2): WidgetEntryView, WidgetEntryView.swift

## Knowledge Gaps
- **64 isolated node(s):** `all`, `oldTestament`, `newTestament`, `psalmsAndProverbs`, `short` (+59 more)
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

- **Why does `ScriptureDatabase` connect `ASV import pipeline` to `Community 23`?**
  _High betweenness centrality (0.100) - this node is a cross-community bridge._
- **Why does `WidgetTimelineService` connect `ESV API fetcher` to `Community 11`?**
  _High betweenness centrality (0.066) - this node is a cross-community bridge._
- **What connects `all`, `oldTestament`, `newTestament` to the rest of the system?**
  _64 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `LSV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.07632850241545894 - nodes in this community are weakly interconnected._
- **Should `KJV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.10052910052910052 - nodes in this community are weakly interconnected._
- **Should `Web seed fetcher` be split into smaller, more focused modules?**
  _Cohesion score 0.10507246376811594 - nodes in this community are weakly interconnected._
- **Should `iOS app build tools` be split into smaller, more focused modules?**
  _Cohesion score 0.09090909090909091 - nodes in this community are weakly interconnected._