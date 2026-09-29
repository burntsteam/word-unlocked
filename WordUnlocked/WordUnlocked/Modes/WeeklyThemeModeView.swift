import SwiftUI

struct WeeklyThemeModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var plan = WeeklyPlan()
    @State private var autoRepeat = true
    @State private var topics: [Topic] = []
    @State private var books: [Book] = []
    @State private var customVerses: [Verse] = []
    @State private var previewVerses: [(dayNumber: Int, verse: Verse)] = []
    @State private var hasLoaded = false
    // What was saved when the sheet opened: saving restarts the plan only when it changed.
    @State private var savedPlan = WeeklyPlan()
    @State private var savedAutoRepeat = true

    private var chapterCount: Int {
        books.first { $0.id == plan.bookId }?.chapterCount ?? 1
    }

    var body: some View {
        Form {
            Section {
                Picker("Verses From", selection: $plan.source) {
                    ForEach(WeeklyPlan.Source.allCases) { source in
                        Text(source.title).tag(source)
                    }
                }
                .pickerStyle(.segmented)
            } footer: {
                Text("Each day of the week shows the next verse from your choice.")
            }

            switch plan.source {
            case .theme:
                themeSection
            case .chapter:
                Section("Chapter") {
                    bookPicker
                    Stepper("Chapter \(plan.chapter)", value: $plan.chapter, in: 1...max(chapterCount, 1))
                }
            case .book:
                Section("Book") {
                    bookPicker
                }
            case .custom:
                customSection
            }

            Section("This Week") {
                if previewVerses.isEmpty {
                    Text(plan.source == .custom ? "Add verses to see this week's plan." : "No verses found for this choice.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(previewVerses, id: \.dayNumber) { preview in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Day \(preview.dayNumber): \(preview.verse.displayReference)")
                                .font(.headline)
                            Text(preview.verse.text)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
            }

            Section {
                Toggle("Repeat every week", isOn: $autoRepeat)
            } footer: {
                Text("Repeat shows the same seven verses every week. Turn it off to move on to the next seven each week, starting over at the end.")
            }

            ModeSaveSection(
                mode: .weeklyTheme,
                isDisabled: plan.source == .custom && plan.customVerseIds.isEmpty,
                footnote: "Saving a new plan starts it this week.",
                save: start
            )
        }
        .navigationTitle("Weekly Plan")
        .onAppear(perform: load)
        .onChange(of: plan) { _, _ in
            loadPreview()
        }
        .onChange(of: plan.bookId) { _, _ in
            plan.chapter = min(plan.chapter, chapterCount)
        }
    }

    private var themeSection: some View {
        Section("Theme") {
            ForEach(topics, id: \.slug) { topic in
                let isSelected = plan.topicSlug == topic.slug
                Button {
                    plan.topicSlug = topic.slug
                } label: {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(topic.name)
                                .font(.headline)
                            Text(topic.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.tint)
                                .accessibilityHidden(true)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
    }

    private var bookPicker: some View {
        Picker("Book", selection: $plan.bookId) {
            Section("Old Testament") {
                ForEach(books.filter { $0.testament == .old }) { book in
                    Text(book.name).tag(book.id)
                }
            }

            Section("New Testament") {
                ForEach(books.filter { $0.testament == .new }) { book in
                    Text(book.name).tag(book.id)
                }
            }
        }
    }

    private var customSection: some View {
        Section {
            ForEach(customVerses) { verse in
                VStack(alignment: .leading, spacing: 4) {
                    Text(verse.displayReference)
                        .font(.headline)
                    Text(verse.text)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            .onDelete { offsets in
                plan.customVerseIds.remove(atOffsets: offsets)
            }

            NavigationLink {
                WeeklyVersePicker(verseIds: $plan.customVerseIds)
            } label: {
                Label("Add Verses", systemImage: "plus.circle")
            }
        } header: {
            Text("My Verses")
        } footer: {
            Text("One verse a day, in this order. Swipe left on a verse to remove it.")
        }
    }

    // Only on first appearance: coming back from Add Verses must keep unsaved picks.
    private func load() {
        guard !hasLoaded else { return }
        hasLoaded = true
        topics = DatabaseService.shared.topics()
        books = DatabaseService.shared.books()
        plan = WeeklyPlan(defaults: AppGroupSettings.defaults, topicSlug: settingsStore.topicSlug)
        if AppGroupSettings.defaults.object(forKey: AppGroupSettings.Keys.weeklyAutoRepeat) != nil {
            autoRepeat = AppGroupSettings.defaults.bool(forKey: AppGroupSettings.Keys.weeklyAutoRepeat)
        }
        savedPlan = plan
        savedAutoRepeat = autoRepeat
        loadPreview()
    }

    // The verse this plan shows on each day of the current week, as it would if started now.
    private func loadPreview() {
        customVerses = plan.customVerseIds.compactMap { DatabaseService.shared.verse(id: $0) }
        let settings = settingsStore.currentSettings()
        let calendar = Calendar.current
        guard let week = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
            previewVerses = []
            return
        }
        previewVerses = (0..<7).compactMap { offset -> (dayNumber: Int, verse: Verse)? in
            guard let day = calendar.date(byAdding: .day, value: offset, to: week.start),
                  let record = VerseSelectionService.weeklyRecord(plan, autoRepeat: true, startDate: nil, settings: settings, date: day) else {
                return nil
            }
            return (dayNumber: offset + 1, verse: Verse(record: record))
        }
    }

    /// Saves the plan. A new plan, or one saved while another mode is active, starts this
    /// week; saving the running plan unchanged keeps its place.
    private func start() {
        let isNewPlan = settingsStore.activeMode != .weeklyTheme || plan != savedPlan || autoRepeat != savedAutoRepeat
        plan.save(to: AppGroupSettings.defaults)
        AppGroupSettings.defaults.set(autoRepeat, forKey: AppGroupSettings.Keys.weeklyAutoRepeat)
        settingsStore.topicSlug = plan.topicSlug
        if isNewPlan {
            settingsStore.startPlan(for: .weeklyTheme)
        }
    }
}

/// Search, or pick from favorites, to build Weekly Plan's own list of verses.
private struct WeeklyVersePicker: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @Binding var verseIds: [Int]
    @State private var searchText = ""
    @State private var results: [Verse] = []
    @State private var favoriteVerses: [Verse] = []

    private var searchTranslationCode: String {
        VerseSelectionService.referenceTranslationCode(for: settingsStore.selectedTranslation)
    }

    var body: some View {
        List {
            Section("Search") {
                TextField("Search reference or words", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                ForEach(results) { verse in
                    row(verse)
                }
            }

            if !favoriteVerses.isEmpty {
                Section("Favorites") {
                    ForEach(favoriteVerses) { verse in
                        row(verse)
                    }
                }
            }
        }
        .navigationTitle("Add Verses")
        .onAppear {
            favoriteVerses = settingsStore.favorites.compactMap { DatabaseService.shared.verse(id: $0.verseId) }
        }
        .task(id: searchText) {
            // Debounced and limited to the rows shown, like Memorization's search.
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !query.isEmpty else {
                results = []
                return
            }
            try? await Task.sleep(for: .milliseconds(250))
            guard !Task.isCancelled else { return }
            let code = searchTranslationCode
            let found = await Task.detached(priority: .userInitiated) {
                DatabaseService.shared.search(query: query, translationCode: code, limit: 20)
            }.value
            guard !Task.isCancelled else { return }
            results = found
        }
    }

    private func row(_ verse: Verse) -> some View {
        let isAdded = verseIds.contains(verse.id)
        return Button {
            if isAdded {
                verseIds.removeAll { $0 == verse.id }
            } else {
                verseIds.append(verse.id)
            }
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(verse.displayReference)
                        .font(.headline)
                    Text(verse.text)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: isAdded ? "checkmark.circle.fill" : "plus.circle")
                    .foregroundStyle(.tint)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isAdded ? "Remove \(verse.displayReference)" : "Add \(verse.displayReference)")
    }
}
