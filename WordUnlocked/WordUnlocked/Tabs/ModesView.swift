import SwiftUI

struct ModesView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var selectedMode: WidgetSettings.VerseMode?

    var body: some View {
        List {
            Section("Verse Modes") {
                ForEach(modeRows) { row in
                    Button {
                        if row.mode != settingsStore.activeMode {
                            selectedMode = row.mode
                        }
                    } label: {
                        ModeRow(row: row, isActive: settingsStore.activeMode == row.mode)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Modes")
        .sheet(item: $selectedMode) { mode in
            NavigationStack {
                detailView(for: mode)
                    .environmentObject(settingsStore)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") {
                                selectedMode = nil
                            }
                        }
                    }
            }
        }
    }

    @ViewBuilder
    private func detailView(for mode: WidgetSettings.VerseMode) -> some View {
        switch mode {
        case .daily:
            DailyVerseModeView()
        case .weeklyTheme:
            WeeklyThemeModeView()
        case .topic:
            TopicModeView()
        case .chapter:
            ChapterModeView()
        case .memorization:
            MemorizationModeView()
        case .favorites:
            FavoritesModeView()
        }
    }
}

private struct ModeRowData: Identifiable {
    let mode: WidgetSettings.VerseMode
    let icon: String
    let title: String
    let description: String

    var id: WidgetSettings.VerseMode { mode }
}

private let modeRows: [ModeRowData] = [
    ModeRowData(mode: .daily, icon: "calendar", title: "Daily Verse", description: "A new verse for every day."),
    ModeRowData(mode: .weeklyTheme, icon: "7.square", title: "Weekly Plan", description: "Seven verses a week from a theme, book, or your list."),
    ModeRowData(mode: .topic, icon: "tag", title: "Topic", description: "Rotate through verses by subject."),
    ModeRowData(mode: .chapter, icon: "book.pages", title: "Chapter", description: "Move through a Bible chapter in order."),
    ModeRowData(mode: .memorization, icon: "brain.head.profile", title: "Memorization", description: "Practice one verse through guided phases."),
    ModeRowData(mode: .favorites, icon: "heart", title: "Favorites", description: "Show verses you have saved.")
]

private struct ModeRow: View {
    let row: ModeRowData
    let isActive: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: row.icon)
                .foregroundStyle(isActive ? Color.accentColor : Color.secondary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(row.title)
                    .font(.headline)
                Text(row.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isActive {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.tint)
            }
        }
        .contentShape(Rectangle())
        .padding(.vertical, 4)
    }
}
