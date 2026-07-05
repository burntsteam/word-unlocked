import SwiftUI
import WidgetKit

struct CircularWidgetView: View {
    let entry: VerseEntry
    
    private var shortRef: String {
        let parts = entry.verseRef.components(separatedBy: " ")
        guard parts.count >= 2 else { return entry.verseRef }
        let book = parts.dropLast().joined(separator: " ")
        let cv = parts.last ?? ""
        let shortBook = String(book.prefix(4))
        return "\(shortBook) \(cv)"
    }
    
    var body: some View {
        VStack(spacing: 1) {
            Text(shortRef.components(separatedBy: ":").first ?? shortRef)
                .font(.system(size: 10, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
            Text(shortRef)
                .font(.system(size: 9))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
    }
}
