# Graph Report - .  (2026-09-22)

## Corpus Check
- 85 files · ~123,681 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 732 nodes · 1436 edges · 59 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output
- Edge kinds: calls: 307 · method: 284 · MODIFIES: 235 · contains: 203 · inherits: 174 · ON_BRANCH: 79 · PARENT_OF: 77 · case_of: 76 · rationale_for: 1


## Input Scope
- Requested: all
- Resolved: all (source: cli)
- Included files: 85 · Candidates: recursive
- Excluded: 0 untracked · 0 ignored · 2 sensitive · 0 missing committed

## Graph Freshness
- Built from Git commit: `0bf66bd`
- Compare this hash to `git rev-parse HEAD` before trusting freshness-sensitive graph output.
## God Nodes (most connected - your core abstractions)
1. `VerseSelectionService` - 37 edges
2. `VerseSelectionServiceTests` - 37 edges
3. `ScriptureDatabase` - 32 edges
4. `ESVBibleServiceTests` - 23 edges
5. `LongVerseServiceTests` - 21 edges
6. `ESVBibleService` - 20 edges
7. `WidgetTimelineService` - 20 edges
8. `SettingsStore` - 19 edges
9. `DatabaseService` - 15 edges
10. `settings()` - 12 edges

## Surprising Connections (you probably didn't know these)
- `1996503 chore(graphify): absorb post-commit hook output from the hardening batch` --PARENT_OF--> `701d0d8 Make every mode setting change the verse`  [EXTRACTED]
  git → git  _Bridges community 0 → community 1_
- `Books` --inherits--> `Equatable`  [EXTRACTED]
  WordUnlocked/Shared/Database/ScriptureDatabase.swift →   _Bridges community 21 → community 8_
- `ChapterVerseCount` --inherits--> `Equatable`  [EXTRACTED]
  WordUnlocked/Shared/Database/ScriptureDatabase.swift →   _Bridges community 6 → community 8_
- `Testament` --inherits--> `Codable`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Models/Book.swift →   _Bridges community 12 → community 8_
- `Difficulty` --inherits--> `Codable`  [EXTRACTED]
  WordUnlocked/WordUnlocked/Models/MemorizationPlan.swift →   _Bridges community 14 → community 8_

## Communities

