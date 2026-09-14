# Graph Report - .  (2026-09-14)

## Corpus Check
- 91 files · ~124,475 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 726 nodes · 1361 edges · 69 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output
- Edge kinds: calls: 307 · method: 284 · contains: 203 · inherits: 174 · MODIFIES: 172 · case_of: 76 · ON_BRANCH: 73 · PARENT_OF: 71 · rationale_for: 1


## Input Scope
- Requested: auto
- Resolved: committed (source: default-auto)
- Included files: 91 · Candidates: 121
- Excluded: 1 untracked · 1547 ignored · 1 sensitive · 0 missing committed
- Recommendation: Use --scope all or graphify.yaml inputs.corpus for a knowledge-base folder.

## Graph Freshness
- Built from Git commit: `f8ef2e8`
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
- `0be6fd8 Add future translation roadmap to submission notes` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 35 → community 2_
- `1996503 chore(graphify): absorb post-commit hook output from the hardening batch` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 7 → community 2_
- `1996503 chore(graphify): absorb post-commit hook output from the hardening batch` --PARENT_OF--> `701d0d8 Make every mode setting change the verse`  [EXTRACTED]
  git → git  _Bridges community 7 → community 10_
- `25233be feat: add an app icon` --PARENT_OF--> `826bf9c fix(onboarding): offer every bundled translation, not just KJV`  [EXTRACTED]
  git → git  _Bridges community 35 → community 7_
- `27d8d8a Choose verses in one database-backed selector shared by app and widget` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 10 → community 2_

## Communities

### Community 0 - "Community 0"
Nodes (42): .builtInVerseIsJohn316WithItsRealDatabaseId(), .chapterNextChapterReadsOnAndWrapsFromRevelationToGenesis(), .chapterRepeatStartsTheChapterAgainAfterItsLastVerse(), .chapterRotationSpeedAdvancesWithinADay(), .chapterStopStaysOnTheLastVerse(), .everyTopicHasVersesInEveryOfflineTranslation(), .excludeLongKeepsEveryDailyVerseShortWhileStillRotating(), .favoritesShuffleShowsEachFavoriteOncePerPass(), .favoritesWithoutShuffleWalkSavedOrderAndCanSkipLongVerses(), .liveRecordCarriesTheLiveTextMeasuredForTheLockScreen(), .liveTranslationsRotateThroughTheKJVReferenceSet(), .pickReturnsNilForAnEmptyArray(), .pickReturnsTheElementAtStableIndex(), .pickReturnsTheElementAtStableIndexAcrossManyDates(), .pickStaysConsistentWithStableIndexAcrossManyDates(), .searchMatchesTextAndTreatsWildcardsAndQuotesLiterally(), .selectionStampChangesWhenAModeSettingChanges(), .shuffledOrderIsAReproduciblePermutation(), .slotAdvancesAtEachIntervalBoundaryAndCountsDaysWhenDaily(), .slotStartDatesBeginNowThenFollowEveryBoundary(), .stableIndexAdvancesByOneEachDay(), .stableIndexIsDeterministicForTheSameInputs(), .stableIndexStaysInBoundsAcrossExtremeDates(), .stableIndexStaysInBoundsForDayComponentAcrossExtremeDates(), .stableIndexStaysInBoundsForWeekOfYearComponentAcrossExtremeDates(), .stableIndexWithZeroCountReturnsZeroInsteadOfCrashing(), .stableIndexYieldsDifferentValuesForDifferentDays(), .topicModeReturnsTheSelectedTranslation(), .upcomingRecordsListEachComingVerseOnceAndStopWhenAModeOnlyRepeats(), .weeklyAutoRepeatOffMovesOnOneThemePerWeek(), .weeklyIndexWalksTheFirstSevenVersesThroughAWeekSpanningNewYear(), .weeklyIndexWrapsWhenATopicHasFewerThanSevenVerses(), .weeklyPlanReadsItsSavedBookOneVerseADay(), .weeklyPlanRepeatsItsFirstSevenVersesOrMovesOnSevenAWeek(), .weeklyPlanShowsYourOwnVersesInTheSelectedTranslation(), .weeklyPlanThemeWithoutRepeatReachesItsLaterVerses(), VerseSelectionServiceTests, chapterVerse(), emptyDefaults(), settings(), weekDay(), withScratchDefaults()

