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

    init(defaults: UserDefaults = AppGroupSettings.defaults) {
        self.defaults = defaults
        let base = WidgetSettings.defaultSettings

        selectedTranslation = defaults.string(forKey: AppGroupSettings.Keys.selectedTranslation) ?? base.translationCode
        activeMode = WidgetSettings.VerseMode(rawValue: defaults.string(forKey: AppGroupSettings.Keys.activeMode) ?? base.activeMode.rawValue) ?? base.activeMode
        selectedTheme = defaults.string(forKey: AppGroupSettings.Keys.selectedTheme) ?? base.themeId
        longVerseStrategy = WidgetSettings.LongVerseStrategy(rawValue: defaults.string(forKey: AppGroupSettings.Keys.longVerseStrategy) ?? base.longVerseStrategy.rawValue) ?? base.longVerseStrategy
        topicSlug = defaults.string(forKey: AppGroupSettings.Keys.topicSlug) ?? base.topicSlug
        chapterBookId = defaults.object(forKey: AppGroupSettings.Keys.chapterBookId) as? Int ?? base.chapterBookId
        chapterNumber = defaults.object(forKey: AppGroupSettings.Keys.chapterNumber) as? Int ?? base.chapterNumber
        memorizationPlanId = defaults.object(forKey: AppGroupSettings.Keys.memorizationPlanId) as? Int ?? base.memorizationPlanId

        if defaults.object(forKey: AppGroupSettings.Keys.showTranslationCode) == nil {
            showTranslationCode = base.showTranslationCode
        } else {
            showTranslationCode = defaults.bool(forKey: AppGroupSettings.Keys.showTranslationCode)
        }

        if defaults.object(forKey: AppGroupSettings.Keys.showProgress) == nil {
            showProgress = base.showProgress
        } else {
            showProgress = defaults.bool(forKey: AppGroupSettings.Keys.showProgress)
        }

        favorites = SettingsStore.loadFavorites(defaults: defaults)
        memorizationPlan = SettingsStore.loadMemorizationPlan(defaults: defaults)
        persistDefaults()
        if let key = Self.planStartKey(for: activeMode), defaults.object(forKey: key) == nil {
            startPlan(for: activeMode)
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

    /// Chapter mode reads from verse 1, and Weekly Theme counts its weeks, from the moment
    /// its plan starts: when the mode, its passage or its theme is chosen.
    func startPlan(for mode: WidgetSettings.VerseMode) {
        guard let key = Self.planStartKey(for: mode) else { return }
        defaults.set(Date(), forKey: key)
    }

    func addFavorite(verse: Verse) {
        guard favorites.contains(where: { $0.verseId == verse.id }) == false else { return }
        favorites.append(
            Favorite(
                verseId: verse.id,
                verseRef: verse.verseRef,
                text: verse.text,
                // A live translation's local verses are the KJV reference text.
                translationCode: VerseSelectionService.referenceTranslationCode(for: selectedTranslation)
            )
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
        for index in offsets.sorted(by: >) {
            favorites.remove(at: index)
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
        saveFavorites()
        saveMemorizationPlan()
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

    private static func loadFavorites(defaults: UserDefaults) -> [Favorite] {
        guard let data = defaults.data(forKey: AppGroupSettings.Keys.favorites) else { return [] }
        return (try? JSONDecoder().decode([Favorite].self, from: data)) ?? []
    }

    private static func loadMemorizationPlan(defaults: UserDefaults) -> MemorizationPlan? {
        guard let data = defaults.data(forKey: AppGroupSettings.Keys.memorizationPlan) else { return nil }
        return try? JSONDecoder().decode(MemorizationPlan.self, from: data)
    }
}
