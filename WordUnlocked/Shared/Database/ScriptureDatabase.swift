import Foundation
import SQLite3
import WidgetKit

final class ScriptureDatabase {
    static let shared = ScriptureDatabase()

    /// Narrows a translation's verses in SQL, so picking one verse never loads the
    /// whole translation into memory — the widget extension has roughly 30MB.
    struct VerseFilter: Equatable {
        enum Books: Equatable {
            case all
            case oldTestament
            case newTestament
            case psalmsAndProverbs
        }

        var books: Books = .all
        var maxCharCount: Int?
    }

    private static let verseColumns = "v.id, v.translation_id, v.translation_code, v.book_id, v.book_name, v.chapter, v.verse, v.verse_ref, v.text, v.char_count, v.word_count, v.fit_category, v.excerpt, v.segment_count"

    private let databaseURL: URL
    private var database: OpaquePointer?
    private let lock = NSLock()
    private let currentDataVersion = 4

    private init() {
        databaseURL = AppGroupSettings.databaseURL
        // The widget extension never creates or changes the shared database: it opens
        // the app-provisioned file read-only on first use, and until that file exists
        // callers fall back to a built-in verse.
        guard !Self.isAppExtension else { return }
        openDatabase()
        provisionDatabaseIfNeeded()
        createSchema()
        #if DEBUG
        seedRVTestingIfNeeded()
        #endif
    }

    private static let isAppExtension: Bool = Bundle.main.bundleURL.pathExtension == "appex"

    deinit {
        if let database {
            sqlite3_close(database)
        }
    }

    func translations() -> [SharedTranslationRecord] {
        lock.lock()
        defer { lock.unlock() }

        let sql = """
        SELECT id, code, display_name, publisher, copyright_notice, license_status, attribution, offline_available, enabled
        FROM translations
        ORDER BY id;
        """

        var records: [SharedTranslationRecord] = []
        query(sql) { statement in
            records.append(
                SharedTranslationRecord(
                    id: intColumn(statement, 0),
                    code: stringColumn(statement, 1),
                    displayName: stringColumn(statement, 2),
                    publisher: stringColumn(statement, 3),
                    copyrightNotice: stringColumn(statement, 4),
                    licenseStatus: stringColumn(statement, 5),
                    attribution: stringColumn(statement, 6),
                    offlineAvailable: boolColumn(statement, 7),
                    enabled: boolColumn(statement, 8)
                )
            )
        }
        return records
    }

    func books() -> [SharedBookRecord] {
        lock.lock()
        defer { lock.unlock() }

        var records: [SharedBookRecord] = []
        query("SELECT id, name, abbreviation, testament, chapter_count FROM books ORDER BY id;") { statement in
            records.append(
                SharedBookRecord(
                    id: intColumn(statement, 0),
                    name: stringColumn(statement, 1),
                    abbreviation: stringColumn(statement, 2),
                    testament: stringColumn(statement, 3),
                    chapterCount: intColumn(statement, 4)
                )
            )
        }
        return records
    }

    func topics() -> [SharedTopicRecord] {
        lock.lock()
        defer { lock.unlock() }

        var records: [SharedTopicRecord] = []
        query("SELECT id, slug, name, symbol_name, summary FROM topics ORDER BY name;") { statement in
            records.append(
                SharedTopicRecord(
                    id: intColumn(statement, 0),
                    slug: stringColumn(statement, 1),
                    name: stringColumn(statement, 2),
                    symbolName: stringColumn(statement, 3),
                    summary: stringColumn(statement, 4)
                )
            )
        }
        return records
    }

    func hasVerses(translationCode: String) -> Bool {
        lock.lock(); defer { lock.unlock() }
        return scalarInt("SELECT COUNT(*) FROM verses WHERE translation_code = \(quoted(translationCode)) LIMIT 1;") > 0
    }

    func verseCount(translationCode: String, filter: VerseFilter = VerseFilter()) -> Int {
        lock.lock(); defer { lock.unlock() }
        return scalarInt("SELECT COUNT(*) FROM verses v WHERE \(conditions(translationCode: translationCode, filter: filter));")
    }

    struct ChapterVerseCount: Equatable {
        let bookId: Int
        let chapter: Int
        let verseCount: Int
    }

    /// Every chapter of a translation in reading order, with how many of its verses fit
    /// `maxCharCount` (all of them when nil). Chapters with none are left out.
    func chapterVerseCounts(translationCode: String, maxCharCount: Int? = nil) -> [ChapterVerseCount] {
        lock.lock(); defer { lock.unlock() }
        let filter = VerseFilter(books: .all, maxCharCount: maxCharCount)
        var counts: [ChapterVerseCount] = []
        query(
            """
            SELECT v.book_id, v.chapter, COUNT(*) FROM verses v
            WHERE \(conditions(translationCode: translationCode, filter: filter))
            GROUP BY v.book_id, v.chapter
            ORDER BY v.book_id, v.chapter;
            """
        ) { statement in
            counts.append(ChapterVerseCount(
                bookId: intColumn(statement, 0),
                chapter: intColumn(statement, 1),
                verseCount: intColumn(statement, 2)
            ))
        }
        return counts
    }

