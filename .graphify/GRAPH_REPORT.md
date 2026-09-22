# Graph Report - .  (2026-09-22)

## Corpus Check
- 93 files · ~125,559 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 736 nodes · 1444 edges · 65 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output
- Edge kinds: calls: 307 · method: 284 · MODIFIES: 235 · contains: 203 · inherits: 174 · ON_BRANCH: 83 · PARENT_OF: 81 · case_of: 76 · rationale_for: 1


## Input Scope
- Requested: auto
- Resolved: committed (source: default-auto)
- Included files: 93 · Candidates: 124
- Excluded: 0 untracked · 1652 ignored · 2 sensitive · 0 missing committed
- Recommendation: Use --scope all or graphify.yaml inputs.corpus for a knowledge-base folder.

## Graph Freshness
- Built from Git commit: `a5526c4`
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
  git → git  _Bridges community 0 → community 8_
- `1f0ac83 engram: Word Unlocked ship status 2026-09-12` --PARENT_OF--> `6130d84 Inject the ESV API key so tests stop depending on build secrets`  [EXTRACTED]
  git → git  _Bridges community 0 → community 10_
- `27d8d8a Choose verses in one database-backed selector shared by app and widget` --PARENT_OF--> `4d7d876 Keep live-verse fetches from dropping, clobbering, or repeating`  [EXTRACTED]
  git → git  _Bridges community 8 → community 10_
- `6fe3b58 Initial commit: Word Unlocked — iOS scripture Lock Screen widget` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 4 → community 0_
- `724315e engram: test-host secrets gotcha; ESV enabled in ship status` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 36 → community 0_

## Communities

### Community 0 - "Test Utilities and Scripts"
Nodes (55): 001201b chore(graphify): absorb post-commit hook output from the hardening batch, 08a7eea chore(graphify): describe every node in the graph, 0be6fd8 Add future translation roadmap to submission notes, 0bf66bd engram: GitHub secret scanning is on but blind to this repo's two secrets, 10220dc chore(graphify): fingerprint community membership in the label sidecar, 126ee46 engram: Word Unlocked ship status 2026-09-12, 1996503 chore(graphify): absorb post-commit hook output from the hardening batch, 1afb72b docs: record the hardening pass and the decisions it leaves open, 1f0ac83 engram: Word Unlocked ship status 2026-09-12, 25233be feat: add an app icon, 2879ff0 chore: declare export compliance and tidy repo hygiene, 299e463 docs(marketing): correct the RV listing and trim over-limit keywords, 2b17ec3 graphify: name 46 placeholder communities via local model, 35537ab docs: add session handoff, 3a44839 Give Lock Screen widget views a container background, 3cc4c76 chore(graphify): refresh the graph and stop stray caches reaching git, 5f4af3d docs: record Pages URLs, screenshot location, and 2026-09-12 status, 6552c8d chore(graphify): absorb post-commit hook output from the ESV batch, 68a479b engram: rotation semantics; era day ordinality rolls over at UTC midnight, 701981f engram: test-host secrets gotcha; ESV enabled in ship status, 79714a1 chore(graphify): absorb post-commit hook output from the handoff update, 7f48826 Restore the curated community names in GRAPH_REPORT.md, 824ec6d docs: record the implemented mode settings and the 5 PM day rollover, 8291b79 docs: record the 2026-09-14 session in the handoff, 829ec96 docs: publish privacy, support, and landing pages, 830b7f0 chore(graphify): refresh the graph and stop stray caches reaching git, 9596b45 engram: verse-selection design; pbxproj resource-wiring gotcha, 98b262d docs: record secret scanning and the current to-do list in the handoff, 9a52cd9 chore(graphify): commit the re-rendered report and track the description sidecar, 9c3ef43 docs(marketing): correct the RV listing and trim over-limit keywords, a2a1fb8 chore(graphify,engram): rebuild the graph, name every community, refresh ship status, a5526c4 chore(graphify,engram): absorb hook output, record the describe workflow, a5b7d50 docs: use privacy@rippre.com contact; add 6.9" App Store screenshots, aad5fb6 docs: record Pages URLs, screenshot location, and 2026-09-12 status, ad994f4 docs: ship ESV - seven translations across listing, site, and screenshots, b5ef1ce chore(graphify): absorb post-commit hook output from the licensing and Weekly Plan batch, b7adf6f chore: declare export compliance and tidy repo hygiene, c1bb9af graphify: name 46 placeholder communities via local model, ca64e70 chore(graphify): stop the graph from indexing its own output, d078d61 chore(graphify): commit the re-rendered report and track the description sidecar, de3bef8 chore: track durable graphify + engram state, e24446a chore(graphify): absorb post-commit hook output from the release batch, e5966e1 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline, e5e5323 Bundle the privacy manifests and declare the App Group defaults reason, ea4ae89 docs: publish privacy, support, and landing pages, eac92c8 docs: describe ESV and Recovery Version storage and Weekly Plan, ed5eb1d chore(graphify): absorb post-commit hook output from the release batch, ee01380 docs: use privacy@rippre.com contact; add 6.9" App Store screenshots, f252501 docs: add session handoff, f498d4b chore(graphify): absorb post-commit hook output from the mode-settings batch, f8ef2e8 engram: live translation licensing; Weekly Plan semantics; commit email rewrite, fe15924 chore(graphify): absorb post-commit hook output from the graph rebuild, fefb492 engram: verse-selection design; pbxproj resource-wiring gotcha, ffb162b Restore the curated community names in GRAPH_REPORT.md, main