### Community 1 - "Community 1"
Nodes (38): .aDownloadKeepsThePlannedVersesInOrderAndStartsThe48HourWait(), .aRefusedRequestIsReportedAndStillWaits48Hours(), .allowanceStopsAtHalfOfABookAndAt500VersesCountingFavorites(), .applyingStoreEvictsExactlyTheOldestPastTheCapKeepingOldestFirst(), .applyingStoreOnAnEmptyCacheYieldsASingleEntry(), .applyingStoreUpsertsByFetchedRefInsteadOfDuplicating(), .beingOfflineDoesNotStartThe48HourWait(), .cachedVerseReturnsNilForAReferenceThatWasNeverFetched(), .canInit(), .canonicalRequest(), .downloadedVersesAreKeyedByTheirRequestedReferenceAndWidenedPassagesAreDropped(), .fetchForAnotherReferenceIsNotDroppedWhileOneIsInFlight(), .fetchReturnsImmediatelyWhenAlreadyFetching(), .fetchWithoutAnAPIKeyFailsWithAConfigurationErrorAndNeverStartsFetching(), .isConfiguredIsFalseWithoutAnAPIKey(), .isConfiguredOnlyWithANonEmptyAPIKey(), .limitsMatchCrosswaysTermsAndTheSharedKeysBudget(), .liveDownloadReturnsTheESVTextOfJohn316AndPsalm23(), .maxCacheCountMatchesTheESVLicenseCap(), .noDownloadStartsWithin48HoursOfTheLastOne(), .nothingIsRequestedWhenEveryPlannedVerseIsAlreadyHere(), .oneRequestAsksForEveryVerseByIdAndFitsTheAPIsRequestLine(), .plannedVersesFollowTheModeFromNowWithinCrosswaysLimits(), .requestCount(), .session(), .startLoading(), .stopLoading(), .stub(), .verseTextDropsTheNumberWhatComesBeforeItAndPoetryLayout(), ESVBibleServiceTests, StubURLProtocol, URLProtocol, esvResponse(), response(), unwrittenDefaults(), verse(), withScratchStore(), withScratchSuite()

### Community 2 - "Community 2"
Nodes (37): 001201b chore(graphify): absorb post-commit hook output from the hardening batch, 126ee46 engram: Word Unlocked ship status 2026-09-12, 1524b07 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline, 1afb72b docs: record the hardening pass and the decisions it leaves open, 1f0ac83 engram: Word Unlocked ship status 2026-09-12, 2879ff0 chore: declare export compliance and tidy repo hygiene, 299e463 docs(marketing): correct the RV listing and trim over-limit keywords, 2b17ec3 graphify: name 46 placeholder communities via local model, 35537ab docs: add session handoff, 3cc4c76 chore(graphify): refresh the graph and stop stray caches reaching git, 3f7b263 chore: track durable graphify + engram state, 5f4af3d docs: record Pages URLs, screenshot location, and 2026-09-12 status, 606b9f4 Add future translation roadmap to submission notes, 68a479b engram: rotation semantics; era day ordinality rolls over at UTC midnight, 7f48826 Restore the curated community names in GRAPH_REPORT.md, 7f5482d chore(graphify): fingerprint community membership in the label sidecar, 824ec6d docs: record the implemented mode settings and the 5 PM day rollover, 829ec96 docs: publish privacy, support, and landing pages, 830b7f0 chore(graphify): refresh the graph and stop stray caches reaching git, 9596b45 engram: verse-selection design; pbxproj resource-wiring gotcha, 9a52cd9 chore(graphify): commit the re-rendered report and track the description sidecar, 9c3ef43 docs(marketing): correct the RV listing and trim over-limit keywords, a5b7d50 docs: use privacy@rippre.com contact; add 6.9" App Store screenshots, aad5fb6 docs: record Pages URLs, screenshot location, and 2026-09-12 status, b7adf6f chore: declare export compliance and tidy repo hygiene, c1bb9af graphify: name 46 placeholder communities via local model, c5336f0 chore(graphify): stop the graph from indexing its own output, d078d61 chore(graphify): commit the re-rendered report and track the description sidecar, e24446a chore(graphify): absorb post-commit hook output from the release batch, ea4ae89 docs: publish privacy, support, and landing pages, eac92c8 docs: describe ESV and Recovery Version storage and Weekly Plan, ed5eb1d chore(graphify): absorb post-commit hook output from the release batch, ee01380 docs: use privacy@rippre.com contact; add 6.9" App Store screenshots, f252501 docs: add session handoff, f498d4b chore(graphify): absorb post-commit hook output from the mode-settings batch, ffb162b Restore the curated community names in GRAPH_REPORT.md, main

