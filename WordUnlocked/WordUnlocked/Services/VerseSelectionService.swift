import Foundation

enum VerseSelectionService {
    static func verse(for settings: WidgetSettings, date: Date = Date(), favorites: [Favorite] = []) -> Verse {
        switch settings.activeMode {
        case .daily:
            return datedVerse(settings: settings, date: date)
        case .weeklyTheme:
            return topicVerse(slug: settings.topicSlug ?? "hope", settings: settings, date: date, span: .weekOfYear)
        case .topic:
            return topicVerse(slug: settings.topicSlug ?? "love", settings: settings, date: date, span: .day)
        case .chapter:
            return chapterVerse(settings: settings, date: date)
        case .memorization:
            return memorizationVerse(settings: settings) ?? datedVerse(settings: settings, date: date)
        case .favorites:
            return favoriteVerse(settings: settings, date: date, favorites: favorites) ?? datedVerse(settings: settings, date: date)
        }
    }

    // Online translations (ESV) have no local verses; rotate them through the
    // KJV reference set and fetch the live text for each. RV keeps its own path.
    private static func referenceCode(for settings: WidgetSettings) -> String {
        settings.translationCode == "ESV" ? "KJV" : settings.translationCode
    }

    private static func datedVerse(settings: WidgetSettings, date: Date) -> Verse {
        let verses = DatabaseService.shared.allVerses(translationCode: referenceCode(for: settings))
        return pick(from: verses, date: date, component: .day) ?? builtInVerse(referenceCode(for: settings))
    }

    private static func topicVerse(slug: String, settings: WidgetSettings, date: Date, span: Calendar.Component) -> Verse {
        let verses = DatabaseService.shared.verses(topicSlug: slug, translationCode: referenceCode(for: settings))
        return pick(from: verses, date: date, component: span) ?? datedVerse(settings: settings, date: date)
    }

    private static func chapterVerse(settings: WidgetSettings, date: Date) -> Verse {
        let bookId = settings.chapterBookId ?? 43
        let chapter = settings.chapterNumber ?? 3
        let verses = DatabaseService.shared.verses(bookId: bookId, chapter: chapter, translationCode: referenceCode(for: settings))
        return pick(from: verses, date: date, component: .day) ?? datedVerse(settings: settings, date: date)
    }

    private static func memorizationVerse(settings: WidgetSettings) -> Verse? {
        guard let verseId = settings.memorizationPlanId else { return nil }
        return DatabaseService.shared.verse(id: verseId)
    }

    private static func favoriteVerse(settings: WidgetSettings, date: Date, favorites: [Favorite]) -> Verse? {
        guard !favorites.isEmpty else { return nil }
        let index = stableIndex(for: date, component: .day, count: favorites.count)
        let favorite = favorites[index]
        return DatabaseService.shared.verse(id: favorite.verseId) ?? Verse(
            id: favorite.verseId,
            translationId: 0,
            bookId: 0,
            chapter: 0,
            verse: 0,
            verseRef: favorite.verseRef,
            text: favorite.text,
            charCount: favorite.text.count,
            wordCount: favorite.text.split(separator: " ").count,
            fitCategory: LongVerseService.fitCategory(charCount: favorite.text.count),
            excerpt: LongVerseService.excerpt(from: favorite.text, maxChars: 132),
            segmentCount: LongVerseService.segments(from: favorite.text, maxCharsPerSegment: 110).count
        )
    }

    // internal, not private: pick/stableIndex are pure and are the determinism contract
    // the widget timeline depends on, so tests need to reach them.
    static func pick(from verses: [Verse], date: Date, component: Calendar.Component) -> Verse? {
        guard !verses.isEmpty else { return nil }
        let index = stableIndex(for: date, component: component, count: verses.count)
        return verses[index]
    }

    static func stableIndex(for date: Date, component: Calendar.Component, count: Int) -> Int {
        let calendar = Calendar.current
        let value: Int
        switch component {
        case .weekOfYear:
            value = calendar.component(.weekOfYear, from: date) + calendar.component(.year, from: date) * 53
        default:
            value = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        }
        return abs(value) % max(count, 1)
    }

    private static func builtInVerse(_ translationCode: String) -> Verse {
        let text = translationCode == "WEB"
            ? "For God so loved the world, that he gave his one and only Son, that whoever believes in him should not perish, but have eternal life."
            : "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life."
        return Verse(
            id: translationCode == "WEB" ? 101 : 1,
            translationId: translationCode == "WEB" ? 2 : 1,
            bookId: 43,
            chapter: 3,
            verse: 16,
            verseRef: "John 3:16",
            text: text,
            charCount: text.count,
            wordCount: text.split(separator: " ").count,
            fitCategory: LongVerseService.fitCategory(charCount: text.count),
            excerpt: LongVerseService.excerpt(from: text, maxChars: 132),
            segmentCount: LongVerseService.segments(from: text, maxCharsPerSegment: 110).count
        )
    }
}

