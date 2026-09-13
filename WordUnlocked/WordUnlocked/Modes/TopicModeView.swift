import SwiftUI

struct TopicModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var topics: [Topic] = []
    @State private var selectedTopicSlug = "love"
    @State private var rotationSpeed: TopicRotationSpeed = .daily

    var body: some View {
        Form {
            Section("Topics") {
                ForEach(topics, id: \.slug) { topic in
                    Button {
                        selectedTopicSlug = topic.slug
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: topic.symbolName)
                                .frame(width: 28)
                                .foregroundStyle(selectedTopicSlug == topic.slug ? Color.accentColor : Color.secondary)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(topic.name)
                                    .font(.headline)
                                Text(topic.summary)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if selectedTopicSlug == topic.slug {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("Rotation Speed") {
                Picker("Speed", selection: $rotationSpeed) {
                    ForEach(TopicRotationSpeed.allCases) { speed in
                        Text(speed.title).tag(speed)
                    }
                }
                .pickerStyle(.segmented)

                Text("The selected topic and rotation speed are saved for widget timeline generation.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section {
                Button {
                    AppGroupSettings.defaults.set(rotationSpeed.rawValue, forKey: AppGroupSettings.Keys.topicRotationSpeed)
                    settingsStore.topicSlug = selectedTopicSlug
                    settingsStore.activeMode = .topic
                } label: {
                    Label("Set as Active Mode", systemImage: "checkmark.circle")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Topic")
        .onAppear {
            // The database's topics, so every topic offered has verses behind it.
            topics = DatabaseService.shared.topics()
            selectedTopicSlug = settingsStore.topicSlug ?? selectedTopicSlug
            if let rawValue = AppGroupSettings.defaults.string(forKey: AppGroupSettings.Keys.topicRotationSpeed),
               let value = TopicRotationSpeed(rawValue: rawValue) {
                rotationSpeed = value
            }
        }
    }
}

private enum TopicRotationSpeed: String, CaseIterable, Identifiable {
    case daily
    case everyTwelveHours
    case everySixHours

    var id: String { rawValue }

    var title: String {
        switch self {
        case .daily: "Daily"
        case .everyTwelveHours: "12h"
        case .everySixHours: "6h"
        }
    }
}
