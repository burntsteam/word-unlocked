import SwiftUI
import WidgetKit

struct RectangularWidgetView: View {
    let entry: VerseEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(entry.verseRef)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                if !entry.translationCode.isEmpty {
                    Text(entry.translationCode)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(.tertiary)
                }
            }
            
            Text("\"\(entry.verseText)\"")
                .font(.system(size: 12))
                .lineLimit(4)
                .minimumScaleFactor(0.65)
                .fixedSize(horizontal: false, vertical: false)
            
            if let seg = entry.segmentInfo {
                Text(seg)
                    .font(.system(size: 9))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}