### Community 0 - "Test Utilities and Scripts"
Nodes (79): 001201b chore(graphify): absorb post-commit hook output from the hardening batch, 0be6fd8 Add future translation roadmap to submission notes, 0bf66bd engram: GitHub secret scanning is on but blind to this repo's two secrets, 10220dc chore(graphify): fingerprint community membership in the label sidecar, 1166ef5 test: add a unit test target covering the cache and selection rules, 126ee46 engram: Word Unlocked ship status 2026-09-12, 1524b07 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline, 1996503 chore(graphify): absorb post-commit hook output from the hardening batch, 1afb72b docs: record the hardening pass and the decisions it leaves open, 1f0ac83 engram: Word Unlocked ship status 2026-09-12, 25233be feat: add an app icon, 2879ff0 chore: declare export compliance and tidy repo hygiene, 299e463 docs(marketing): correct the RV listing and trim over-limit keywords, 2b17ec3 graphify: name 46 placeholder communities via local model, 35537ab docs: add session handoff, 3a44839 Give Lock Screen widget views a container background, 3cc4c76 chore(graphify): refresh the graph and stop stray caches reaching git, 3f7b263 chore: track durable graphify + engram state, 4d7d876 Keep live-verse fetches from dropping, clobbering, or repeating, 5f4af3d docs: record Pages URLs, screenshot location, and 2026-09-12 status, 606b9f4 Add future translation roadmap to submission notes, 6130d84 Inject the ESV API key so tests stop depending on build secrets, 6552c8d chore(graphify): absorb post-commit hook output from the ESV batch, 68a479b engram: rotation semantics; era day ordinality rolls over at UTC midnight, 6c96c57 feat: add an app icon, 701981f engram: test-host secrets gotcha; ESV enabled in ship status, 724315e engram: test-host secrets gotcha; ESV enabled in ship status, 79714a1 chore(graphify): absorb post-commit hook output from the handoff update, 7b57407 Keep live-verse fetches from dropping, clobbering, or repeating, 7f48826 Restore the curated community names in GRAPH_REPORT.md, 7f5482d chore(graphify): fingerprint community membership in the label sidecar, 820767f feat(translations): hide ESV until its API key is configured, 824ec6d docs: record the implemented mode settings and the 5 PM day rollover, 826bf9c fix(onboarding): offer every bundled translation, not just KJV, 8291b79 docs: record the 2026-09-14 session in the handoff, 829ec96 docs: publish privacy, support, and landing pages, 82f5d22 docs: ship ESV - seven translations across listing, site, and screenshots, 830b7f0 chore(graphify): refresh the graph and stop stray caches reaching git, 8c91015 feat(translations): hide ESV until its API key is configured, 9596b45 engram: verse-selection design; pbxproj resource-wiring gotcha, 98b262d docs: record secret scanning and the current to-do list in the handoff, 98e0574 chore(graphify): absorb post-commit hook output from the ESV batch, 9a52cd9 chore(graphify): commit the re-rendered report and track the description sidecar, 9c3ef43 docs(marketing): correct the RV listing and trim over-limit keywords, ESVBibleService.swift, ESVBibleServiceTests.swift, LongVerseServiceTests.swift, SharedModelsTests.swift, a5b7d50 docs: use privacy@rippre.com contact; add 6.9" App Store screenshots, aa2cf1f fix(onboarding): offer every bundled translation, not just KJV, aad5fb6 docs: record Pages URLs, screenshot location, and 2026-09-12 status, ad994f4 docs: ship ESV - seven translations across listing, site, and screenshots, b5ef1ce chore(graphify): absorb post-commit hook output from the licensing and Weekly Plan batch, b7adf6f chore: declare export compliance and tidy repo hygiene, c1bb9af graphify: name 46 placeholder communities via local model, c47336c Bundle the privacy manifests and declare the App Group defaults reason, c5336f0 chore(graphify): stop the graph from indexing its own output, ca64e70 chore(graphify): stop the graph from indexing its own output, d078d61 chore(graphify): commit the re-rendered report and track the description sidecar, d9d693f test: add a unit test target covering the cache and selection rules, de3bef8 chore: track durable graphify + engram state, e24446a chore(graphify): absorb post-commit hook output from the release batch, e5966e1 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline, e5e5323 Bundle the privacy manifests and declare the App Group defaults reason, ea4ae89 docs: publish privacy, support, and landing pages, eac92c8 docs: describe ESV and Recovery Version storage and Weekly Plan, ed5eb1d chore(graphify): absorb post-commit hook output from the release batch, ee01380 docs: use privacy@rippre.com contact; add 6.9" App Store screenshots, f252501 docs: add session handoff, f3814f9 docs: record the hardening pass and the decisions it leaves open, f498d4b chore(graphify): absorb post-commit hook output from the mode-settings batch, f8ef2e8 engram: live translation licensing; Weekly Plan semantics; commit email rewrite, fa28332 Inject the ESV API key so tests stop depending on build secrets, fefb492 engram: verse-selection design; pbxproj resource-wiring gotcha, ffb162b Restore the curated community names in GRAPH_REPORT.md, generate-app-icon.swift, main, page(), rgb()

