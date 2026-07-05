import SwiftUI

struct FavoritesModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var rotationSpeed: FavoritesRotationSpeed = .daily
    @State private var shuffleFavorites = true
    @State private var excludeLongVerses = false

    var body: some View {
        Form {
            Section("Favorites Count") {
                LabeledContent("Saved Verses", value: "\(settingsStore.favorites.count)")

                if settingsStore.favorites.isEmpty {
                    Text("Save at least one verse before using Favorites mode.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Rotation") {
                Picker("Speed", selection: $rotationSpeed) {
                    ForEach(FavoritesRotationSpeed.allCases) { speed in
                        Text(speed.title).tag(speed)
                    }
                }

                Toggle("Shuffle", isOn: $shuffleFavorites)
                Toggle("Exclude Long Verses", isOn: $excludeLongVerses)

                Text("Favorites mode uses these saved choices when selecting verses for the widget timeline.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section {
                Button {
                    savePreferences()
                    if excludeLongVerses {
                        settingsStore.longVerseStrategy = .excludeLong
                    } else if settingsStore.longVerseStrategy == .excludeLong {
                        settingsStore.longVerseStrategy = .smartFit
                    }
                    settingsStore.activeMode = .favorites
                } label: {
                    Label("Set as Active Mode", systemImage: "checkmark.circle")
                        .frame(maxWidth: .infinity)
                }
                .disabled(settingsStore.favorites.isEmpty)
            }

            Section("Saved Verses") {
                if settingsStore.favorites.isEmpty {
                    ContentUnavailableView("No Favorites", systemImage: "heart")
                } else {
                    ForEach(settingsStore.favorites) { favorite in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(favorite.verseRef)
                                .font(.headline)
                            Text(favorite.text)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorites Mode")
        .onAppear(perform: loadPreferences)
    }

    private func loadPreferences() {
        let defaults = AppGroupSettings.defaults
        if let rawValue = defaults.string(forKey: AppGroupSettings.Keys.favoritesRotationSpeed),
           let value = FavoritesRotationSpeed(rawValue: rawValue) {
            rotationSpeed = value
        }
        if defaults.object(forKey: AppGroupSettings.Keys.favoritesShuffle) != nil {
            shuffleFavorites = defaults.bool(forKey: AppGroupSettings.Keys.favoritesShuffle)
        }
        if defaults.object(forKey: AppGroupSettings.Keys.favoritesExcludeLong) != nil {
            excludeLongVerses = defaults.bool(forKey: AppGroupSettings.Keys.favoritesExcludeLong)
        } else {
            excludeLongVerses = settingsStore.longVerseStrategy == .excludeLong
        }
    }

    private func savePreferences() {
        let defaults = AppGroupSettings.defaults
        defaults.set(rotationSpeed.rawValue, forKey: AppGroupSettings.Keys.favoritesRotationSpeed)
        defaults.set(shuffleFavorites, forKey: AppGroupSettings.Keys.favoritesShuffle)
        defaults.set(excludeLongVerses, forKey: AppGroupSettings.Keys.favoritesExcludeLong)
    }
}

private enum FavoritesRotationSpeed: String, CaseIterable, Identifiable {
    case daily
    case everyTwelveHours
    case everySixHours

    var id: String { rawValue }

    var title: String {
        switch self {
        case .daily: "Daily"
        case .everyTwelveHours: "Every 12 Hours"
        case .everySixHours: "Every 6 Hours"
        }
    }
}
