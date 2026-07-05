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
                    description: Text("Save verses from Today to rotate them on the Lock Screen.")
                )
            } else {
                ForEach(settingsStore.favorites) { favorite in
                    Button {
                        selectedFavorite = favorite
                    } label: {
                        FavoriteRow(favorite: favorite)
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: settingsStore.removeFavorites)
            }
        }
        .navigationTitle("Favorites")
        .sheet(item: $selectedFavorite) { favorite in
            FavoriteDetailView(favorite: favorite)
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
                    .background(.thinMaterial)
                    .clipShape(Capsule())
            }

            Text(favorite.text.prefixText(limit: 80))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

private struct FavoriteDetailView: View {
    let favorite: Favorite

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(favorite.verseRef)
                        .font(.title2.weight(.semibold))
                    Text(favorite.text)
                        .font(.title3)
                        .lineSpacing(5)
                    Text("Saved \(favorite.addedAt.formatted(date: .abbreviated, time: .omitted))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text(favorite.translationCode)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .navigationTitle("Favorite")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private extension String {
    func prefixText(limit: Int) -> String {
        guard count > limit else { return self }
        let endIndex = index(startIndex, offsetBy: limit)
        return String(self[..<endIndex]) + "..."
    }
}