### Community 1 - "Core Scripture Models"
Nodes (70): .init(), .theme(), .translation(), 27d8d8a Choose verses in one database-backed selector shared by app and widget, 4ebcbf9 Choose verses in one database-backed selector shared by app and widget, 676cef0 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, 6fe3b58 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, 701d0d8 Make every mode setting change the verse, 9986f75 Give Lock Screen widget views a container background, App, AppGroupSettings, AppGroupSettings.swift, Book.swift, ChapterModeView.swift, CircularWidgetView.swift, Color, DailyVerseModeView.swift, DatabaseService.swift, Favorite.swift, FavoritesModeView.swift, HomeScreenWidgetView.swift, InlineWidgetView.swift, Keys, LockScreenWidgetGuideView.swift, LongVerseService.swift, MemorizationModeView.swift, MemorizationService.swift, ModesView.swift, OnboardingWelcomeView.swift, RectangularWidgetView.swift, ScriptureDatabase.swift, SearchView.swift, SettingsStore.swift, ThemeColors.swift, ThemeService, ThemeService.swift, TimelineEntry, TodayView.swift, Topic.swift, TopicModeView.swift, Translation.swift, TranslationService, TranslationService.swift, Verse.swift, VerseEntry, VerseSegment.swift, VerseSelectionService.swift, WallpaperView.swift, WeeklyPlan.swift, WeeklyThemeModeView.swift, WeeklyVersePreview, Widget, WidgetBundle, WidgetEntry.swift, WidgetEntryView.swift, WidgetProvider.swift, WidgetTheme.swift, WidgetTimelineService.swift, WordUnlockedApp, WordUnlockedApp.swift, WordUnlockedWidget, WordUnlockedWidget.swift, WordUnlockedWidgetBundle, WordUnlockedWidgetBundle.swift, b13e9d7 Keep ESV within Crossway's limits, stop storing Recovery Version text, add Weekly Plan sources, build_prebuilt_db.py, fd8543d Make every mode setting change the verse, load(), main(), weeklyPreview()

### Community 2 - "Verse Index Stability Logic"
Nodes (44): .builtInVerseIsJohn316WithItsRealDatabaseId(), .chapterNextChapterReadsOnAndWrapsFromRevelationToGenesis(), .chapterRepeatStartsTheChapterAgainAfterItsLastVerse(), .chapterRotationSpeedAdvancesWithinADay(), .chapterStopStaysOnTheLastVerse(), .everyTopicHasVersesInEveryOfflineTranslation(), .excludeLongKeepsEveryDailyVerseShortWhileStillRotating(), .favoritesShuffleShowsEachFavoriteOncePerPass(), .favoritesWithoutShuffleWalkSavedOrderAndCanSkipLongVerses(), .liveRecordCarriesTheLiveTextMeasuredForTheLockScreen(), .liveTranslationsRotateThroughTheKJVReferenceSet(), .pickReturnsNilForAnEmptyArray(), .pickReturnsTheElementAtStableIndex(), .pickReturnsTheElementAtStableIndexAcrossManyDates(), .pickStaysConsistentWithStableIndexAcrossManyDates(), .searchMatchesTextAndTreatsWildcardsAndQuotesLiterally(), .selectionStampChangesWhenAModeSettingChanges(), .shuffledOrderIsAReproduciblePermutation(), .slotAdvancesAtEachIntervalBoundaryAndCountsDaysWhenDaily(), .slotStartDatesBeginNowThenFollowEveryBoundary(), .stableIndexAdvancesByOneEachDay(), .stableIndexIsDeterministicForTheSameInputs(), .stableIndexStaysInBoundsAcrossExtremeDates(), .stableIndexStaysInBoundsForDayComponentAcrossExtremeDates(), .stableIndexStaysInBoundsForWeekOfYearComponentAcrossExtremeDates(), .stableIndexWithZeroCountReturnsZeroInsteadOfCrashing(), .stableIndexYieldsDifferentValuesForDifferentDays(), .topicModeReturnsTheSelectedTranslation(), .upcomingRecordsListEachComingVerseOnceAndStopWhenAModeOnlyRepeats(), .weeklyAutoRepeatOffMovesOnOneThemePerWeek(), .weeklyIndexWalksTheFirstSevenVersesThroughAWeekSpanningNewYear(), .weeklyIndexWrapsWhenATopicHasFewerThanSevenVerses(), .weeklyPlanReadsItsSavedBookOneVerseADay(), .weeklyPlanRepeatsItsFirstSevenVersesOrMovesOnSevenAWeek(), .weeklyPlanShowsYourOwnVersesInTheSelectedTranslation(), .weeklyPlanThemeWithoutRepeatReachesItsLaterVerses(), VerseSelectionServiceTests, VerseSelectionServiceTests.swift, chapterVerse(), emptyDefaults(), makeVerse(), settings(), weekDay(), withScratchDefaults()

