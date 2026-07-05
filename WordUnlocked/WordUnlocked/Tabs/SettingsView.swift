import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsStore: SettingsStore

    var body: some View {
        Form {
            Section("Translation") {
                Picker("Default Translation", selection: $settingsStore.selectedTranslation) {
                    ForEach(TranslationService.availableOffline) { translation in
                        Text("\(translation.code) - \(translation.displayName)").tag(translation.code)
                    }
                }
            }

            Section("Active Mode") {
                Picker("Mode", selection: $settingsStore.activeMode) {
                    ForEach(WidgetSettings.VerseMode.allCases) { mode in
                        Label(mode.title, systemImage: mode.symbolName).tag(mode)
                    }
                }
            }

            Section("Widget Theme") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ThemeService.themes) { theme in
                            ThemeSwatch(
                                theme: theme,
                                isSelected: settingsStore.selectedTheme == theme.id
                            ) {
                                settingsStore.selectedTheme = theme.id
                            }
                        }
                    }
                    .padding(.vertical, 6)
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 0))
            }

            Section("Long Verse Handling") {
                Picker("Strategy", selection: $settingsStore.longVerseStrategy) {
                    ForEach(WidgetSettings.LongVerseStrategy.allCases) { strategy in
                        Text(strategy.title).tag(strategy)
                    }
                }

                Text(settingsStore.longVerseStrategy.summary)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section {
                Text("Everything runs on your device. No accounts, no analytics.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                PrivacyRow(title: "No account required", systemImage: "person.crop.circle.badge.xmark")
                PrivacyRow(title: "No ads", systemImage: "nosign")
                PrivacyRow(title: "No tracking", systemImage: "location.slash")
                PrivacyRow(title: "No analytics", systemImage: "chart.bar.xaxis")
                PrivacyRow(title: "No notifications", systemImage: "bell.slash")
                PrivacyRow(title: "No cloud sync", systemImage: "icloud.slash")
                PrivacyRow(title: "No AI processing", systemImage: "cpu")
                PrivacyRow(title: "KJV works offline", systemImage: "wifi.slash")
            } header: {
                Text("Privacy & Data")
            }

            Section("Bible Translation Licenses") {
                NavigationLink {
                    BibleLicensesView()
                } label: {
                    Label("View Licenses", systemImage: "doc.text")
                }
            }

            Section("Legal") {
                NavigationLink {
                    PrivacyPolicyView()
                } label: {
                    Label("Privacy Policy", systemImage: "hand.raised")
                }
            }

            Section("About") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Word Unlocked")
                        .font(.title3.weight(.bold))
                    Text("Version \(appVersion)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Put scripture on your Lock Screen. Offline and private.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Settings")
    }

    private var appVersion: String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
    }
}

private struct ThemeSwatch: View {
    let theme: WidgetTheme
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                Text("\"For God so loved the world...\"")
                    .font(.system(size: 10, design: theme.fontDesign))
                    .foregroundStyle(theme.colors.text)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)

                Spacer(minLength: 0)

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(theme.name)
                            .font(.system(size: 11, weight: .semibold, design: theme.fontDesign))
                            .foregroundStyle(theme.colors.text)
                            .lineLimit(1)
                        Text("John 3:16")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(theme.colors.accent)
                    }
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.subheadline)
                            .foregroundStyle(theme.colors.accent)
                    }
                }
            }
            .frame(width: 140, height: 110)
            .padding(12)
            .background(theme.colors.background)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(
                        isSelected ? theme.colors.accent : Color.secondary.opacity(0.15),
                        lineWidth: isSelected ? 2.5 : 1
                    )
            )
            .scaleEffect(isSelected ? 1.03 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

private struct PrivacyRow: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .foregroundStyle(.primary)
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        List {
            Section("Data Collection") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("No data is ever collected.")
                        .font(.subheadline.weight(.semibold))
                    Text("Word Unlocked does not collect, store, or transmit any personal data. There are no accounts, no analytics, no advertising identifiers, and no crash reporting.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Network Access") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Recovery Version (RV)")
                        .font(.subheadline.weight(.semibold))
                    Text("When RV is selected, a live request is made to api.lsm.org (Living Stream Ministry) to fetch the current verse. The text is cached locally on your device only — nothing is sent to any server operated by this app.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 6) {
                    Text("English Standard Version (ESV)")
                        .font(.subheadline.weight(.semibold))
                    Text("When ESV is selected, verses are fetched live from api.esv.org (Crossway) as you read. Up to 500 recently-viewed verses are cached on your device only — nothing is sent to any server operated by this app.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 6) {
                    Text("KJV & WEB — fully offline")
                        .font(.subheadline.weight(.semibold))
                    Text("KJV and WEB text is stored entirely on your device. No network request is ever made when either of these translations is selected.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Local Storage") {
                Text("Your settings and the most recently loaded verse are stored locally in iOS UserDefaults, shared only between this app and its Lock Screen widget on the same device. Nothing is uploaded or shared externally.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
            }

            Section("Third-Party SDKs") {
                Text("This app contains no third-party SDKs of any kind — no analytics, no advertising, no crash reporting, no social login.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
            }

            Section("Contact") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Questions about privacy?")
                        .font(.subheadline)
                    Text("privacy@rippre.com")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Privacy Policy")
    }
}
