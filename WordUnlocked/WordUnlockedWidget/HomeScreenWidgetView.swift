import SwiftUI
import WidgetKit

struct HomeScreenWidgetView: View {
    let entry: VerseEntry
    @Environment(\.widgetFamily) private var family

    private var theme: WidgetTheme {
        WidgetTheme.theme(id: entry.theme)
    }

    var body: some View {
        Group {
            if family == .systemSmall {
                smallLayout
            } else {
                mediumLayout
            }
        }
        .containerBackground(for: .widget) {
            theme.colors.background
        }
    }

    private var smallLayout: some View {
        HStack(alignment: .top, spacing: 0) {
            Rectangle()
                .fill(theme.colors.accent)
                .frame(width: 3)
                .padding(.vertical, 14)

            VStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: 0)

                Text("\"\(entry.verseText)\"")
                    .font(.system(size: 12, weight: .light, design: theme.fontDesign))
                    .foregroundStyle(theme.colors.text)
                    .lineLimit(6)
                    .minimumScaleFactor(0.6)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: false)

                Spacer(minLength: 8)

                HStack(alignment: .firstTextBaseline) {
                    if !entry.translationCode.isEmpty {
                        Text(entry.translationCode)
                            .font(.system(size: 8, weight: .medium))
                            .foregroundStyle(theme.colors.text.opacity(0.45))
                    }
                    Spacer()
                    Text(entry.verseRef)
                        .font(.system(size: 10, weight: .semibold, design: theme.fontDesign))
                        .foregroundStyle(theme.colors.accent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 14)
            .padding(.vertical, 14)
        }
    }

    private var mediumLayout: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text(entry.verseRef)
                    .font(.system(size: 12, weight: .semibold, design: theme.fontDesign))
                    .foregroundStyle(theme.colors.accent)
                    .lineLimit(1)

                Spacer()

                if !entry.translationCode.isEmpty {
                    Text(entry.translationCode)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(theme.colors.text.opacity(0.55))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(theme.colors.text.opacity(0.08))
                        .clipShape(Capsule())
                }
            }
            .padding(.bottom, 8)

            theme.colors.accent.opacity(0.25)
                .frame(height: 1)
                .padding(.bottom, 10)

            Text("\"\(entry.verseText)\"")
                .font(.system(size: 13, weight: .light, design: theme.fontDesign))
                .foregroundStyle(theme.colors.text)
                .lineLimit(4)
                .minimumScaleFactor(0.65)
                .lineSpacing(3)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .padding(16)
    }
}
