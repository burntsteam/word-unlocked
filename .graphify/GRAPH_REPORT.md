# Graph Report - .  (2026-09-29)

## Corpus Check
- 101 files · ~128,554 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 851 nodes · 1688 edges · 77 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output
- Edge kinds: calls: 367 · method: 353 · MODIFIES: 299 · contains: 227 · inherits: 183 · ON_BRANCH: 88 · PARENT_OF: 86 · case_of: 81 · rationale_for: 4


## Input Scope
- Requested: auto
- Resolved: committed (source: default-auto)
- Included files: 101 · Candidates: 132
- Excluded: 0 untracked · 1750 ignored · 2 sensitive · 0 missing committed
- Recommendation: Use --scope all or graphify.yaml inputs.corpus for a knowledge-base folder.

## Graph Freshness
- Built from Git commit: `d68ec0b`
- Compare this hash to `git rev-parse HEAD` before trusting freshness-sensitive graph output.
## God Nodes (most connected - your core abstractions)
1. `VerseSelectionServiceTests` - 41 edges
2. `ScriptureDatabase` - 38 edges
3. `VerseSelectionService` - 38 edges
4. `ESVBibleServiceTests` - 28 edges
5. `WidgetTimelineService` - 24 edges
6. `SettingsStore` - 22 edges
7. `LongVerseServiceTests` - 22 edges
8. `ESVBibleService` - 21 edges
9. `DatabaseService` - 15 edges
10. `settings()` - 14 edges

## Surprising Connections (you probably didn't know these)
- `08a7eea chore(graphify): describe every node in the graph` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 38 → community 12_
- `0be6fd8 Add future translation roadmap to submission notes` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 25 → community 12_
- `0bf66bd engram: GitHub secret scanning is on but blind to this repo's two secrets` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 18 → community 12_
- `1996503 chore(graphify): absorb post-commit hook output from the hardening batch` --PARENT_OF--> `701d0d8 Make every mode setting change the verse`  [EXTRACTED]
  git → git  _Bridges community 12 → community 0_
- `1f0ac83 engram: Word Unlocked ship status 2026-09-12` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 27 → community 12_

## Communities

### Community 0 - "Community 0"
Nodes (96): .init(), .init(), .theme(), .translation(), 1166ef5 test: add a unit test target covering the cache and selection rules, 27d8d8a Choose verses in one database-backed selector shared by app and widget, 4d7d876 Keep live-verse fetches from dropping, clobbering, or repeating, 4ebcbf9 Choose verses in one database-backed selector shared by app and widget, 6130d84 Inject the ESV API key so tests stop depending on build secrets, 676cef0 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, 6fe3b58 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, 701d0d8 Make every mode setting change the verse, 7b57407 Keep live-verse fetches from dropping, clobbering, or repeating, 7e76457 fix: every finding from the 2026-09-27 audit, 820767f feat(translations): hide ESV until its API key is configured, 8c91015 feat(translations): hide ESV until its API key is configured, 9986f75 Give Lock Screen widget views a container background, AppGroupSettings, AppGroupSettings.swift, Book.swift, ChapterModeView.swift, CircularWidgetView.swift, Color, ContentView.swift, DailyVerseModeView.swift, DatabaseService.swift, Decodable, ESVBibleService.swift, ESVBibleServiceTests.swift, ESVResponse, Favorite.swift, FavoritesModeView.swift, HomeScreenWidgetView.swift, InlineWidgetView.swift, Keys, LSMResponse, LSMVerse, LockScreenWidgetGuideView.swift, LongVerseService.swift, LongVerseServiceTests.swift, Lossy, MemorizationModeView.swift, MemorizationPlan.Phase, MemorizationPlan.swift, MemorizationService.swift, OnboardingWelcomeView.swift, PassageMeta, RVBibleService.swift, RVBibleServiceTests.swift, RectangularWidgetView.swift, ScriptureDatabase.swift, SearchView.swift, SettingsStore.swift, SharedModelsTests.swift, ThemeColors.swift, ThemeService, ThemeService.swift, TimelineEntry, TodayView.swift, Topic.swift, TopicModeView.swift, Translation.swift, TranslationService, TranslationService.swift, Verse.swift, VerseEntry, VerseSegment.swift, VerseSelectionService.swift, VerseSelectionServiceTests.swift, WallpaperView.swift, WeeklyPlan.swift, WeeklyThemeModeView.swift, WeeklyVersePreview, Widget, WidgetBundle, WidgetEntry.swift, WidgetEntryView.swift, WidgetProvider.swift, WidgetSettings.swift, WidgetTheme.swift, WidgetTimelineService.swift, WordUnlockedApp.swift, WordUnlockedWidget, WordUnlockedWidget.swift, WordUnlockedWidgetBundle, WordUnlockedWidgetBundle.swift, b13e9d7 Keep ESV within Crossway's limits, stop storing Recovery Version text, add Weekly Plan sources, build_prebuilt_db.py, d9d693f test: add a unit test target covering the cache and selection rules, fa28332 Inject the ESV API key so tests stop depending on build secrets, fd8543d Make every mode setting change the verse, isCurated(), load(), main(), makeVerse(), weeklyPreview()

