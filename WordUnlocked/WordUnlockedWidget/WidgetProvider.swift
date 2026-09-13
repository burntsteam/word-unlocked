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
        completion(WidgetTimelineService.shared.generateTimeline(dayCount: 1).first ?? placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VerseEntry>) -> Void) {
        let now = Date()
        let entries = WidgetTimelineService.shared.generateTimeline(now: now)
        let calendar = Calendar.current
        let nextMidnight = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) ?? now.addingTimeInterval(86_400)
        completion(Timeline(entries: entries, policy: .after(nextMidnight)))
    }
}