### Community 3 - "Verse Selection Strategies"
Nodes (37): .bool(), .builtInVerse(), .chapterRecord(), .chapterVerse(), .dailyBooks(), .dailyRecord(), .datedVerse(), .dayNumber(), .favoriteInRotation(), .favoriteRecord(), .favoriteVerse(), .filteredRecord(), .fitting(), .liveRecord(), .matching(), .memorizationVerse(), .pick(), .readingPlanRecord(), .record(), .referenceCode(), .referenceTranslationCode(), .rotationInterval(), .selectionStamp(), .shuffledOrder(), .slot(), .slotStartDates(), .stableIndex(), .textRecord(), .topicVerse(), .upcomingRecords(), .verse(), .weeklyIndex(), .weeklyRecord(), .weeklyThemeRecord(), .weeklyTopicSlug(), .weeksBetween(), VerseSelectionService

### Community 4 - "Community 4"
Nodes (34): .admit(), .applyingStore(), .cachedVerse(), .canSaveFavorite(), .failedBeforeReachingServer(), .fetch(), .init(), .init(), .isFetchDue(), .passageId(), .plannedVerses(), .recordFetch(), .refreshIfDue(), .report(), .request(), .savedFavoriteBookIds(), .store(), .update(), .verseText(), .verses(), Allowance, CodingKey, CodingKeys, CodingKeys, ESVBibleService, accentHex, backgroundHex, fontDesign, id, name, parsed, passageMeta, passages, textHex

### Community 5 - "Community 5"
Nodes (34): .allVerses(), .bookVerseCounts(), .books(), .boolColumn(), .chapterVerseCounts(), .conditions(), .connection(), .createSchema(), .deinit(), .execute(), .hasVerses(), .init(), .intColumn(), .intValue(), .likeEscaped(), .loadSeedRows(), .openDatabase(), .provisionDatabaseIfNeeded(), .query(), .queryVerses(), .quoted(), .scalarInt(), .searchVerses(), .seedRVTestingIfNeeded(), .stringColumn(), .stringValue(), .topics(), .translations(), .verse(), .verseCount(), .verses(), ChapterVerseCount, ScriptureDatabase, VerseFilter

### Community 6 - "Community 6"
Nodes (26): .addFavorite(), .apply(), .currentSettings(), .fetch(), .init(), .init(), .isFavorite(), .loadFavorites(), .loadMemorizationPlan(), .persistDefaults(), .planStartKey(), .reloadWidgetTimelines(), .removeFavorite(), .removeFavorites(), .report(), .request(), .resetWidgetSettings(), .save(), .saveFavorites(), .saveMemorizationPlan(), .startPlan(), .verse(), LoadedVerse, ObservableObject, RVBibleService, SettingsStore

