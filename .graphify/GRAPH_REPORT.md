# Graph Report - .  (2026-09-22)

## Corpus Check
- 92 files · ~125,269 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 730 nodes · 1432 edges · 66 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output
- Edge kinds: calls: 307 · method: 284 · MODIFIES: 235 · contains: 203 · inherits: 174 · ON_BRANCH: 77 · case_of: 76 · PARENT_OF: 75 · rationale_for: 1


## Input Scope
- Requested: auto
- Resolved: committed (source: default-auto)
- Included files: 92 · Candidates: 122
- Excluded: 0 untracked · 1628 ignored · 1 sensitive · 0 missing committed
- Recommendation: Use --scope all or graphify.yaml inputs.corpus for a knowledge-base folder.

## Graph Freshness
- Built from Git commit: `98b262d`
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
  git → git  _Bridges community 36 → community 9_
- `10220dc chore(graphify): fingerprint community membership in the label sidecar` --PARENT_OF--> `25233be feat: add an app icon`  [EXTRACTED]
  git → git  _Bridges community 36 → community 17_
- `1996503 chore(graphify): absorb post-commit hook output from the hardening batch` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 13 → community 9_
- `1996503 chore(graphify): absorb post-commit hook output from the hardening batch` --PARENT_OF--> `701d0d8 Make every mode setting change the verse`  [EXTRACTED]
  git → git  _Bridges community 13 → community 0_
- `1f0ac83 engram: Word Unlocked ship status 2026-09-12` --PARENT_OF--> `6130d84 Inject the ESV API key so tests stop depending on build secrets`  [EXTRACTED]
  git → git  _Bridges community 9 → community 38_

## Communities

### Community 0 - "Community 0"
Nodes (70): .init(), .theme(), .translation(), 27d8d8a Choose verses in one database-backed selector shared by app and widget, 4ebcbf9 Choose verses in one database-backed selector shared by app and widget, 676cef0 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, 6fe3b58 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, 701d0d8 Make every mode setting change the verse, 9986f75 Give Lock Screen widget views a container background, App, AppGroupSettings, AppGroupSettings.swift, Book.swift, ChapterModeView.swift, CircularWidgetView.swift, Color, DailyVerseModeView.swift, DatabaseService.swift, Favorite.swift, FavoritesModeView.swift, HomeScreenWidgetView.swift, InlineWidgetView.swift, Keys, LockScreenWidgetGuideView.swift, LongVerseService.swift, MemorizationModeView.swift, MemorizationService.swift, ModesView.swift, OnboardingWelcomeView.swift, RectangularWidgetView.swift, ScriptureDatabase.swift, SearchView.swift, SettingsStore.swift, ThemeColors.swift, ThemeService, ThemeService.swift, TimelineEntry, TodayView.swift, Topic.swift, TopicModeView.swift, Translation.swift, TranslationService, TranslationService.swift, Verse.swift, VerseEntry, VerseSegment.swift, VerseSelectionService.swift, WallpaperView.swift, WeeklyPlan.swift, WeeklyThemeModeView.swift, WeeklyVersePreview, Widget, WidgetBundle, WidgetEntry.swift, WidgetEntryView.swift, WidgetProvider.swift, WidgetTheme.swift, WidgetTimelineService.swift, WordUnlockedApp, WordUnlockedApp.swift, WordUnlockedWidget, WordUnlockedWidget.swift, WordUnlockedWidgetBundle, WordUnlockedWidgetBundle.swift, b13e9d7 Keep ESV within Crossway's limits, stop storing Recovery Version text, add Weekly Plan sources, build_prebuilt_db.py, fd8543d Make every mode setting change the verse, load(), main(), weeklyPreview()

