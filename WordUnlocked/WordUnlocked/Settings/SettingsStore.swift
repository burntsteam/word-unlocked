import Foundation
import WidgetKit

@MainActor
final class SettingsStore: ObservableObject {
    private let defaults: UserDefaults

    @Published var selectedTranslation: String {
        didSet {
            defaults.set(selectedTranslation, forKey: AppGroupSettings.Keys.selectedTranslation)
            reloadWidgetTimelines()
        }
    }

    @Published var activeMode: WidgetSettings.VerseMode {
        didSet {
            defaults.set(activeMode.rawValue, forKey: AppGroupSettings.Keys.activeMode)
            if activeMode != oldValue {
                startPlan(for: activeMode)
            }
            reloadWidgetTimelines()
        }
    }

    @Published var selectedTheme: String {
        didSet {
            defaults.set(selectedTheme, forKey: AppGroupSettings.Keys.selectedTheme)
            reloadWidgetTimelines()
        }
    }

    @Published var longVerseStrategy: WidgetSettings.LongVerseStrategy {
        didSet {
            defaults.set(longVerseStrategy.rawValue, forKey: AppGroupSettings.Keys.longVerseStrategy)
            reloadWidgetTimelines()
        }
    }

    @Published var topicSlug: String? {
        didSet {
            defaults.set(topicSlug, forKey: AppGroupSettings.Keys.topicSlug)
            if topicSlug != oldValue, activeMode == .weeklyTheme {
                startPlan(for: .weeklyTheme)
            }
            reloadWidgetTimelines()
        }
    }

    @Published var chapterBookId: Int? {
        didSet {
            defaults.set(chapterBookId, forKey: AppGroupSettings.Keys.chapterBookId)
            if chapterBookId != oldValue, activeMode == .chapter {
                startPlan(for: .chapter)
            }
            reloadWidgetTimelines()
        }
    }

    @Published var chapterNumber: Int? {
        didSet {
            defaults.set(chapterNumber, forKey: AppGroupSettings.Keys.chapterNumber)
            if chapterNumber != oldValue, activeMode == .chapter {
                startPlan(for: .chapter)
            }
            reloadWidgetTimelines()
        }
    }

    @Published var memorizationPlanId: Int? {
        didSet {
            defaults.set(memorizationPlanId, forKey: AppGroupSettings.Keys.memorizationPlanId)
            reloadWidgetTimelines()
        }
    }

    @Published var showTranslationCode: Bool {
        didSet {
            defaults.set(showTranslationCode, forKey: AppGroupSettings.Keys.showTranslationCode)
            reloadWidgetTimelines()
        }
    }

    @Published var showProgress: Bool {
        didSet {
            defaults.set(showProgress, forKey: AppGroupSettings.Keys.showProgress)
            reloadWidgetTimelines()
        }
    }

    @Published var favorites: [Favorite] {
        didSet {
            saveFavorites()
            reloadWidgetTimelines()
        }
    }

    @Published var memorizationPlan: MemorizationPlan? {
        didSet {
            saveMemorizationPlan()
            reloadWidgetTimelines()
        }
    }

    init(defaults: UserDefaults = AppGroupSettings.defaults, database: ScriptureDatabase = .shared) {
        self.defaults = defaults
        let saved = WidgetSettings(defaults: defaults)

        selectedTranslation = saved.translationCode
        activeMode = saved.activeMode
        selectedTheme = saved.themeId
        longVerseStrategy = saved.longVerseStrategy
        topicSlug = saved.topicSlug
        chapterBookId = saved.chapterBookId
        chapterNumber = saved.chapterNumber
        memorizationPlanId = saved.memorizationPlanId
        showTranslationCode = saved.showTranslationCode
        showProgress = saved.showProgress

        let savedFavorites = Favorite.saved(in: defaults)
        favorites = Self.migrated(savedFavorites, database: database)
        memorizationPlan = MemorizationPlan.saved(in: defaults)

        // Favorites and the plan are written only when they change: writing back what was just
        // read would replace favorites a newer or damaged format couldn't decode with nothing.
        persistDefaults()
        if favorites != savedFavorites {
            saveFavorites()
        }
        defaults.removeObject(forKey: Self.legacyRecoveryVersionKey)
        if let key = Self.planStartKey(for: activeMode), defaults.object(forKey: key) == nil {
            startPlan(for: activeMode)
        }
    }

    /// Where builds before 14 September 2026 kept the last Recovery Version verse. LSM's
    /// terms forbid storing any of its text, so it is removed at launch.
    private static let legacyRecoveryVersionKey = "rvCachedVerse"

    /// Favorites as this version keeps them. Earlier builds saved Recovery Version favorites
    /// with their text: each becomes the King James text of the same verse, or is dropped when
    /// that verse can't be found. They also saved the database's abbreviated reference, such
    /// as "1Kgs 2:2", which becomes the full one.
    static func migrated(_ favorites: [Favorite], database: ScriptureDatabase) -> [Favorite] {
        favorites.compactMap { favorite in
            let verse = database.verse(id: favorite.verseId)
            guard favorite.translationCode == "RV" else {
                guard let verse, verse.displayReference != favorite.verseRef else { return favorite }
                return Favorite(
                    id: favorite.id, verseId: favorite.verseId, verseRef: verse.displayReference, text: favorite.text,
                    translationCode: favorite.translationCode, addedAt: favorite.addedAt
                )
            }
            guard let kjv = verse, kjv.translationCode == "KJV" else { return nil }
            return Favorite(
                id: favorite.id, verseId: kjv.id, verseRef: kjv.displayReference, text: kjv.text,
                translationCode: kjv.translationCode, addedAt: favorite.addedAt
            )
        }
    }