### Community 1 - "Verse Index Stability Logic"
Nodes (42): .builtInVerseIsJohn316WithItsRealDatabaseId(), .chapterNextChapterReadsOnAndWrapsFromRevelationToGenesis(), .chapterRepeatStartsTheChapterAgainAfterItsLastVerse(), .chapterRotationSpeedAdvancesWithinADay(), .chapterStopStaysOnTheLastVerse(), .everyTopicHasVersesInEveryOfflineTranslation(), .excludeLongKeepsEveryDailyVerseShortWhileStillRotating(), .favoritesShuffleShowsEachFavoriteOncePerPass(), .favoritesWithoutShuffleWalkSavedOrderAndCanSkipLongVerses(), .liveRecordCarriesTheLiveTextMeasuredForTheLockScreen(), .liveTranslationsRotateThroughTheKJVReferenceSet(), .pickReturnsNilForAnEmptyArray(), .pickReturnsTheElementAtStableIndex(), .pickReturnsTheElementAtStableIndexAcrossManyDates(), .pickStaysConsistentWithStableIndexAcrossManyDates(), .searchMatchesTextAndTreatsWildcardsAndQuotesLiterally(), .selectionStampChangesWhenAModeSettingChanges(), .shuffledOrderIsAReproduciblePermutation(), .slotAdvancesAtEachIntervalBoundaryAndCountsDaysWhenDaily(), .slotStartDatesBeginNowThenFollowEveryBoundary(), .stableIndexAdvancesByOneEachDay(), .stableIndexIsDeterministicForTheSameInputs(), .stableIndexStaysInBoundsAcrossExtremeDates(), .stableIndexStaysInBoundsForDayComponentAcrossExtremeDates(), .stableIndexStaysInBoundsForWeekOfYearComponentAcrossExtremeDates(), .stableIndexWithZeroCountReturnsZeroInsteadOfCrashing(), .stableIndexYieldsDifferentValuesForDifferentDays(), .topicModeReturnsTheSelectedTranslation(), .upcomingRecordsListEachComingVerseOnceAndStopWhenAModeOnlyRepeats(), .weeklyAutoRepeatOffMovesOnOneThemePerWeek(), .weeklyIndexWalksTheFirstSevenVersesThroughAWeekSpanningNewYear(), .weeklyIndexWrapsWhenATopicHasFewerThanSevenVerses(), .weeklyPlanReadsItsSavedBookOneVerseADay(), .weeklyPlanRepeatsItsFirstSevenVersesOrMovesOnSevenAWeek(), .weeklyPlanShowsYourOwnVersesInTheSelectedTranslation(), .weeklyPlanThemeWithoutRepeatReachesItsLaterVerses(), VerseSelectionServiceTests, chapterVerse(), emptyDefaults(), settings(), weekDay(), withScratchDefaults()

