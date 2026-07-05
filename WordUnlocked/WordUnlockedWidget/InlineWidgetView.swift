import SwiftUI
import WidgetKit

struct InlineWidgetView: View {
    let entry: VerseEntry
    
    var body: some View {
        let shortText = entry.verseText.count > 35 
            ? String(entry.verseText.prefix(35)) + "…" 
            : entry.verseText
        Text("\(entry.verseRef) · \(shortText)")
            .font(.system(size: 12, weight: .regular))
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }
}