### Community 1 - "Community 1"
Nodes (44): .builtInVerseIsJohn316WithItsRealDatabaseId(), .chapterNextChapterReadsOnAndWrapsFromRevelationToGenesis(), .chapterRepeatStartsTheChapterAgainAfterItsLastVerse(), .chapterRotationSpeedAdvancesWithinADay(), .chapterStopStaysOnTheLastVerse(), .everyTopicHasVersesInEveryOfflineTranslation(), .excludeLongKeepsEveryDailyVerseShortWhileStillRotating(), .favoritesShuffleShowsEachFavoriteOncePerPass(), .favoritesWithoutShuffleWalkSavedOrderAndCanSkipLongVerses(), .liveRecordCarriesTheLiveTextMeasuredForTheLockScreen(), .liveTranslationsRotateThroughTheKJVReferenceSet(), .pickReturnsNilForAnEmptyArray(), .pickReturnsTheElementAtStableIndex(), .pickReturnsTheElementAtStableIndexAcrossManyDates(), .pickStaysConsistentWithStableIndexAcrossManyDates(), .searchMatchesTextAndTreatsWildcardsAndQuotesLiterally(), .selectionStampChangesWhenAModeSettingChanges(), .shuffledOrderIsAReproduciblePermutation(), .slotAdvancesAtEachIntervalBoundaryAndCountsDaysWhenDaily(), .slotStartDatesBeginNowThenFollowEveryBoundary(), .stableIndexAdvancesByOneEachDay(), .stableIndexIsDeterministicForTheSameInputs(), .stableIndexStaysInBoundsAcrossExtremeDates(), .stableIndexStaysInBoundsForDayComponentAcrossExtremeDates(), .stableIndexStaysInBoundsForWeekOfYearComponentAcrossExtremeDates(), .stableIndexWithZeroCountReturnsZeroInsteadOfCrashing(), .stableIndexYieldsDifferentValuesForDifferentDays(), .topicModeReturnsTheSelectedTranslation(), .upcomingRecordsListEachComingVerseOnceAndStopWhenAModeOnlyRepeats(), .weeklyAutoRepeatOffMovesOnOneThemePerWeek(), .weeklyIndexWalksTheFirstSevenVersesThroughAWeekSpanningNewYear(), .weeklyIndexWrapsWhenATopicHasFewerThanSevenVerses(), .weeklyPlanReadsItsSavedBookOneVerseADay(), .weeklyPlanRepeatsItsFirstSevenVersesOrMovesOnSevenAWeek(), .weeklyPlanShowsYourOwnVersesInTheSelectedTranslation(), .weeklyPlanThemeWithoutRepeatReachesItsLaterVerses(), VerseSelectionServiceTests, VerseSelectionServiceTests.swift, chapterVerse(), emptyDefaults(), makeVerse(), settings(), weekDay(), withScratchDefaults()

### Community 2 - "Community 2"
Nodes (39): .aDownloadKeepsThePlannedVersesInOrderAndStartsThe48HourWait(), .aRefusedRequestIsReportedAndStillWaits48Hours(), .allowanceStopsAtHalfOfABookAndAt500VersesCountingFavorites(), .applyingStoreEvictsExactlyTheOldestPastTheCapKeepingOldestFirst(), .applyingStoreOnAnEmptyCacheYieldsASingleEntry(), .applyingStoreUpsertsByFetchedRefInsteadOfDuplicating(), .beingOfflineDoesNotStartThe48HourWait(), .cachedVerseReturnsNilForAReferenceThatWasNeverFetched(), .canInit(), .canonicalRequest(), .downloadedVersesAreKeyedByTheirRequestedReferenceAndWidenedPassagesAreDropped(), .fetchForAnotherReferenceIsNotDroppedWhileOneIsInFlight(), .fetchReturnsImmediatelyWhenAlreadyFetching(), .fetchWithoutAnAPIKeyFailsWithAConfigurationErrorAndNeverStartsFetching(), .isConfiguredIsFalseWithoutAnAPIKey(), .isConfiguredOnlyWithANonEmptyAPIKey(), .limitsMatchCrosswaysTermsAndTheSharedKeysBudget(), .liveDownloadReturnsTheESVTextOfJohn316AndPsalm23(), .maxCacheCountMatchesTheESVLicenseCap(), .noDownloadStartsWithin48HoursOfTheLastOne(), .nothingIsRequestedWhenEveryPlannedVerseIsAlreadyHere(), .oneRequestAsksForEveryVerseByIdAndFitsTheAPIsRequestLine(), .plannedVersesFollowTheModeFromNowWithinCrosswaysLimits(), .requestCount(), .session(), .startLoading(), .stopLoading(), .stub(), .verseTextDropsTheNumberWhatComesBeforeItAndPoetryLayout(), ESVBibleServiceTests, ESVBibleServiceTests.swift, StubURLProtocol, URLProtocol, esvResponse(), response(), unwrittenDefaults(), verse(), withScratchStore(), withScratchSuite()