### Community 3 - "ESV Service Tests"
Nodes (38): .aDownloadKeepsThePlannedVersesInOrderAndStartsThe48HourWait(), .aRefusedRequestIsReportedAndStillWaits48Hours(), .allowanceStopsAtHalfOfABookAndAt500VersesCountingFavorites(), .applyingStoreEvictsExactlyTheOldestPastTheCapKeepingOldestFirst(), .applyingStoreOnAnEmptyCacheYieldsASingleEntry(), .applyingStoreUpsertsByFetchedRefInsteadOfDuplicating(), .beingOfflineDoesNotStartThe48HourWait(), .cachedVerseReturnsNilForAReferenceThatWasNeverFetched(), .canInit(), .canonicalRequest(), .downloadedVersesAreKeyedByTheirRequestedReferenceAndWidenedPassagesAreDropped(), .fetchForAnotherReferenceIsNotDroppedWhileOneIsInFlight(), .fetchReturnsImmediatelyWhenAlreadyFetching(), .fetchWithoutAnAPIKeyFailsWithAConfigurationErrorAndNeverStartsFetching(), .isConfiguredIsFalseWithoutAnAPIKey(), .isConfiguredOnlyWithANonEmptyAPIKey(), .limitsMatchCrosswaysTermsAndTheSharedKeysBudget(), .liveDownloadReturnsTheESVTextOfJohn316AndPsalm23(), .maxCacheCountMatchesTheESVLicenseCap(), .noDownloadStartsWithin48HoursOfTheLastOne(), .nothingIsRequestedWhenEveryPlannedVerseIsAlreadyHere(), .oneRequestAsksForEveryVerseByIdAndFitsTheAPIsRequestLine(), .plannedVersesFollowTheModeFromNowWithinCrosswaysLimits(), .requestCount(), .session(), .startLoading(), .stopLoading(), .stub(), .verseTextDropsTheNumberWhatComesBeforeItAndPoetryLayout(), ESVBibleServiceTests, StubURLProtocol, URLProtocol, esvResponse(), response(), unwrittenDefaults(), verse(), withScratchStore(), withScratchSuite()

### Community 4 - "Verse Selection Strategies"
Nodes (37): .bool(), .builtInVerse(), .chapterRecord(), .chapterVerse(), .dailyBooks(), .dailyRecord(), .datedVerse(), .dayNumber(), .favoriteInRotation(), .favoriteRecord(), .favoriteVerse(), .filteredRecord(), .fitting(), .liveRecord(), .matching(), .memorizationVerse(), .pick(), .readingPlanRecord(), .record(), .referenceCode(), .referenceTranslationCode(), .rotationInterval(), .selectionStamp(), .shuffledOrder(), .slot(), .slotStartDates(), .stableIndex(), .textRecord(), .topicVerse(), .upcomingRecords(), .verse(), .weeklyIndex(), .weeklyRecord(), .weeklyThemeRecord(), .weeklyTopicSlug(), .weeksBetween(), VerseSelectionService

### Community 5 - "ESV Service Logic"
Nodes (34): .admit(), .applyingStore(), .cachedVerse(), .canSaveFavorite(), .failedBeforeReachingServer(), .fetch(), .init(), .init(), .isFetchDue(), .passageId(), .plannedVerses(), .recordFetch(), .refreshIfDue(), .report(), .request(), .savedFavoriteBookIds(), .store(), .update(), .verseText(), .verses(), Allowance, CodingKey, CodingKeys, CodingKeys, ESVBibleService, accentHex, backgroundHex, fontDesign, id, name, parsed, passageMeta, passages, textHex

### Community 6 - "Database Context Methods"
Nodes (34): .allVerses(), .bookVerseCounts(), .books(), .boolColumn(), .chapterVerseCounts(), .conditions(), .connection(), .createSchema(), .deinit(), .execute(), .hasVerses(), .init(), .intColumn(), .intValue(), .likeEscaped(), .loadSeedRows(), .openDatabase(), .provisionDatabaseIfNeeded(), .query(), .queryVerses(), .quoted(), .scalarInt(), .searchVerses(), .seedRVTestingIfNeeded(), .stringColumn(), .stringValue(), .topics(), .translations(), .verse(), .verseCount(), .verses(), ChapterVerseCount, ScriptureDatabase, VerseFilter