### Community 1 - "Verse Index Stability Logic"
Nodes (46): .aFavoriteSavedWithESVTextShowsThatTextOnItsOwnVerse(), .builtInVerseIsJohn316WithItsRealDatabaseId(), .chapterNextChapterReadsOnAndWrapsFromRevelationToGenesis(), .chapterRepeatStartsTheChapterAgainAfterItsLastVerse(), .chapterRotationSpeedAdvancesWithinADay(), .chapterStopStaysOnTheLastVerse(), .dailyTestamentChoicesNarrowTheCuratedList(), .dailyVersesComeFromTheCuratedListInAShuffledOrder(), .everyTopicHasVersesInEveryOfflineTranslation(), .excludeLongKeepsEveryDailyVerseShortWhileStillRotating(), .favoritesShuffleShowsEachFavoriteOncePerPass(), .favoritesWithoutShuffleWalkSavedOrderAndCanSkipLongVerses(), .liveRecordCarriesTheLiveTextMeasuredForTheLockScreen(), .liveTextKeepsItsVerseAndIsMeasuredForTheLockScreen(), .liveTranslationsRotateThroughTheKJVReferenceSet(), .pickReturnsNilForAnEmptyArray(), .pickReturnsTheElementAtStableIndex(), .pickReturnsTheElementAtStableIndexAcrossManyDates(), .pickStaysConsistentWithStableIndexAcrossManyDates(), .searchMatchesTextAndTreatsWildcardsAndQuotesLiterally(), .selectionStampChangesWhenAModeSettingChanges(), .shuffledOrderIsAReproduciblePermutation(), .slotAdvancesAtEachIntervalBoundaryAndCountsDaysWhenDaily(), .slotStartDatesBeginNowThenFollowEveryBoundary(), .stableIndexAdvancesByOneEachDay(), .stableIndexIsDeterministicForTheSameInputs(), .stableIndexStaysInBoundsAcrossExtremeDates(), .stableIndexStaysInBoundsForDayComponentAcrossExtremeDates(), .stableIndexStaysInBoundsForWeekOfYearComponentAcrossExtremeDates(), .stableIndexWithZeroCountReturnsZeroInsteadOfCrashing(), .stableIndexYieldsDifferentValuesForDifferentDays(), .topicModeReturnsTheSelectedTranslation(), .upcomingRecordsListEachComingVerseOnceAndStopWhenAModeOnlyRepeats(), .weeklyAutoRepeatOffMovesOnOneThemePerWeek(), .weeklyIndexWalksTheFirstSevenVersesThroughAWeekSpanningNewYear(), .weeklyIndexWrapsWhenATopicHasFewerThanSevenVerses(), .weeklyPlanReadsItsSavedBookOneVerseADay(), .weeklyPlanRepeatsItsFirstSevenVersesOrMovesOnSevenAWeek(), .weeklyPlanShowsYourOwnVersesInTheSelectedTranslation(), .weeklyPlanThemeWithoutRepeatReachesItsLaterVerses(), VerseSelectionServiceTests, chapterVerse(), emptyDefaults(), settings(), weekDay(), withScratchDefaults()

### Community 2 - "ESV Service Logic"
Nodes (43): .admit(), .applyingStore(), .cachedVerse(), .canSaveFavorite(), .failedBeforeReachingServer(), .fetch(), .fetch(), .init(), .init(), .init(), .isFetchDue(), .passageId(), .plannedVerses(), .recordFetch(), .refreshIfDue(), .report(), .report(), .request(), .request(), .restoreFetchDate(), .savedFavoriteBookIds(), .store(), .update(), .verse(), .verseText(), .verses(), Allowance, CodingKey, CodingKeys, CodingKeys, ESVBibleService, LoadedVerse, ObservableObject, RVBibleService, accentHex, backgroundHex, fontDesign, id, name, parsed, passageMeta, passages, textHex