### Community 3 - "Verse Selection Strategies"
Nodes (37): .bool(), .builtInVerse(), .chapterRecord(), .chapterVerse(), .dailyBooks(), .dailyRecord(), .datedVerse(), .dayNumber(), .favoriteInRotation(), .favoriteRecord(), .favoriteVerse(), .filteredRecord(), .fitting(), .liveRecord(), .matching(), .memorizationVerse(), .pick(), .readingPlanRecord(), .record(), .referenceCode(), .referenceTranslationCode(), .rotationInterval(), .selectionStamp(), .shuffledOrder(), .slot(), .slotStartDates(), .stableIndex(), .textRecord(), .topicVerse(), .upcomingRecords(), .verse(), .weeklyIndex(), .weeklyRecord(), .weeklyThemeRecord(), .weeklyTopicSlug(), .weeksBetween(), VerseSelectionService

### Community 4 - "Community 4"
Nodes (34): .admit(), .applyingStore(), .cachedVerse(), .canSaveFavorite(), .failedBeforeReachingServer(), .fetch(), .init(), .init(), .isFetchDue(), .passageId(), .plannedVerses(), .recordFetch(), .refreshIfDue(), .report(), .request(), .savedFavoriteBookIds(), .store(), .update(), .verseText(), .verses(), Allowance, CodingKey, CodingKeys, CodingKeys, ESVBibleService, accentHex, backgroundHex, fontDesign, id, name, parsed, passageMeta, passages, textHex

### Community 5 - "Community 5"
Nodes (34): .allVerses(), .bookVerseCounts(), .books(), .boolColumn(), .chapterVerseCounts(), .conditions(), .connection(), .createSchema(), .deinit(), .execute(), .hasVerses(), .init(), .intColumn(), .intValue(), .likeEscaped(), .loadSeedRows(), .openDatabase(), .provisionDatabaseIfNeeded(), .query(), .queryVerses(), .quoted(), .scalarInt(), .searchVerses(), .seedRVTestingIfNeeded(), .stringColumn(), .stringValue(), .topics(), .translations(), .verse(), .verseCount(), .verses(), ChapterVerseCount, ScriptureDatabase, VerseFilter

### Community 6 - "Community 6"
Nodes (25): .addFavorite(), .apply(), .currentSettings(), .fetch(), .init(), .init(), .isFavorite(), .loadFavorites(), .loadMemorizationPlan(), .persistDefaults(), .planStartKey(), .reloadWidgetTimelines(), .removeFavorite(), .removeFavorites(), .report(), .request(), .resetWidgetSettings(), .save(), .saveFavorites(), .saveMemorizationPlan(), .startPlan(), .verse(), ObservableObject, RVBibleService, SettingsStore

### Community 7 - "Community 7"
Nodes (24): .init(), .init(), .save(), .storedESVVerses(), Book, Codable, Equatable, Favorite, Identifiable, LiveCachedVerse, ModeRowData, SharedBookRecord, SharedModels.swift, SharedTopicRecord, SharedTranslationRecord, SharedVerseRecord, ThemeColors, Topic, TopicModeOption, Translation, VerseSegment, WallpaperBackground, WeeklyPlan, WeeklyThemePlan

