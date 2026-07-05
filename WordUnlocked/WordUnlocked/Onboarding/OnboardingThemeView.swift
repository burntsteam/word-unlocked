import SwiftUI

struct OnboardingThemeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    let onContinue: () -> Void

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                OnboardingHeader(
                    systemImage: "paintpalette",
                    title: "Choose a Theme",
                    subtitle: "Select a widget style that stays readable on your Lock Screen."
                )

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(ThemeService.themes) { theme in
                        Button {
                            settingsStore.selectedTheme = theme.id
                        } label: {
                            ThemeChoiceSwatch(
                                theme: theme,
                                isSelected: settingsStore.selectedTheme == theme.id
                            )
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

private struct ThemeChoiceSwatch: View {
    let theme: WidgetTheme
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(theme.colors.accent)
                    .frame(width: 14, height: 14)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                }
            }

            Text(theme.name)
                .font(.subheadline.weight(.semibold))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 84, alignment: .topLeading)
        .padding(12)
        .background(theme.colors.background)
        .foregroundStyle(theme.colors.text)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(isSelected ? theme.colors.accent : Color.secondary.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
    }
}
