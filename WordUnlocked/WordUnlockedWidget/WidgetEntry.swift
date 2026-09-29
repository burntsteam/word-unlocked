import WidgetKit
import Foundation

struct VerseEntry: TimelineEntry {
    let date: Date
    /// The text to show, already fitted to the widget; nil shows the reference alone.
    let verseText: String?
    /// The reference people read, such as "Psalm 23:1".
    let verseRef: String
    /// The database's short reference, such as "Ps 23:1", for the smallest widget.
    let shortRef: String
    let translationCode: String
    let theme: String
    /// A short line under the verse: which part of a split verse, where the chapter is,
    /// or what a memorization step asks.
    let note: String?

    /// Where tapping the widget leads: the app's Today tab.
    static let todayURL = URL(string: "wordunlocked://today")!

    static let placeholder = VerseEntry(
        date: Date(),
        verseText: "For God so loved the world, that he gave his only begotten Son…",
        verseRef: "John 3:16",
        shortRef: "John 3:16",
        translationCode: "KJV",
        theme: WidgetTheme.automaticId,
        note: nil
    )
}