### Community 7 - "Community 7"
Nodes (22): 1166ef5 test: add a unit test target covering the cache and selection rules, 1996503 chore(graphify): absorb post-commit hook output from the hardening batch, 4d7d876 Keep live-verse fetches from dropping, clobbering, or repeating, 6130d84 Inject the ESV API key so tests stop depending on build secrets, 7b57407 Keep live-verse fetches from dropping, clobbering, or repeating, 820767f feat(translations): hide ESV until its API key is configured, 826bf9c fix(onboarding): offer every bundled translation, not just KJV, 82f5d22 docs: ship ESV - seven translations across listing, site, and screenshots, Decodable, ESVBibleService.swift, ESVBibleServiceTests.swift, ESVResponse, LSMResponse, LSMVerse, PassageMeta, RVBibleService.swift, SharedModelsTests.swift, ad994f4 docs: ship ESV - seven translations across listing, site, and screenshots, d9d693f test: add a unit test target covering the cache and selection rules, f3814f9 docs: record the hardening pass and the decisions it leaves open, fa28332 Inject the ESV API key so tests stop depending on build secrets, fefb492 engram: verse-selection design; pbxproj resource-wiring gotcha

### Community 8 - "Community 8"
Nodes (22): .excerptExactlyAtLimitIsUnchanged(), .excerptFarOverLimitBreaksOnWholeWords(), .excerptOfEmptyStringIsEmpty(), .excerptShorterThanLimitIsUnchanged(), .excerptWithNoWhitespaceFallsBackToHardTruncation(), .firstLettersExtractsAndUppercasesInitials(), .firstLettersOfEmptyStringIsEmpty(), .fitCategoryAtLongUpperBoundIsLong(), .fitCategoryAtMediumUpperBoundIsMedium(), .fitCategoryAtShortUpperBoundIsShort(), .fitCategoryAtZeroIsShort(), .fitCategoryJustPastLongIsVeryLong(), .fitCategoryJustPastMediumIsLong(), .fitCategoryJustPastShortIsMedium(), .fitCategoryWellPastLongIsVeryLong(), .segmentsExactlyAtLimitReturnsSingleSegment(), .segmentsFarOverLimitSplitsOnWordBoundaries(), .segmentsOfEmptyStringReturnsSingleEmptySegment(), .segmentsShorterThanLimitReturnsSingleSegment(), .segmentsWithNoWhitespaceCannotSplitAndOverflowsSingleSegment(), LongVerseServiceTests, LongVerseServiceTests.swift

### Community 9 - "Community 9"
Nodes (21): .theme(), 676cef0 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, CircularWidgetView, CircularWidgetView.swift, Favorite.swift, HomeScreenWidgetView, HomeScreenWidgetView.swift, InlineWidgetView, InlineWidgetView.swift, LockScreenWidgetGuideView, LockScreenWidgetGuideView.swift, OnboardingWelcomeView, OnboardingWelcomeView.swift, RectangularWidgetView, RectangularWidgetView.swift, ThemeService, ThemeService.swift, Topic.swift, VerseSegment.swift, WidgetEntryView, WidgetEntryView.swift

### Community 10 - "Community 10"
Nodes (20): 27d8d8a Choose verses in one database-backed selector shared by app and widget, 4ebcbf9 Choose verses in one database-backed selector shared by app and widget, 6fe3b58 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, 701d0d8 Make every mode setting change the verse, AppGroupSettings, AppGroupSettings.swift, Keys, ScriptureDatabase.swift, SettingsStore.swift, VerseSelectionService.swift, VerseSelectionServiceTests.swift, WeeklyPlan.swift, WeeklyThemeModeView.swift, WeeklyVersePreview, WidgetProvider.swift, WidgetTimelineService.swift, b13e9d7 Keep ESV within Crossway's limits, stop storing Recovery Version text, add Weekly Plan sources, fd8543d Make every mode setting change the verse, makeVerse(), weeklyPreview()