### Community 2 - "ESV Service Tests"
Nodes (38): .aDownloadKeepsThePlannedVersesInOrderAndStartsThe48HourWait(), .aRefusedRequestIsReportedAndStillWaits48Hours(), .allowanceStopsAtHalfOfABookAndAt500VersesCountingFavorites(), .applyingStoreEvictsExactlyTheOldestPastTheCapKeepingOldestFirst(), .applyingStoreOnAnEmptyCacheYieldsASingleEntry(), .applyingStoreUpsertsByFetchedRefInsteadOfDuplicating(), .beingOfflineDoesNotStartThe48HourWait(), .cachedVerseReturnsNilForAReferenceThatWasNeverFetched(), .canInit(), .canonicalRequest(), .downloadedVersesAreKeyedByTheirRequestedReferenceAndWidenedPassagesAreDropped(), .fetchForAnotherReferenceIsNotDroppedWhileOneIsInFlight(), .fetchReturnsImmediatelyWhenAlreadyFetching(), .fetchWithoutAnAPIKeyFailsWithAConfigurationErrorAndNeverStartsFetching(), .isConfiguredIsFalseWithoutAnAPIKey(), .isConfiguredOnlyWithANonEmptyAPIKey(), .limitsMatchCrosswaysTermsAndTheSharedKeysBudget(), .liveDownloadReturnsTheESVTextOfJohn316AndPsalm23(), .maxCacheCountMatchesTheESVLicenseCap(), .noDownloadStartsWithin48HoursOfTheLastOne(), .nothingIsRequestedWhenEveryPlannedVerseIsAlreadyHere(), .oneRequestAsksForEveryVerseByIdAndFitsTheAPIsRequestLine(), .plannedVersesFollowTheModeFromNowWithinCrosswaysLimits(), .requestCount(), .session(), .startLoading(), .stopLoading(), .stub(), .verseTextDropsTheNumberWhatComesBeforeItAndPoetryLayout(), ESVBibleServiceTests, StubURLProtocol, URLProtocol, esvResponse(), response(), unwrittenDefaults(), verse(), withScratchStore(), withScratchSuite()

### Community 3 - "Verse Selection Strategies"
Nodes (37): .bool(), .builtInVerse(), .chapterRecord(), .chapterVerse(), .dailyBooks(), .dailyRecord(), .datedVerse(), .dayNumber(), .favoriteInRotation(), .favoriteRecord(), .favoriteVerse(), .filteredRecord(), .fitting(), .liveRecord(), .matching(), .memorizationVerse(), .pick(), .readingPlanRecord(), .record(), .referenceCode(), .referenceTranslationCode(), .rotationInterval(), .selectionStamp(), .shuffledOrder(), .slot(), .slotStartDates(), .stableIndex(), .textRecord(), .topicVerse(), .upcomingRecords(), .verse(), .weeklyIndex(), .weeklyRecord(), .weeklyThemeRecord(), .weeklyTopicSlug(), .weeksBetween(), VerseSelectionService

### Community 4 - "Core Scripture Models"
Nodes (35): .theme(), .translation(), 676cef0 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, 6fe3b58 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, App, Book.swift, CircularWidgetView.swift, Favorite.swift, HomeScreenWidgetView.swift, InlineWidgetView.swift, LockScreenWidgetGuideView.swift, LongVerseService.swift, MemorizationService.swift, OnboardingWelcomeView.swift, RectangularWidgetView.swift, ThemeService, ThemeService.swift, TimelineEntry, Topic.swift, Translation.swift, TranslationService, TranslationService.swift, VerseEntry, VerseSegment.swift, WeeklyPlan.swift, Widget, WidgetBundle, WidgetEntry.swift, WidgetTheme.swift, WordUnlockedApp, WordUnlockedApp.swift, WordUnlockedWidget, WordUnlockedWidget.swift, WordUnlockedWidgetBundle, WordUnlockedWidgetBundle.swift