### Community 3 - "ESV Service Tests"
Nodes (43): .aDownloadFinishesWhenTheScreenThatStartedItGoesAway(), .aDownloadKeepsThePlannedVersesInOrderAndStartsThe48HourWait(), .aFailedSecureConnectionDoesNotStartThe48HourWait(), .aRefusedRequestIsReportedAndStillWaits48Hours(), .allowanceStopsAtHalfOfABookAndAt500VersesCountingFavorites(), .applyingStoreEvictsExactlyTheOldestPastTheCapKeepingOldestFirst(), .applyingStoreOnAnEmptyCacheYieldsASingleEntry(), .applyingStoreUpsertsByFetchedRefInsteadOfDuplicating(), .beingOfflineDoesNotStartThe48HourWait(), .cachedVerseReturnsNilForAReferenceThatWasNeverFetched(), .canInit(), .canonicalRequest(), .downloadedVersesAreKeyedByTheirRequestedReferenceAndWidenedPassagesAreDropped(), .fetchForAnotherReferenceIsNotDroppedWhileOneIsInFlight(), .fetchReturnsImmediatelyWhenAlreadyFetching(), .fetchWithoutAnAPIKeyFailsWithAConfigurationErrorAndNeverStartsFetching(), .isConfiguredIsFalseWithoutAnAPIKey(), .isConfiguredOnlyWithANonEmptyAPIKey(), .limitsMatchCrosswaysTermsAndTheSharedKeysBudget(), .liveDownloadReturnsTheESVTextOfJohn316AndPsalm23(), .liveRequestsGoThroughASessionThatCachesNothing(), .maxCacheCountMatchesTheESVLicenseCap(), .noDownloadStartsWithin48HoursOfTheLastOne(), .nothingIsRequestedWhenEveryPlannedVerseIsAlreadyHere(), .oneRequestAsksForEveryVerseByIdAndFitsTheAPIsRequestLine(), .onlyFailuresBeforeTheRequestIsSentLeaveTheWaitUnstarted(), .plannedVersesFollowTheModeFromNowWithinCrosswaysLimits(), .requestCount(), .session(), .startLoading(), .stopLoading(), .stub(), .theWaitStartsBeforeTheRequestGoesOut(), .verseTextDropsTheNumberWhatComesBeforeItAndPoetryLayout(), ESVBibleServiceTests, StubURLProtocol, URLProtocol, esvResponse(), response(), unwrittenDefaults(), verse(), withScratchStore(), withScratchSuite()

### Community 4 - "Database Context Methods"
Nodes (40): .allVerses(), .bookVerseCounts(), .books(), .boolColumn(), .chapterVerseCounts(), .closeConnection(), .conditions(), .connection(), .createSchema(), .curatedJoin(), .curatedVerse(), .curatedVerseCount(), .deinit(), .excludeFromBackup(), .execute(), .hasVerses(), .init(), .intColumn(), .intValue(), .likeEscaped(), .loadSeedRows(), .openDatabase(), .provisionDatabaseIfNeeded(), .query(), .queryVerses(), .quoted(), .removeRecoveryVersionRows(), .scalarInt(), .searchVerses(), .seedRVTestingIfNeeded(), .stringColumn(), .stringValue(), .topics(), .translations(), .verse(), .verseCount(), .verses(), ChapterVerseCount, ScriptureDatabase, VerseFilter

### Community 5 - "Verse Selection Strategies"
Nodes (38): .bool(), .builtInVerse(), .chapterRecord(), .chapterVerse(), .dailyBooks(), .dailyRecord(), .datedVerse(), .dayNumber(), .favoriteInRotation(), .favoriteRecord(), .favoriteVerse(), .filteredRecord(), .fitting(), .liveRecord(), .matching(), .memorizationVerse(), .pick(), .readingPlanRecord(), .record(), .referenceCode(), .referenceTranslationCode(), .rotationInterval(), .selectionStamp(), .shuffledOrder(), .slot(), .slotStart(), .slotStartDates(), .stableIndex(), .textRecord(), .topicVerse(), .upcomingRecords(), .verse(), .weeklyIndex(), .weeklyRecord(), .weeklyThemeRecord(), .weeklyTopicSlug(), .weeksBetween(), VerseSelectionService

