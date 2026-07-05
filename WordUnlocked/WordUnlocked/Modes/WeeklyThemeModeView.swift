import SwiftUI

struct WeeklyThemeModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var selectedPlanID = weeklyThemePlans[0].id
    @State private var autoRepeat = true
    @State private var previewVerses: [(dayNumber: Int, verse: Verse)] = []

    private var selectedPlan: WeeklyThemePlan {
        weeklyThemePlans.first { $0.id == selectedPlanID } ?? weeklyThemePlans[0]
    }

    var body: some View {
        Form {
            Section("Weekly Theme Plans") {
                ForEach(weeklyThemePlans) { plan in
                    Button {
                        selectedPlanID = plan.id
                    } label: {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(plan.title)
                                    .font(.headline)
                                Text(plan.summary)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if selectedPlanID == plan.id {
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
                    settingsStore.topicSlug = selectedPlan.id
                    settingsStore.activeMode = .weeklyTheme
                } label: {
                    Label("Start This Week", systemImage: "calendar.badge.checkmark")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Weekly Theme")
        .onAppear {
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

    private func loadPreview() {
        previewVerses = DatabaseService.shared.weeklyPlanVerses(
            topicSlug: selectedPlanID,
            translationCode: settingsStore.selectedTranslation
        )
    }
}

private struct WeeklyThemePlan: Identifiable {
    let id: String
    let title: String
    let summary: String
    let verses: [WeeklyVersePreview]
}

private struct WeeklyVersePreview: Identifiable {
    let day: Int
    let verseRef: String
    let text: String

    var id: Int { day }
}

private let weeklyThemePlans: [WeeklyThemePlan] = [
    WeeklyThemePlan(id: "hope", title: "Hope", summary: "Confidence in God's promises.", verses: weeklyPreview("Hope", refs: ["Romans 15:13", "Psalm 42:11", "Isaiah 40:31", "Lamentations 3:24", "Hebrews 6:19", "1 Peter 1:3", "Romans 5:5"])),
    WeeklyThemePlan(id: "peace", title: "Peace", summary: "Resting in God through pressure.", verses: weeklyPreview("Peace", refs: ["John 14:27", "Philippians 4:7", "Isaiah 26:3", "Colossians 3:15", "Psalm 4:8", "Romans 8:6", "2 Thessalonians 3:16"])),
    WeeklyThemePlan(id: "wisdom", title: "Wisdom", summary: "Learning to walk with discernment.", verses: weeklyPreview("Wisdom", refs: ["James 1:5", "Proverbs 3:5", "Proverbs 2:6", "Psalm 90:12", "Colossians 4:5", "Ephesians 5:15", "Proverbs 16:16"])),
    WeeklyThemePlan(id: "courage", title: "Courage", summary: "Strength when fear rises.", verses: weeklyPreview("Courage", refs: ["Joshua 1:9", "Psalm 27:1", "Isaiah 41:10", "2 Timothy 1:7", "Deuteronomy 31:6", "Psalm 56:3", "1 Corinthians 16:13"])),
    WeeklyThemePlan(id: "love", title: "Love", summary: "Receiving and practicing God's love.", verses: weeklyPreview("Love", refs: ["1 John 4:19", "John 13:35", "Romans 12:9", "1 Corinthians 13:4", "Colossians 3:14", "Ephesians 3:17", "John 15:12"])),
    WeeklyThemePlan(id: "faith", title: "Faith", summary: "Trusting what God has spoken.", verses: weeklyPreview("Faith", refs: ["Hebrews 11:1", "Romans 10:17", "Mark 11:22", "2 Corinthians 5:7", "Galatians 2:20", "Ephesians 2:8", "James 2:17"])),
    WeeklyThemePlan(id: "gratitude", title: "Gratitude", summary: "Practicing thankfulness.", verses: weeklyPreview("Gratitude", refs: ["1 Thessalonians 5:18", "Psalm 107:1", "Colossians 3:17", "Psalm 100:4", "James 1:17", "Hebrews 12:28", "Ephesians 5:20"])),
    WeeklyThemePlan(id: "prayer", title: "Prayer", summary: "Returning attention to God.", verses: weeklyPreview("Prayer", refs: ["Matthew 6:6", "1 John 5:14", "Philippians 4:6", "Colossians 4:2", "James 5:16", "Psalm 145:18", "Romans 12:12"])),
    WeeklyThemePlan(id: "forgiveness", title: "Forgiveness", summary: "Mercy received and extended.", verses: weeklyPreview("Forgiveness", refs: ["Ephesians 4:32", "Colossians 3:13", "1 John 1:9", "Matthew 6:14", "Psalm 103:12", "Isaiah 1:18", "Luke 6:37"])),
    WeeklyThemePlan(id: "humility", title: "Humility", summary: "A quiet life before God.", verses: weeklyPreview("Humility", refs: ["Micah 6:8", "James 4:10", "Philippians 2:3", "1 Peter 5:6", "Proverbs 11:2", "Matthew 23:12", "Romans 12:16"])),
    WeeklyThemePlan(id: "patience", title: "Patience", summary: "Faithful waiting.", verses: weeklyPreview("Patience", refs: ["Romans 12:12", "James 5:8", "Psalm 37:7", "Galatians 6:9", "Colossians 1:11", "Hebrews 10:36", "Ecclesiastes 7:8"])),
    WeeklyThemePlan(id: "joy", title: "Joy", summary: "Gladness grounded in God.", verses: weeklyPreview("Joy", refs: ["Nehemiah 8:10", "Psalm 16:11", "John 15:11", "Romans 15:13", "Philippians 4:4", "James 1:2", "1 Peter 1:8"])),
    WeeklyThemePlan(id: "discipline", title: "Discipline", summary: "Daily attention and practice.", verses: weeklyPreview("Discipline", refs: ["1 Corinthians 9:24", "Hebrews 12:11", "Proverbs 12:1", "2 Timothy 1:7", "Titus 2:12", "1 Timothy 4:7", "Proverbs 25:28"])),
    WeeklyThemePlan(id: "mercy", title: "Mercy", summary: "Compassion in action.", verses: weeklyPreview("Mercy", refs: ["Luke 6:36", "Micah 6:8", "Matthew 5:7", "James 2:13", "Psalm 145:9", "Ephesians 2:4", "Hebrews 4:16"])),
    WeeklyThemePlan(id: "guidance", title: "Guidance", summary: "Letting God direct the path.", verses: weeklyPreview("Guidance", refs: ["Psalm 32:8", "Proverbs 3:6", "Isaiah 30:21", "Psalm 119:105", "John 16:13", "James 1:5", "Psalm 25:4"])),
    WeeklyThemePlan(id: "strength", title: "Strength", summary: "Help for weakness.", verses: weeklyPreview("Strength", refs: ["Philippians 4:13", "Isaiah 40:29", "Psalm 46:1", "2 Corinthians 12:9", "Ephesians 6:10", "Exodus 15:2", "Psalm 18:2"])),
    WeeklyThemePlan(id: "rest", title: "Rest", summary: "Receiving Sabbath-shaped grace.", verses: weeklyPreview("Rest", refs: ["Matthew 11:28", "Psalm 23:2", "Hebrews 4:9", "Exodus 33:14", "Psalm 127:2", "Mark 6:31", "Isaiah 30:15"])),
    WeeklyThemePlan(id: "generosity", title: "Generosity", summary: "Open hands and cheerful giving.", verses: weeklyPreview("Generosity", refs: ["2 Corinthians 9:7", "Acts 20:35", "Proverbs 11:25", "Luke 6:38", "1 Timothy 6:18", "Hebrews 13:16", "Matthew 6:21"])),
    WeeklyThemePlan(id: "identity", title: "Identity", summary: "Remembering who you are in Christ.", verses: weeklyPreview("Identity", refs: ["2 Corinthians 5:17", "Ephesians 2:10", "1 Peter 2:9", "Galatians 3:26", "Romans 8:16", "Colossians 3:3", "John 1:12"])),
    WeeklyThemePlan(id: "worship", title: "Worship", summary: "Life oriented toward God.", verses: weeklyPreview("Worship", refs: ["Psalm 95:6", "John 4:24", "Romans 12:1", "Psalm 100:2", "Hebrews 13:15", "Revelation 4:11", "Psalm 29:2"]))
]

private func weeklyPreview(_ theme: String, refs: [String]) -> [WeeklyVersePreview] {
    refs.enumerated().map { index, ref in
        WeeklyVersePreview(
            day: index + 1,
            verseRef: ref,
            text: "\(theme) focus for day \(index + 1) using \(ref)."
        )
    }
}