### Community 11 - "Community 11"
Nodes (20): .bool(), .builtInVerse(), .cachedEntry(), .chapterVerse(), .dailyVerse(), .entryDates(), .favoriteVerse(), .generateTimeline(), .init(), .makeEntry(), .makeRVEntry(), .pick(), .readESVCache(), .readFavorites(), .readRVCache(), .readSettings(), .selectVerse(), .stableIndex(), .topicVerse(), WidgetTimelineService

### Community 12 - "Community 12"
Nodes (18): CaseIterable, ChapterEndBehavior, Identifiable, RotationInterval, WallpaperBackground, WeeklyThemePlan, WidgetSettings, WidgetSettings.LongVerseStrategy, WidgetSettings.VerseMode, WidgetSettings.WidgetKind, WidgetSettings.swift, daily, everyEightHours, everySixHours, everyTwelveHours, nextChapter, repeatChapter, stop

### Community 13 - "Community 13"
Nodes (18): .init(), .init(), .save(), .storedESVVerses(), Book, Codable, Equatable, Favorite, LiveCachedVerse, SharedBookRecord, SharedModels.swift, SharedTopicRecord, SharedTranslationRecord, SharedVerseRecord, Topic, Translation, VerseSegment, WeeklyPlan

### Community 14 - "Database Query Operations"
Nodes (16): .allVerses(), .book(), .books(), .fitCategory(), .init(), .search(), .topic(), .topics(), .translation(), .translations(), .verse(), .verseForToday(), .verses(), .weeklyPlanVerses(), DatabaseService, DatabaseService.swift

### Community 15 - "Memorization Plan Logic"
Nodes (15): Difficulty, Int, MemorizationPlan, MemorizationPlan.Difficulty, MemorizationPlan.Phase, MemorizationPlan.swift, Phase, easy, firstLetters, fullVerse, hard, medium, partialBlank, referenceOnly, review

### Community 16 - "Chapter Reading Configuration"
Nodes (15): Book.swift, ChapterEndBehavior, ChapterModeView, ChapterModeView.swift, ChapterRotationSpeed, String, Testament, daily, everySixHours, everyTwelveHours, new, nextChapter, old, repeatChapter, stop

### Community 17 - "Community 17"
Nodes (14): .row(), BibleLicensesView, ESVTranslationRow, LicenseRow, OnboardingCompleteView, OnboardingCompleteView.swift, OnboardingHeader, OnboardingPageLayout, RVTranslationRow, TranslationRow, TranslationsView, TranslationsView.swift, View, WeeklyVersePicker

### Community 18 - "Wallpaper Export Workflow"
Nodes (12): .init(), .renderWallpaper(), .saveToPhotos(), .stepRow(), SaveState, WallpaperCanvas, WallpaperExportView, WallpaperView.swift, error, idle, saved, saving

### Community 19 - "LSV import pipeline"
Nodes (10): clean_inline(), derived(), excerpt(), fetch(), fetch_lsv_seed.py, fit_category(), main(), parse_usfm(), segments(), words()

### Community 20 - "Today's Verse Display"
Nodes (9): .computeCurrentVerse(), .init(), .toggleFavorite(), ActionArea, Chip, InfoRow, MiniWidgetPreview, TodayView, TodayView.swift

### Community 21 - "Verse Length Categories"
Nodes (8): .init(), FitCategory, Verse, Verse.swift, long, medium, short, veryLong

### Community 22 - "Favorites Mode View"
Nodes (8): .loadPreferences(), .savePreferences(), FavoritesModeView, FavoritesModeView.swift, FavoritesRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 23 - "ASV import pipeline"
Nodes (8): clean(), derived(), excerpt(), fetch_asv_seed.py, fit_category(), main(), segments(), words()

### Community 24 - "KJV import pipeline"
Nodes (8): derived(), excerpt(), fetch_json(), fetch_kjv_seed.py, fit_category(), main(), segments(), words()

### Community 25 - "Web seed fetcher"
Nodes (8): clean(), derived(), excerpt(), fetch_web_seed.py, fit_category(), main(), segments(), words()

