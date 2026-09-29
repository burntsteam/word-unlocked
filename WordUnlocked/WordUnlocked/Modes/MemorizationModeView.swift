import SwiftUI

struct MemorizationModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var searchText = ""
    @State private var searchResults: [Verse] = []
    @State private var searchedText = ""
    @State private var selectedVerse: Verse?
    @State private var isTodaysVerse = false
    @State private var durationDays = 7
    @State private var difficulty: MemorizationPlan.Difficulty = .medium

    private var searchTranslationCode: String {
        VerseSelectionService.referenceTranslationCode(for: settingsStore.selectedTranslation)
    }

    var body: some View {
        Form {
            Section("Find a Verse") {
                TextField("Search reference or words", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                if searchResults.isEmpty && !searchText.isEmpty && searchedText == searchText {
                    Text("No matching verses found in \(searchTranslationCode).")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(searchResults) { verse in
                        let isSelected = selectedVerse?.id == verse.id
                        Button {
                            selectedVerse = verse
                            isTodaysVerse = false
                        } label: {
                            VerseSearchRow(verse: verse, isSelected: isSelected)
                        }
                        .buttonStyle(.plain)
                        .accessibilityAddTraits(isSelected ? .isSelected : [])
                    }
                }
            }

            Section {
                if let selectedVerse {
                    Text(selectedVerse.displayReference)
                        .font(.headline)
                    Text(selectedVerse.text)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Search above and tap a verse to choose it.")
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text(isTodaysVerse ? "Verse to Learn: Today's Verse" : "Verse to Learn")
            }

            Section {
                Picker("Length", selection: $durationDays) {
                    ForEach([3, 5, 7, 14], id: \.self) { days in
                        Text("\(days) days").tag(days)
                    }
                }
                .pickerStyle(.segmented)

                Picker("Difficulty", selection: $difficulty) {
                    ForEach(MemorizationPlan.Difficulty.allCases) { difficulty in
                        Text(difficulty.title).tag(difficulty)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Plan")
            } footer: {
                Text("Each day shows less of the verse: all of it, then some words blanked out, then first letters, then only the reference, then all of it again to review. Difficulty sets how many words are blanked.")
            }

            if let plan = settingsStore.memorizationPlan, let verse = DatabaseService.shared.verse(id: plan.verseId) {
                let phase = MemorizationService.phase(of: plan)
                Section("Current Plan") {
                    LabeledContent("Verse", value: verse.displayReference)
                    LabeledContent("Length", value: "\(plan.durationDays) days")
                    LabeledContent("Difficulty", value: plan.difficulty.title)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Step \(phase.rawValue) of 5: \(phase.title)")
                            .font(.headline)
                        ProgressView(value: Double(phase.rawValue), total: 5)
                            .accessibilityHidden(true)
                    }
                    .accessibilityElement(children: .combine)
                }
            }

            ModeSaveSection(
                mode: .memorization,
                isDisabled: selectedVerse == nil,
                footnote: "Saving a different verse, length or difficulty, or coming back from another mode, starts the plan again from today.",
                save: savePlan
            )
        }
        .navigationTitle("Memorization")
        .task(id: searchText) {
            await search(searchText)
        }
        .onAppear(perform: load)
    }

    private func load() {
        guard selectedVerse == nil else { return }
        if let plan = settingsStore.memorizationPlan {
            selectedVerse = DatabaseService.shared.verse(id: plan.verseId)
            durationDays = plan.durationDays
            difficulty = plan.difficulty
        } else {
            selectedVerse = VerseSelectionService.verse(for: settingsStore.currentSettings(), favorites: settingsStore.favorites)
            isTodaysVerse = true
        }
    }

    /// Starts a plan for the chosen verse, unless it is the plan already running unchanged.
    private func savePlan() {
        guard let verse = selectedVerse else { return }
        if let current = settingsStore.memorizationPlan,
           settingsStore.activeMode == .memorization,
           current.verseId == verse.id, current.durationDays == durationDays, current.difficulty == difficulty {
            return
        }
        settingsStore.save(plan: MemorizationPlan(verseId: verse.id, durationDays: durationDays, difficulty: difficulty))
    }

    // Debounced and limited to the rows shown, so typing never waits on a scan of
    // the whole translation.
    private func search(_ text: String) async {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            searchResults = []
            searchedText = text
            return
        }
        try? await Task.sleep(for: .milliseconds(250))
        guard !Task.isCancelled else { return }
        let code = searchTranslationCode
        let results = await Task.detached(priority: .userInitiated) {
            DatabaseService.shared.search(query: query, translationCode: code, limit: 8)
        }.value
        guard !Task.isCancelled else { return }
        searchResults = results
        searchedText = text
    }
}

private struct VerseSearchRow: View {
    let verse: Verse
    let isSelected: Bool

    var body: some View {
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

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.tint)
                    .accessibilityHidden(true)
            }
        }
        .contentShape(Rectangle())
    }
}
