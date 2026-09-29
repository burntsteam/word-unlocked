import SwiftUI

struct OnboardingModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore

    // Memorization and Favorites need a chosen or saved verse first, so they're set up later in Modes.
    private let modes: [WidgetSettings.VerseMode] = [.daily, .weeklyTheme, .topic, .chapter]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                OnboardingHeader(
                    systemImage: "rectangle.3.group",
                    title: "Choose How Verses Rotate",
                    subtitle: "Start simple, or choose a focused rhythm."
                )

                VStack(spacing: 10) {
                    ForEach(modes) { mode in
                        let isSelected = settingsStore.activeMode == mode
                        Button {
                            settingsStore.activeMode = mode
                        } label: {
                            ModeChoiceCard(mode: mode, isSelected: isSelected)
                        }
                        .buttonStyle(.plain)
                        .accessibilityAddTraits(isSelected ? .isSelected : [])
                    }
                }

                Text("You can pick the topic, passage or plan in Modes, and set up Memorization or Favorites once you've chosen a verse.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
        }
    }
}

private struct ModeChoiceCard: View {
    let mode: WidgetSettings.VerseMode
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: mode.symbolName)
                .frame(width: 28)
                .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(mode.title)
                    .font(.headline)
                Text(mode.summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.tint)
                    .accessibilityHidden(true)
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(isSelected ? Color.accentColor : Color.secondary.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
    }
}
