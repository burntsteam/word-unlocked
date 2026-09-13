import SwiftUI

struct MemorizationModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var searchText = ""
    @State private var searchResults: [Verse] = []
    @State private var searchedText = ""
    @State private var selectedVerseId: Int?
    @State private var durationDays = 7
    @State private var difficulty: MemorizationPlan.Difficulty = .medium

    private var fallbackVerse: Verse {
        VerseSelectionService.verse(for: settingsStore.currentSettings(), favorites: settingsStore.favorites)
    }

    private var searchTranslationCode: String {
        VerseSelectionService.referenceTranslationCode(for: settingsStore.selectedTranslation)
    }

    private var selectedVerse: Verse {
        if let selectedVerseId, let verse = DatabaseService.shared.verse(id: selectedVerseId) {
            return verse
        }
        return searchResults.first ?? fallbackVerse
    }

    var body: some View {
        Form {
            Section("Verse Search") {
                TextField("Search reference or words", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                if searchResults.isEmpty && !searchText.isEmpty && searchedText == searchText {
                    Text("No matching verses found in \(searchTranslationCode).")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(searchResults) { verse in
                        Button {
                            selectedVerseId = verse.id
                        } label: {
                            VerseSearchRow(
                                verse: verse,
                                isSelected: selectedVerseId == verse.id
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Section("Plan") {
                Picker("Duration", selection: $durationDays) {
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
            }

            if let plan = settingsStore.memorizationPlan {
                Section("Current Plan") {
                    LabeledContent("Verse ID", value: "\(plan.verseId)")
                    LabeledContent("Duration", value: "\(plan.durationDays) days")
                    LabeledContent("Difficulty", value: plan.difficulty.title)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phase \(plan.currentPhase.rawValue) of 5 - \(plan.currentPhase.title)")
                            .font(.headline)
                        ProgressView(value: Double(plan.currentPhase.rawValue), total: 5)
                    }
                }
            }

            Section("Selected Verse") {
                Text(selectedVerse.verseRef)
                    .font(.headline)
                Text(selectedVerse.text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section {
                Button {
                    let plan = MemorizationPlan(
                        id: selectedVerse.id,
                        verseId: selectedVerse.id,
                        startDate: Date(),
                        durationDays: durationDays,
                        difficulty: difficulty,
                        currentPhase: .fullVerse,
                        enabled: true
                    )
                    settingsStore.save(plan: plan)
                    settingsStore.activeMode = .memorization
                } label: {
                    Label("Start New Plan", systemImage: "brain.head.profile")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Memorization")
        .task(id: searchText) {
            await search(searchText)
        }
        .onAppear {
            if let plan = settingsStore.memorizationPlan {
                selectedVerseId = plan.verseId
                durationDays = plan.durationDays
                difficulty = plan.difficulty
            }
            if var plan = settingsStore.memorizationPlan {
                let calculated = MemorizationService.currentPhase(plan: plan)
                if plan.currentPhase != calculated {
                    plan.currentPhase = calculated
                    settingsStore.save(plan: plan)
                }
            }
        }
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
        searchResults = DatabaseService.shared.search(query: query, translationCode: searchTranslationCode, limit: 8)
        searchedText = text
    }
}

private struct VerseSearchRow: View {
    let verse: Verse
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(verse.verseRef)
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
            }
        }
    }
}
