import SwiftUI
import WidgetKit

struct WidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    let entry: VerseEntry
    
    var body: some View {
        switch family {
        case .accessoryInline:
            InlineWidgetView(entry: entry)
        case .accessoryCircular:
            CircularWidgetView(entry: entry)
        case .accessoryRectangular:
            RectangularWidgetView(entry: entry)
        case .systemSmall, .systemMedium:
            HomeScreenWidgetView(entry: entry)
        default:
            HomeScreenWidgetView(entry: entry)
        }
    }
}