### Community 5 - "ESV Service Logic"
Nodes (34): .admit(), .applyingStore(), .cachedVerse(), .canSaveFavorite(), .failedBeforeReachingServer(), .fetch(), .init(), .init(), .isFetchDue(), .passageId(), .plannedVerses(), .recordFetch(), .refreshIfDue(), .report(), .request(), .savedFavoriteBookIds(), .store(), .update(), .verseText(), .verses(), Allowance, CodingKey, CodingKeys, CodingKeys, ESVBibleService, accentHex, backgroundHex, fontDesign, id, name, parsed, passageMeta, passages, textHex

### Community 6 - "Database Context Methods"
Nodes (34): .allVerses(), .bookVerseCounts(), .books(), .boolColumn(), .chapterVerseCounts(), .conditions(), .connection(), .createSchema(), .deinit(), .execute(), .hasVerses(), .init(), .intColumn(), .intValue(), .likeEscaped(), .loadSeedRows(), .openDatabase(), .provisionDatabaseIfNeeded(), .query(), .queryVerses(), .quoted(), .scalarInt(), .searchVerses(), .seedRVTestingIfNeeded(), .stringColumn(), .stringValue(), .topics(), .translations(), .verse(), .verseCount(), .verses(), ChapterVerseCount, ScriptureDatabase, VerseFilter

### Community 7 - "RV Bible Service Layer"
Nodes (26): .addFavorite(), .apply(), .currentSettings(), .fetch(), .init(), .init(), .isFavorite(), .loadFavorites(), .loadMemorizationPlan(), .persistDefaults(), .planStartKey(), .reloadWidgetTimelines(), .removeFavorite(), .removeFavorites(), .report(), .request(), .resetWidgetSettings(), .save(), .saveFavorites(), .saveMemorizationPlan(), .startPlan(), .verse(), LoadedVerse, ObservableObject, RVBibleService, SettingsStore

### Community 8 - "Scripture Database Models"
Nodes (25): 27d8d8a Choose verses in one database-backed selector shared by app and widget, 4ebcbf9 Choose verses in one database-backed selector shared by app and widget, 701d0d8 Make every mode setting change the verse, AppGroupSettings, AppGroupSettings.swift, ChapterModeView.swift, DailyVerseModeView.swift, DatabaseService.swift, FavoritesModeView.swift, Keys, MemorizationModeView.swift, ScriptureDatabase.swift, SearchView.swift, SettingsStore.swift, TodayView.swift, TopicModeView.swift, Verse.swift, VerseSelectionService.swift, VerseSelectionServiceTests.swift, WeeklyThemeModeView.swift, WidgetProvider.swift, WidgetTimelineService.swift, b13e9d7 Keep ESV within Crossway's limits, stop storing Recovery Version text, add Weekly Plan sources, fd8543d Make every mode setting change the verse, makeVerse()

### Community 9 - "Primary UI Components"
Nodes (22): ActionArea, BibleLicensesView, ChapterModeView, Chip, CircularWidgetView, ESVTranslationRow, HomeScreenWidgetView, InfoRow, InlineWidgetView, LicenseRow, LockScreenWidgetGuideView, MiniWidgetPreview, OnboardingWelcomeView, RVTranslationRow, RectangularWidgetView, TopicModeView, TranslationRow, TranslationsView, TranslationsView.swift, VerseSearchRow, View, WidgetEntryView

### Community 10 - "Bible Service Implementations"
Nodes (21): 1166ef5 test: add a unit test target covering the cache and selection rules, 4d7d876 Keep live-verse fetches from dropping, clobbering, or repeating, 6130d84 Inject the ESV API key so tests stop depending on build secrets, 7b57407 Keep live-verse fetches from dropping, clobbering, or repeating, 820767f feat(translations): hide ESV until its API key is configured, 826bf9c fix(onboarding): offer every bundled translation, not just KJV, 82f5d22 docs: ship ESV - seven translations across listing, site, and screenshots, 8c91015 feat(translations): hide ESV until its API key is configured, Decodable, ESVBibleService.swift, ESVBibleServiceTests.swift, ESVResponse, LSMResponse, LSMVerse, LongVerseServiceTests.swift, PassageMeta, RVBibleService.swift, SharedModelsTests.swift, d9d693f test: add a unit test target covering the cache and selection rules, f3814f9 docs: record the hardening pass and the decisions it leaves open, fa28332 Inject the ESV API key so tests stop depending on build secrets