### Community 7 - "RV Bible Service Layer"
Nodes (32): .addFavorite(), .apply(), .currentSettings(), .fetch(), .init(), .init(), .isFavorite(), .loadFavorites(), .loadMemorizationPlan(), .persistDefaults(), .planStartKey(), .reloadWidgetTimelines(), .removeFavorite(), .removeFavorites(), .report(), .request(), .resetWidgetSettings(), .save(), .saveFavorites(), .saveMemorizationPlan(), .startPlan(), .verse(), Decodable, ESVResponse, LSMResponse, LSMVerse, LoadedVerse, ObservableObject, PassageMeta, RVBibleService, RVBibleService.swift, SettingsStore

### Community 8 - "Shared Model Definitions"
Nodes (24): .init(), .init(), .save(), .storedESVVerses(), Book, Codable, Equatable, Favorite, Identifiable, LiveCachedVerse, ModeRowData, SharedBookRecord, SharedModels.swift, SharedTopicRecord, SharedTranslationRecord, SharedVerseRecord, ThemeColors, Topic, TopicModeOption, Translation, VerseSegment, WallpaperBackground, WeeklyPlan, WeeklyThemePlan

### Community 9 - "Primary UI Components"
Nodes (23): ActionArea, BibleLicensesView, ChapterModeView, Chip, CircularWidgetView, ESVTranslationRow, HomeScreenWidgetView, InfoRow, InlineWidgetView, LicenseRow, LockScreenWidgetGuideView, MiniWidgetPreview, ModeRow, OnboardingWelcomeView, RVTranslationRow, RectangularWidgetView, TopicModeView, TranslationRow, TranslationsView, TranslationsView.swift, VerseSearchRow, View, WidgetEntryView

### Community 10 - "Verse Category Classification"
Nodes (21): .excerptExactlyAtLimitIsUnchanged(), .excerptFarOverLimitBreaksOnWholeWords(), .excerptOfEmptyStringIsEmpty(), .excerptShorterThanLimitIsUnchanged(), .excerptWithNoWhitespaceFallsBackToHardTruncation(), .firstLettersExtractsAndUppercasesInitials(), .firstLettersOfEmptyStringIsEmpty(), .fitCategoryAtLongUpperBoundIsLong(), .fitCategoryAtMediumUpperBoundIsMedium(), .fitCategoryAtShortUpperBoundIsShort(), .fitCategoryAtZeroIsShort(), .fitCategoryJustPastLongIsVeryLong(), .fitCategoryJustPastMediumIsLong(), .fitCategoryJustPastShortIsMedium(), .fitCategoryWellPastLongIsVeryLong(), .segmentsExactlyAtLimitReturnsSingleSegment(), .segmentsFarOverLimitSplitsOnWordBoundaries(), .segmentsOfEmptyStringReturnsSingleEmptySegment(), .segmentsShorterThanLimitReturnsSingleSegment(), .segmentsWithNoWhitespaceCannotSplitAndOverflowsSingleSegment(), LongVerseServiceTests

### Community 11 - "Widget Timeline Generator"
Nodes (20): .bool(), .builtInVerse(), .cachedEntry(), .chapterVerse(), .dailyVerse(), .entryDates(), .favoriteVerse(), .generateTimeline(), .init(), .makeEntry(), .makeRVEntry(), .pick(), .readESVCache(), .readFavorites(), .readRVCache(), .readSettings(), .selectVerse(), .stableIndex(), .topicVerse(), WidgetTimelineService

### Community 12 - "Theme and Status Types"
Nodes (19): .loadPreferences(), .savePreferences(), DailyVerseModeView, DailyVerseUpdateInterval, LicenseStatus, String, Testament, WidgetKind, ccBySA, circular, comingSoon, daily, everyEightHours, inline, licensed, new, old, publicDomain, rectangular

### Community 13 - "Widget Configuration Settings"
Nodes (15): CaseIterable, ChapterEndBehavior, RotationInterval, WidgetSettings, WidgetSettings.LongVerseStrategy, WidgetSettings.VerseMode, WidgetSettings.WidgetKind, WidgetSettings.swift, daily, everyEightHours, everySixHours, everyTwelveHours, nextChapter, repeatChapter, stop

