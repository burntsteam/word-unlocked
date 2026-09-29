import SwiftUI

struct TopicModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var topics: [Topic] = []
    @State private var selectedTopicSlug = "love"
    @State private var rotationSpeed: WidgetSettings.RotationInterval = .daily

    private let speedOptions: [WidgetSettings.RotationInterval] = [.daily, .everyTwelveHours, .everySixHours]

    var body: some View {
        Form {
            Section("Topics") {
                ForEach(topics, id: \.slug) { topic in
                    let isSelected = selectedTopicSlug == topic.slug
                    Button {
                        selectedTopicSlug = topic.slug
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: topic.symbolName)
                                .frame(width: 28)
                                .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
                                .accessibilityHidden(true)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(topic.name)
                                    .font(.headline)
                                Text(topic.summary)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.tint)
                                    .accessibilityHidden(true)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }

            Section {
                Picker("Speed", selection: $rotationSpeed) {
                    ForEach(speedOptions) { speed in
                        Text(speed.title).tag(speed)
                    }
                }
            } header: {
                Text("Rotation Speed")
            } footer: {
                Text("Every 12 Hours and Every 6 Hours change the verse through the day, starting at midnight.")
            }

            ModeSaveSection(mode: .topic) {
                AppGroupSettings.defaults.set(rotationSpeed.rawValue, forKey: AppGroupSettings.Keys.topicRotationSpeed)
                settingsStore.topicSlug = selectedTopicSlug
            }
        }
        .navigationTitle("Topic")
        .onAppear {
            // The database's topics, so every topic offered has verses behind it.
            topics = DatabaseService.shared.topics()
            selectedTopicSlug = settingsStore.topicSlug ?? selectedTopicSlug
            if let rawValue = AppGroupSettings.defaults.string(forKey: AppGroupSettings.Keys.topicRotationSpeed),
               let value = WidgetSettings.RotationInterval(rawValue: rawValue) {
                rotationSpeed = value
            }
        }
    }
}
