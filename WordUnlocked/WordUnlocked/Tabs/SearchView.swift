import SwiftUI

struct SearchView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var query = ""
    @State private var results: [Verse] = []
    @State private var selectedVerse: Verse?
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        List {
            if query.count < 2 {
                ContentUnavailableView(
                    "Search",
                    systemImage: "magnifyingglass",
                    description: Text("Type at least 2 characters to search.")
                )
            } else if query.count >= 2 && results.isEmpty {
                ContentUnavailableView(
                    "No Results",
                    systemImage: "magnifyingglass",
                    description: Text("Try a reference like \"John 3\" or a word like \"fear\".")
                )
            } else {
                ForEach(results) { verse in
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(verse.verseRef)
                                .font(.headline)
                            Text(verse.text)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }

                        Spacer()

                        Button {
                            toggleFavorite(verse)
                        } label: {
                            Image(systemName: settingsStore.isFavorite(verse) ? "heart.fill" : "heart")
                                .foregroundStyle(settingsStore.isFavorite(verse) ? .red : .secondary)
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel(settingsStore.isFavorite(verse) ? "Remove favorite" : "Add favorite")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedVerse = verse
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Search")
        .searchable(text: $query, prompt: "Reference, keyword, or topic")
        .onChange(of: query) { _, newValue in
            performSearch(newValue)
        }
        .sheet(item: $selectedVerse) { verse in
            VerseDetailSheet(verse: verse, settingsStore: settingsStore)
                .presentationDetents([.medium, .large])
        }
    }

    private func performSearch(_ q: String) {
        let trimmed = q.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else {
            results = []
            return
        }
        results = DatabaseService.shared.search(
            query: trimmed,
            translationCode: VerseSelectionService.referenceTranslationCode(for: settingsStore.selectedTranslation)
        )
    }

    private func toggleFavorite(_ verse: Verse) {
        if let favorite = settingsStore.favorites.first(where: { $0.verseId == verse.id }) {
            settingsStore.removeFavorite(favorite)
        } else {
            settingsStore.addFavorite(verse: verse)
        }
    }
}

private struct VerseDetailSheet: View {
    let verse: Verse
    @ObservedObject var settingsStore: SettingsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(verse.verseRef)
                            .font(.title2.weight(.semibold))

                        Spacer()

                        Button {
                            toggleFavorite()
                        } label: {
                            Image(systemName: settingsStore.isFavorite(verse) ? "heart.fill" : "heart")
                                .foregroundStyle(settingsStore.isFavorite(verse) ? .red : .secondary)
                        }
                        .accessibilityLabel(settingsStore.isFavorite(verse) ? "Remove favorite" : "Add favorite")
                    }

                    Text(verse.text)
                        .font(.title3)
                        .lineSpacing(5)

                    Text(VerseSelectionService.referenceTranslationCode(for: settingsStore.selectedTranslation))
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.thinMaterial)
                        .clipShape(Capsule())

                    Button {
                        useForMemorization()
                    } label: {
                        Label("Use for Memorization", systemImage: "brain.head.profile")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .navigationTitle("Verse")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func toggleFavorite() {
        if let favorite = settingsStore.favorites.first(where: { $0.verseId == verse.id }) {
            settingsStore.removeFavorite(favorite)
        } else {
            settingsStore.addFavorite(verse: verse)
        }
    }

    private func useForMemorization() {
        let plan = MemorizationPlan(
            id: verse.id,
            verseId: verse.id,
            startDate: Date(),
            durationDays: 7,
            difficulty: .medium,
            currentPhase: .fullVerse,
            enabled: true
        )
        settingsStore.save(plan: plan)
        settingsStore.activeMode = .memorization
    }
}
