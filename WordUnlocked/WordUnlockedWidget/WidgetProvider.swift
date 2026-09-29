import WidgetKit
import Foundation

struct VerseProvider: TimelineProvider {
    func placeholder(in context: Context) -> VerseEntry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (VerseEntry) -> Void) {
        let entry = WidgetTimelineService.shared.entries(maxEntries: 1).first ?? .placeholder
        // Each request opens the database afresh: the app may have replaced the file since.
        ScriptureDatabase.shared.closeConnection()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VerseEntry>) -> Void) {
        let timeline = WidgetTimelineService.shared.timeline(now: Date())
        ScriptureDatabase.shared.closeConnection()
        let entries = timeline.entries.isEmpty ? [.placeholder] : timeline.entries
        completion(Timeline(entries: entries, policy: .after(timeline.reloadDate)))
    }
}
