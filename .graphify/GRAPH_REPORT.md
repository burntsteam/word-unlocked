# Graph Report - .  (2026-09-13)

## Corpus Check
- 89 files · ~119,822 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 601 nodes · 1040 edges · 71 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output
- Edge kinds: method: 225 · calls: 221 · contains: 187 · inherits: 165 · MODIFIES: 107 · case_of: 67 · ON_BRANCH: 34 · PARENT_OF: 33 · rationale_for: 1


## Input Scope
- Requested: auto
- Resolved: committed (source: default-auto)
- Included files: 89 · Candidates: 119
- Excluded: 1 untracked · 1443 ignored · 1 sensitive · 0 missing committed
- Recommendation: Use --scope all or graphify.yaml inputs.corpus for a knowledge-base folder.

## Graph Freshness
- Built from Git commit: `fd8543d`
- Compare this hash to `git rev-parse HEAD` before trusting freshness-sensitive graph output.
## God Nodes (most connected - your core abstractions)
1. `VerseSelectionService` - 32 edges
2. `ScriptureDatabase` - 31 edges
3. `VerseSelectionServiceTests` - 31 edges
4. `LongVerseServiceTests` - 21 edges
5. `WidgetTimelineService` - 20 edges
6. `SettingsStore` - 19 edges
7. `DatabaseService` - 15 edges
8. `ESVBibleServiceTests` - 11 edges
9. `VerseMode` - 9 edges
10. `WidgetTheme` - 9 edges

## Surprising Connections (you probably didn't know these)
- `001201b chore(graphify): absorb post-commit hook output from the hardening batch` --PARENT_OF--> `fd8543d Make every mode setting change the verse`  [EXTRACTED]
  git → git  _Bridges community 0 → community 9_
- `Books` --inherits--> `Equatable`  [EXTRACTED]
  WordUnlocked/Shared/Database/ScriptureDatabase.swift →   _Bridges community 32 → community 8_
- `ChapterEndBehavior` --inherits--> `String`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Models/WidgetSettings.swift →   _Bridges community 5 → community 10_
- `LongVerseStrategy` --inherits--> `Codable`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Models/WidgetSettings.swift →   _Bridges community 28 → community 8_
- `LongVerseStrategy` --inherits--> `String`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Models/WidgetSettings.swift →   _Bridges community 28 → community 10_

## Communities

### Community 0 - "Community 0"
Nodes (49): .arrayOfVersesRoundTripsThroughJSON(), .decodingFailsWhenARequiredKeyIsMissing(), .decodingLocksTheExpectedWireKeys(), .rvCachedVerseRoundTripsThroughJSON(), .singleVerseRoundTripsThroughJSON(), 001201b chore(graphify): absorb post-commit hook output from the hardening batch, 1166ef5 test: add a unit test target covering the cache and selection rules, 126ee46 engram: Word Unlocked ship status 2026-09-12, 1524b07 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline, 1afb72b docs: record the hardening pass and the decisions it leaves open, 2879ff0 chore: declare export compliance and tidy repo hygiene, 2b17ec3 graphify: name 46 placeholder communities via local model, 35537ab docs: add session handoff, 3a44839 Give Lock Screen widget views a container background, 3cc4c76 chore(graphify): refresh the graph and stop stray caches reaching git, 3f7b263 chore: track durable graphify + engram state, 5f4af3d docs: record Pages URLs, screenshot location, and 2026-09-12 status, 606b9f4 Add future translation roadmap to submission notes, 6552c8d chore(graphify): absorb post-commit hook output from the ESV batch, 6c96c57 feat: add an app icon, 701981f engram: test-host secrets gotcha; ESV enabled in ship status, 7b57407 Keep live-verse fetches from dropping, clobbering, or repeating, 7f5482d chore(graphify): fingerprint community membership in the label sidecar, 829ec96 docs: publish privacy, support, and landing pages, 8c91015 feat(translations): hide ESV until its API key is configured, 9596b45 engram: verse-selection design; pbxproj resource-wiring gotcha, 9c3ef43 docs(marketing): correct the RV listing and trim over-limit keywords, Decodable, ESVBibleService.swift, ESVBibleServiceTests.swift, ESVResponse, LSMResponse, LSMVerse, RVBibleService.swift, SharedModelsTests, SharedModelsTests.swift, a5b7d50 docs: use privacy@rippre.com contact; add 6.9" App Store screenshots, aa2cf1f fix(onboarding): offer every bundled translation, not just KJV, ad994f4 docs: ship ESV - seven translations across listing, site, and screenshots, c5336f0 chore(graphify): stop the graph from indexing its own output, d078d61 chore(graphify): commit the re-rendered report and track the description sidecar, e5e5323 Bundle the privacy manifests and declare the App Group defaults reason, ed5eb1d chore(graphify): absorb post-commit hook output from the release batch, fa28332 Inject the ESV API key so tests stop depending on build secrets, ffb162b Restore the curated community names in GRAPH_REPORT.md, generate-app-icon.swift, main, page(), rgb()