### Community 26 - "Community 26"
Nodes (8): .aLoadedVerseCarriesLSMsAttributionAndIsKeptInMemoryOnly(), .liveFetchReturnsTheRecoveryVersionOfJohn316(), .rejectedCredentialsAreReported(), .requestAsksForTheReferenceWithBasicAuthentication(), .withoutATokenNothingIsRequested(), RVBibleServiceTests, RVBibleServiceTests.swift, lsmResponse()

### Community 27 - "Community 27"
Nodes (7): Books, all, book, chapter, newTestament, oldTestament, psalmsAndProverbs

### Community 28 - "Daily Verse Mode Options"
Nodes (7): VerseMode, chapter, daily, favorites, memorization, topic, weeklyTheme

### Community 29 - "Daily Verse Mode View"
Nodes (7): .loadPreferences(), .savePreferences(), DailyVerseModeView, DailyVerseModeView.swift, DailyVerseUpdateInterval, daily, everyEightHours

### Community 30 - "Topic Mode View"
Nodes (7): TopicModeOption, TopicModeView, TopicModeView.swift, TopicRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 31 - "BSB import pipeline"
Nodes (7): derived(), excerpt(), fetch_bsb_seed.py, fit_category(), main(), segments(), words()

### Community 32 - "Community 32"
Nodes (7): .performSearch(), .toggleFavorite(), .toggleFavorite(), .useForMemorization(), SearchView, SearchView.swift, VerseDetailSheet

### Community 33 - "Widget Theme Encoding"
Nodes (7): .encode(), .fontDesign(), .init(), .name(), .theme(), WidgetTheme, WidgetTheme.swift

### Community 34 - "Community 34"
Nodes (7): .arrayOfVersesRoundTripsThroughJSON(), .decodingFailsWhenARequiredKeyIsMissing(), .decodingLocksTheExpectedWireKeys(), .rvCachedVerseRoundTripsThroughJSON(), .singleVerseRoundTripsThroughJSON(), .storedVersesReadBackWhatWasWrittenAndNothingFromCorruptData(), SharedModelsTests

### Community 35 - "Community 35"
Nodes (6): 0be6fd8 Add future translation roadmap to submission notes, 10220dc chore(graphify): fingerprint community membership in the label sidecar, 25233be feat: add an app icon, ca64e70 chore(graphify): stop the graph from indexing its own output, de3bef8 chore: track durable graphify + engram state, e5966e1 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline

### Community 36 - "Community 36"
Nodes (6): 6c96c57 feat: add an app icon, 8c91015 feat(translations): hide ESV until its API key is configured, aa2cf1f fix(onboarding): offer every bundled translation, not just KJV, generate-app-icon.swift, page(), rgb()

### Community 37 - "Translation License Status"
Nodes (6): LicenseStatus, Translation.swift, ccBySA, comingSoon, licensed, publicDomain

### Community 38 - "Long Verse Handling Strategy"
Nodes (6): LongVerseStrategy, excerpt, excludeLong, referenceOnly, segmented, smartFit

### Community 39 - "ESV API fetcher"
Nodes (6): Return the ESV text for a single-verse reference, or raise on hard failure., fetch_esv_seed.py, fetch_text(), load_json(), main(), resolve_api_key()

### Community 40 - "Long Verse Text Processing"
Nodes (6): .excerpt(), .firstLetters(), .fitCategory(), .segments(), LongVerseService, LongVerseService.swift

### Community 41 - "Favorites List Interface"
Nodes (6): .prefixText(), FavoriteDetailView, FavoriteRow, FavoritesView, FavoritesView.swift, String

### Community 42 - "Community 42"
Nodes (5): Source, book, chapter, custom, theme

### Community 43 - "Memorization Display Logic"
Nodes (5): .currentPhase(), .displayText(), .partialBlank(), MemorizationService, MemorizationService.swift

### Community 44 - "Mode Selection Interface"
Nodes (5): .detailView(), ModeRow, ModeRowData, ModesView, ModesView.swift

### Community 45 - "Community 45"
Nodes (5): PrivacyPolicyView, PrivacyRow, SettingsView, SettingsView.swift, ThemeSwatch