### Community 14 - "Memorization Plan Logic"
Nodes (15): Difficulty, Int, MemorizationPlan, MemorizationPlan.Difficulty, MemorizationPlan.Phase, MemorizationPlan.swift, Phase, easy, firstLetters, fullVerse, hard, medium, partialBlank, referenceOnly, review

### Community 15 - "Database Query Operations"
Nodes (15): .allVerses(), .book(), .books(), .fitCategory(), .init(), .search(), .topic(), .topics(), .translation(), .translations(), .verse(), .verseForToday(), .verses(), .weeklyPlanVerses(), DatabaseService

### Community 16 - "LSV import pipeline"
Nodes (10): clean_inline(), derived(), excerpt(), fetch(), fetch_lsv_seed.py, fit_category(), main(), parse_usfm(), segments(), words()

### Community 17 - "ASV import pipeline"
Nodes (8): clean(), derived(), excerpt(), fetch_asv_seed.py, fit_category(), main(), segments(), words()

### Community 18 - "KJV import pipeline"
Nodes (8): derived(), excerpt(), fetch_json(), fetch_kjv_seed.py, fit_category(), main(), segments(), words()

### Community 19 - "Web seed fetcher"
Nodes (8): clean(), derived(), excerpt(), fetch_web_seed.py, fit_category(), main(), segments(), words()

### Community 20 - "RV Bible Service Tests"
Nodes (8): .aLoadedVerseCarriesLSMsAttributionAndIsKeptInMemoryOnly(), .liveFetchReturnsTheRecoveryVersionOfJohn316(), .rejectedCredentialsAreReported(), .requestAsksForTheReferenceWithBasicAuthentication(), .withoutATokenNothingIsRequested(), RVBibleServiceTests, RVBibleServiceTests.swift, lsmResponse()

### Community 21 - "Testament Enumerations"
Nodes (7): Books, all, book, chapter, newTestament, oldTestament, psalmsAndProverbs

### Community 22 - "Verse Length Categories"
Nodes (7): .init(), FitCategory, Verse, long, medium, short, veryLong

### Community 23 - "Daily Verse Mode Options"
Nodes (7): VerseMode, chapter, daily, favorites, memorization, topic, weeklyTheme

### Community 24 - "Favorites Mode View"
Nodes (7): .loadPreferences(), .savePreferences(), FavoritesModeView, FavoritesRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 25 - "BSB import pipeline"
Nodes (7): derived(), excerpt(), fetch_bsb_seed.py, fit_category(), main(), segments(), words()

### Community 26 - "Shared Model Serialization Tests"
Nodes (7): .arrayOfVersesRoundTripsThroughJSON(), .decodingFailsWhenARequiredKeyIsMissing(), .decodingLocksTheExpectedWireKeys(), .rvCachedVerseRoundTripsThroughJSON(), .singleVerseRoundTripsThroughJSON(), .storedVersesReadBackWhatWasWrittenAndNothingFromCorruptData(), SharedModelsTests

### Community 27 - "Long Verse Handling Strategy"
Nodes (6): LongVerseStrategy, excerpt, excludeLong, referenceOnly, segmented, smartFit

### Community 28 - "ESV API fetcher"
Nodes (6): Return the ESV text for a single-verse reference, or raise on hard failure., fetch_esv_seed.py, fetch_text(), load_json(), main(), resolve_api_key()

### Community 29 - "Favorites List Interface"
Nodes (6): .prefixText(), FavoriteDetailView, FavoriteRow, FavoritesView, FavoritesView.swift, String

### Community 30 - "Wallpaper Export Workflow"
Nodes (6): .init(), .renderWallpaper(), .saveToPhotos(), .stepRow(), WallpaperCanvas, WallpaperExportView

### Community 31 - "Widget Theme Encoding"
Nodes (6): .encode(), .fontDesign(), .init(), .name(), .theme(), WidgetTheme

### Community 32 - "Source Theme Properties"
Nodes (5): Source, book, chapter, custom, theme

### Community 33 - "Long Verse Text Processing"
Nodes (5): .excerpt(), .firstLetters(), .fitCategory(), .segments(), LongVerseService