    /// The verse at `offset`, in id order, among the verses matching `filter`.
    func verse(translationCode: String, filter: VerseFilter = VerseFilter(), offset: Int) -> SharedVerseRecord? {
        lock.lock(); defer { lock.unlock() }
        return queryVerses(
            """
            SELECT \(Self.verseColumns) FROM verses v
            WHERE \(conditions(translationCode: translationCode, filter: filter))
            ORDER BY v.id
            LIMIT 1 OFFSET \(max(offset, 0));
            """
        ).first
    }

    func verse(id: Int) -> SharedVerseRecord? {
        lock.lock(); defer { lock.unlock() }
        return queryVerses("SELECT \(Self.verseColumns) FROM verses v WHERE v.id = \(id) LIMIT 1;").first
    }

    func verse(id: Int, translationCode: String) -> SharedVerseRecord? {
        lock.lock(); defer { lock.unlock() }
        return queryVerses("""
            SELECT \(Self.verseColumns) FROM verses v
            WHERE v.id = \(id) AND v.translation_code = \(quoted(translationCode)) LIMIT 1;
            """).first
    }

    func verse(verseRef: String, translationCode: String) -> SharedVerseRecord? {
        lock.lock(); defer { lock.unlock() }
        return queryVerses("""
            SELECT \(Self.verseColumns) FROM verses v
            WHERE v.verse_ref = \(quoted(verseRef)) AND v.translation_code = \(quoted(translationCode)) LIMIT 1;
            """).first
    }

    func verse(bookId: Int, chapter: Int, verse: Int, translationCode: String) -> SharedVerseRecord? {
        lock.lock(); defer { lock.unlock() }
        return queryVerses("""
            SELECT \(Self.verseColumns) FROM verses v
            WHERE v.translation_code = \(quoted(translationCode))
              AND v.book_id = \(bookId) AND v.chapter = \(chapter) AND v.verse = \(verse)
            LIMIT 1;
            """).first
    }

    /// A topic's verses in `translationCode`. topic_verses stores KJV verse ids, so
    /// other translations are matched on book, chapter and verse.
    func verses(topicSlug: String, translationCode: String) -> [SharedVerseRecord] {
        lock.lock()
        defer { lock.unlock() }

        return queryVerses(
            """
            SELECT \(Self.verseColumns)
            FROM topic_verses tv
            INNER JOIN verses ref ON ref.id = tv.verse_id
            INNER JOIN verses v ON v.book_id = ref.book_id AND v.chapter = ref.chapter AND v.verse = ref.verse
            WHERE tv.topic_slug = \(quoted(topicSlug)) AND v.translation_code = \(quoted(translationCode))
            ORDER BY ref.id;
            """
        )
    }

    func verses(bookId: Int, chapter: Int, translationCode: String) -> [SharedVerseRecord] {
        lock.lock()
        defer { lock.unlock() }

        return queryVerses(
            """
            SELECT \(Self.verseColumns)
            FROM verses v
            WHERE v.book_id = \(bookId) AND v.chapter = \(chapter) AND v.translation_code = \(quoted(translationCode))
            ORDER BY v.verse;
            """
        )
    }

    /// Verses whose reference or text contains `text`, in id order. LIKE is
    /// case-insensitive for ASCII, which covers the bundled English translations.
    func searchVerses(containing text: String, translationCode: String, limit: Int) -> [SharedVerseRecord] {
        lock.lock(); defer { lock.unlock() }
        let pattern = quoted("%\(likeEscaped(text))%")
        return queryVerses(
            """
            SELECT \(Self.verseColumns) FROM verses v
            WHERE v.translation_code = \(quoted(translationCode))
              AND (v.verse_ref LIKE \(pattern) ESCAPE '\\' OR v.text LIKE \(pattern) ESCAPE '\\')
            ORDER BY v.id
            LIMIT \(max(limit, 0));
            """
        )
    }

    private func conditions(translationCode: String, filter: VerseFilter) -> String {
        var conditions = ["v.translation_code = \(quoted(translationCode))"]
        switch filter.books {
        case .all:
            break
        case .oldTestament:
            conditions.append("v.book_id < 40")
        case .newTestament:
            conditions.append("v.book_id >= 40")
        case .psalmsAndProverbs:
            conditions.append("v.book_id IN (19, 20)")
        }
        if let maxCharCount = filter.maxCharCount {
            conditions.append("v.char_count <= \(maxCharCount)")
        }
        return conditions.joined(separator: " AND ")
    }

