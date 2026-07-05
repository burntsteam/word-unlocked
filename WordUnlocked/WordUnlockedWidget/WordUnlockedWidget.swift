import SwiftUI
import WidgetKit

struct WordUnlockedWidget: Widget {
    let kind: String = "WordUnlockedWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VerseProvider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Word Unlocked")
        .description("Scripture on your Lock Screen. Offline and private.")
        .supportedFamilies([
            // Lock Screen (accessory) families lead — this is the default surface.
            .accessoryRectangular,
            .accessoryInline,
            .accessoryCircular,
            // Home Screen sizes remain available.
            .systemSmall,
            .systemMedium
        ])
    }
}
