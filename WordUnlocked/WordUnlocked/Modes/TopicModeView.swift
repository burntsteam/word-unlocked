import SwiftUI

struct TopicModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var selectedTopicSlug = topicModeOptions[0].slug
    @State private var rotationSpeed: TopicRotationSpeed = .daily

    var body: some View {
        Form {
            Section("Topics") {
                ForEach(topicModeOptions) { topic in
                    Button {
                        selectedTopicSlug = topic.slug
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: topic.icon)
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
            selectedTopicSlug = settingsStore.topicSlug ?? selectedTopicSlug
            if let rawValue = AppGroupSettings.defaults.string(forKey: AppGroupSettings.Keys.topicRotationSpeed),
               let value = TopicRotationSpeed(rawValue: rawValue) {
                rotationSpeed = value
            }
        }
    }
}

private struct TopicModeOption: Identifiable {
    let slug: String
    let name: String
    let summary: String
    let icon: String

    var id: String { slug }
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

private let topicModeOptions: [TopicModeOption] = [
    TopicModeOption(slug: "love", name: "Love", summary: "God's steadfast care.", icon: "heart"),
    TopicModeOption(slug: "peace", name: "Peace", summary: "Quiet trust under pressure.", icon: "leaf"),
    TopicModeOption(slug: "hope", name: "Hope", summary: "Confidence in God's promise.", icon: "sunrise"),
    TopicModeOption(slug: "faith", name: "Faith", summary: "Trust in what God has spoken.", icon: "shield"),
    TopicModeOption(slug: "wisdom", name: "Wisdom", summary: "Discernment for daily life.", icon: "lightbulb"),
    TopicModeOption(slug: "courage", name: "Courage", summary: "Strength when fear rises.", icon: "figure.strengthtraining.traditional"),
    TopicModeOption(slug: "prayer", name: "Prayer", summary: "Attention turned toward God.", icon: "hands.sparkles"),
    TopicModeOption(slug: "forgiveness", name: "Forgiveness", summary: "Mercy received and extended.", icon: "arrow.counterclockwise"),
    TopicModeOption(slug: "gratitude", name: "Gratitude", summary: "Practicing thankfulness.", icon: "gift"),
    TopicModeOption(slug: "joy", name: "Joy", summary: "Gladness grounded in God.", icon: "sparkles"),
    TopicModeOption(slug: "patience", name: "Patience", summary: "Faithful waiting.", icon: "hourglass"),
    TopicModeOption(slug: "humility", name: "Humility", summary: "A quiet life before God.", icon: "arrow.down.heart"),
    TopicModeOption(slug: "discipline", name: "Discipline", summary: "Daily attention and practice.", icon: "target"),
    TopicModeOption(slug: "strength", name: "Strength", summary: "Help for weakness.", icon: "bolt"),
    TopicModeOption(slug: "rest", name: "Rest", summary: "Receiving grace and renewal.", icon: "bed.double"),
    TopicModeOption(slug: "guidance", name: "Guidance", summary: "Letting God direct the path.", icon: "map"),
    TopicModeOption(slug: "mercy", name: "Mercy", summary: "Compassion in action.", icon: "hand.raised"),
    TopicModeOption(slug: "obedience", name: "Obedience", summary: "Hearing and doing.", icon: "checkmark.seal"),
    TopicModeOption(slug: "generosity", name: "Generosity", summary: "Open hands and cheerful giving.", icon: "shippingbox"),
    TopicModeOption(slug: "identity", name: "Identity", summary: "Who you are in Christ.", icon: "person.text.rectangle"),
    TopicModeOption(slug: "worship", name: "Worship", summary: "Life oriented toward God.", icon: "music.note"),
    TopicModeOption(slug: "healing", name: "Healing", summary: "Wholeness and restoration.", icon: "cross.case"),
    TopicModeOption(slug: "justice", name: "Justice", summary: "Doing what is right.", icon: "scalemass"),
    TopicModeOption(slug: "purity", name: "Purity", summary: "A clean heart and focused mind.", icon: "drop"),
    TopicModeOption(slug: "service", name: "Service", summary: "Loving through action.", icon: "wrench.and.screwdriver"),
    TopicModeOption(slug: "perseverance", name: "Perseverance", summary: "Endurance through difficulty.", icon: "figure.walk")
]
