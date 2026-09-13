import SwiftUI

struct DailyVerseModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var includeOldTestament = true
    @State private var includeNewTestament = true
    @State private var psalmsProverbsOnly = false
    @State private var updateInterval: WidgetSettings.RotationInterval = .daily

    private let intervalOptions: [WidgetSettings.RotationInterval] = [.daily, .everyEightHours]

    var body: some View {
        Form {
            Section("Translation") {
                Picker("Translation", selection: $settingsStore.selectedTranslation) {
                    ForEach(TranslationService.availableOffline) { translation in
                        Text("\(translation.code) - \(translation.displayName)").tag(translation.code)
                    }
                }
            }

            Section("Verse Scope") {
                Toggle("Include Old Testament", isOn: $includeOldTestament)
                Toggle("Include New Testament", isOn: $includeNewTestament)
                Toggle("Psalms and Proverbs Only", isOn: $psalmsProverbsOnly)

                Text("The widget uses this saved scope when choosing Daily Verse entries.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Update Interval") {
                Picker("Update", selection: $updateInterval) {
                    ForEach(intervalOptions) { interval in
                        Text(interval.title).tag(interval)
                    }
                }
                .pickerStyle(.segmented)

                Text("Every 8 Hours changes the verse at midnight, 8 AM and 4 PM.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section {
                Button {
                    savePreferences()
                    settingsStore.activeMode = .daily
                } label: {
                    Label("Set as Active Mode", systemImage: "checkmark.circle")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Daily Verse")
        .onAppear(perform: loadPreferences)
    }

    private func loadPreferences() {
        let defaults = AppGroupSettings.defaults
        if defaults.object(forKey: AppGroupSettings.Keys.dailyIncludeOldTestament) != nil {
            includeOldTestament = defaults.bool(forKey: AppGroupSettings.Keys.dailyIncludeOldTestament)
        }
        if defaults.object(forKey: AppGroupSettings.Keys.dailyIncludeNewTestament) != nil {
            includeNewTestament = defaults.bool(forKey: AppGroupSettings.Keys.dailyIncludeNewTestament)
        }
        if defaults.object(forKey: AppGroupSettings.Keys.dailyPsalmsProverbsOnly) != nil {
            psalmsProverbsOnly = defaults.bool(forKey: AppGroupSettings.Keys.dailyPsalmsProverbsOnly)
        }
        if let rawValue = defaults.string(forKey: AppGroupSettings.Keys.dailyUpdateInterval),
           let value = WidgetSettings.RotationInterval(rawValue: rawValue) {
            updateInterval = value
        }
    }

    private func savePreferences() {
        let defaults = AppGroupSettings.defaults
        defaults.set(includeOldTestament, forKey: AppGroupSettings.Keys.dailyIncludeOldTestament)
        defaults.set(includeNewTestament, forKey: AppGroupSettings.Keys.dailyIncludeNewTestament)
        defaults.set(psalmsProverbsOnly, forKey: AppGroupSettings.Keys.dailyPsalmsProverbsOnly)
        defaults.set(updateInterval.rawValue, forKey: AppGroupSettings.Keys.dailyUpdateInterval)
    }
}
