import SwiftUI
import WidgetKit

struct RectangularWidgetView: View {
    let entry: VerseEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let text = entry.verseText {
                HStack(alignment: .firstTextBaseline) {
                    Text(entry.verseRef)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer(minLength: 4)
                    translationCode
                }

                Text("\u{201C}\(text)\u{201D}")
                    .font(.system(size: 12))
                    .lineLimit(entry.note == nil ? 4 : 3)
                    .minimumScaleFactor(0.65)
            } else {
                // The reference alone: a verse too long for the Lock Screen, or a
                // memorization step that asks for the words from memory.
                Text(entry.verseRef)
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                translationCode
            }

            if let note = entry.note {
                Text(note)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var translationCode: some View {
        if !entry.translationCode.isEmpty {
            Text(entry.translationCode)
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }
}
