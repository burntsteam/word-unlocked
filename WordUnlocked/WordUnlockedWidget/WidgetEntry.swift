import WidgetKit
import Foundation

struct VerseEntry: TimelineEntry {
    let date: Date
    let verseText: String
    let verseRef: String
    let translationCode: String
    let theme: String
    let segmentInfo: String?
    let mode: String
}
