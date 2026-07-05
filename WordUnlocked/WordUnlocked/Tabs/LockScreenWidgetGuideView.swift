import SwiftUI

/// Guide for adding the Lock Screen widget — the recommended default way to keep
/// a verse in view. iOS has no API to add a widget programmatically, so (like the
/// wallpaper flow) we walk the user through the system steps.
struct LockScreenWidgetGuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header
                recommendedCard
                steps
                footnote
            }
            .padding()
        }
        .navigationTitle("Add Lock Screen Widget")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "rectangle.inset.filled")
                .font(.largeTitle)
                .foregroundStyle(.tint)
            Text("Scripture on your Lock Screen")
                .font(.title2.weight(.bold))
            Text("The Lock Screen widget is the quickest way to keep a verse in view. Add it once and it updates through the day — offline, no account.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Highlights the Rectangular widget (the default) with a small mock of it.
    private var recommendedCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "star.fill").font(.caption2)
                Text("RECOMMENDED").font(.caption.weight(.bold)).tracking(1)
            }
            .foregroundStyle(.tint)

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text("Jas 1:3").font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)
                    Spacer()
                    Text("KJV").font(.system(size: 10, weight: .medium)).foregroundStyle(.tertiary)
                }
                Text("\u{201C}Knowing this, that the trying of your faith worketh patience.\u{201D}")
                    .font(.system(size: 13))
                    .lineLimit(3)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text("The Rectangular widget shows the most text. Inline and Circular are also available.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.accentColor.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var steps: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(stepList.enumerated()), id: \.offset) { index, text in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 26, height: 26)
                        .background(Color.accentColor, in: Circle())
                    Text(text)
                        .font(.callout)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private var footnote: some View {
        Text("Widgets update through the day and never need a network connection or account.")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private let stepList = [
        "Lock your iPhone, then touch and hold the Lock Screen.",
        "Tap Customize, then choose Lock Screen.",
        "Tap the widget area just below the clock.",
        "Search for \u{201C}Word Unlocked.\u{201D}",
        "Choose the Rectangular widget, then tap it to add.",
        "Tap Done to save your Lock Screen."
    ]
}
