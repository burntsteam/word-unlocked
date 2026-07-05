import SwiftUI

struct TranslationsView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @StateObject private var rvService = RVBibleService.shared
    @StateObject private var esvService = ESVBibleService.shared

    var body: some View {
        List {
            Section("Translations") {
                // KJV — always offline
                Button {
                    settingsStore.selectedTranslation = "KJV"
                } label: {
                    TranslationRow(
                        code: "KJV",
                        name: "King James Version",
                        badge: "Offline",
                        badgeColor: .green,
                        isSelected: settingsStore.selectedTranslation == "KJV"
                    )
                }
                .buttonStyle(.plain)

                // WEB — always offline
                Button {
                    settingsStore.selectedTranslation = "WEB"
                } label: {
                    TranslationRow(
                        code: "WEB",
                        name: "World English Bible",
                        badge: "Offline",
                        badgeColor: .green,
                        isSelected: settingsStore.selectedTranslation == "WEB"
                    )
                }
                .buttonStyle(.plain)

                // BSB — modern, public domain, always offline
                Button {
                    settingsStore.selectedTranslation = "BSB"
                } label: {
                    TranslationRow(
                        code: "BSB",
                        name: "Berean Standard Bible",
                        badge: "Offline",
                        badgeColor: .green,
                        isSelected: settingsStore.selectedTranslation == "BSB"
                    )
                }
                .buttonStyle(.plain)

                // ASV — classic, public domain, always offline
                Button {
                    settingsStore.selectedTranslation = "ASV"
                } label: {
                    TranslationRow(
                        code: "ASV",
                        name: "American Standard Version",
                        badge: "Offline",
                        badgeColor: .green,
                        isSelected: settingsStore.selectedTranslation == "ASV"
                    )
                }
                .buttonStyle(.plain)

                // LSV — literal, CC BY-SA, always offline
                Button {
                    settingsStore.selectedTranslation = "LSV"
                } label: {
                    TranslationRow(
                        code: "LSV",
                        name: "Literal Standard Version",
                        badge: "Offline",
                        badgeColor: .green,
                        isSelected: settingsStore.selectedTranslation == "LSV"
                    )
                }
                .buttonStyle(.plain)

                // Recovery Version — live API only, no offline storage
                RVTranslationRow(
                    isSelected: settingsStore.selectedTranslation == "RV",
                    cachedVerse: rvService.cachedVerse,
                    isFetching: rvService.isFetching,
                    error: rvService.error
                ) {
                    settingsStore.selectedTranslation = "RV"
                }

                // English Standard Version — live API, ≤500-verse offline cache
                ESVTranslationRow(
                    isSelected: settingsStore.selectedTranslation == "ESV",
                    cachedCount: esvService.cache.count,
                    isFetching: esvService.isFetching,
                    error: esvService.error
                ) {
                    settingsStore.selectedTranslation = "ESV"
                }
            }

            if settingsStore.selectedTranslation == "RV" {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Recovery Version is fetched live from the LSM API each time you open the app. The most recently loaded verse appears on your Lock Screen widget.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Text("© Living Stream Ministry — used by permission.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("About Recovery Version")
                }
            }

            if settingsStore.selectedTranslation == "ESV" {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("English Standard Version is fetched live from the Crossway ESV API (api.esv.org) as you read. Up to 500 recently-viewed verses are saved for offline use; others load when you're online.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Text("Scripture quotations are from the ESV® Bible, © 2001 by Crossway. Used by permission. All rights reserved.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                        Link("Learn more at esv.org", destination: URL(string: "https://www.esv.org")!)
                            .font(.caption)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("About English Standard Version")
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

private struct TranslationRow: View {
    let code: String
    let name: String
    let badge: String
    let badgeColor: Color
    let isSelected: Bool

    var body: some View {
        HStack {
            Circle()
                .fill(badgeColor)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 4) {
                Text(code).font(.headline)
                Text(name).font(.subheadline).foregroundStyle(.secondary)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(.tint)
            } else {
                Text(badge)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(badgeColor)
            }
        }
    }
}

private struct RVTranslationRow: View {
    let isSelected: Bool
    let cachedVerse: RVCachedVerse?
    let isFetching: Bool
    let error: String?
    let onSelect: () -> Void

    var body: some View {
        HStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 4) {
                Text("RV").font(.headline)
                Text("Recovery Version").font(.subheadline).foregroundStyle(.secondary)
                if let verse = cachedVerse {
                    Text(verse.ref)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Label("Requires internet", systemImage: "wifi")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if isFetching {
                ProgressView().scaleEffect(0.8)
            } else if isSelected {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(.tint)
            } else {
                Button("Select", action: onSelect)
                    .font(.caption.weight(.semibold))
                    .buttonStyle(.bordered)
                    .controlSize(.small)
            }
        }

        if let error {
            Text(error)
                .font(.caption)
                .foregroundStyle(.red)
                .padding(.top, 2)
        }
    }
}

private struct ESVTranslationRow: View {
    let isSelected: Bool
    let cachedCount: Int
    let isFetching: Bool
    let error: String?
    let onSelect: () -> Void

    var body: some View {
        HStack {
            Circle()
                .fill(Color.purple)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 4) {
                Text("ESV").font(.headline)
                Text("English Standard Version").font(.subheadline).foregroundStyle(.secondary)
                if cachedCount > 0 {
                    Text("\(cachedCount) verse\(cachedCount == 1 ? "" : "s") saved offline")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Label("Requires internet", systemImage: "wifi")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if isFetching {
                ProgressView().scaleEffect(0.8)
            } else if isSelected {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(.tint)
            } else {
                Button("Select", action: onSelect)
                    .font(.caption.weight(.semibold))
                    .buttonStyle(.bordered)
                    .controlSize(.small)
            }
        }

        if let error {
            Text(error)
                .font(.caption)
                .foregroundStyle(.red)
                .padding(.top, 2)
        }
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
                    license: "© 2020 Covenant Press. CC BY-SA 4.0.",
                    attribution: "The Holy Bible, Literal Standard Version (LSV), © 2020 Covenant Press and the Covenant Christian Coalition. Licensed under Creative Commons Attribution-ShareAlike; bundled for offline use with attribution."
                )
            }

            Section("Live API Translations") {
                LicenseRow(
                    title: "Recovery Version",
                    code: "RV",
                    license: "© 2022 Living Stream Ministry. All rights reserved.",
                    attribution: "Recovery Version text is served live from the LSM API by permission of Living Stream Ministry. Text is not stored offline."
                )
                LicenseRow(
                    title: "English Standard Version",
                    code: "ESV",
                    license: "© 2001 by Crossway. All rights reserved.",
                    attribution: "Scripture quotations are from the ESV® Bible (The Holy Bible, English Standard Version®), © 2001 by Crossway, a publishing ministry of Good News Publishers. Used by permission. Up to 500 verses are cached locally per the ESV API license; the full text is not stored offline."
                )
                Link("English Standard Version — esv.org", destination: URL(string: "https://www.esv.org")!)
                    .font(.subheadline)
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
            }
            Text(license)
            Text(attribution).foregroundStyle(.secondary)
        }
        .font(.subheadline)
    }
}