### Community 8 - "Community 8"
Nodes (23): ActionArea, BibleLicensesView, ChapterModeView, Chip, CircularWidgetView, ESVTranslationRow, HomeScreenWidgetView, InfoRow, InlineWidgetView, LicenseRow, LockScreenWidgetGuideView, MiniWidgetPreview, ModeRow, OnboardingWelcomeView, RVTranslationRow, RectangularWidgetView, TopicModeView, TranslationRow, TranslationsView, TranslationsView.swift, VerseSearchRow, View, WidgetEntryView

### Community 9 - "Community 9"
Nodes (21): 1f0ac83 engram: Word Unlocked ship status 2026-09-12, 299e463 docs(marketing): correct the RV listing and trim over-limit keywords, 68a479b engram: rotation semantics; era day ordinality rolls over at UTC midnight, 7f48826 Restore the curated community names in GRAPH_REPORT.md, 824ec6d docs: record the implemented mode settings and the 5 PM day rollover, 8291b79 docs: record the 2026-09-14 session in the handoff, 830b7f0 chore(graphify): refresh the graph and stop stray caches reaching git, 98b262d docs: record secret scanning and the current to-do list in the handoff, 9a52cd9 chore(graphify): commit the re-rendered report and track the description sidecar, aad5fb6 docs: record Pages URLs, screenshot location, and 2026-09-12 status, b5ef1ce chore(graphify): absorb post-commit hook output from the licensing and Weekly Plan batch, b7adf6f chore: declare export compliance and tidy repo hygiene, c1bb9af graphify: name 46 placeholder communities via local model, e24446a chore(graphify): absorb post-commit hook output from the release batch, ea4ae89 docs: publish privacy, support, and landing pages, eac92c8 docs: describe ESV and Recovery Version storage and Weekly Plan, ee01380 docs: use privacy@rippre.com contact; add 6.9" App Store screenshots, f252501 docs: add session handoff, f498d4b chore(graphify): absorb post-commit hook output from the mode-settings batch, f8ef2e8 engram: live translation licensing; Weekly Plan semantics; commit email rewrite, main

### Community 10 - "Community 10"
Nodes (21): .excerptExactlyAtLimitIsUnchanged(), .excerptFarOverLimitBreaksOnWholeWords(), .excerptOfEmptyStringIsEmpty(), .excerptShorterThanLimitIsUnchanged(), .excerptWithNoWhitespaceFallsBackToHardTruncation(), .firstLettersExtractsAndUppercasesInitials(), .firstLettersOfEmptyStringIsEmpty(), .fitCategoryAtLongUpperBoundIsLong(), .fitCategoryAtMediumUpperBoundIsMedium(), .fitCategoryAtShortUpperBoundIsShort(), .fitCategoryAtZeroIsShort(), .fitCategoryJustPastLongIsVeryLong(), .fitCategoryJustPastMediumIsLong(), .fitCategoryJustPastShortIsMedium(), .fitCategoryWellPastLongIsVeryLong(), .segmentsExactlyAtLimitReturnsSingleSegment(), .segmentsFarOverLimitSplitsOnWordBoundaries(), .segmentsOfEmptyStringReturnsSingleEmptySegment(), .segmentsShorterThanLimitReturnsSingleSegment(), .segmentsWithNoWhitespaceCannotSplitAndOverflowsSingleSegment(), LongVerseServiceTests

### Community 11 - "Community 11"
Nodes (20): .bool(), .builtInVerse(), .cachedEntry(), .chapterVerse(), .dailyVerse(), .entryDates(), .favoriteVerse(), .generateTimeline(), .init(), .makeEntry(), .makeRVEntry(), .pick(), .readESVCache(), .readFavorites(), .readRVCache(), .readSettings(), .selectVerse(), .stableIndex(), .topicVerse(), WidgetTimelineService

### Community 12 - "Community 12"
Nodes (19): .loadPreferences(), .savePreferences(), DailyVerseModeView, DailyVerseUpdateInterval, LicenseStatus, String, Testament, WidgetKind, ccBySA, circular, comingSoon, daily, everyEightHours, inline, licensed, new, old, publicDomain, rectangular

