import SwiftUI

struct SearchView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var query = ""
    @State private var results: [Verse] = []
    /// The query `results` answer, so No Results waits until a search has finished.
    @State private var resultsQuery = ""
    @State private var selectedVerse: Verse?

    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Live translations have no verses on the device, so they search the text they stand in for.
    private var translationCode: String {
        VerseSelectionService.referenceTranslationCode(for: settingsStore.selectedTranslation)
    }

    var body: some View {
        List {
            if trimmedQuery.count < 2 {
                ContentUnavailableView(
                    "Search the Bible",
                    systemImage: "magnifyingglass",
                    description: Text("Type a reference such as \u{201C}Psalm 23\u{201D} or \u{201C}John 3:16\u{201D}, or words such as \u{201C}fear not\u{201D}.")
                )
            } else if results.isEmpty {
                if resultsQuery == trimmedQuery {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "magnifyingglass",
                        description: Text("Nothing in the \(TranslationsView.name(of: translationCode)) matches \u{201C}\(trimmedQuery)\u{201D}. Try a reference such as \u{201C}Romans 8:28\u{201D}, or other words.")
                    )
                }
            } else {
                Section {
                    ForEach(results) { verse in
                        SearchResultRow(
                            verse: verse,
                            isFavorite: settingsStore.isFavorite(verse),
                            open: { selectedVerse = verse },
                            toggleFavorite: { settingsStore.toggleFavorite(verse) }
                        )
                    }
                } header: {
                    Text(TranslationsView.name(of: translationCode))
                }
            }
        }
        .navigationTitle("Search")
        .searchable(text: $query, prompt: "Reference or word")
        .autocorrectionDisabled()
        .task(id: "\(translationCode)|\(trimmedQuery)") {
            await search()
        }
        .sheet(item: $selectedVerse) { verse in
            VerseDetailSheet(verse: verse)
                .environmentObject(settingsStore)
                .presentationDetents([.medium, .large])
        }
    }

    // Debounced and run off the main thread, so typing never waits on the database.
    private func search() async {
        let query = trimmedQuery
        let code = translationCode
        guard query.count >= 2 else {
            results = []
            resultsQuery = query
            return
        }
        try? await Task.sleep(for: .milliseconds(250))
        guard !Task.isCancelled else { return }
        let found = await Task.detached(priority: .userInitiated) {
            DatabaseService.shared.search(query: query, translationCode: code)
        }.value
        guard !Task.isCancelled else { return }
        results = found
        resultsQuery = query
    }
}

/// A result opens its verse; the heart beside it saves or removes it.
private struct SearchResultRow: View {
    let verse: Verse
    let isFavorite: Bool
    let open: () -> Void
    let toggleFavorite: () -> Void

    @ScaledMetric(relativeTo: .body) private var favoriteButtonSize: CGFloat = 44

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Button(action: open) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(verse.displayReference)
                        .font(.headline)
                    Text(verse.text)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(isFavorite ? Color.red : Color.secondary)
                    .frame(width: favoriteButtonSize, height: favoriteButtonSize)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.borderless)
            .accessibilityLabel(isFavorite ? "Remove \(verse.displayReference) from Favorites" : "Add \(verse.displayReference) to Favorites")
        }
        .padding(.vertical, 2)
    }
}

private struct VerseDetailSheet: View {
    let verse: Verse
    @EnvironmentObject private var settingsStore: SettingsStore
    @Environment(\.dismiss) private var dismiss

    private var isFavorite: Bool {
        settingsStore.isFavorite(verse)
    }

    private var isMemorizing: Bool {
        guard let plan = settingsStore.memorizationPlan else { return false }
        return settingsStore.activeMode == .memorization
            && plan.verseId == verse.id
            && settingsStore.memorizationPlanId == plan.id
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(verse.displayReference)
                        .font(.title2.weight(.semibold))
                        .accessibilityAddTraits(.isHeader)

                    Text(verse.text)
                        .font(.title3)
                        .lineSpacing(5)
                        .textSelection(.enabled)

                    Text(TranslationsView.name(of: verse.translationCode))
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.thinMaterial, in: Capsule())

                    VStack(spacing: 12) {
                        if isMemorizing {
                            Label {
                                Text("Memorizing This Verse")
                            } icon: {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 44)
                        } else {
                            Button(action: memorize) {
                                Label("Use for Memorization", systemImage: "brain.head.profile")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        Button {
                            settingsStore.toggleFavorite(verse)
                        } label: {
                            Label(isFavorite ? "Remove from Favorites" : "Add to Favorites", systemImage: isFavorite ? "heart.fill" : "heart")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)

                        ShareLink(item: verse.shareText) {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                    .controlSize(.large)

                    if isMemorizing {
                        Text("Today and your widgets take this verse one step a day, starting today.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    /// Starts a plan for this verse from today, keeping the current plan's length and difficulty.
    private func memorize() {
        let current = settingsStore.memorizationPlan
        settingsStore.save(plan: MemorizationPlan(
            verseId: verse.id,
            durationDays: current?.durationDays ?? 7,
            difficulty: current?.difficulty ?? .medium
        ))
        settingsStore.activeMode = .memorization
    }
}