    func currentSettings(widgetKind: WidgetSettings.WidgetKind = .rectangular) -> WidgetSettings {
        WidgetSettings(
            widgetKind: widgetKind,
            activeMode: activeMode,
            translationCode: selectedTranslation,
            topicSlug: topicSlug,
            chapterBookId: chapterBookId,
            chapterNumber: chapterNumber,
            memorizationPlanId: memorizationPlanId,
            themeId: selectedTheme,
            longVerseStrategy: longVerseStrategy,
            showTranslationCode: showTranslationCode,
            showProgress: showProgress
        )
    }

    func apply(settings: WidgetSettings) {
        activeMode = settings.activeMode
        selectedTranslation = settings.translationCode
        topicSlug = settings.topicSlug
        chapterBookId = settings.chapterBookId
        chapterNumber = settings.chapterNumber
        memorizationPlanId = settings.memorizationPlanId
        selectedTheme = settings.themeId
        longVerseStrategy = settings.longVerseStrategy
        showTranslationCode = settings.showTranslationCode
        showProgress = settings.showProgress
    }

    func resetWidgetSettings() {
        apply(settings: .defaultSettings)
    }

    /// Chapter mode reads from verse 1, and Weekly Plan counts its weeks, from the moment
    /// its plan starts: when the mode, its passage or its plan is chosen.
    func startPlan(for mode: WidgetSettings.VerseMode) {
        guard let key = Self.planStartKey(for: mode) else { return }
        defaults.set(Date(), forKey: key)
        reloadWidgetTimelines()
    }

    /// Saves `verse` with its own text and translation. While a live translation is selected
    /// the verses shown are its KJV reference text, so that is what is saved.
    func addFavorite(verse: Verse) {
        guard favorites.contains(where: { $0.verseId == verse.id }) == false else { return }
        favorites.append(
            Favorite(verseId: verse.id, verseRef: verse.displayReference, text: verse.text, translationCode: verse.translationCode)
        )
    }

    func addFavorite(verseId: Int, verseRef: String, text: String, translationCode: String) {
        guard favorites.contains(where: { $0.verseId == verseId }) == false else { return }
        favorites.append(Favorite(verseId: verseId, verseRef: verseRef, text: text, translationCode: translationCode))
    }

    func removeFavorite(_ favorite: Favorite) {
        favorites.removeAll { $0.id == favorite.id }
    }

    func removeFavorites(at offsets: IndexSet) {
        favorites.remove(atOffsets: offsets)
    }

    /// Favorites mode shows favorites in this order unless Shuffle is on.
    func moveFavorites(from offsets: IndexSet, to destination: Int) {
        favorites.move(fromOffsets: offsets, toOffset: destination)
    }

    /// Removes `verse` from favorites, or saves it with its own text and translation.
    func toggleFavorite(_ verse: Verse) {
        if let favorite = favorites.first(where: { $0.verseId == verse.id }) {
            removeFavorite(favorite)
        } else {
            addFavorite(verse: verse)
        }
    }

    func isFavorite(_ verse: Verse) -> Bool {
        favorites.contains { $0.verseId == verse.id }
    }

    func save(plan: MemorizationPlan) {
        memorizationPlan = plan
        memorizationPlanId = plan.id
    }

    private static func planStartKey(for mode: WidgetSettings.VerseMode) -> String? {
        switch mode {
        case .chapter: AppGroupSettings.Keys.chapterStartDate
        case .weeklyTheme: AppGroupSettings.Keys.weeklyStartDate
        default: nil
        }
    }

    private func persistDefaults() {
        defaults.set(selectedTranslation, forKey: AppGroupSettings.Keys.selectedTranslation)
        defaults.set(activeMode.rawValue, forKey: AppGroupSettings.Keys.activeMode)
        defaults.set(selectedTheme, forKey: AppGroupSettings.Keys.selectedTheme)
        defaults.set(longVerseStrategy.rawValue, forKey: AppGroupSettings.Keys.longVerseStrategy)
        defaults.set(topicSlug, forKey: AppGroupSettings.Keys.topicSlug)
        defaults.set(chapterBookId, forKey: AppGroupSettings.Keys.chapterBookId)
        defaults.set(chapterNumber, forKey: AppGroupSettings.Keys.chapterNumber)
        defaults.set(memorizationPlanId, forKey: AppGroupSettings.Keys.memorizationPlanId)
        defaults.set(showTranslationCode, forKey: AppGroupSettings.Keys.showTranslationCode)
        defaults.set(showProgress, forKey: AppGroupSettings.Keys.showProgress)
    }

    private func saveFavorites() {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        defaults.set(data, forKey: AppGroupSettings.Keys.favorites)
    }

    private func saveMemorizationPlan() {
        guard let memorizationPlan else {
            defaults.removeObject(forKey: AppGroupSettings.Keys.memorizationPlan)
            return
        }
        guard let data = try? JSONEncoder().encode(memorizationPlan) else { return }
        defaults.set(data, forKey: AppGroupSettings.Keys.memorizationPlan)
    }

    private func reloadWidgetTimelines() {
        WidgetCenter.shared.reloadAllTimelines()
    }

}
