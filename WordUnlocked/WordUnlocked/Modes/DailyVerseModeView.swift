import SwiftUI

struct DailyVerseModeView: View {
    @State private var includeOldTestament = true
    @State private var includeNewTestament = true
    @State private var psalmsProverbsOnly = false
    @State private var updateInterval: WidgetSettings.RotationInterval = .daily

    private let intervalOptions: [WidgetSettings.RotationInterval] = [.daily, .everyEightHours]

    var body: some View {
        Form {
            Section {
                // At least one testament stays on, and Psalms and Proverbs Only takes over from both.
                Toggle("Include Old Testament", isOn: $includeOldTestament)
                    .disabled(psalmsProverbsOnly || !includeNewTestament)
                Toggle("Include New Testament", isOn: $includeNewTestament)
                    .disabled(psalmsProverbsOnly || !includeOldTestament)
                Toggle("Psalms and Proverbs Only", isOn: $psalmsProverbsOnly)
            } header: {
                Text("Verse Scope")
            } footer: {
                Text("Daily Verse picks from well-known verses in the part of the Bible you choose, in a new order each time through.")
            }

            Section {
                Picker("Update", selection: $updateInterval) {
                    ForEach(intervalOptions) { interval in
                        Text(interval.title).tag(interval)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Update Interval")
            } footer: {
                Text("Every 8 Hours changes the verse at midnight, 8 AM and 4 PM.")
            }

            ModeSaveSection(mode: .daily, save: savePreferences)
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
        if !includeOldTestament && !includeNewTestament {
            includeOldTestament = true
            includeNewTestament = true
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
