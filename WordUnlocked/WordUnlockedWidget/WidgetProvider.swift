import WidgetKit
import Foundation

struct VerseProvider: TimelineProvider {
    func placeholder(in context: Context) -> VerseEntry {
        VerseEntry(date: Date(),
                   verseText: "For God so loved the world, that he gave his only begotten Son...",
                   verseRef: "John 3:16",
                   translationCode: "KJV",
                   theme: "minimal-light",
                   segmentInfo: nil,
                   mode: "daily")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (VerseEntry) -> Void) {
        completion(WidgetTimelineService.shared.generateTimeline().first ?? placeholder(in: context))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<VerseEntry>) -> Void) {
        let entries = WidgetTimelineService.shared.generateTimeline()
        let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date().addingTimeInterval(86_400)
        completion(Timeline(entries: entries, policy: .after(nextUpdate)))
    }
}