### Community 11 - "Verse Category Classification"
Nodes (21): .excerptExactlyAtLimitIsUnchanged(), .excerptFarOverLimitBreaksOnWholeWords(), .excerptOfEmptyStringIsEmpty(), .excerptShorterThanLimitIsUnchanged(), .excerptWithNoWhitespaceFallsBackToHardTruncation(), .firstLettersExtractsAndUppercasesInitials(), .firstLettersOfEmptyStringIsEmpty(), .fitCategoryAtLongUpperBoundIsLong(), .fitCategoryAtMediumUpperBoundIsMedium(), .fitCategoryAtShortUpperBoundIsShort(), .fitCategoryAtZeroIsShort(), .fitCategoryJustPastLongIsVeryLong(), .fitCategoryJustPastMediumIsLong(), .fitCategoryJustPastShortIsMedium(), .fitCategoryWellPastLongIsVeryLong(), .segmentsExactlyAtLimitReturnsSingleSegment(), .segmentsFarOverLimitSplitsOnWordBoundaries(), .segmentsOfEmptyStringReturnsSingleEmptySegment(), .segmentsShorterThanLimitReturnsSingleSegment(), .segmentsWithNoWhitespaceCannotSplitAndOverflowsSingleSegment(), LongVerseServiceTests

### Community 12 - "Widget Timeline Generator"
Nodes (20): .bool(), .builtInVerse(), .cachedEntry(), .chapterVerse(), .dailyVerse(), .entryDates(), .favoriteVerse(), .generateTimeline(), .init(), .makeEntry(), .makeRVEntry(), .pick(), .readESVCache(), .readFavorites(), .readRVCache(), .readSettings(), .selectVerse(), .stableIndex(), .topicVerse(), WidgetTimelineService

### Community 13 - "Theme and Status Types"
Nodes (19): .loadPreferences(), .savePreferences(), DailyVerseModeView, DailyVerseUpdateInterval, Difficulty, LicenseStatus, String, Testament, ccBySA, comingSoon, daily, easy, everyEightHours, hard, licensed, medium, new, old, publicDomain

### Community 14 - "Shared Model Definitions"
Nodes (18): .init(), .init(), .save(), .storedESVVerses(), Book, Codable, Equatable, Favorite, LiveCachedVerse, SharedBookRecord, SharedModels.swift, SharedTopicRecord, SharedTranslationRecord, SharedVerseRecord, Topic, Translation, VerseSegment, WeeklyPlan

### Community 15 - "Widget Configuration Settings"
Nodes (15): CaseIterable, ChapterEndBehavior, RotationInterval, WidgetSettings, WidgetSettings.LongVerseStrategy, WidgetSettings.VerseMode, WidgetSettings.WidgetKind, WidgetSettings.swift, daily, everyEightHours, everySixHours, everyTwelveHours, nextChapter, repeatChapter, stop

### Community 16 - "Database Query Operations"
Nodes (15): .allVerses(), .book(), .books(), .fitCategory(), .init(), .search(), .topic(), .topics(), .translation(), .translations(), .verse(), .verseForToday(), .verses(), .weeklyPlanVerses(), DatabaseService

### Community 17 - "Memorization Plan Configuration"
Nodes (14): ChapterEndBehavior, Identifiable, MemorizationPlan, MemorizationPlan.Difficulty, MemorizationPlan.Phase, MemorizationPlan.swift, TopicModeOption, WallpaperBackground, WeeklyThemePlan, WeeklyVersePreview, nextChapter, repeatChapter, stop, weeklyPreview()

### Community 18 - "Wallpaper Export Workflow"
Nodes (12): .init(), .renderWallpaper(), .saveToPhotos(), .stepRow(), SaveState, WallpaperCanvas, WallpaperExportView, WallpaperView.swift, error, idle, saved, saving

