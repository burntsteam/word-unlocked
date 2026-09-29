import SwiftUI

struct FavoritesModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var rotationSpeed: WidgetSettings.RotationInterval = .daily
    @State private var shuffleFavorites = true
    @State private var excludeLongVerses = false

    private let speedOptions: [WidgetSettings.RotationInterval] = [.daily, .everyTwelveHours, .everySixHours]

    var body: some View {
        Form {
            Section {
                LabeledContent("Saved Verses", value: "\(settingsStore.favorites.count)")
            } header: {
                Text("Favorites")
            } footer: {
                if settingsStore.favorites.isEmpty {
                    Text("Save at least one verse, from Today or Search, before using Favorites mode.")
                }
            }

            Section {
                Picker("Speed", selection: $rotationSpeed) {
                    ForEach(speedOptions) { speed in
                        Text(speed.title).tag(speed)
                    }
                }

                Toggle("Shuffle", isOn: $shuffleFavorites)
                Toggle("Exclude Long Verses", isOn: $excludeLongVerses)
            } header: {
                Text("Rotation")
            } footer: {
                Text("Shuffle shows every favorite once before any comes back, in a new order each time through.")
            }

            ModeSaveSection(mode: .favorites, isDisabled: settingsStore.favorites.isEmpty, save: savePreferences)

            if !settingsStore.favorites.isEmpty {
                Section("Saved Verses") {
                    ForEach(settingsStore.favorites) { favorite in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(favorite.verseRef)
                                .font(.headline)
                            Text(favorite.text)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .accessibilityElement(children: .combine)
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
           let value = WidgetSettings.RotationInterval(rawValue: rawValue) {
            rotationSpeed = value
        }
        if defaults.object(forKey: AppGroupSettings.Keys.favoritesShuffle) != nil {
            shuffleFavorites = defaults.bool(forKey: AppGroupSettings.Keys.favoritesShuffle)
        }
        if defaults.object(forKey: AppGroupSettings.Keys.favoritesExcludeLong) != nil {
            excludeLongVerses = defaults.bool(forKey: AppGroupSettings.Keys.favoritesExcludeLong)
        }
    }

    private func savePreferences() {
        let defaults = AppGroupSettings.defaults
        defaults.set(rotationSpeed.rawValue, forKey: AppGroupSettings.Keys.favoritesRotationSpeed)
        defaults.set(shuffleFavorites, forKey: AppGroupSettings.Keys.favoritesShuffle)
        defaults.set(excludeLongVerses, forKey: AppGroupSettings.Keys.favoritesExcludeLong)
    }
}
