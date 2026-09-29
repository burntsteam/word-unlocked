import SwiftUI

struct TodayView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var rvService = RVBibleService.shared
    @StateObject private var esvService = ESVBibleService.shared
    @ScaledMetric(relativeTo: .body) private var favoriteButtonSize: CGFloat = 44

    // Recomputed only when something that picks the verse changes (see refreshKey), not on
    // every redraw while a live translation loads.
    @State private var currentVerse: Verse
    @State private var lockScreenEntry: VerseEntry?
    @State private var showsWholeVerse = false
    // Moves on at each rotation slot, so the card changes with the widget while the app is open.
    @State private var clock = Date()

    init() {
        // Read from the App Group, which never writes, so the first frame is right before
        // the environment's store is available.
        let defaults = AppGroupSettings.defaults
        _currentVerse = State(initialValue: VerseSelectionService.verse(
            for: WidgetSettings(defaults: defaults),
            favorites: Favorite.saved(in: defaults)
        ))
    }

    /// Changes whenever the verse, or how the widget shows it, could change.
    private var refreshKey: String {
        let favorites = settingsStore.favorites.map { "\($0.verseId)\($0.translationCode)" }.joined(separator: ",")
        let plan = settingsStore.memorizationPlan.map { "\($0.id)|\($0.startDate)|\($0.durationDays)|\($0.difficulty)" } ?? ""
        return [
            settingsStore.activeMode.rawValue,
            settingsStore.selectedTranslation,
            settingsStore.longVerseStrategy.rawValue,
            settingsStore.topicSlug ?? "",
            settingsStore.chapterBookId.map(String.init) ?? "",
            settingsStore.chapterNumber.map(String.init) ?? "",
            settingsStore.memorizationPlanId.map(String.init) ?? "",
            String(settingsStore.showProgress),
            String(settingsStore.showTranslationCode),
            favorites,
            plan,
            String(esvService.verses.count),
            VerseSelectionService.selectionStamp(for: settingsStore.activeMode, date: clock)
        ].joined(separator: "|")
    }

    // Reruns the live request for another translation or verse, and each time the app comes
    // to the foreground, which is when a due ESV download can start.
    private var liveRequestKey: String {
        [settingsStore.selectedTranslation, currentVerse.verseRef, scenePhase == .active ? "active" : "inactive"]
            .joined(separator: "|")
    }

    private var theme: WidgetTheme {
        ThemeService.theme(id: settingsStore.selectedTheme, colorScheme: colorScheme)
    }

    // MARK: Which text shows, and in which translation

    private var isLiveTranslation: Bool {
        VerseSelectionService.liveTranslationCodes.contains(settingsStore.selectedTranslation)
    }

    /// Whether the verse on screen is the reference text a live translation replaces. A
    /// favorite keeps the translation it was saved in.
    private var standsInForLiveText: Bool {
        isLiveTranslation
            && currentVerse.translationCode == VerseSelectionService.referenceTranslationCode(for: settingsStore.selectedTranslation)
    }

    /// The live translation's text for this verse, when the app has it: ESV downloaded ahead
    /// of time, or a Recovery Version verse loaded into memory.
    private var liveText: String? {
        guard standsInForLiveText else { return nil }
        switch settingsStore.selectedTranslation {
        case "RV": return rvService.verse(for: currentVerse.verseRef)?.text
        case "ESV": return esvService.cachedVerse(for: currentVerse.verseRef)?.text
        default: return nil
        }
    }

    private var verseText: String {
        liveText ?? currentVerse.text
    }

    /// The translation of the text actually on screen.
    private var shownTranslation: String {
        liveText != nil ? settingsStore.selectedTranslation : currentVerse.translationCode
    }

    /// The attribution a live verse needs, or why the King James Version shows instead.
    private var liveNote: String? {
        guard standsInForLiveText else { return nil }
        switch settingsStore.selectedTranslation {
        case "RV":
            if let verse = rvService.verse(for: currentVerse.verseRef) {
                return "\(verse.attribution)\n\nRecovery Version text isn't stored on your device, so the Lock Screen widget and wallpapers use the King James Version."
            }
            if rvService.isFetching {
                return "Loading the Recovery Version…"
            }
            return "Showing the King James Version until the Recovery Version loads, which needs an internet connection."
        case "ESV":
            guard liveText == nil else { return nil }
            if esvService.isFetching {
                return "Downloading ESV verses…"
            }
            if let next = esvService.nextFetchDate, next > Date() {
                return "Showing the King James Version. ESV verses download at most once every 48 hours, so this one can download after \(next.formatted(date: .abbreviated, time: .shortened))."
            }
            return "Showing the King James Version until this ESV verse downloads, which needs an internet connection."
        default:
            return nil
        }
    }

    /// What a saved wallpaper shows. Recovery Version text can't be stored, so wallpapers use
    /// the King James text it stands in for.
    private var wallpaperVerse: (ref: String, text: String, translation: String) {
        settingsStore.selectedTranslation == "RV"
            ? (currentVerse.displayReference, currentVerse.text, currentVerse.translationCode)
            : (currentVerse.displayReference, verseText, shownTranslation)
    }

    // MARK: Memorization

    private var memorizationPlan: MemorizationPlan? {
        guard settingsStore.activeMode == .memorization,
              let plan = settingsStore.memorizationPlan,
              plan.id == settingsStore.memorizationPlanId else { return nil }
        return plan
    }

    /// The text the card shows: the verse, or the memorization step's version of it. Nil
    /// asks for the verse from memory.
    private var cardText: String? {
        guard let plan = memorizationPlan, !showsWholeVerse else { return verseText }
        return MemorizationService.text(verseText, in: MemorizationService.phase(of: plan), difficulty: plan.difficulty)
    }

    private var isHidingPartOfTheVerse: Bool {
        guard let plan = memorizationPlan else { return false }
        return [.partialBlank, .firstLetters, .referenceOnly].contains(MemorizationService.phase(of: plan))
    }

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                activeVerseCard
                if let liveNote {
                    Text(liveNote)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }
                widgetPreviewSection
                navigationActions
            }
            .padding()
        }
        .navigationTitle("Today")
        .onAppear(perform: refresh)
        .onChange(of: refreshKey) { _, _ in
            refresh()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                clock = Date()
            }
        }
        .task(id: refreshKey) {
            let interval = VerseSelectionService.rotationInterval(for: settingsStore.activeMode)
            guard let next = VerseSelectionService.slotStartDates(from: Date(), interval: interval, dayCount: 2).dropFirst().first else { return }
            try? await Task.sleep(for: .seconds(max(next.timeIntervalSinceNow, 1)))
            guard !Task.isCancelled else { return }
            clock = Date()
        }
        .task(id: liveRequestKey) {
            guard scenePhase == .active else { return }
            switch settingsStore.selectedTranslation {
            case "RV":
                if standsInForLiveText {
                    await rvService.fetch(reference: currentVerse.verseRef)
                }
            case "ESV":
                await esvService.refreshIfDue(settings: settingsStore.currentSettings(), favorites: settingsStore.favorites)
            default:
                break
            }
        }
    }

    private func refresh() {
        currentVerse = VerseSelectionService.verse(for: settingsStore.currentSettings(), favorites: settingsStore.favorites)
        lockScreenEntry = WidgetTimelineService.shared.entries(maxEntries: 1).first
        showsWholeVerse = false
    }

    private var activeVerseCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(currentVerse.displayReference)
                            .font(.title2.weight(.bold))
                            .padding(.trailing, favoriteButtonSize)
                        InfoRow(
                            mode: settingsStore.activeMode,
                            translation: shownTranslation,
                            themeName: WidgetTheme.name(forId: settingsStore.selectedTheme),
                            theme: theme
                        )
                    }

                    if let cardText {
                        Text(cardText)
                            .font(.system(.title3, design: theme.fontDesign).weight(.light))
                            .lineSpacing(6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("Recite it from memory, then tap Show Verse to check.")
                            .font(.system(.body, design: theme.fontDesign))
                            .foregroundStyle(theme.colors.secondaryText)
                    }

                    if let progress = progressText {
                        HStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 2, style: .continuous)
                                .fill(theme.colors.accent)
                                .frame(width: 3, height: 14)
                                .accessibilityHidden(true)
                            Text(progress)
                                .font(.footnote.weight(.medium))
                                .foregroundStyle(theme.colors.accent)
                        }
                    }
                }
                .accessibilityElement(children: .combine)

                favoriteButton
            }

            if isHidingPartOfTheVerse {
                Button(showsWholeVerse ? "Hide Verse" : "Show Verse") {
                    showsWholeVerse.toggle()
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(theme.colors.accent)
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.colors.background)
        .foregroundStyle(theme.colors.text)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
    }

    /// Chapter progress, or the memorization step, shown under the verse.
    private var progressText: String? {
        if let plan = memorizationPlan {
            let phase = MemorizationService.phase(of: plan)
            return "Step \(phase.rawValue) of 5 · \(phase.caption)"
        }
        guard settingsStore.activeMode == .chapter, let note = lockScreenEntry?.note else { return nil }
        return "\(currentVerse.bookName) \(currentVerse.chapter) · \(note)"
    }

    private var isFavorite: Bool {
        settingsStore.isFavorite(currentVerse)
    }

    private var favoriteButton: some View {
        Button {
            toggleFavorite()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.body.weight(.semibold))
                .foregroundStyle(isFavorite ? theme.colors.accent : theme.colors.secondaryText)
                .frame(width: favoriteButtonSize, height: favoriteButtonSize)
                .background(theme.colors.text.opacity(0.08), in: Circle())
        }
        .accessibilityLabel(isFavorite ? "Remove from Favorites" : "Add to Favorites")
    }

    private var widgetPreviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Lock Screen widget")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            if let lockScreenEntry {
                LockScreenWidgetPreview(entry: lockScreenEntry)
            }

            Text("Home Screen widget")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.top, 6)

            MiniWidgetPreview(
                ref: wallpaperVerse.ref,
                text: wallpaperVerse.text,
                theme: theme,
                translation: wallpaperVerse.translation
            )

            Text("Themes style the Home Screen widget and wallpapers; Lock Screen widgets take on your Lock Screen's look. Long verses on the Lock Screen: \(settingsStore.longVerseStrategy.summary)")
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
                    subtitle: "Recommended: scripture on your Lock Screen",
                    systemImage: "rectangle.inset.filled",
                    accentColor: theme.colors.accent
                )
            }

            NavigationLink {
                WallpaperExportView(
                    ref: wallpaperVerse.ref,
                    text: wallpaperVerse.text,
                    translation: wallpaperVerse.translation,
                    theme: theme
                )
            } label: {
                ActionArea(
                    title: "Set as Wallpaper",
                    subtitle: "A verse image that stays clear of the clock",
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
                    subtitle: "Current: \(WidgetTheme.name(forId: settingsStore.selectedTheme))",
                    systemImage: "paintpalette.fill",
                    accentColor: theme.colors.accent
                )
            }
        }
        .buttonStyle(.plain)
    }

    private func toggleFavorite() {
        if let favorite = settingsStore.favorites.first(where: { $0.verseId == currentVerse.id }) {
            settingsStore.removeFavorite(favorite)
        } else if settingsStore.selectedTranslation == "ESV", let text = liveText,
                  ESVBibleService.canSaveFavorite(bookId: currentVerse.bookId, favorites: settingsStore.favorites) {
            settingsStore.addFavorite(verseId: currentVerse.id, verseRef: currentVerse.displayReference, text: text, translationCode: "ESV")
        } else {
            // Recovery Version text can't be stored, and ESV text past Crossway's limits isn't
            // kept, so those favorites keep the King James text on screen underneath.
            settingsStore.addFavorite(verse: currentVerse)
        }
    }
}

