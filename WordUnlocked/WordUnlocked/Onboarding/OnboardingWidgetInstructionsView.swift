import SwiftUI

struct OnboardingWidgetInstructionsView: View {
    let onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                OnboardingHeader(
                    systemImage: "rectangle.inset.filled",
                    title: "Add the Widget",
                    subtitle: "Use the iPhone Lock Screen editor after setup."
                )

                VStack(alignment: .leading, spacing: 14) {
                    ForEach(widgetInstructionSteps) { step in
                        WidgetInstructionRow(step: step)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button("Next", action: onContinue)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
            .padding(24)
        }
    }
}

private struct WidgetInstructionStep: Identifiable {
    let number: Int
    let icon: String
    let text: String

    var id: Int { number }
}

private let widgetInstructionSteps: [WidgetInstructionStep] = [
    WidgetInstructionStep(number: 1, icon: "hand.tap", text: "Touch and hold the Lock Screen."),
    WidgetInstructionStep(number: 2, icon: "slider.horizontal.3", text: "Tap Customize."),
    WidgetInstructionStep(number: 3, icon: "lock", text: "Choose Lock Screen."),
    WidgetInstructionStep(number: 4, icon: "rectangle.grid.1x2", text: "Tap the widget area."),
    WidgetInstructionStep(number: 5, icon: "magnifyingglass", text: "Find Word Unlocked."),
    WidgetInstructionStep(number: 6, icon: "rectangle.3.group", text: "Choose Inline, Circular, or Rectangular."),
    WidgetInstructionStep(number: 7, icon: "plus.circle", text: "Add the widget."),
    WidgetInstructionStep(number: 8, icon: "checkmark", text: "Tap Done to save the Lock Screen.")
]

private struct WidgetInstructionRow: View {
    let step: WidgetInstructionStep

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.12))
                Text("\(step.number)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.tint)
            }
            .frame(width: 32, height: 32)

            Image(systemName: step.icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 24, height: 32)

            Text(step.text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
        )
    }
}