### Community 1 - "Community 1"
Nodes (35): .builtInVerseIsJohn316WithItsRealDatabaseId(), .chapterNextChapterReadsOnAndWrapsFromRevelationToGenesis(), .chapterRepeatStartsTheChapterAgainAfterItsLastVerse(), .chapterRotationSpeedAdvancesWithinADay(), .chapterStopStaysOnTheLastVerse(), .everyTopicHasVersesInEveryOfflineTranslation(), .excludeLongKeepsEveryDailyVerseShortWhileStillRotating(), .favoritesShuffleShowsEachFavoriteOncePerPass(), .favoritesWithoutShuffleWalkSavedOrderAndCanSkipLongVerses(), .liveTranslationsRotateThroughTheKJVReferenceSet(), .pickReturnsNilForAnEmptyArray(), .pickReturnsTheElementAtStableIndex(), .pickReturnsTheElementAtStableIndexAcrossManyDates(), .pickStaysConsistentWithStableIndexAcrossManyDates(), .searchMatchesTextAndTreatsWildcardsAndQuotesLiterally(), .selectionStampChangesWhenAModeSettingChanges(), .shuffledOrderIsAReproduciblePermutation(), .slotAdvancesAtEachIntervalBoundaryAndCountsDaysWhenDaily(), .slotStartDatesBeginNowThenFollowEveryBoundary(), .stableIndexAdvancesByOneEachDay(), .stableIndexIsDeterministicForTheSameInputs(), .stableIndexStaysInBoundsAcrossExtremeDates(), .stableIndexStaysInBoundsForDayComponentAcrossExtremeDates(), .stableIndexStaysInBoundsForWeekOfYearComponentAcrossExtremeDates(), .stableIndexWithZeroCountReturnsZeroInsteadOfCrashing(), .stableIndexYieldsDifferentValuesForDifferentDays(), .topicModeReturnsTheSelectedTranslation(), .weeklyAutoRepeatOffMovesOnOneThemePerWeek(), .weeklyIndexWalksTheFirstSevenVersesThroughAWeekSpanningNewYear(), .weeklyIndexWrapsWhenATopicHasFewerThanSevenVerses(), VerseSelectionServiceTests, chapterVerse(), emptyDefaults(), settings(), withScratchDefaults()

### Community 2 - "Verse Selection Strategies"
Nodes (32): .bool(), .builtInVerse(), .chapterRecord(), .chapterVerse(), .dailyBooks(), .dailyRecord(), .datedVerse(), .dayNumber(), .favoriteInRotation(), .favoriteRecord(), .favoriteVerse(), .fitting(), .matching(), .memorizationVerse(), .pick(), .readingPlanRecord(), .record(), .referenceCode(), .referenceTranslationCode(), .rotationInterval(), .selectionStamp(), .shuffledOrder(), .slot(), .slotStartDates(), .stableIndex(), .topicVerse(), .verse(), .weeklyIndex(), .weeklyThemeRecord(), .weeklyTopicSlug(), .weeksBetween(), VerseSelectionService

### Community 3 - "Community 3"
Nodes (31): .allVerses(), .books(), .boolColumn(), .chapterVerseCounts(), .conditions(), .connection(), .createSchema(), .deinit(), .execute(), .hasVerses(), .init(), .intColumn(), .intValue(), .likeEscaped(), .loadSeedRows(), .openDatabase(), .provisionDatabaseIfNeeded(), .query(), .queryVerses(), .quoted(), .scalarInt(), .searchVerses(), .seedRVTestingIfNeeded(), .stringColumn(), .stringValue(), .topics(), .translations(), .verse(), .verseCount(), .verses(), ScriptureDatabase