    private func openDatabase() {
        let flags: Int32
        if Self.isAppExtension {
            flags = SQLITE_OPEN_READONLY
        } else {
            try? FileManager.default.createDirectory(at: databaseURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE
        }
        guard sqlite3_open_v2(databaseURL.path, &database, flags, nil) == SQLITE_OK else {
            sqlite3_close(database)
            database = nil
            return
        }
        // Wait for a cross-process lock (widget may hold a read lock) instead of
        // failing writes immediately with SQLITE_BUSY.
        sqlite3_busy_timeout(database, 5000)
    }

    /// The open handle. The extension can be asked for a timeline before the app has
    /// provisioned the file, so a failed open is retried by the next query.
    private func connection() -> OpaquePointer? {
        if database == nil {
            openDatabase()
        }
        return database
    }

    private func createSchema() {
        execute(
            """
            CREATE TABLE IF NOT EXISTS translations (
                id INTEGER PRIMARY KEY,
                code TEXT NOT NULL UNIQUE,
                display_name TEXT NOT NULL,
                publisher TEXT NOT NULL,
                copyright_notice TEXT NOT NULL,
                license_status TEXT NOT NULL,
                attribution TEXT NOT NULL,
                offline_available INTEGER NOT NULL,
                enabled INTEGER NOT NULL
            );

            CREATE TABLE IF NOT EXISTS books (
                id INTEGER PRIMARY KEY,
                name TEXT NOT NULL,
                abbreviation TEXT NOT NULL,
                testament TEXT NOT NULL,
                chapter_count INTEGER NOT NULL
            );

            CREATE TABLE IF NOT EXISTS topics (
                id INTEGER PRIMARY KEY,
                slug TEXT NOT NULL UNIQUE,
                name TEXT NOT NULL,
                symbol_name TEXT NOT NULL,
                summary TEXT NOT NULL
            );

            CREATE TABLE IF NOT EXISTS verses (
                id INTEGER PRIMARY KEY,
                translation_id INTEGER NOT NULL,
                translation_code TEXT NOT NULL,
                book_id INTEGER NOT NULL,
                book_name TEXT NOT NULL,
                chapter INTEGER NOT NULL,
                verse INTEGER NOT NULL,
                verse_ref TEXT NOT NULL,
                text TEXT NOT NULL,
                char_count INTEGER NOT NULL,
                word_count INTEGER NOT NULL,
                fit_category TEXT NOT NULL,
                excerpt TEXT NOT NULL,
                segment_count INTEGER NOT NULL
            );

            CREATE TABLE IF NOT EXISTS topic_verses (
                topic_slug TEXT NOT NULL,
                verse_id INTEGER NOT NULL,
                PRIMARY KEY (topic_slug, verse_id)
            );

            CREATE INDEX IF NOT EXISTS idx_verses_translation ON verses(translation_code);
            CREATE INDEX IF NOT EXISTS idx_verses_book_chapter ON verses(translation_code, book_id, chapter);
            CREATE INDEX IF NOT EXISTS idx_topic_verses_verse ON topic_verses(verse_id);
            """
        )
    }

    /// Copies the pre-built database bundled with the app into the App Group
    /// container on first launch, or after a data-version bump. This replaces
    /// runtime JSON seeding: no multi-MB parse, no ~155k inserts, no main-thread
    /// hang. Favorites live in UserDefaults (not this database), so replacing
    /// the file is safe. If the bundled database is missing the existing
    /// database is kept, and callers fall back to a built-in verse.
    private func provisionDatabaseIfNeeded() {
        guard scalarInt("PRAGMA user_version;") < currentDataVersion else { return }
        guard let bundled = Bundle.main.url(forResource: "wordunlocked_seed", withExtension: "sqlite3") else {
            return
        }
        if let database {
            sqlite3_close(database)
            self.database = nil
        }
        // Copy beside the live file and swap it in with rename(2), so the widget can
        // never open a half-copied database.
        let fileManager = FileManager.default
        let stagingPath = databaseURL.path + ".provisioning"
        try? fileManager.removeItem(atPath: stagingPath)
        do {
            try fileManager.copyItem(atPath: bundled.path, toPath: stagingPath)
            for suffix in ["-wal", "-shm", "-journal"] {
                try? fileManager.removeItem(atPath: databaseURL.path + suffix)
            }
            guard rename(stagingPath, databaseURL.path) == 0 else {
                throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO)
            }
            // A timeline built before this point could only show the built-in verse.
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            try? fileManager.removeItem(atPath: stagingPath)
            #if DEBUG
            NSLog("ScriptureDatabase provisioning failed: \(error)")
            #endif
        }
        openDatabase()
    }

