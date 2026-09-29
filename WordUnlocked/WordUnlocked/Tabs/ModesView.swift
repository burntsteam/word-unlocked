import SwiftUI

struct ModesView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var selectedMode: WidgetSettings.VerseMode?

    var body: some View {
        List {
            Section {
                ForEach(WidgetSettings.VerseMode.allCases) { mode in
                    let isActive = settingsStore.activeMode == mode
                    Button {
                        selectedMode = mode
                    } label: {
                        ModeRow(mode: mode, isActive: isActive)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isActive ? .isSelected : [])
                }
            } header: {
                Text("Verse Modes")
            } footer: {
                Text("Tap a mode to change its settings. The checked mode is the one Today and your widgets show.")
            }
        }
        .navigationTitle("Modes")
        .sheet(item: $selectedMode) { mode in
            NavigationStack {
                detailView(for: mode)
                    .environmentObject(settingsStore)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
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

private struct ModeRow: View {
    let mode: WidgetSettings.VerseMode
    let isActive: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: mode.symbolName)
                .foregroundStyle(isActive ? Color.accentColor : Color.secondary)
                .frame(width: 28)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(mode.title)
                    .font(.headline)
                Text(mode.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isActive {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.tint)
                    .accessibilityHidden(true)
            }
        }
        .contentShape(Rectangle())
        .padding(.vertical, 4)
    }
}

/// The last section of every mode's settings. Its button makes the mode active, or saves
/// changes to the mode that already is, then closes the sheet.
struct ModeSaveSection: View {
    let mode: WidgetSettings.VerseMode
    var isDisabled = false
    var footnote: String?
    let save: () -> Void

    @EnvironmentObject private var settingsStore: SettingsStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Section {
            Button {
                save()
                settingsStore.activeMode = mode
                dismiss()
            } label: {
                Label(settingsStore.activeMode == mode ? "Save" : "Set as Active Mode", systemImage: "checkmark.circle")
                    .frame(maxWidth: .infinity)
            }
            .disabled(isDisabled)
        } footer: {
            VStack(alignment: .leading, spacing: 8) {
                if let footnote {
                    Text(footnote)
                }
                ESVDownloadNotice()
            }
        }
    }
}

/// While ESV is selected and its next download has to wait, verses a new choice needs show
/// in the King James Version until then. Saying so here keeps that from looking broken.
private struct ESVDownloadNotice: View {
    @EnvironmentObject private var settingsStore: SettingsStore
    @ObservedObject private var esvService = ESVBibleService.shared

    var body: some View {
        if settingsStore.selectedTranslation == "ESV", let next = esvService.nextFetchDate, next > Date() {
            Text("ESV verses download at most once every 48 hours. Until \(next.formatted(date: .abbreviated, time: .shortened)), verses this choice needs that aren't on your device show in the King James Version.")
        }
    }
}