### Community 4 - "Community 4"
Nodes (30): .addFavorite(), .apply(), .applyingStore(), .cachedVerse(), .currentSettings(), .fetch(), .fetch(), .init(), .init(), .init(), .isFavorite(), .loadFavorites(), .loadMemorizationPlan(), .persistDefaults(), .planStartKey(), .reloadWidgetTimelines(), .removeFavorite(), .removeFavorites(), .report(), .report(), .resetWidgetSettings(), .save(), .saveFavorites(), .saveMemorizationPlan(), .startPlan(), .store(), ESVBibleService, ObservableObject, RVBibleService, SettingsStore

### Community 5 - "Community 5"
Nodes (26): CaseIterable, ChapterEndBehavior, ChapterEndBehavior, Identifiable, MemorizationPlan, MemorizationPlan.Difficulty, MemorizationPlan.Phase, MemorizationPlan.swift, RotationInterval, TopicModeOption, WallpaperBackground, WidgetSettings, WidgetSettings.LongVerseStrategy, WidgetSettings.VerseMode, WidgetSettings.WidgetKind, WidgetSettings.swift, daily, everyEightHours, everySixHours, everyTwelveHours, nextChapter, nextChapter, repeatChapter, repeatChapter, stop, stop

### Community 6 - "Community 6"
Nodes (22): .excerptExactlyAtLimitIsUnchanged(), .excerptFarOverLimitBreaksOnWholeWords(), .excerptOfEmptyStringIsEmpty(), .excerptShorterThanLimitIsUnchanged(), .excerptWithNoWhitespaceFallsBackToHardTruncation(), .firstLettersExtractsAndUppercasesInitials(), .firstLettersOfEmptyStringIsEmpty(), .fitCategoryAtLongUpperBoundIsLong(), .fitCategoryAtMediumUpperBoundIsMedium(), .fitCategoryAtShortUpperBoundIsShort(), .fitCategoryAtZeroIsShort(), .fitCategoryJustPastLongIsVeryLong(), .fitCategoryJustPastMediumIsLong(), .fitCategoryJustPastShortIsMedium(), .fitCategoryWellPastLongIsVeryLong(), .segmentsExactlyAtLimitReturnsSingleSegment(), .segmentsFarOverLimitSplitsOnWordBoundaries(), .segmentsOfEmptyStringReturnsSingleEmptySegment(), .segmentsShorterThanLimitReturnsSingleSegment(), .segmentsWithNoWhitespaceCannotSplitAndOverflowsSingleSegment(), LongVerseServiceTests, LongVerseServiceTests.swift

### Community 7 - "Community 7"
Nodes (20): .bool(), .builtInVerse(), .cachedEntry(), .chapterVerse(), .dailyVerse(), .entryDates(), .favoriteVerse(), .generateTimeline(), .init(), .makeEntry(), .makeRVEntry(), .pick(), .readESVCache(), .readFavorites(), .readRVCache(), .readSettings(), .selectVerse(), .stableIndex(), .topicVerse(), WidgetTimelineService

### Community 8 - "Community 8"
Nodes (19): .init(), Book, Book.swift, ChapterVerseCount, Codable, Equatable, Favorite, Favorite.swift, LiveCachedVerse, SharedBookRecord, SharedModels.swift, SharedTopicRecord, SharedTranslationRecord, SharedVerseRecord, Topic, VerseFilter, VerseSegment, WeeklyPlan, WeeklyPlan.swift

### Community 9 - "Community 9"
Nodes (18): 4ebcbf9 Choose verses in one database-backed selector shared by app and widget, 676cef0 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, ChapterModeView.swift, DailyVerseModeView.swift, DatabaseService.swift, FavoritesModeView.swift, MemorizationModeView.swift, ScriptureDatabase.swift, SearchView.swift, SettingsStore.swift, Topic.swift, TopicModeView.swift, Verse.swift, VerseSegment.swift, VerseSelectionService.swift, WidgetProvider.swift, WidgetTimelineService.swift, fd8543d Make every mode setting change the verse

### Community 10 - "Community 10"
Nodes (18): .loadPreferences(), .savePreferences(), DailyVerseModeView, DailyVerseUpdateInterval, Difficulty, String, Testament, WidgetKind, circular, daily, easy, everyEightHours, hard, inline, medium, new, old, rectangular

