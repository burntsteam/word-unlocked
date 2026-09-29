import SwiftUI
import WidgetKit

struct HomeScreenWidgetView: View {
    let entry: VerseEntry
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var colorScheme

    private var theme: WidgetTheme {
        WidgetTheme.theme(id: entry.theme, colorScheme: colorScheme)
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

    // A small widget holds about a hundred characters at a readable size, so longer
    // verses show their opening.
    private var smallLayout: some View {
        HStack(alignment: .top, spacing: 0) {
            Rectangle()
                .fill(theme.colors.accent)
                .frame(width: 3)
                .padding(.vertical, 14)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: 0)

                if let text = entry.verseText {
                    Text("\u{201C}\(LongVerseService.excerpt(from: text, maxChars: 100))\u{201D}")
                        .font(.system(size: 13, weight: .regular, design: theme.fontDesign))
                        .foregroundStyle(theme.colors.text)
                        .lineLimit(6)
                        .minimumScaleFactor(0.8)
                        .lineSpacing(2)
                } else {
                    Text(entry.verseRef)
                        .font(.system(size: 18, weight: .semibold, design: theme.fontDesign))
                        .foregroundStyle(theme.colors.text)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                }

                Spacer(minLength: 8)

                if let note = entry.note {
                    Text(note)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(theme.colors.secondaryText)
                        .lineLimit(1)
                        .padding(.bottom, 2)
                }

                HStack(alignment: .firstTextBaseline) {
                    if !entry.translationCode.isEmpty {
                        Text(entry.translationCode)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(theme.colors.secondaryText)
                    }
                    Spacer()
                    if entry.verseText != nil {
                        Text(entry.verseRef)
                            .font(.system(size: 11, weight: .semibold, design: theme.fontDesign))
                            .foregroundStyle(theme.colors.accent)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 14)
            .padding(.vertical, 14)
        }
        .accessibilityElement(children: .combine)
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
                        .foregroundStyle(theme.colors.secondaryText)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(theme.colors.text.opacity(0.06))
                        .clipShape(Capsule())
                }
            }
            .padding(.bottom, 8)

            theme.colors.accent.opacity(0.25)
                .frame(height: 1)
                .padding(.bottom, 10)
                .accessibilityHidden(true)

            if let text = entry.verseText {
                Text("\u{201C}\(text)\u{201D}")
                    .font(.system(size: 13, weight: .light, design: theme.fontDesign))
                    .foregroundStyle(theme.colors.text)
                    .lineLimit(entry.note == nil ? 4 : 3)
                    .minimumScaleFactor(0.65)
                    .lineSpacing(3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            } else {
                Text(entry.verseRef)
                    .font(.system(size: 22, weight: .semibold, design: theme.fontDesign))
                    .foregroundStyle(theme.colors.text)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }

            if let note = entry.note {
                Text(note)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(theme.colors.secondaryText)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .accessibilityElement(children: .combine)
    }
}