    #if DEBUG
    private func seedRVTestingIfNeeded() {
        guard !hasVerses(translationCode: "RV") else { return }
        let rows = loadSeedRows(named: "seed_verses_rv_testing")
        guard !rows.isEmpty else { return }
        lock.lock(); defer { lock.unlock() }
        rows.forEach { row in
            let bookId = intValue(row, "book_id")
            execute(
                """
                INSERT OR IGNORE INTO verses
                    (id, translation_id, translation_code, book_id, book_name, chapter, verse, verse_ref, text, char_count, word_count, fit_category, excerpt, segment_count)
                VALUES
                    (\(intValue(row, "id")), \(intValue(row, "translation_id")), \(quoted("RV")),
                     \(bookId), \(quoted(stringValue(row, "book_name"))), \(intValue(row, "chapter")),
                     \(intValue(row, "verse")), \(quoted(stringValue(row, "verse_ref"))), \(quoted(stringValue(row, "text"))),
                     \(intValue(row, "char_count")), \(intValue(row, "word_count")), \(quoted(stringValue(row, "fit_category"))),
                     \(quoted(stringValue(row, "excerpt"))), \(intValue(row, "segment_count")));
                """
            )
        }
    }

    private func loadSeedRows(named resourceName: String) -> [[String: Any]] {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let object = try? JSONSerialization.jsonObject(with: data),
              let rows = object as? [[String: Any]] else {
            return []
        }
        return rows
    }

    private func intValue(_ row: [String: Any], _ key: String) -> Int {
        if let value = row[key] as? Int {
            return value
        }
        if let value = row[key] as? NSNumber {
            return value.intValue
        }
        if let value = row[key] as? String, let intValue = Int(value) {
            return intValue
        }
        return 0
    }

    private func stringValue(_ row: [String: Any], _ key: String) -> String {
        if let value = row[key] as? String {
            return value
        }
        if let value = row[key] as? NSNumber {
            return value.stringValue
        }
        return ""
    }
    #endif

    private func queryVerses(_ sql: String) -> [SharedVerseRecord] {
        var records: [SharedVerseRecord] = []
        query(sql) { statement in
            records.append(
                SharedVerseRecord(
                    id: intColumn(statement, 0),
                    translationId: intColumn(statement, 1),
                    translationCode: stringColumn(statement, 2),
                    bookId: intColumn(statement, 3),
                    bookName: stringColumn(statement, 4),
                    chapter: intColumn(statement, 5),
                    verse: intColumn(statement, 6),
                    verseRef: stringColumn(statement, 7),
                    text: stringColumn(statement, 8),
                    charCount: intColumn(statement, 9),
                    wordCount: intColumn(statement, 10),
                    fitCategory: stringColumn(statement, 11),
                    excerpt: stringColumn(statement, 12),
                    segmentCount: intColumn(statement, 13)
                )
            )
        }
        return records
    }

    private func execute(_ sql: String) {
        guard let database = connection() else { return }
        let result = sqlite3_exec(database, sql, nil, nil, nil)
        #if DEBUG
        if result != SQLITE_OK {
            let msg = String(cString: sqlite3_errmsg(database))
            NSLog("ScriptureDatabase execute failed (\(result)): \(msg) :: \(sql.prefix(80))")
        }
        #endif
    }

    private func scalarInt(_ sql: String) -> Int {
        guard let database = connection() else { return 0 }
        var statement: OpaquePointer?
        defer {
            if statement != nil {
                sqlite3_finalize(statement)
            }
        }

        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK else { return 0 }
        guard sqlite3_step(statement) == SQLITE_ROW else { return 0 }
        return intColumn(statement, 0)
    }

    private func query(_ sql: String, row: (OpaquePointer?) -> Void) {
        guard let database = connection() else { return }
        var statement: OpaquePointer?
        defer {
            if statement != nil {
                sqlite3_finalize(statement)
            }
        }

        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK else { return }
        while sqlite3_step(statement) == SQLITE_ROW {
            row(statement)
        }
    }

    private func quoted(_ value: String) -> String {
        "'\(value.replacingOccurrences(of: "'", with: "''"))'"
    }

    private func likeEscaped(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "%", with: "\\%")
            .replacingOccurrences(of: "_", with: "\\_")
    }

    private func intColumn(_ statement: OpaquePointer?, _ index: Int32) -> Int {
        Int(sqlite3_column_int(statement, index))
    }

    private func boolColumn(_ statement: OpaquePointer?, _ index: Int32) -> Bool {
        sqlite3_column_int(statement, index) != 0
    }

    private func stringColumn(_ statement: OpaquePointer?, _ index: Int32) -> String {
        guard let text = sqlite3_column_text(statement, index) else { return "" }
        return String(cString: UnsafeRawPointer(text).assumingMemoryBound(to: CChar.self))
    }
}