/// The mode, translation and theme, in chips that wrap onto their own lines when the text is large.
private struct InfoRow: View {
    let mode: WidgetSettings.VerseMode
    let translation: String
    let themeName: String
    let theme: WidgetTheme

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 6) { chips }
            VStack(alignment: .leading, spacing: 6) { chips }
        }
    }

    @ViewBuilder
    private var chips: some View {
        Chip(text: mode.title, systemImage: mode.symbolName, theme: theme)
        Chip(text: translation, theme: theme)
        Chip(text: themeName, theme: theme)
    }
}

private struct Chip: View {
    let text: String
    var systemImage: String? = nil
    let theme: WidgetTheme

    var body: some View {
        HStack(spacing: 3) {
            if let icon = systemImage {
                Image(systemName: icon)
                    .font(.caption2)
                    .accessibilityHidden(true)
            }
            Text(text)
                .font(.caption.weight(.medium))
        }
        .foregroundStyle(theme.colors.text.opacity(0.78))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(theme.colors.text.opacity(0.08), in: Capsule())
    }
}

/// The Lock Screen widget as it will look: the widget's own view, in white on a dark screen.
struct LockScreenWidgetPreview: View {
    let entry: VerseEntry

    var body: some View {
        RectangularWidgetView(entry: entry)
            .frame(width: 172, height: 76)
            .foregroundStyle(.white)
            .environment(\.colorScheme, .dark)
            .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                LinearGradient(colors: [Color(hex: "#2B3A55"), Color(hex: "#111827")], startPoint: .top, endPoint: .bottom),
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
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
                    .foregroundStyle(theme.colors.secondaryText)
            }
            .padding(.bottom, 8)

            theme.colors.accent.opacity(0.2)
                .frame(height: 1)
                .padding(.bottom, 10)
                .accessibilityHidden(true)

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
        .accessibilityElement(children: .combine)
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
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.quaternary, lineWidth: 0.5)
        )
        .contentShape(Rectangle())
    }
}
