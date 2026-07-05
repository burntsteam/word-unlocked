import SwiftUI

struct OnboardingModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    let onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                OnboardingHeader(
                    systemImage: "rectangle.3.group",
                    title: "Choose How Verses Rotate",
                    subtitle: "Start simple, or choose a focused rhythm."
                )

                VStack(spacing: 10) {
                    ForEach(onboardingModeCards) { card in
                        Button {
                            settingsStore.activeMode = card.mode
                        } label: {
                            ModeChoiceCard(card: card, isSelected: settingsStore.activeMode == card.mode)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Button("Next", action: onContinue)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
            .padding(24)
        }
    }
}

private struct OnboardingModeCard: Identifiable {
    let mode: WidgetSettings.VerseMode
    let title: String
    let description: String
    let icon: String

    var id: WidgetSettings.VerseMode { mode }
}

private let onboardingModeCards: [OnboardingModeCard] = [
    OnboardingModeCard(mode: .daily, title: "Daily Verse", description: "A new verse every day.", icon: "calendar"),
    OnboardingModeCard(mode: .weeklyTheme, title: "Weekly Theme", description: "Seven verses around one theme.", icon: "7.square"),
    OnboardingModeCard(mode: .topic, title: "Topic", description: "Focus on a subject you choose.", icon: "tag"),
    OnboardingModeCard(mode: .chapter, title: "Chapter", description: "Move through one chapter in order.", icon: "book.pages"),
    OnboardingModeCard(mode: .memorization, title: "Memorization", description: "Practice one verse in phases.", icon: "brain.head.profile"),
    OnboardingModeCard(mode: .favorites, title: "Favorites", description: "Rotate saved verses.", icon: "heart")
]

private struct ModeChoiceCard: View {
    let card: OnboardingModeCard
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: card.icon)
                .frame(width: 28)
                .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)

            VStack(alignment: .leading, spacing: 3) {
                Text(card.title)
                    .font(.headline)
                Text(card.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.tint)
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