### Community 6 - "Widget Configuration Settings"
Nodes (28): .init(), .loadPreferences(), .saved(), CaseIterable, ChapterEndBehavior, ChapterEndBehavior, DailyVerseUpdateInterval, Identifiable, MemorizationPlan, MemorizationPlan.Difficulty, Source, TopicModeOption, WeeklyThemePlan, WidgetSettings.LongVerseStrategy, WidgetSettings.VerseMode, WidgetSettings.WidgetKind, book, chapter, custom, daily, everyEightHours, nextChapter, nextChapter, repeatChapter, repeatChapter, stop, stop, theme

### Community 7 - "Shared Model Definitions"
Nodes (25): .display(), .init(), .init(), .init(), .save(), .saved(), .storedESVVerses(), Book, Codable, Equatable, Favorite, LiveCachedVerse, SharedBookRecord, SharedModels.swift, SharedTopicRecord, SharedTranslationRecord, SharedVerseRecord, ThemeColors, Topic, Translation, VerseReference, VerseSegment, WallpaperBackground, WeeklyPlan, WidgetSettings

### Community 8 - "Community 8"
Nodes (25): .savePreferences(), ActionArea, ChapterModeView, Chip, CircularWidgetView, ContentView, DailyVerseModeView, HomeScreenWidgetView, InfoRow, InlineWidgetView, LockScreenWidgetGuideView, LockScreenWidgetPreview, MainTabView, MiniWidgetPreview, OnboardingCompleteView, OnboardingCompleteView.swift, OnboardingHeader, OnboardingPageLayout, OnboardingWelcomeView, RectangularWidgetView, SearchResultRow, TopicModeView, VerseSearchRow, View, WidgetEntryView

### Community 9 - "Widget Timeline Generator"
Nodes (24): .bool(), .builtInVerse(), .cachedEntry(), .chapterLength(), .chapterVerse(), .dailyVerse(), .entries(), .entryDates(), .favoriteVerse(), .generateTimeline(), .init(), .makeEntry(), .makeRVEntry(), .pick(), .readESVCache(), .readFavorites(), .readRVCache(), .readSettings(), .selectVerse(), .slotEntries(), .stableIndex(), .timeline(), .topicVerse(), WidgetTimelineService

### Community 10 - "Verse Category Classification"
Nodes (22): .excerptExactlyAtLimitIsUnchanged(), .excerptFarOverLimitBreaksOnWholeWords(), .excerptOfEmptyStringIsEmpty(), .excerptShorterThanLimitIsUnchanged(), .excerptWithNoWhitespaceFallsBackToHardTruncation(), .firstLettersExtractsAndUppercasesInitials(), .firstLettersOfEmptyStringIsEmpty(), .firstLettersSkipOpeningQuotationMarks(), .fitCategoryAtLongUpperBoundIsLong(), .fitCategoryAtMediumUpperBoundIsMedium(), .fitCategoryAtShortUpperBoundIsShort(), .fitCategoryAtZeroIsShort(), .fitCategoryJustPastLongIsVeryLong(), .fitCategoryJustPastMediumIsLong(), .fitCategoryJustPastShortIsMedium(), .fitCategoryWellPastLongIsVeryLong(), .segmentsExactlyAtLimitReturnsSingleSegment(), .segmentsFarOverLimitSplitsOnWordBoundaries(), .segmentsOfEmptyStringReturnsSingleEmptySegment(), .segmentsShorterThanLimitReturnsSingleSegment(), .segmentsWithNoWhitespaceCannotSplitAndOverflowsSingleSegment(), LongVerseServiceTests

### Community 11 - "RV Bible Service Layer"
Nodes (21): .addFavorite(), .apply(), .currentSettings(), .init(), .isFavorite(), .loadFavorites(), .loadMemorizationPlan(), .migrated(), .moveFavorites(), .persistDefaults(), .planStartKey(), .reloadWidgetTimelines(), .removeFavorite(), .removeFavorites(), .resetWidgetSettings(), .save(), .saveFavorites(), .saveMemorizationPlan(), .startPlan(), .toggleFavorite(), SettingsStore