### Community 19 - "App Icon Generation Script"
Nodes (10): 1524b07 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline, 3f7b263 chore: track durable graphify + engram state, 606b9f4 Add future translation roadmap to submission notes, 6c96c57 feat: add an app icon, 7f5482d chore(graphify): fingerprint community membership in the label sidecar, aa2cf1f fix(onboarding): offer every bundled translation, not just KJV, c5336f0 chore(graphify): stop the graph from indexing its own output, generate-app-icon.swift, page(), rgb()

### Community 20 - "LSV import pipeline"
Nodes (10): clean_inline(), derived(), excerpt(), fetch(), fetch_lsv_seed.py, fit_category(), main(), parse_usfm(), segments(), words()

### Community 21 - "ASV import pipeline"
Nodes (8): clean(), derived(), excerpt(), fetch_asv_seed.py, fit_category(), main(), segments(), words()

### Community 22 - "KJV import pipeline"
Nodes (8): derived(), excerpt(), fetch_json(), fetch_kjv_seed.py, fit_category(), main(), segments(), words()

### Community 23 - "Web seed fetcher"
Nodes (8): clean(), derived(), excerpt(), fetch_web_seed.py, fit_category(), main(), segments(), words()

### Community 24 - "RV Bible Service Tests"
Nodes (8): .aLoadedVerseCarriesLSMsAttributionAndIsKeptInMemoryOnly(), .liveFetchReturnsTheRecoveryVersionOfJohn316(), .rejectedCredentialsAreReported(), .requestAsksForTheReferenceWithBasicAuthentication(), .withoutATokenNothingIsRequested(), RVBibleServiceTests, RVBibleServiceTests.swift, lsmResponse()

### Community 25 - "Testament Enumerations"
Nodes (7): Books, all, book, chapter, newTestament, oldTestament, psalmsAndProverbs

### Community 26 - "Verse Display Modes"
Nodes (7): Int, Phase, firstLetters, fullVerse, partialBlank, referenceOnly, review

### Community 27 - "Verse Length Categories"
Nodes (7): .init(), FitCategory, Verse, long, medium, short, veryLong

### Community 28 - "Daily Verse Mode Options"
Nodes (7): VerseMode, chapter, daily, favorites, memorization, topic, weeklyTheme

### Community 29 - "Favorites Mode View"
Nodes (7): .loadPreferences(), .savePreferences(), FavoritesModeView, FavoritesRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 30 - "BSB import pipeline"
Nodes (7): derived(), excerpt(), fetch_bsb_seed.py, fit_category(), main(), segments(), words()

### Community 31 - "Shared Model Serialization Tests"
Nodes (7): .arrayOfVersesRoundTripsThroughJSON(), .decodingFailsWhenARequiredKeyIsMissing(), .decodingLocksTheExpectedWireKeys(), .rvCachedVerseRoundTripsThroughJSON(), .singleVerseRoundTripsThroughJSON(), .storedVersesReadBackWhatWasWrittenAndNothingFromCorruptData(), SharedModelsTests

### Community 32 - "Long Verse Handling Strategy"
Nodes (6): LongVerseStrategy, excerpt, excludeLong, referenceOnly, segmented, smartFit

### Community 33 - "ESV API fetcher"
Nodes (6): Return the ESV text for a single-verse reference, or raise on hard failure., fetch_esv_seed.py, fetch_text(), load_json(), main(), resolve_api_key()

### Community 34 - "Favorites List Interface"
Nodes (6): .prefixText(), FavoriteDetailView, FavoriteRow, FavoritesView, FavoritesView.swift, String

### Community 35 - "Widget Theme Encoding"
Nodes (6): .encode(), .fontDesign(), .init(), .name(), .theme(), WidgetTheme

### Community 36 - "Widget Entry View Logic"
Nodes (5): 724315e engram: test-host secrets gotcha; ESV enabled in ship status, 98e0574 chore(graphify): absorb post-commit hook output from the ESV batch, 9986f75 Give Lock Screen widget views a container background, WidgetEntryView.swift, c47336c Bundle the privacy manifests and declare the App Group defaults reason

