import SwiftUI
import WidgetKit

struct CircularWidgetView: View {
    let entry: VerseEntry

    /// "Ps 23:1" split into the book, "Ps", and the place in it, "23:1".
    private var reference: (book: String, place: String) {
        let parts = entry.shortRef.split(separator: " ")
        guard parts.count >= 2, let place = parts.last else { return (entry.shortRef, "") }
        return (parts.dropLast().joined(separator: " "), String(place))
    }

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 0) {
                Text(reference.book)
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if !reference.place.isEmpty {
                    Text(reference.place)
                        .font(.system(size: 11))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(4)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(entry.verseRef)
    }
}