### Community 11 - "Database Query Operations"
Nodes (15): .allVerses(), .book(), .books(), .fitCategory(), .init(), .search(), .topic(), .topics(), .translation(), .translations(), .verse(), .verseForToday(), .verses(), .weeklyPlanVerses(), DatabaseService

### Community 12 - "Settings and Translations UI"
Nodes (13): .search(), BibleLicensesView, ChapterModeView, ESVTranslationRow, LicenseRow, MemorizationModeView, RVTranslationRow, TopicModeView, TranslationRow, TranslationsView, TranslationsView.swift, VerseSearchRow, View

### Community 13 - "Wallpaper Export Workflow"
Nodes (12): .init(), .renderWallpaper(), .saveToPhotos(), .stepRow(), SaveState, WallpaperCanvas, WallpaperExportView, WallpaperView.swift, error, idle, saved, saving

### Community 14 - "Community 14"
Nodes (11): .applyingStoreEvictsExactlyTheOldestPastTheCapKeepingOldestFirst(), .applyingStoreOnAnEmptyCacheYieldsASingleEntry(), .applyingStoreUpsertsByFetchedRefInsteadOfDuplicating(), .cachedVerseReturnsNilForAReferenceThatWasNeverFetched(), .fetchForAnotherReferenceIsNotDroppedWhileOneIsInFlight(), .fetchReturnsImmediatelyWhenAlreadyFetching(), .fetchWithoutAnAPIKeyFailsWithAConfigurationErrorAndNeverStartsFetching(), .isConfiguredIsFalseWithoutAnAPIKey(), .isConfiguredOnlyWithANonEmptyAPIKey(), .maxCacheCountMatchesTheESVLicenseCap(), ESVBibleServiceTests

### Community 15 - "LSV import pipeline"
Nodes (10): clean_inline(), derived(), excerpt(), fetch(), fetch_lsv_seed.py, fit_category(), main(), parse_usfm(), segments(), words()

### Community 16 - "Today's Verse Display"
Nodes (9): .computeCurrentVerse(), .init(), .toggleFavorite(), ActionArea, Chip, InfoRow, MiniWidgetPreview, TodayView, TodayView.swift

### Community 17 - "Coding Key Definitions"
Nodes (8): CodingKey, CodingKeys, accentHex, backgroundHex, fontDesign, id, name, textHex

### Community 18 - "ASV import pipeline"
Nodes (8): clean(), derived(), excerpt(), fetch_asv_seed.py, fit_category(), main(), segments(), words()

### Community 19 - "KJV import pipeline"
Nodes (8): derived(), excerpt(), fetch_json(), fetch_kjv_seed.py, fit_category(), main(), segments(), words()

### Community 20 - "Web seed fetcher"
Nodes (8): clean(), derived(), excerpt(), fetch_web_seed.py, fit_category(), main(), segments(), words()

### Community 21 - "Community 21"
Nodes (7): Int, Phase, firstLetters, fullVerse, partialBlank, referenceOnly, review

### Community 22 - "Translation License Status"
Nodes (7): LicenseStatus, Translation, Translation.swift, ccBySA, comingSoon, licensed, publicDomain

### Community 23 - "Verse Length Categories"
Nodes (7): .init(), FitCategory, Verse, long, medium, short, veryLong

### Community 24 - "Daily Verse Mode Options"
Nodes (7): VerseMode, chapter, daily, favorites, memorization, topic, weeklyTheme

### Community 25 - "Favorites Mode View"
Nodes (7): .loadPreferences(), .savePreferences(), FavoritesModeView, FavoritesRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 26 - "BSB import pipeline"
Nodes (7): derived(), excerpt(), fetch_bsb_seed.py, fit_category(), main(), segments(), words()

### Community 27 - "Widget Theme Encoding"
Nodes (7): .encode(), .fontDesign(), .init(), .name(), .theme(), WidgetTheme, WidgetTheme.swift

### Community 28 - "Long Verse Handling Strategy"
Nodes (6): LongVerseStrategy, excerpt, excludeLong, referenceOnly, segmented, smartFit

### Community 29 - "ESV API fetcher"
Nodes (6): Return the ESV text for a single-verse reference, or raise on hard failure., fetch_esv_seed.py, fetch_text(), load_json(), main(), resolve_api_key()