### Community 13 - "Community 13"
Nodes (16): 001201b chore(graphify): absorb post-commit hook output from the hardening batch, 1996503 chore(graphify): absorb post-commit hook output from the hardening batch, 1afb72b docs: record the hardening pass and the decisions it leaves open, 4d7d876 Keep live-verse fetches from dropping, clobbering, or repeating, 7b57407 Keep live-verse fetches from dropping, clobbering, or repeating, 9596b45 engram: verse-selection design; pbxproj resource-wiring gotcha, Decodable, ESVBibleService.swift, ESVResponse, LSMResponse, LSMVerse, LoadedVerse, PassageMeta, RVBibleService.swift, f3814f9 docs: record the hardening pass and the decisions it leaves open, fefb492 engram: verse-selection design; pbxproj resource-wiring gotcha

### Community 14 - "Community 14"
Nodes (15): CaseIterable, ChapterEndBehavior, RotationInterval, WidgetSettings, WidgetSettings.LongVerseStrategy, WidgetSettings.VerseMode, WidgetSettings.WidgetKind, WidgetSettings.swift, daily, everyEightHours, everySixHours, everyTwelveHours, nextChapter, repeatChapter, stop

### Community 15 - "Memorization Plan Logic"
Nodes (15): Difficulty, Int, MemorizationPlan, MemorizationPlan.Difficulty, MemorizationPlan.Phase, MemorizationPlan.swift, Phase, easy, firstLetters, fullVerse, hard, medium, partialBlank, referenceOnly, review

### Community 16 - "Database Query Operations"
Nodes (15): .allVerses(), .book(), .books(), .fitCategory(), .init(), .search(), .topic(), .topics(), .translation(), .translations(), .verse(), .verseForToday(), .verses(), .weeklyPlanVerses(), DatabaseService

### Community 17 - "Community 17"
Nodes (13): 1166ef5 test: add a unit test target covering the cache and selection rules, 25233be feat: add an app icon, 6c96c57 feat: add an app icon, 820767f feat(translations): hide ESV until its API key is configured, 826bf9c fix(onboarding): offer every bundled translation, not just KJV, 8c91015 feat(translations): hide ESV until its API key is configured, LongVerseServiceTests.swift, SharedModelsTests.swift, aa2cf1f fix(onboarding): offer every bundled translation, not just KJV, d9d693f test: add a unit test target covering the cache and selection rules, generate-app-icon.swift, page(), rgb()

### Community 18 - "Community 18"
Nodes (10): 2879ff0 chore: declare export compliance and tidy repo hygiene, 2b17ec3 graphify: name 46 placeholder communities via local model, 35537ab docs: add session handoff, 3cc4c76 chore(graphify): refresh the graph and stop stray caches reaching git, 829ec96 docs: publish privacy, support, and landing pages, 9c3ef43 docs(marketing): correct the RV listing and trim over-limit keywords, a5b7d50 docs: use privacy@rippre.com contact; add 6.9" App Store screenshots, d078d61 chore(graphify): commit the re-rendered report and track the description sidecar, ed5eb1d chore(graphify): absorb post-commit hook output from the release batch, ffb162b Restore the curated community names in GRAPH_REPORT.md

### Community 19 - "LSV import pipeline"
Nodes (10): clean_inline(), derived(), excerpt(), fetch(), fetch_lsv_seed.py, fit_category(), main(), parse_usfm(), segments(), words()

### Community 20 - "Community 20"
Nodes (8): 126ee46 engram: Word Unlocked ship status 2026-09-12, 3a44839 Give Lock Screen widget views a container background, 5f4af3d docs: record Pages URLs, screenshot location, and 2026-09-12 status, 6552c8d chore(graphify): absorb post-commit hook output from the ESV batch, 701981f engram: test-host secrets gotcha; ESV enabled in ship status, ad994f4 docs: ship ESV - seven translations across listing, site, and screenshots, e5e5323 Bundle the privacy manifests and declare the App Group defaults reason, fa28332 Inject the ESV API key so tests stop depending on build secrets

