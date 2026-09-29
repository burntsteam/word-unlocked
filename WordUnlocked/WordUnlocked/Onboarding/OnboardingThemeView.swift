import SwiftUI

struct OnboardingThemeView: View {
    @EnvironmentObject var settingsStore: SettingsStore

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                OnboardingHeader(
                    systemImage: "paintpalette",
                    title: "Choose a Theme",
                    subtitle: "Pick the look of your Home Screen widget and wallpapers. Lock Screen widgets take on your Lock Screen's style."
                )

                LazyVGrid(columns: columns, spacing: 12) {
                    themeButton(id: WidgetTheme.automaticId) {
                        AutomaticThemeSwatch(isSelected: settingsStore.selectedTheme == WidgetTheme.automaticId)
                    }
                    ForEach(ThemeService.themes) { theme in
                        themeButton(id: theme.id) {
                            ThemeChoiceSwatch(theme: theme, isSelected: settingsStore.selectedTheme == theme.id)
                        }
                    }
                }
            }
            .padding(24)
        }
    }

    private func themeButton<Label: View>(id: String, @ViewBuilder label: () -> Label) -> some View {
        let isSelected = settingsStore.selectedTheme == id
        return Button {
            settingsStore.selectedTheme = id
        } label: {
            label()
        }
        .buttonStyle(.plain)
        .accessibilityLabel(WidgetTheme.name(forId: id))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
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

/// Automatic shown as Minimal Light with a strip of Minimal Dark beside it.
struct AutomaticThemeSwatch: View {
    let isSelected: Bool

    private let light = WidgetTheme.theme(id: "minimal-light", colorScheme: .light)
    private let dark = WidgetTheme.theme(id: "minimal-dark", colorScheme: .dark)

    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Circle()
                        .fill(light.colors.accent)
                        .frame(width: 14, height: 14)
                    Text("Automatic")
                        .font(.subheadline.weight(.semibold))
                    Text("Light or dark with your iPhone")
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .foregroundStyle(light.colors.text)
                .padding(12)
                .frame(maxWidth: .infinity, minHeight: 84, alignment: .topLeading)
                .background(light.colors.background)

                dark.colors.background
                    .frame(width: 30)
            }

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(dark.colors.text)
                    .padding(7)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(isSelected ? light.colors.accent : Color.secondary.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
    }
}