### Community 12 - "Community 12"
Nodes (20): 001201b chore(graphify): absorb post-commit hook output from the hardening batch, 1996503 chore(graphify): absorb post-commit hook output from the hardening batch, 1afb72b docs: record the hardening pass and the decisions it leaves open, 3a44839 Give Lock Screen widget views a container background, 6552c8d chore(graphify): absorb post-commit hook output from the ESV batch, 68a479b engram: rotation semantics; era day ordinality rolls over at UTC midnight, 701981f engram: test-host secrets gotcha; ESV enabled in ship status, 724315e engram: test-host secrets gotcha; ESV enabled in ship status, 824ec6d docs: record the implemented mode settings and the 5 PM day rollover, 82f5d22 docs: ship ESV - seven translations across listing, site, and screenshots, 9596b45 engram: verse-selection design; pbxproj resource-wiring gotcha, 98e0574 chore(graphify): absorb post-commit hook output from the ESV batch, ad994f4 docs: ship ESV - seven translations across listing, site, and screenshots, c47336c Bundle the privacy manifests and declare the App Group defaults reason, d68ec0b docs: align pages, listing and records with the audit fixes, e5e5323 Bundle the privacy manifests and declare the App Group defaults reason, f3814f9 docs: record the hardening pass and the decisions it leaves open, f498d4b chore(graphify): absorb post-commit hook output from the mode-settings batch, fefb492 engram: verse-selection design; pbxproj resource-wiring gotcha, main

### Community 13 - "Community 13"
Nodes (16): ChapterRotationSpeed, Difficulty, String, Testament, WidgetKind, circular, daily, easy, everySixHours, everyTwelveHours, hard, inline, medium, new, old, rectangular

### Community 14 - "Database Query Operations"
Nodes (15): .allVerses(), .book(), .books(), .fitCategory(), .init(), .search(), .topic(), .topics(), .translation(), .translations(), .verse(), .verseForToday(), .verses(), .weeklyPlanVerses(), DatabaseService

### Community 15 - "Community 15"
Nodes (15): .chapterProgressSaysWhereInTheChapterTheVerseIs(), .dailyEntriesStartNowThenChangeAtEachMidnight(), .downloadedESVTextStandsInOnlyForTheKingJamesVerses(), .favoritesShowFullReferencesInTheTranslationEachWasSavedIn(), .memorizationShowsEachStepOfThePlanOnItsDay(), .referenceOnlyShowsJustTheReferenceForAVerseTooLongForTheLockScreen(), .segmentedPartsTakeTurnsEvery20MinutesFromTheStartOfTheSlot(), .segmentedPartsTakeTurnsUntilMidnightOnTheDayTheClocksChange(), .theWidgetAsksForItsNextTimelineAtMidnight(), WidgetTimelineServiceTests, WidgetTimelineServiceTests.swift, at(), favorite(), firstEntriesByShortReference(), timeline()

### Community 16 - "App Icon Generation Script"
Nodes (10): 1524b07 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline, 3f7b263 chore: track durable graphify + engram state, 606b9f4 Add future translation roadmap to submission notes, 6c96c57 feat: add an app icon, 7f5482d chore(graphify): fingerprint community membership in the label sidecar, aa2cf1f fix(onboarding): offer every bundled translation, not just KJV, c5336f0 chore(graphify): stop the graph from indexing its own output, generate-app-icon.swift, page(), rgb()

### Community 17 - "LSV import pipeline"
Nodes (10): clean_inline(), derived(), excerpt(), fetch(), fetch_lsv_seed.py, fit_category(), main(), parse_usfm(), segments(), words()

### Community 18 - "Community 18"
Nodes (8): 0bf66bd engram: GitHub secret scanning is on but blind to this repo's two secrets, 79714a1 chore(graphify): absorb post-commit hook output from the handoff update, 8291b79 docs: record the 2026-09-14 session in the handoff, 98b262d docs: record secret scanning and the current to-do list in the handoff, a2a1fb8 chore(graphify,engram): rebuild the graph, name every community, refresh ship status, b5ef1ce chore(graphify): absorb post-commit hook output from the licensing and Weekly Plan batch, eac92c8 docs: describe ESV and Recovery Version storage and Weekly Plan, f8ef2e8 engram: live translation licensing; Weekly Plan semantics; commit email rewrite