### Community 21 - "ASV import pipeline"
Nodes (8): clean(), derived(), excerpt(), fetch_asv_seed.py, fit_category(), main(), segments(), words()

### Community 22 - "KJV import pipeline"
Nodes (8): derived(), excerpt(), fetch_json(), fetch_kjv_seed.py, fit_category(), main(), segments(), words()

### Community 23 - "Web seed fetcher"
Nodes (8): clean(), derived(), excerpt(), fetch_web_seed.py, fit_category(), main(), segments(), words()

### Community 24 - "Community 24"
Nodes (8): .aLoadedVerseCarriesLSMsAttributionAndIsKeptInMemoryOnly(), .liveFetchReturnsTheRecoveryVersionOfJohn316(), .rejectedCredentialsAreReported(), .requestAsksForTheReferenceWithBasicAuthentication(), .withoutATokenNothingIsRequested(), RVBibleServiceTests, RVBibleServiceTests.swift, lsmResponse()

### Community 25 - "Community 25"
Nodes (7): Books, all, book, chapter, newTestament, oldTestament, psalmsAndProverbs

### Community 26 - "Verse Length Categories"
Nodes (7): .init(), FitCategory, Verse, long, medium, short, veryLong

### Community 27 - "Daily Verse Mode Options"
Nodes (7): VerseMode, chapter, daily, favorites, memorization, topic, weeklyTheme

### Community 28 - "Favorites Mode View"
Nodes (7): .loadPreferences(), .savePreferences(), FavoritesModeView, FavoritesRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 29 - "BSB import pipeline"
Nodes (7): derived(), excerpt(), fetch_bsb_seed.py, fit_category(), main(), segments(), words()

### Community 30 - "Community 30"
Nodes (7): .arrayOfVersesRoundTripsThroughJSON(), .decodingFailsWhenARequiredKeyIsMissing(), .decodingLocksTheExpectedWireKeys(), .rvCachedVerseRoundTripsThroughJSON(), .singleVerseRoundTripsThroughJSON(), .storedVersesReadBackWhatWasWrittenAndNothingFromCorruptData(), SharedModelsTests

### Community 31 - "Long Verse Handling Strategy"
Nodes (6): LongVerseStrategy, excerpt, excludeLong, referenceOnly, segmented, smartFit

### Community 32 - "ESV API fetcher"
Nodes (6): Return the ESV text for a single-verse reference, or raise on hard failure., fetch_esv_seed.py, fetch_text(), load_json(), main(), resolve_api_key()

### Community 33 - "Favorites List Interface"
Nodes (6): .prefixText(), FavoriteDetailView, FavoriteRow, FavoritesView, FavoritesView.swift, String

### Community 34 - "Wallpaper Export Workflow"
Nodes (6): .init(), .renderWallpaper(), .saveToPhotos(), .stepRow(), WallpaperCanvas, WallpaperExportView

### Community 35 - "Widget Theme Encoding"
Nodes (6): .encode(), .fontDesign(), .init(), .name(), .theme(), WidgetTheme

### Community 36 - "Community 36"
Nodes (5): 0be6fd8 Add future translation roadmap to submission notes, 10220dc chore(graphify): fingerprint community membership in the label sidecar, ca64e70 chore(graphify): stop the graph from indexing its own output, de3bef8 chore: track durable graphify + engram state, e5966e1 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline

### Community 37 - "Community 37"
Nodes (5): 1524b07 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline, 3f7b263 chore: track durable graphify + engram state, 606b9f4 Add future translation roadmap to submission notes, 7f5482d chore(graphify): fingerprint community membership in the label sidecar, c5336f0 chore(graphify): stop the graph from indexing its own output

### Community 38 - "Community 38"
Nodes (5): 6130d84 Inject the ESV API key so tests stop depending on build secrets, 724315e engram: test-host secrets gotcha; ESV enabled in ship status, 82f5d22 docs: ship ESV - seven translations across listing, site, and screenshots, 98e0574 chore(graphify): absorb post-commit hook output from the ESV batch, c47336c Bundle the privacy manifests and declare the App Group defaults reason

