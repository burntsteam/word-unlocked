import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsStore: SettingsStore

    private var translationName: String {
        TranslationsView.name(of: settingsStore.selectedTranslation)
    }

    var body: some View {
        Form {
            Section("Translation") {
                NavigationLink {
                    TranslationsView()
                } label: {
                    LabeledContent("Translation", value: translationName)
                }
            }

            Section("Active Mode") {
                // A pushed list, so a large text size wraps the mode's name instead of cutting it.
                Picker("Mode", selection: $settingsStore.activeMode) {
                    ForEach(WidgetSettings.VerseMode.allCases) { mode in
                        Label(mode.title, systemImage: mode.symbolName).tag(mode)
                    }
                }
                .pickerStyle(.navigationLink)
            }

            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 12) {
                        swatchButton(id: WidgetTheme.automaticId) {
                            AutomaticThemeSwatch(isSelected: settingsStore.selectedTheme == WidgetTheme.automaticId)
                                .frame(width: 164)
                        }
                        ForEach(ThemeService.themes) { theme in
                            swatchButton(id: theme.id) {
                                ThemeSwatch(theme: theme, isSelected: settingsStore.selectedTheme == theme.id)
                            }
                        }
                    }
                    .padding(.vertical, 6)
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 0))
            } header: {
                Text("Theme")
            } footer: {
                Text("Styles the Home Screen widget, Today and wallpapers. Lock Screen widgets take on your Lock Screen's look.")
            }

            Section {
                Picker("Strategy", selection: $settingsStore.longVerseStrategy) {
                    ForEach(WidgetSettings.LongVerseStrategy.allCases) { strategy in
                        Text(strategy.title).tag(strategy)
                    }
                }
            } header: {
                Text("Long Verse Handling")
            } footer: {
                Text(settingsStore.longVerseStrategy.summary)
            }

            Section {
                PrivacyRow(title: "No account required", systemImage: "person.crop.circle.badge.xmark")
                PrivacyRow(title: "No ads", systemImage: "nosign")
                PrivacyRow(title: "No tracking", systemImage: "location.slash")
                PrivacyRow(title: "No analytics", systemImage: "chart.bar.xaxis")
                PrivacyRow(title: "No notifications", systemImage: "bell.slash")
                PrivacyRow(title: "No cloud sync", systemImage: "icloud.slash")
                PrivacyRow(title: "No AI processing", systemImage: "cpu")
                PrivacyRow(title: "Five translations work offline", systemImage: "wifi.slash")
            } header: {
                Text("Privacy & Data")
            } footer: {
                Text("Nothing is sent to a server run by Word Unlocked. The ESV and the Recovery Version load from their publishers when you choose them.")
            }

            Section("Legal") {
                NavigationLink {
                    PrivacyPolicyView()
                } label: {
                    Label("Privacy Policy", systemImage: "hand.raised")
                }
                NavigationLink {
                    BibleLicensesView()
                } label: {
                    Label("Bible Translation Licenses", systemImage: "doc.text")
                }
            }

            Section("About") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Word Unlocked")
                        .font(.title3.weight(.bold))
                    Text("Version \(appVersion)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Put scripture on your Lock Screen. Private, with no account.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                }
                .padding(.vertical, 4)
                .accessibilityElement(children: .combine)
            }
        }
        .navigationTitle("Settings")
    }

    private var appVersion: String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
    }

    private func swatchButton<Content: View>(id: String, @ViewBuilder content: () -> Content) -> some View {
        let isSelected = settingsStore.selectedTheme == id
        return Button {
            settingsStore.selectedTheme = id
        } label: {
            content()
        }
        .buttonStyle(.plain)
        .accessibilityLabel(WidgetTheme.name(forId: id))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

private struct ThemeSwatch: View {
    let theme: WidgetTheme
    let isSelected: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\u{201C}For God so loved the world…\u{201D}")
                .font(.system(.caption2, design: theme.fontDesign))
                .foregroundStyle(theme.colors.text)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)

            Spacer(minLength: 0)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(theme.name)
                        .font(.system(.caption, design: theme.fontDesign).weight(.semibold))
                        .foregroundStyle(theme.colors.text)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("John 3:16")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(theme.colors.accent)
                }
                Spacer(minLength: 0)
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(theme.colors.accent)
                }
            }
        }
        .frame(width: 140)
        .frame(minHeight: 110)
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
        .scaleEffect(isSelected && !reduceMotion ? 1.03 : 1.0)
        .animation(reduceMotion ? nil : .spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
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
                PolicyEntry(
                    title: "No personal data is collected.",
                    text: "Word Unlocked has no accounts, analytics, advertising identifiers or crash reporting, and it sends nothing to a server run by this app."
                )
            }

            Section {
                PolicyEntry(
                    title: "KJV, WEB, BSB, ASV and LSV: fully offline",
                    text: "These five translations are stored entirely on your device. No network request is made while one of them is selected."
                )
                PolicyEntry(
                    title: "Recovery Version (RV)",
                    text: "When RV is selected, the verse you're reading is requested from api.lsm.org, run by Living Stream Ministry. Its text stays in memory while you read and is never stored on your device. Like any web request, it reaches LSM with your device's IP address and basic app and system details, such as the app and iOS versions."
                )
                PolicyEntry(
                    title: "English Standard Version (ESV)",
                    text: "When ESV is selected, the verses your mode shows next are downloaded from api.esv.org, run by Crossway, at most once every 48 hours, and up to 500 are kept on your device for the Lock Screen widget. The request lists those verses, so it reflects the mode or topic you chose, and like any web request it reaches Crossway with your device's IP address and basic app and system details."
                )
            } header: {
                Text("Network Access")
            } footer: {
                Text("Living Stream Ministry and Crossway handle these requests under their own privacy policies.")
            }

            Section("Local Storage") {
                Text("Your settings, favorites, memorization plan and downloaded ESV verses are stored on your device, shared only between the app and its widget. Like other app data, they are included in your device backups. This app uploads nothing.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
            }

            Section("Third-Party SDKs") {
                Text("This app contains no third-party SDKs of any kind: no analytics, no advertising, no crash reporting, no social login.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
            }

            Section("Contact") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Questions about privacy?")
                        .font(.subheadline)
                    Text(verbatim: "privacy@rippre.com")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Privacy Policy")
    }
}

private struct PolicyEntry: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.semibold))
            Text(text)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}