### Community 19 - "Verse Length Categories"
Nodes (8): .init(), .shareText(), FitCategory, Verse, long, medium, short, veryLong

### Community 20 - "Community 20"
Nodes (8): Return data unchanged if its SHA-256 matches the pinned hex digest, else abort., Return the bytes at url once they match the pinned SHA-256. A cache file is, Return the bytes at url, fetched over verified TLS., Verified downloads for the seed scripts (stdlib only; certifi optional).  Every, _download.py, download(), fetch_verified(), verify()

### Community 21 - "ASV import pipeline"
Nodes (8): clean(), derived(), excerpt(), fetch_asv_seed.py, fit_category(), main(), segments(), words()

### Community 22 - "KJV import pipeline"
Nodes (8): derived(), excerpt(), fetch_json(), fetch_kjv_seed.py, fit_category(), main(), segments(), words()

### Community 23 - "Web seed fetcher"
Nodes (8): clean(), derived(), excerpt(), fetch_web_seed.py, fit_category(), main(), segments(), words()

### Community 24 - "Settings and Translations UI"
Nodes (8): .name(), BibleLicensesView, ESVTranslationRow, LicenseRow, RVTranslationRow, TranslationRow, TranslationsView, TranslationsView.swift

### Community 25 - "Community 25"
Nodes (7): 0be6fd8 Add future translation roadmap to submission notes, 10220dc chore(graphify): fingerprint community membership in the label sidecar, 25233be feat: add an app icon, 826bf9c fix(onboarding): offer every bundled translation, not just KJV, ca64e70 chore(graphify): stop the graph from indexing its own output, de3bef8 chore: track durable graphify + engram state, e5966e1 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline

### Community 26 - "Community 26"
Nodes (7): 126ee46 engram: Word Unlocked ship status 2026-09-12, 2b17ec3 graphify: name 46 placeholder communities via local model, 35537ab docs: add session handoff, 5f4af3d docs: record Pages URLs, screenshot location, and 2026-09-12 status, a5b7d50 docs: use privacy@rippre.com contact; add 6.9" App Store screenshots, d078d61 chore(graphify): commit the re-rendered report and track the description sidecar, ffb162b Restore the curated community names in GRAPH_REPORT.md

### Community 27 - "Community 27"
Nodes (7): 1f0ac83 engram: Word Unlocked ship status 2026-09-12, 7f48826 Restore the curated community names in GRAPH_REPORT.md, 9a52cd9 chore(graphify): commit the re-rendered report and track the description sidecar, aad5fb6 docs: record Pages URLs, screenshot location, and 2026-09-12 status, c1bb9af graphify: name 46 placeholder communities via local model, ee01380 docs: use privacy@rippre.com contact; add 6.9" App Store screenshots, f252501 docs: add session handoff

### Community 28 - "Testament Enumerations"
Nodes (7): Books, all, book, chapter, newTestament, oldTestament, psalmsAndProverbs

### Community 29 - "Community 29"
Nodes (7): Hashable, Tab, favorites, modes, search, settings, today

### Community 30 - "Verse Display Modes"
Nodes (7): Int, Phase, firstLetters, fullVerse, partialBlank, referenceOnly, review

### Community 31 - "Daily Verse Mode Options"
Nodes (7): VerseMode, chapter, daily, favorites, memorization, topic, weeklyTheme

### Community 32 - "BSB import pipeline"
Nodes (7): derived(), excerpt(), fetch_bsb_seed.py, fit_category(), main(), segments(), words()

### Community 33 - "Mode Selection Interface"
Nodes (7): .detailView(), ESVDownloadNotice, ModeRow, ModeRowData, ModeSaveSection, ModesView, ModesView.swift

### Community 34 - "Settings Interface Elements"
Nodes (7): .swatchButton(), PolicyEntry, PrivacyPolicyView, PrivacyRow, SettingsView, SettingsView.swift, ThemeSwatch

### Community 35 - "RV Bible Service Tests"
Nodes (7): .aLoadedVerseCarriesLSMsAttributionAndIsKeptInMemoryOnly(), .liveFetchReturnsTheRecoveryVersionOfJohn316(), .rejectedCredentialsAreReported(), .requestAsksForTheReferenceWithBasicAuthentication(), .withoutATokenNothingIsRequested(), RVBibleServiceTests, lsmResponse()

