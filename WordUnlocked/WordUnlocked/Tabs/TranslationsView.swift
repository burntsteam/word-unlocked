import SwiftUI

struct TranslationsView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @StateObject private var rvService = RVBibleService.shared
    @StateObject private var esvService = ESVBibleService.shared

    /// A translation's full name, for the offline ones from the database.
    static func name(of code: String) -> String {
        switch code {
        case "RV": return "Recovery Version"
        case "ESV": return "English Standard Version"
        default: return TranslationService.allTranslations.first { $0.code == code }?.displayName ?? code
        }
    }

    var body: some View {
        List {
            Section("Translations") {
                ForEach(TranslationService.availableOffline.filter(\.enabled)) { translation in
                    TranslationRow(
                        code: translation.code,
                        name: translation.displayName,
                        detail: "Offline",
                        dotColor: .green,
                        isSelected: settingsStore.selectedTranslation == translation.code,
                        isBusy: false
                    ) {
                        settingsStore.selectedTranslation = translation.code
                    }
                }

                // Recovery Version: live API only; LSM's terms forbid storing the text.
                TranslationRow(
                    code: "RV",
                    name: Self.name(of: "RV"),
                    detail: "Needs internet · not stored",
                    dotColor: .blue,
                    isSelected: settingsStore.selectedTranslation == "RV",
                    isBusy: rvService.isFetching,
                    error: settingsStore.selectedTranslation == "RV" ? rvService.error : nil
                ) {
                    settingsStore.selectedTranslation = "RV"
                }

                // English Standard Version: downloaded ahead, up to 500 verses on the device.
                // Hidden when ESV_API_KEY is unset: without it nothing can download.
                if ESVBibleService.isConfigured {
                    TranslationRow(
                        code: "ESV",
                        name: Self.name(of: "ESV"),
                        detail: esvService.verses.isEmpty
                            ? "Needs internet"
                            : "\(esvService.verses.count) verse\(esvService.verses.count == 1 ? "" : "s") on this device",
                        dotColor: .purple,
                        isSelected: settingsStore.selectedTranslation == "ESV",
                        isBusy: esvService.isFetching,
                        error: settingsStore.selectedTranslation == "ESV" ? esvService.error : nil
                    ) {
                        settingsStore.selectedTranslation = "ESV"
                        Task {
                            await esvService.refreshIfDue(settings: settingsStore.currentSettings(), favorites: settingsStore.favorites)
                        }
                    }
                }
            }

            if settingsStore.selectedTranslation == "RV" {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("The Recovery Version loads from Living Stream Ministry's API while you read. LSM's terms don't allow storing its text on your device, so the Lock Screen widget and wallpapers show the King James Version.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Text(RVBibleService.defaultAttribution)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("About the Recovery Version")
                }
            }

            if settingsStore.selectedTranslation == "ESV" {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Word Unlocked keeps up to 500 ESV verses on your device, the ones your mode shows next, so the Lock Screen widget works offline. Crossway's terms allow no more than that, or half of any book. New verses download from api.esv.org at most once every 48 hours.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Text("Scripture quotations are from the ESV® Bible, © 2001 by Crossway. Used by permission. All rights reserved.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Link("Learn more at esv.org", destination: URL(string: "https://www.esv.org")!)
                            .font(.caption)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("About the English Standard Version")
                }
            }

            Section("Attribution") {
                NavigationLink {
                    BibleLicensesView()
                } label: {
                    Label("Bible Translation Licenses", systemImage: "doc.text")
                }
            }
        }
        .navigationTitle("Translations")
    }
}

/// One translation. The whole row selects it.
private struct TranslationRow: View {
    let code: String
    let name: String
    let detail: String
    let dotColor: Color
    let isSelected: Bool
    let isBusy: Bool
    var error: String?
    let select: () -> Void

    var body: some View {
        Button(action: select) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(dotColor)
                        .frame(width: 10, height: 10)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(code).font(.headline)
                        Text(name).font(.subheadline).foregroundStyle(.secondary)
                        Text(detail).font(.caption).foregroundStyle(.secondary)
                    }

                    Spacer()

                    if isBusy {
                        ProgressView()
                            .accessibilityLabel("Loading")
                    } else if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.tint)
                            .accessibilityHidden(true)
                    }
                }

                if let error {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct BibleLicensesView: View {
    var body: some View {
        List {
            Section("Offline Translations") {
                LicenseRow(
                    title: "King James Version",
                    code: "KJV",
                    license: "Public domain in the United States.",
                    attribution: "King James Version text is included for offline use."
                )
                LicenseRow(
                    title: "World English Bible",
                    code: "WEB",
                    license: "Public Domain. No copyright.",
                    attribution: "World English Bible (WEB) is dedicated to the public domain by its translators. Free to use without restriction."
                )
                LicenseRow(
                    title: "Berean Standard Bible",
                    code: "BSB",
                    license: "Public Domain. No copyright.",
                    attribution: "The Holy Bible, Berean Standard Bible (BSB), produced in cooperation with Bible Hub, Discovery Bible, unfoldingWord, and the Berean Bible Translation Committee. Dedicated to the public domain."
                )
                LicenseRow(
                    title: "American Standard Version",
                    code: "ASV",
                    license: "Public domain (1901).",
                    attribution: "American Standard Version (ASV), 1901. Public domain. Free to use without restriction."
                )
                LicenseRow(
                    title: "Literal Standard Version",
                    code: "LSV",
                    license: "© 2020 Covenant Press. Licensed under CC BY-SA 4.0.",
                    attribution: "The Holy Bible, Literal Standard Version (LSV), © 2020 Covenant Press and the Covenant Christian Coalition. Changes: footnotes and section headings are removed, and long verses may be shortened or split to fit the widget.",
                    links: [
                        ("Creative Commons BY-SA 4.0", "https://creativecommons.org/licenses/by-sa/4.0/"),
                        ("LSV source text", "https://github.com/BibleCorps/ENG-B-LSV2022-CC-CCC")
                    ]
                )
            }

            Section("Live API Translations") {
                LicenseRow(
                    title: "Recovery Version",
                    code: "RV",
                    license: "© 2025 Living Stream Ministry. All rights reserved.",
                    attribution: "\(RVBibleService.defaultAttribution). Loaded from the LSM API while you read; LSM's terms don't allow storing the text on your device."
                )
                LicenseRow(
                    title: "English Standard Version",
                    code: "ESV",
                    license: "© 2001 by Crossway. All rights reserved.",
                    attribution: "Scripture quotations are from the ESV® Bible (The Holy Bible, English Standard Version®), © 2001 by Crossway, a publishing ministry of Good News Publishers. Used by permission. Up to 500 verses, and never more than half of a book, are kept on the device as the ESV API terms allow; the full text is not stored.",
                    links: [("English Standard Version at esv.org", "https://www.esv.org")]
                )
            }
        }
        .navigationTitle("Licenses")
    }
}

private struct LicenseRow: View {
    let title: String
    let code: String
    let license: String
    let attribution: String
    var links: [(title: String, url: String)] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                Text(code)
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                    .accessibilityHidden(true)
            }
            Text(license)
            Text(attribution).foregroundStyle(.secondary)
            ForEach(links, id: \.url) { link in
                if let url = URL(string: link.url) {
                    Link(link.title, destination: url)
                }
            }
        }
        .font(.subheadline)
    }
}