### Community 30 - "Long Verse Text Processing"
Nodes (6): .excerpt(), .firstLetters(), .fitCategory(), .segments(), LongVerseService, LongVerseService.swift

### Community 31 - "Favorites List Interface"
Nodes (6): .prefixText(), FavoriteDetailView, FavoriteRow, FavoritesView, FavoritesView.swift, String

### Community 32 - "Community 32"
Nodes (5): Books, all, newTestament, oldTestament, psalmsAndProverbs

### Community 33 - "Memorization Display Logic"
Nodes (5): .currentPhase(), .displayText(), .partialBlank(), MemorizationService, MemorizationService.swift

### Community 34 - "Mode Selection Interface"
Nodes (5): .detailView(), ModeRow, ModeRowData, ModesView, ModesView.swift

### Community 35 - "Community 35"
Nodes (5): PrivacyPolicyView, PrivacyRow, SettingsView, SettingsView.swift, ThemeSwatch

### Community 36 - "Widget Data Provider"
Nodes (5): .getSnapshot(), .getTimeline(), .placeholder(), TimelineProvider, VerseProvider

### Community 37 - "Community 37"
Nodes (4): ChapterRotationSpeed, daily, everySixHours, everyTwelveHours

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

### Community 55 - "Search and Favorite Actions"
Nodes (3): .performSearch(), .toggleFavorite(), SearchView

### Community 56 - "Community 56"
Nodes (3): .toggleFavorite(), .useForMemorization(), VerseDetailSheet

### Community 57 - "Widget Timeline Entries"
Nodes (3): TimelineEntry, VerseEntry, WidgetEntry.swift

### Community 58 - "Widget Bundle Entry"
Nodes (3): WidgetBundle, WordUnlockedWidgetBundle, WordUnlockedWidgetBundle.swift

### Community 59 - "Widget Display Component"
Nodes (3): Widget, WordUnlockedWidget, WordUnlockedWidget.swift

### Community 60 - "Main App Views"
Nodes (3): ContentView, ContentView.swift, MainTabView

### Community 61 - "Community 61"
Nodes (2): .loadPreview(), WeeklyThemeModeView

### Community 62 - "Community 62"
Nodes (2): OnboardingWelcomeView, OnboardingWelcomeView.swift

### Community 63 - "Community 63"
Nodes (2): LockScreenWidgetGuideView, LockScreenWidgetGuideView.swift

### Community 64 - "Community 64"
Nodes (2): WidgetEntryView, WidgetEntryView.swift

### Community 65 - "Community 65"
Nodes (2): VerseSelectionServiceTests.swift, makeVerse()

### Community 66 - "Community 66"
Nodes (2): CircularWidgetView, CircularWidgetView.swift

### Community 67 - "Community 67"
Nodes (2): HomeScreenWidgetView, HomeScreenWidgetView.swift

### Community 68 - "Community 68"
Nodes (2): InlineWidgetView, InlineWidgetView.swift

### Community 69 - "Community 69"
Nodes (2): RectangularWidgetView, RectangularWidgetView.swift

### Community 70 - "Community 70"
Nodes (2): WidgetEntryView, WidgetEntryView.swift

## Knowledge Gaps
- **71 isolated node(s):** `all`, `oldTestament`, `newTestament`, `psalmsAndProverbs`, `inline` (+66 more)
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

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `VerseSelectionService` connect `KJV import pipeline` to `Community 9`?**
  _High betweenness centrality (0.100) - this node is a cross-community bridge._
- **Why does `ScriptureDatabase` connect `Web seed fetcher` to `Community 9`?**
  _High betweenness centrality (0.093) - this node is a cross-community bridge._
- **Why does `VerseSelectionServiceTests` connect `ASV import pipeline` to `Community 65`?**
  _High betweenness centrality (0.077) - this node is a cross-community bridge._
- **What connects `all`, `oldTestament`, `newTestament` to the rest of the system?**
  _71 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `LSV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.07227891156462585 - nodes in this community are weakly interconnected._
- **Should `ASV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.08067226890756303 - nodes in this community are weakly interconnected._
- **Should `iOS app build tools` be split into smaller, more focused modules?**
  _Cohesion score 0.09885057471264368 - nodes in this community are weakly interconnected._