### Community 34 - "Settings Interface Elements"
Nodes (5): PrivacyPolicyView, PrivacyRow, SettingsView, SettingsView.swift, ThemeSwatch

### Community 35 - "Save State Machine"
Nodes (5): SaveState, error, idle, saved, saving

### Community 36 - "Widget Data Provider"
Nodes (5): .getSnapshot(), .getTimeline(), .placeholder(), TimelineProvider, VerseProvider

### Community 37 - "Chapter End Behavior Modes"
Nodes (4): ChapterEndBehavior, nextChapter, repeatChapter, stop

### Community 38 - "Chapter Rotation Frequency Options"
Nodes (4): ChapterRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 39 - "Topic Mode View"
Nodes (4): TopicRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 40 - "Weekly Theme Controller"
Nodes (4): .load(), .loadPreview(), .start(), WeeklyThemeModeView

### Community 41 - "Onboarding Completion Screen"
Nodes (4): OnboardingCompleteView, OnboardingCompleteView.swift, OnboardingHeader, OnboardingPageLayout

### Community 42 - "Onboarding Mode Selection"
Nodes (4): ModeChoiceCard, OnboardingModeCard, OnboardingModeView, OnboardingModeView.swift

### Community 43 - "Onboarding Translation Selection"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 44 - "Widget Instructions View"
Nodes (4): OnboardingWidgetInstructionsView, OnboardingWidgetInstructionsView.swift, WidgetInstructionRow, WidgetInstructionStep

### Community 45 - "Translation Selection View"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 46 - "Memorization Display Logic"
Nodes (4): .currentPhase(), .displayText(), .partialBlank(), MemorizationService

### Community 47 - "Today Display Controller"
Nodes (4): .computeCurrentVerse(), .init(), .toggleFavorite(), TodayView

### Community 48 - "App Icon Generator"
Nodes (3): generate-app-icon.swift, page(), rgb()

### Community 49 - "Onboarding Theme Selection"
Nodes (3): OnboardingThemeView, OnboardingThemeView.swift, ThemeChoiceSwatch

### Community 50 - "Main Onboarding Flow"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 51 - "Onboarding Progress Screen"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 52 - "Search and Favorite Actions"
Nodes (3): .performSearch(), .toggleFavorite(), SearchView

### Community 53 - "Verse Detail Actions"
Nodes (3): .toggleFavorite(), .useForMemorization(), VerseDetailSheet

### Community 54 - "Main App Views"
Nodes (3): ContentView, ContentView.swift, MainTabView

### Community 55 - "Memorization Mode View"
Nodes (2): .search(), MemorizationModeView

### Community 56 - "Verse Picker Interface"
Nodes (2): .row(), WeeklyVersePicker

### Community 57 - "Modes Navigation View"
Nodes (2): .detailView(), ModesView

### Community 58 - "Widget Entry View Implementation"
Nodes (2): WidgetEntryView, WidgetEntryView.swift

## Knowledge Gaps
- **79 isolated node(s):** `all`, `oldTestament`, `newTestament`, `psalmsAndProverbs`, `book` (+74 more)
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

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `VerseSelectionService` connect `iOS app build tools` to `ASV import pipeline`?**
  _High betweenness centrality (0.095) - this node is a cross-community bridge._
- **Why does `ScriptureDatabase` connect `ESV API fetcher` to `ASV import pipeline`?**
  _High betweenness centrality (0.080) - this node is a cross-community bridge._
- **What connects `all`, `oldTestament`, `newTestament` to the rest of the system?**
  _79 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ASV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.06832298136645963 - nodes in this community are weakly interconnected._
- **Should `ESV API fetcher` be split into smaller, more focused modules?**
  _Cohesion score 0.1497326203208556 - nodes in this community are weakly interconnected._
- **Should `Primary UI Components` be split into smaller, more focused modules?**
  _Cohesion score 0.1067193675889328 - nodes in this community are weakly interconnected._
- **Should `Theme and Status Types` be split into smaller, more focused modules?**
  _Cohesion score 0.10526315789473684 - nodes in this community are weakly interconnected._