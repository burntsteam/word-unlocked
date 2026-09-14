import SwiftUI

struct TodayView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var rvService = RVBibleService.shared
    @StateObject private var esvService = ESVBibleService.shared

    // Drives verse reference selection (always KJV-backed for mode logic).
    // Held as @State so it is recomputed only when verse-selection-relevant
    // settings change (see verseSelectionKey), not on every body re-render
    // triggered by the live services publishing fetch progress.
    @State private var currentVerse: Verse

    init() {
        // Seed from the persisted App Group settings so the first render is
        // correct before the injected @EnvironmentObject becomes available.
        // .onAppear re-syncs with the live store immediately after.
        let store = SettingsStore()
        _currentVerse = State(
            initialValue: VerseSelectionService.verse(
                for: store.currentSettings(),
                favorites: store.favorites
            )
        )
    }

    // Recompute the verse from the live environment store.
    private func computeCurrentVerse() -> Verse {
        VerseSelectionService.verse(
            for: settingsStore.currentSettings(),
            favorites: settingsStore.favorites
        )
    }

    // Changes to any field below alter VerseSelectionService.verse() output.
    // Used as the .onChange key so currentVerse refreshes on real settings
    // changes (and at each new rotation slot) without recomputing on live-service publishes.
    private var verseSelectionKey: String {
        let favoriteIds = settingsStore.favorites.map { String($0.verseId) }.joined(separator: ",")
        return [
            settingsStore.activeMode.rawValue,
            settingsStore.selectedTranslation,
            settingsStore.longVerseStrategy.rawValue,
            settingsStore.topicSlug ?? "",
            settingsStore.chapterBookId.map(String.init) ?? "",
            settingsStore.chapterNumber.map(String.init) ?? "",
            settingsStore.memorizationPlanId.map(String.init) ?? "",
            favoriteIds,
            VerseSelectionService.selectionStamp(for: settingsStore.activeMode)
        ].joined(separator: "|")
    }

    // Reruns the live request for another translation or verse, and each time the app comes
    // to the foreground, which is when a due ESV download can start.
    private var liveRequestKey: String {
        [settingsStore.selectedTranslation, currentVerse.verseRef, scenePhase == .active ? "active" : "inactive"]
            .joined(separator: "|")
    }

    // Translations whose text comes from an API rather than the bundled database.
    private var isLiveTranslation: Bool {
        VerseSelectionService.liveTranslationCodes.contains(settingsStore.selectedTranslation)
    }

    // The live translation's text for the current reference, when the app has it: ESV
    // downloaded ahead of time, or a Recovery Version verse loaded into memory.
    private var liveVerse: (ref: String, text: String)? {
        switch settingsStore.selectedTranslation {
        case "RV":
            return rvService.verse(for: currentVerse.verseRef).map { ($0.ref, $0.text) }
        case "ESV":
            return esvService.cachedVerse(for: currentVerse.verseRef).map { ($0.ref, $0.text) }
        default:
            return nil
        }
    }

    private var isLiveFetching: Bool {
        switch settingsStore.selectedTranslation {
        case "RV": return rvService.isFetching
        case "ESV": return esvService.isFetching
        default: return false
        }
    }

    // Show the live verse when it matches the current reference; otherwise
    // currentVerse (King James-backed) drives the display so ref and text agree.
    private var displayRef: String {
        liveVerse?.ref ?? currentVerse.verseRef
    }

    private var displayText: String {
        liveVerse?.text ?? currentVerse.text
    }

    // The public-domain translation shown when a live translation's text isn't
    // available (offline or not yet fetched). currentVerse is King James-backed.
    private static let offlineFallbackCode = "KJV"

    // True when a live translation is selected but its text isn't on screen — the
    // bundled public-domain verse is showing instead. Excludes the in-flight
    // fetch window so the label doesn't flip while loading.
    private var liveFallbackActive: Bool {
        isLiveTranslation && !isLiveFetching && liveVerse == nil
    }

    // Translation label for the text actually on screen. Reports the
    // public-domain code when live text isn't available, so a King James verse
    // is never mislabeled.
    private var displayTranslation: String {
        liveFallbackActive ? Self.offlineFallbackCode : settingsStore.selectedTranslation
    }

    // What the Lock Screen widget and a saved wallpaper show. Recovery Version text can't be
    // stored, so those use the reference translation.
    private var storableVerse: (ref: String, text: String, translation: String) {
        settingsStore.selectedTranslation == "RV"
            ? (currentVerse.verseRef, currentVerse.text, Self.offlineFallbackCode)
            : (displayRef, displayText, displayTranslation)
    }

    // The attribution a live verse needs, or why the King James Version shows instead.
    private var liveTranslationNote: String? {
        switch settingsStore.selectedTranslation {
        case "RV":
            if let verse = rvService.verse(for: currentVerse.verseRef) {
                return "\(verse.attribution)\n\nRecovery Version text isn't stored on your device, so the Lock Screen widget and wallpapers use the King James Version."
            }
            return liveFallbackActive
                ? "Showing the King James Version until the Recovery Version loads, which needs an internet connection."
                : nil
        case "ESV":
            guard liveFallbackActive else { return nil }
            if let next = esvService.nextFetchDate, next > Date() {
                return "Showing the King James Version. ESV verses download at most once every 48 hours, so this one can download after \(next.formatted(date: .abbreviated, time: .shortened))."
            }
            return "Showing the King James Version until this ESV verse downloads, which needs an internet connection."
        default:
            return nil
        }
    }

    private var theme: WidgetTheme {
        ThemeService.theme(id: settingsStore.selectedTheme)
    }

    private var chapterProgressText: String? {
        guard settingsStore.activeMode == .chapter else { return nil }
        return "\(currentVerse.bookName) \(currentVerse.chapter) · verse \(currentVerse.verse)"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                activeVerseCard
                if let liveTranslationNote {
                    Text(liveTranslationNote)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }
                widgetPreviewSection
                navigationActions
                Text("Lock Screen widgets have limited space. Word Unlocked may use excerpts, segmented rotation, or references for longer verses based on your fitting setting.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }
            .padding()
        }
        .navigationTitle("Today")
        .onAppear {
            currentVerse = computeCurrentVerse()
        }
        .onChange(of: verseSelectionKey) { _, _ in
            currentVerse = computeCurrentVerse()
        }
        .task(id: liveRequestKey) {
            guard scenePhase == .active else { return }
            switch settingsStore.selectedTranslation {
            case "RV":
                await rvService.fetch(reference: currentVerse.verseRef)
            case "ESV":
                await esvService.refreshIfDue(settings: settingsStore.currentSettings(), favorites: settingsStore.favorites)
            default:
                break
            }
        }
    }

    private var activeVerseCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Text(displayRef)
                            .font(.title2.weight(.bold))
                        if isLiveFetching {
                            ProgressView().scaleEffect(0.7)
                        }
                    }
                    InfoRow(
                        modeTitle: settingsStore.activeMode.title,
                        translation: displayTranslation,
                        themeName: theme.name
                    )
                }

                Spacer()

                Button {
                    toggleFavorite()
                } label: {
                    Image(systemName: settingsStore.isFavorite(currentVerse) ? "heart.fill" : "heart")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(settingsStore.isFavorite(currentVerse) ? theme.colors.accent : theme.colors.text.opacity(0.5))
                        .frame(width: 40, height: 40)
                        .background(theme.colors.text.opacity(0.08))
                        .clipShape(Circle())
                }
                .accessibilityLabel(settingsStore.isFavorite(currentVerse) ? "Remove favorite" : "Add favorite")
            }

            Text(displayText)
                .font(.system(.title3, design: theme.fontDesign).weight(.light))
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let chapterProgressText {
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(theme.colors.accent)
                        .frame(width: 3, height: 14)
                    Text(chapterProgressText)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(theme.colors.accent)
                }
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.colors.background)
        .foregroundStyle(theme.colors.text)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
    }

    private var widgetPreviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Widget Preview")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            MiniWidgetPreview(
                ref: storableVerse.ref,
                text: storableVerse.text,
                theme: theme,
                translation: storableVerse.translation
            )

            Text("Long verse handling: \(settingsStore.longVerseStrategy.summary)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private var navigationActions: some View {
        VStack(spacing: 12) {
            NavigationLink {
                LockScreenWidgetGuideView()
            } label: {
                ActionArea(
                    title: "Add Lock Screen Widget",
                    subtitle: "Recommended — scripture on your Lock Screen",
                    systemImage: "rectangle.inset.filled",
                    accentColor: theme.colors.accent
                )
            }

            NavigationLink {
                WallpaperExportView(
                    ref: storableVerse.ref,
                    text: storableVerse.text,
                    translation: storableVerse.translation,
                    theme: theme
                )
            } label: {
                ActionArea(
                    title: "Set as Wallpaper",
                    subtitle: "Verse image that clears the clock",
                    systemImage: "photo.on.rectangle.angled",
                    accentColor: theme.colors.accent
                )
            }

            NavigationLink {
                ModesView()
            } label: {
                ActionArea(
                    title: "Change Mode",
                    subtitle: settingsStore.activeMode.summary,
                    systemImage: "rectangle.3.group.fill",
                    accentColor: theme.colors.accent
                )
            }

            NavigationLink {
                SettingsView()
            } label: {
                ActionArea(
                    title: "Change Theme",
                    subtitle: "Current: \(theme.name)",
                    systemImage: "paintpalette.fill",
                    accentColor: theme.colors.accent
                )
            }
        }
    }

    private func toggleFavorite() {
        if let favorite = settingsStore.favorites.first(where: { $0.verseId == currentVerse.id }) {
            settingsStore.removeFavorite(favorite)
        } else if settingsStore.selectedTranslation == "ESV", let live = liveVerse,
                  ESVBibleService.canSaveFavorite(bookId: currentVerse.bookId, favorites: settingsStore.favorites) {
            settingsStore.addFavorite(verseId: currentVerse.id, verseRef: live.ref, text: live.text, translationCode: "ESV")
        } else {
            // Recovery Version text can't be stored, and ESV text past Crossway's limits isn't
            // kept, so those favorites keep the reference translation's text.
            settingsStore.addFavorite(verse: currentVerse)
        }
    }
}

