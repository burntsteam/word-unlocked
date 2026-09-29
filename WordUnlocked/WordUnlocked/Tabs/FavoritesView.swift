import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var selectedFavorite: Favorite?

    var body: some View {
        List {
            if settingsStore.favorites.isEmpty {
                ContentUnavailableView(
                    "No Favorites",
                    systemImage: "heart",
                    description: Text("Tap the heart on Today or in Search to save a verse. Favorites mode rotates them on your Lock Screen.")
                )
            } else {
                Section {
                    ForEach(settingsStore.favorites) { favorite in
                        Button {
                            selectedFavorite = favorite
                        } label: {
                            FavoriteRow(favorite: favorite)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: settingsStore.removeFavorites)
                    .onMove(perform: settingsStore.moveFavorites)
                } footer: {
                    Text("Favorites mode shows them in this order unless Shuffle is on.")
                }
            }
        }
        .navigationTitle("Favorites")
        .toolbar {
            if !settingsStore.favorites.isEmpty {
                EditButton()
            }
        }
        .sheet(item: $selectedFavorite) { favorite in
            FavoriteDetailView(favorite: favorite)
                .environmentObject(settingsStore)
                .presentationDetents([.medium, .large])
        }
    }
}

private struct FavoriteRow: View {
    let favorite: Favorite

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(favorite.verseRef)
                    .font(.headline.weight(.bold))
                Spacer()
                Text(favorite.translationCode)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.thinMaterial, in: Capsule())
            }

            Text(favorite.text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

private struct FavoriteDetailView: View {
    let favorite: Favorite
    @EnvironmentObject private var settingsStore: SettingsStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(favorite.verseRef)
                        .font(.title2.weight(.semibold))
                        .accessibilityAddTraits(.isHeader)

                    Text(favorite.text)
                        .font(.title3)
                        .lineSpacing(5)
                        .textSelection(.enabled)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(TranslationsView.name(of: favorite.translationCode))
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.thinMaterial, in: Capsule())
                        Text("Saved \(favorite.addedAt.formatted(date: .abbreviated, time: .omitted))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 12) {
                        ShareLink(item: Verse.shareText(favorite.text, reference: favorite.verseRef, translationCode: favorite.translationCode)) {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)

                        Button(role: .destructive) {
                            settingsStore.removeFavorite(favorite)
                            dismiss()
                        } label: {
                            Label("Remove from Favorites", systemImage: "heart.slash")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                    .controlSize(.large)
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
}