### Community 37 - "Source Theme Properties"
Nodes (5): Source, book, chapter, custom, theme

### Community 38 - "Long Verse Text Processing"
Nodes (5): .excerpt(), .firstLetters(), .fitCategory(), .segments(), LongVerseService

### Community 39 - "Mode Selection Interface"
Nodes (5): .detailView(), ModeRow, ModeRowData, ModesView, ModesView.swift

### Community 40 - "Settings Interface Elements"
Nodes (5): PrivacyPolicyView, PrivacyRow, SettingsView, SettingsView.swift, ThemeSwatch

### Community 41 - "Widget Data Provider"
Nodes (5): .getSnapshot(), .getTimeline(), .placeholder(), TimelineProvider, VerseProvider

### Community 42 - "Widget Layout Types"
Nodes (4): WidgetKind, circular, inline, rectangular

### Community 43 - "Chapter Rotation Frequency Options"
Nodes (4): ChapterRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 44 - "Topic Mode View"
Nodes (4): TopicRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 45 - "Weekly Theme Controller"
Nodes (4): .load(), .loadPreview(), .start(), WeeklyThemeModeView

### Community 46 - "Onboarding Completion Screen"
Nodes (4): OnboardingCompleteView, OnboardingCompleteView.swift, OnboardingHeader, OnboardingPageLayout

### Community 47 - "Onboarding Mode Selection"
Nodes (4): ModeChoiceCard, OnboardingModeCard, OnboardingModeView, OnboardingModeView.swift

### Community 48 - "Onboarding Translation Selection"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 49 - "Widget Instructions View"
Nodes (4): OnboardingWidgetInstructionsView, OnboardingWidgetInstructionsView.swift, WidgetInstructionRow, WidgetInstructionStep

### Community 50 - "Translation Selection View"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 51 - "Memorization Display Logic"
Nodes (4): .currentPhase(), .displayText(), .partialBlank(), MemorizationService

### Community 52 - "Today Display Controller"
Nodes (4): .computeCurrentVerse(), .init(), .toggleFavorite(), TodayView

### Community 53 - "Theme Color Definitions"
Nodes (4): .init(), Color, ThemeColors, ThemeColors.swift

### Community 54 - "App Icon Generator"
Nodes (3): generate-app-icon.swift, page(), rgb()

### Community 55 - "Onboarding Theme Selection"
Nodes (3): OnboardingThemeView, OnboardingThemeView.swift, ThemeChoiceSwatch

### Community 56 - "Main Onboarding Flow"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 57 - "Onboarding Progress Screen"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 58 - "Database Build Script"
Nodes (3): build_prebuilt_db.py, load(), main()

### Community 59 - "Search and Favorite Actions"
Nodes (3): .performSearch(), .toggleFavorite(), SearchView

### Community 60 - "Verse Detail Actions"
Nodes (3): .toggleFavorite(), .useForMemorization(), VerseDetailSheet

### Community 61 - "Main App Views"
Nodes (3): ContentView, ContentView.swift, MainTabView

### Community 62 - "Memorization Mode View"
Nodes (2): .search(), MemorizationModeView

### Community 63 - "Verse Picker Interface"
Nodes (2): .row(), WeeklyVersePicker

### Community 64 - "Widget Entry View Implementation"
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

- **Why does `VerseSelectionService` connect `Web seed fetcher` to `Scripture Database Models`?**
  _High betweenness centrality (0.095) - this node is a cross-community bridge._
- **Why does `ScriptureDatabase` connect `ESV API fetcher` to `Scripture Database Models`?**
  _High betweenness centrality (0.079) - this node is a cross-community bridge._
- **Why does `VerseSelectionServiceTests` connect `ASV import pipeline` to `Scripture Database Models`?**
  _High betweenness centrality (0.072) - this node is a cross-community bridge._
- **What connects `all`, `oldTestament`, `newTestament` to the rest of the system?**
  _79 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `LSV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.06734006734006734 - nodes in this community are weakly interconnected._
- **Should `ASV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.0743321718931475 - nodes in this community are weakly interconnected._
- **Should `KJV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.08819345661450925 - nodes in this community are weakly interconnected._