### Community 36 - "Community 36"
Nodes (7): .aFavoriteKeepsTheTranslationOfItsOwnText(), .aFavoriteThatCantBeReadIsSkippedAndTheRestAreKeptUnchanged(), .launchingSavesMigratedFavoritesAndRemovesTheStoredRecoveryVersionVerse(), .recoveryVersionFavoritesBecomeKingJamesAndReferencesAreWrittenOut(), .reorderingFavoritesSavesTheNewOrder(), SettingsStoreTests, SettingsStoreTests.swift

### Community 37 - "Shared Model Serialization Tests"
Nodes (7): .arrayOfVersesRoundTripsThroughJSON(), .decodingFailsWhenARequiredKeyIsMissing(), .decodingLocksTheExpectedWireKeys(), .rvCachedVerseRoundTripsThroughJSON(), .singleVerseRoundTripsThroughJSON(), .storedVersesReadBackWhatWasWrittenAndNothingFromCorruptData(), SharedModelsTests

### Community 38 - "Community 38"
Nodes (6): 08a7eea chore(graphify): describe every node in the graph, 47818a0 chore(graphify): absorb post-commit hook output, a5526c4 chore(graphify,engram): absorb hook output, record the describe workflow, b5b951b fix(scripts): verify TLS and pin every seed source, f854b48 docs: record the graph state in the handoff and ship-status engram, fe15924 chore(graphify): absorb post-commit hook output from the graph rebuild

### Community 39 - "Long Verse Handling Strategy"
Nodes (6): LongVerseStrategy, excerpt, excludeLong, referenceOnly, segmented, smartFit

### Community 40 - "Memorization Display Logic"
Nodes (6): .currentPhase(), .displayText(), .partialBlank(), .phase(), .text(), MemorizationService

### Community 41 - "Community 41"
Nodes (6): .book(), .parse(), ReferenceParser, ReferenceParser.swift, VerseQuery, group()

### Community 42 - "Favorites List Interface"
Nodes (6): .prefixText(), FavoriteDetailView, FavoriteRow, FavoritesView, FavoritesView.swift, String

### Community 43 - "Community 43"
Nodes (6): .init(), .renderWallpaper(), .saveToPhotos(), .stepRow(), WallpaperCanvas, WallpaperExportView

### Community 44 - "Widget Theme Encoding"
Nodes (6): .encode(), .fontDesign(), .init(), .name(), .theme(), WidgetTheme

### Community 45 - "Community 45"
Nodes (6): .aPausedPlanShowsTheWholeVerse(), .aSevenDayPlanTakesOneStepPerLocalCalendarDay(), .eachStepShowsTheVerseItsOwnWay(), .harderPlansBlankMoreWords(), MemorizationServiceTests, MemorizationServiceTests.swift

### Community 46 - "Community 46"
Nodes (5): 2879ff0 chore: declare export compliance and tidy repo hygiene, 3cc4c76 chore(graphify): refresh the graph and stop stray caches reaching git, 829ec96 docs: publish privacy, support, and landing pages, 9c3ef43 docs(marketing): correct the RV listing and trim over-limit keywords, ed5eb1d chore(graphify): absorb post-commit hook output from the release batch

### Community 47 - "Community 47"
Nodes (5): 299e463 docs(marketing): correct the RV listing and trim over-limit keywords, 830b7f0 chore(graphify): refresh the graph and stop stray caches reaching git, b7adf6f chore: declare export compliance and tidy repo hygiene, e24446a chore(graphify): absorb post-commit hook output from the release batch, ea4ae89 docs: publish privacy, support, and landing pages

### Community 48 - "Translation License Status"
Nodes (5): LicenseStatus, ccBySA, comingSoon, licensed, publicDomain

### Community 49 - "Community 49"
Nodes (5): RotationInterval, daily, everyEightHours, everySixHours, everyTwelveHours

### Community 50 - "Favorites Mode View"
Nodes (5): .loadPreferences(), FavoritesRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 51 - "Onboarding Theme Selection"
Nodes (5): .themeButton(), AutomaticThemeSwatch, OnboardingThemeView, OnboardingThemeView.swift, ThemeChoiceSwatch

### Community 52 - "Long Verse Text Processing"
Nodes (5): .excerpt(), .firstLetters(), .fitCategory(), .segments(), LongVerseService