### Community 39 - "Community 39"
Nodes (5): Source, book, chapter, custom, theme

### Community 40 - "Long Verse Text Processing"
Nodes (5): .excerpt(), .firstLetters(), .fitCategory(), .segments(), LongVerseService

### Community 41 - "Community 41"
Nodes (5): PrivacyPolicyView, PrivacyRow, SettingsView, SettingsView.swift, ThemeSwatch

### Community 42 - "Community 42"
Nodes (5): SaveState, error, idle, saved, saving

### Community 43 - "Widget Data Provider"
Nodes (5): .getSnapshot(), .getTimeline(), .placeholder(), TimelineProvider, VerseProvider

### Community 44 - "Community 44"
Nodes (4): ChapterEndBehavior, nextChapter, repeatChapter, stop

### Community 45 - "Community 45"
Nodes (4): ChapterRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 46 - "Topic Mode View"
Nodes (4): TopicRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 47 - "Community 47"
Nodes (4): .load(), .loadPreview(), .start(), WeeklyThemeModeView

### Community 48 - "Onboarding Completion Screen"
Nodes (4): OnboardingCompleteView, OnboardingCompleteView.swift, OnboardingHeader, OnboardingPageLayout

### Community 49 - "Onboarding Mode Selection"
Nodes (4): ModeChoiceCard, OnboardingModeCard, OnboardingModeView, OnboardingModeView.swift

### Community 50 - "Onboarding Translation Selection"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 51 - "Widget Instructions View"
Nodes (4): OnboardingWidgetInstructionsView, OnboardingWidgetInstructionsView.swift, WidgetInstructionRow, WidgetInstructionStep

### Community 52 - "Translation Selection View"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 53 - "Memorization Display Logic"
Nodes (4): .currentPhase(), .displayText(), .partialBlank(), MemorizationService

### Community 54 - "Community 54"
Nodes (4): .computeCurrentVerse(), .init(), .toggleFavorite(), TodayView

### Community 55 - "App Icon Generator"
Nodes (3): generate-app-icon.swift, page(), rgb()

### Community 56 - "Onboarding Theme Selection"
Nodes (3): OnboardingThemeView, OnboardingThemeView.swift, ThemeChoiceSwatch

### Community 57 - "Main Onboarding Flow"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 58 - "Onboarding Progress Screen"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 59 - "Search and Favorite Actions"
Nodes (3): .performSearch(), .toggleFavorite(), SearchView

### Community 60 - "Community 60"
Nodes (3): .toggleFavorite(), .useForMemorization(), VerseDetailSheet

### Community 61 - "Main App Views"
Nodes (3): ContentView, ContentView.swift, MainTabView

### Community 62 - "Memorization Mode View"
Nodes (2): .search(), MemorizationModeView

### Community 63 - "Community 63"
Nodes (2): .row(), WeeklyVersePicker

### Community 64 - "Community 64"
Nodes (2): .detailView(), ModesView

### Community 65 - "Community 65"
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

- **Why does `VerseSelectionService` connect `Web seed fetcher` to `LSV import pipeline`?**
  _High betweenness centrality (0.096) - this node is a cross-community bridge._
- **Why does `ScriptureDatabase` connect `BSB import pipeline` to `LSV import pipeline`?**
  _High betweenness centrality (0.080) - this node is a cross-community bridge._
- **What connects `all`, `oldTestament`, `newTestament` to the rest of the system?**
  _79 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `LSV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.06832298136645963 - nodes in this community are weakly interconnected._
- **Should `ASV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.07505285412262157 - nodes in this community are weakly interconnected._
- **Should `KJV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.09446693657219973 - nodes in this community are weakly interconnected._
- **Should `iOS app build tools` be split into smaller, more focused modules?**
  _Cohesion score 0.0962566844919786 - nodes in this community are weakly interconnected._