### Community 46 - "Widget Data Provider"
Nodes (5): .getSnapshot(), .getTimeline(), .placeholder(), TimelineProvider, VerseProvider

### Community 47 - "Community 47"
Nodes (4): 3a44839 Give Lock Screen widget views a container background, 6552c8d chore(graphify): absorb post-commit hook output from the ESV batch, 701981f engram: test-host secrets gotcha; ESV enabled in ship status, e5e5323 Bundle the privacy manifests and declare the App Group defaults reason

### Community 48 - "Community 48"
Nodes (4): 724315e engram: test-host secrets gotcha; ESV enabled in ship status, 98e0574 chore(graphify): absorb post-commit hook output from the ESV batch, 9986f75 Give Lock Screen widget views a container background, c47336c Bundle the privacy manifests and declare the App Group defaults reason

### Community 49 - "Community 49"
Nodes (4): WidgetKind, circular, inline, rectangular

### Community 50 - "Memorization Mode View"
Nodes (4): .search(), MemorizationModeView, MemorizationModeView.swift, VerseSearchRow

### Community 51 - "Community 51"
Nodes (4): .load(), .loadPreview(), .start(), WeeklyThemeModeView

### Community 52 - "Onboarding Mode Selection"
Nodes (4): ModeChoiceCard, OnboardingModeCard, OnboardingModeView, OnboardingModeView.swift

### Community 53 - "Onboarding Translation Selection"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 54 - "Widget Instructions View"
Nodes (4): OnboardingWidgetInstructionsView, OnboardingWidgetInstructionsView.swift, WidgetInstructionRow, WidgetInstructionStep

### Community 55 - "Translation Selection View"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 56 - "Theme Color Definitions"
Nodes (4): .init(), Color, ThemeColors, ThemeColors.swift

### Community 57 - "App Entry Point"
Nodes (3): App, WordUnlockedApp, WordUnlockedApp.swift

### Community 58 - "App Icon Generator"
Nodes (3): generate-app-icon.swift, page(), rgb()

### Community 59 - "Onboarding Theme Selection"
Nodes (3): OnboardingThemeView, OnboardingThemeView.swift, ThemeChoiceSwatch

### Community 60 - "Main Onboarding Flow"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 61 - "Onboarding Progress Screen"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 62 - "Database Build Script"
Nodes (3): build_prebuilt_db.py, load(), main()

### Community 63 - "Translation Lookup Service"
Nodes (3): .translation(), TranslationService, TranslationService.swift

### Community 64 - "Widget Timeline Entries"
Nodes (3): TimelineEntry, VerseEntry, WidgetEntry.swift

### Community 65 - "Widget Bundle Entry"
Nodes (3): WidgetBundle, WordUnlockedWidgetBundle, WordUnlockedWidgetBundle.swift

### Community 66 - "Widget Display Component"
Nodes (3): Widget, WordUnlockedWidget, WordUnlockedWidget.swift

### Community 67 - "Main App Views"
Nodes (3): ContentView, ContentView.swift, MainTabView

### Community 68 - "Community 68"
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

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `VerseSelectionService` connect `Web seed fetcher` to `Community 10`?**
  _High betweenness centrality (0.096) - this node is a cross-community bridge._
- **Why does `ScriptureDatabase` connect `BSB import pipeline` to `Community 10`?**
  _High betweenness centrality (0.080) - this node is a cross-community bridge._
- **Why does `VerseSelectionServiceTests` connect `LSV import pipeline` to `Community 10`?**
  _High betweenness centrality (0.073) - this node is a cross-community bridge._
- **What connects `all`, `oldTestament`, `newTestament` to the rest of the system?**
  _79 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `LSV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.0743321718931475 - nodes in this community are weakly interconnected._
- **Should `ASV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.08819345661450925 - nodes in this community are weakly interconnected._
- **Should `KJV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.0990990990990991 - nodes in this community are weakly interconnected._