### Community 53 - "Today Display Controller"
Nodes (5): .computeCurrentVerse(), .init(), .refresh(), .toggleFavorite(), TodayView

### Community 54 - "Save State Machine"
Nodes (5): SaveState, error, idle, saved, saving

### Community 55 - "Widget Data Provider"
Nodes (5): .getSnapshot(), .getTimeline(), .placeholder(), TimelineProvider, VerseProvider

### Community 56 - "Community 56"
Nodes (5): .leavesWordsAndImpossibleReferencesToWordSearch(), .readsReferencesTheWayPeopleWriteThem(), .searchReturnsTheVersesAReferenceNamesInOrder(), ReferenceParserTests, ReferenceParserTests.swift

### Community 57 - "Memorization Mode View"
Nodes (4): .load(), .savePlan(), .search(), MemorizationModeView

### Community 58 - "Topic Mode View"
Nodes (4): TopicRotationSpeed, daily, everySixHours, everyTwelveHours

### Community 59 - "Weekly Theme Controller"
Nodes (4): .load(), .loadPreview(), .start(), WeeklyThemeModeView

### Community 60 - "Onboarding Mode Selection"
Nodes (4): ModeChoiceCard, OnboardingModeCard, OnboardingModeView, OnboardingModeView.swift

### Community 61 - "Onboarding Translation Selection"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 62 - "Widget Instructions View"
Nodes (4): OnboardingWidgetInstructionsView, OnboardingWidgetInstructionsView.swift, WidgetInstructionRow, WidgetInstructionStep

### Community 63 - "Translation Selection View"
Nodes (4): OnboardingTranslationCard, OnboardingTranslationView, OnboardingTranslationView.swift, TranslationChoiceCard

### Community 64 - "Search and Favorite Actions"
Nodes (4): .performSearch(), .search(), .toggleFavorite(), SearchView

### Community 65 - "Verse Detail Actions"
Nodes (4): .memorize(), .toggleFavorite(), .useForMemorization(), VerseDetailSheet

### Community 66 - "App Entry Point"
Nodes (3): .init(), App, WordUnlockedApp

### Community 67 - "App Icon Generator"
Nodes (3): generate-app-icon.swift, page(), rgb()

### Community 68 - "Main Onboarding Flow"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 69 - "Onboarding Progress Screen"
Nodes (3): OnboardingProgressDots, OnboardingView, OnboardingView.swift

### Community 70 - "Community 70"
Nodes (3): .removeCachedResponses(), LiveAPISession, LiveAPISession.swift

### Community 71 - "Community 71"
Nodes (3): .aVerseWithoutItsPlaceFallsBackToTheSavedReference(), .referencesUseTheBooksFullNameAndPsalmForOnePsalm(), VerseReferenceTests

### Community 72 - "Community 72"
Nodes (3): TestDefaults.swift, emptyDefaults(), withScratchDefaults()

### Community 73 - "Community 73"
Nodes (2): .savePreferences(), FavoritesModeView

### Community 74 - "Verse Picker Interface"
Nodes (2): .row(), WeeklyVersePicker

### Community 75 - "Widget Entry View Implementation"
Nodes (2): WidgetEntryView, WidgetEntryView.swift

### Community 76 - "Community 76"
Nodes (1): Return the ESV text for a single-verse reference, or raise on hard failure.

## Knowledge Gaps
- **88 isolated node(s):** `all`, `oldTestament`, `newTestament`, `psalmsAndProverbs`, `book` (+83 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `Return the ESV text for a single-verse reference, or raise on hard failure.`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `VerseSelectionService` connect `BSB import pipeline` to `LSV import pipeline`?**
  _High betweenness centrality (0.084) - this node is a cross-community bridge._
- **Why does `ScriptureDatabase` connect `iOS app build tools` to `LSV import pipeline`?**
  _High betweenness centrality (0.082) - this node is a cross-community bridge._
- **Why does `VerseSelectionServiceTests` connect `ASV import pipeline` to `LSV import pipeline`?**
  _High betweenness centrality (0.069) - this node is a cross-community bridge._
- **What connects `all`, `oldTestament`, `newTestament` to the rest of the system?**
  _88 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `LSV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.05899122807017544 - nodes in this community are weakly interconnected._
- **Should `ASV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.06763285024154589 - nodes in this community are weakly interconnected._
- **Should `KJV import pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.0753045404208195 - nodes in this community are weakly interconnected._