private struct InfoRow: View {
    let modeTitle: String
    let translation: String
    let themeName: String

    var body: some View {
        HStack(spacing: 6) {
            Chip(text: modeTitle, systemImage: "rectangle.3.group")
            Chip(text: translation)
            Chip(text: themeName)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.8)
    }
}

private struct Chip: View {
    let text: String
    var systemImage: String? = nil

    var body: some View {
        HStack(spacing: 3) {
            if let icon = systemImage {
                Image(systemName: icon)
                    .font(.caption2)
            }
            Text(text)
                .font(.caption.weight(.medium))
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.thinMaterial)
        .clipShape(Capsule())
    }
}

private struct MiniWidgetPreview: View {
    let ref: String
    let text: String
    let theme: WidgetTheme
    let translation: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text(ref)
                    .font(.system(.caption, design: theme.fontDesign).weight(.semibold))
                    .foregroundStyle(theme.colors.accent)
                Spacer()
                Text(translation)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(theme.colors.text.opacity(0.5))
            }
            .padding(.bottom, 8)

            theme.colors.accent.opacity(0.2)
                .frame(height: 1)
                .padding(.bottom, 10)

            Text(text)
                .font(.system(.footnote, design: theme.fontDesign).weight(.light))
                .lineLimit(4)
                .lineSpacing(3)
                .foregroundStyle(theme.colors.text)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .background(theme.colors.background)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(theme.colors.accent.opacity(0.25), lineWidth: 1)
        )
    }
}

private struct ActionArea: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let accentColor: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.quaternary, lineWidth: 0.5)
        )
    }
}
