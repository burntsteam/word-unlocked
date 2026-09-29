import SwiftUI
import WidgetKit

struct WidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    let entry: VerseEntry

    var body: some View {
        content.widgetURL(VerseEntry.todayURL)
    }

    @ViewBuilder
    private var content: some View {
        switch family {
        case .accessoryInline:
            InlineWidgetView(entry: entry)
                .containerBackground(for: .widget) { Color.clear }
        case .accessoryCircular:
            CircularWidgetView(entry: entry)
                .containerBackground(for: .widget) { Color.clear }
        case .accessoryRectangular:
            RectangularWidgetView(entry: entry)
                .containerBackground(for: .widget) { Color.clear }
        default:
            HomeScreenWidgetView(entry: entry)
        }
    }
}
