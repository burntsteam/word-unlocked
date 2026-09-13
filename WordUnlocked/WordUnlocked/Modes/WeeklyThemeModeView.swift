import SwiftUI

struct WeeklyThemeModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var topics: [Topic] = []
    @State private var selectedPlanID = "hope"
    @State private var autoRepeat = true
    @State private var previewVerses: [(dayNumber: Int, verse: Verse)] = []

    var body: some View {
        Form {
            Section("Weekly Theme Plans") {
                ForEach(topics, id: \.slug) { topic in
                    Button {
                        selectedPlanID = topic.slug
                    } label: {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(topic.name)
                                    .font(.headline)
                                Text(topic.summary)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if selectedPlanID == topic.slug {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("Preview 7 Verses") {
                if previewVerses.isEmpty {
                    Text("Loading...")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(previewVerses, id: \.dayNumber) { preview in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Day \(preview.dayNumber): \(preview.verse.verseRef)")
                                .font(.headline)
                            Text(preview.verse.text)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section("Start") {
                Toggle("Auto-repeat weekly plan", isOn: $autoRepeat)

                Text("The selected weekly theme and repeat preference are saved to the shared widget settings.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Button {
                    AppGroupSettings.defaults.set(autoRepeat, forKey: AppGroupSettings.Keys.weeklyAutoRepeat)
                    settingsStore.topicSlug = selectedPlanID
                    settingsStore.activeMode = .weeklyTheme
                } label: {
                    Label("Start This Week", systemImage: "calendar.badge.checkmark")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Weekly Theme")
        .onAppear {
            // The database's topics, so every plan offered has verses behind it.
            topics = DatabaseService.shared.topics()
            selectedPlanID = settingsStore.topicSlug ?? selectedPlanID
            if AppGroupSettings.defaults.object(forKey: AppGroupSettings.Keys.weeklyAutoRepeat) != nil {
                autoRepeat = AppGroupSettings.defaults.bool(forKey: AppGroupSettings.Keys.weeklyAutoRepeat)
            }
            loadPreview()
        }
        .onChange(of: selectedPlanID) { _, _ in
            loadPreview()
        }
    }

    // The verse Weekly Theme selects for each day of the current week.
    private func loadPreview() {
        var settings = settingsStore.currentSettings()
        settings.activeMode = .weeklyTheme
        settings.topicSlug = selectedPlanID
        let calendar = Calendar.current
        guard let week = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
            previewVerses = []
            return
        }
        previewVerses = (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: week.start).map { day in
                (dayNumber: offset + 1, verse: VerseSelectionService.verse(for: settings, date: day))
            }
        }
    }
}
