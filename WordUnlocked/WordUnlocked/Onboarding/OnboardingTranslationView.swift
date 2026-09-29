import SwiftUI

struct OnboardingTranslationView: View {
    @EnvironmentObject var settingsStore: SettingsStore

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                OnboardingHeader(
                    systemImage: "book",
                    title: "Your Translation",
                    subtitle: "Five translations are included offline. Pick one — you can change it any time."
                )

                VStack(spacing: 12) {
                    ForEach(translationCards) { card in
                        TranslationChoiceCard(
                            translation: card,
                            isSelected: settingsStore.selectedTranslation == card.code,
                            action: {
                                if card.isAvailable {
                                    settingsStore.selectedTranslation = card.code
                                }
                            }
                        )
                    }
                }

                Text("The English Standard Version and the Recovery Version are also available, from Settings, with an internet connection.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
        }
    }
}

private struct OnboardingTranslationCard: Identifiable {
    let code: String
    let name: String
    let detail: String
    let isAvailable: Bool

    var id: String { code }
}

// Built from the bundled seed database rather than hardcoded, so a translation added to
// the seed shows up during onboarding instead of silently staying invisible here.
private var translationCards: [OnboardingTranslationCard] {
    TranslationService.availableOffline
        .filter(\.enabled)
        .map { translation in
            OnboardingTranslationCard(
                code: translation.code,
                name: translation.displayName,
                detail: "Available offline",
                isAvailable: true
            )
        }
}

private struct TranslationChoiceCard: View {
    let translation: OnboardingTranslationCard
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Circle()
                    .fill(translation.isAvailable ? Color.green : Color.gray)
                    .frame(width: 10, height: 10)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(translation.code)
                        .font(.headline)
                    Text(translation.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    // Secondary, not green: green text is under 3:1 on white, and the dot says it.
                    Text(translation.detail)
                        .font(.caption.weight(.semibold))
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
            .foregroundStyle(translation.isAvailable ? Color.primary : Color.secondary)
        }
        .buttonStyle(.plain)
        .disabled(!translation.isAvailable)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
