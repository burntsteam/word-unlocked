import SwiftUI

struct ChapterModeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var selectedBookId = 43
    @State private var chapterNumber = 3
    @State private var rotationSpeed: WidgetSettings.RotationInterval = .daily
    @State private var endBehavior: WidgetSettings.ChapterEndBehavior = .repeatChapter
    @State private var showProgress = true
    @State private var books: [Book] = []

    private let speedOptions: [WidgetSettings.RotationInterval] = [.daily, .everyTwelveHours, .everySixHours]

    private var selectedBook: Book {
        books.first { $0.id == selectedBookId } ?? books.first ?? Book(id: selectedBookId, name: "", abbreviation: "", testament: .new, chapterCount: 1)
    }

    var body: some View {
        Form {
            Section("Book") {
                Picker("Book", selection: $selectedBookId) {
                    Section("Old Testament") {
                        ForEach(books.filter { $0.testament == .old }) { book in
                            Text(book.name).tag(book.id)
                        }
                    }

                    Section("New Testament") {
                        ForEach(books.filter { $0.testament == .new }) { book in
                            Text(book.name).tag(book.id)
                        }
                    }
                }
                .onChange(of: selectedBookId) {
                    chapterNumber = min(chapterNumber, selectedBook.chapterCount)
                }
            }

            Section("Chapter") {
                Stepper(
                    "Chapter \(chapterNumber)",
                    value: $chapterNumber,
                    in: 1...max(selectedBook.chapterCount, 1)
                )
                Text("\(selectedBook.name) has \(selectedBook.chapterCount) chapters.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Rotation") {
                Picker("Speed", selection: $rotationSpeed) {
                    ForEach(speedOptions) { speed in
                        Text(speed.title).tag(speed)
                    }
                }

                Picker("End Behavior", selection: $endBehavior) {
                    ForEach(WidgetSettings.ChapterEndBehavior.allCases) { behavior in
                        Text(behavior.title).tag(behavior)
                    }
                }

                Toggle("Show Progress", isOn: $showProgress)

                Text("Reading starts at verse 1 when you set a new passage. After the last verse, Repeat starts the chapter again, Next Chapter keeps reading, and Stop stays on the last verse.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section {
                Button {
                    AppGroupSettings.defaults.set(rotationSpeed.rawValue, forKey: AppGroupSettings.Keys.chapterRotationSpeed)
                    AppGroupSettings.defaults.set(endBehavior.rawValue, forKey: AppGroupSettings.Keys.chapterEndBehavior)
                    settingsStore.chapterBookId = selectedBookId
                    settingsStore.chapterNumber = min(chapterNumber, selectedBook.chapterCount)
                    settingsStore.showProgress = showProgress
                    settingsStore.activeMode = .chapter
                } label: {
                    Label("Set as Active Mode", systemImage: "checkmark.circle")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Chapter")
        .onAppear {
            selectedBookId = settingsStore.chapterBookId ?? selectedBookId
            chapterNumber = settingsStore.chapterNumber ?? chapterNumber
            showProgress = settingsStore.showProgress
            if let rawValue = AppGroupSettings.defaults.string(forKey: AppGroupSettings.Keys.chapterRotationSpeed),
               let value = WidgetSettings.RotationInterval(rawValue: rawValue) {
                rotationSpeed = value
            }
            if let rawValue = AppGroupSettings.defaults.string(forKey: AppGroupSettings.Keys.chapterEndBehavior),
               let value = WidgetSettings.ChapterEndBehavior(rawValue: rawValue) {
                endBehavior = value
            }
            if books.isEmpty {
                books = DatabaseService.shared.books()
            }
        }
    }
}
