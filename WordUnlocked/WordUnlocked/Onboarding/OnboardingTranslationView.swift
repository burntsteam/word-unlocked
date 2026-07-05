import SwiftUI

struct OnboardingTranslationView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    let onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                OnboardingHeader(
                    systemImage: "book",
                    title: "Your Translation",
                    subtitle: "King James Version is included offline."
                )

                VStack(spacing: 12) {
                    ForEach(translationCards) { translation in
                        TranslationChoiceCard(
                            translation: translation,
                            isSelected: settingsStore.selectedTranslation == translation.code,
                            action: {
                                if translation.isAvailable {
                                    settingsStore.selectedTranslation = translation.code
                                }
                            }
                        )
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

private struct OnboardingTranslationCard: Identifiable {
    let code: String
    let name: String
    let detail: String
    let isAvailable: Bool

    var id: String { code }
}

private let translationCards: [OnboardingTranslationCard] = [
    OnboardingTranslationCard(code: "KJV", name: "King James Version", detail: "Available offline", isAvailable: true)
]

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

                VStack(alignment: .leading, spacing: 4) {
                    Text(translation.code)
                        .font(.headline)
                    Text(translation.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(translation.detail)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(translation.isAvailable ? Color.green : Color.secondary)
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
            .foregroundStyle(translation.isAvailable ? Color.primary : Color.secondary)
        }
        .buttonStyle(.plain)
        .disabled(!translation.isAvailable)
    }
}
