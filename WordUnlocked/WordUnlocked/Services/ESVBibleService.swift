import Foundation
import WidgetKit

// Keeps English Standard Version verses on the device, downloaded from the Crossway ESV API
// (https://api.esv.org), so the app and its Lock Screen widget show ESV offline. Crossway's
// terms allow at most 500 ESV verses on a device and never more than half of any book.
// Every install shares one API key (5,000 requests a day), so an install downloads at most
// once every 48 hours: one request for the verses its settings show next that it lacks.
@MainActor
final class ESVBibleService: ObservableObject {
    // ESV_API_KEY is supplied at build time via Config/Secrets.xcconfig.
    static let shared = ESVBibleService(
        apiKey: Bundle.main.infoDictionary?["ESVApiKey"] as? String ?? "")

    /// Crossway's cap on ESV verses kept on a device.
    nonisolated static let maxStoredVerses = 500
    /// How long an install waits after a download before the next one.
    nonisolated static let minimumFetchInterval: TimeInterval = 48 * 60 * 60
    /// Verses per request, so the id list stays inside the API's 4,094-byte request line.
    nonisolated static let maxVersesPerRequest = 300

    @Published private(set) var isFetching = false
    @Published private(set) var error: String?
    /// The downloaded verses, in the order the settings they were planned for show them.
    @Published private(set) var verses: [LiveCachedVerse]

    private let apiKey: String
    private let defaults: UserDefaults
    private let session: URLSession
    private var isRefreshing = false

    // Without a key there is nothing to download, so the UI hides the translation.
    static var isConfigured: Bool { shared.isConfigured }
    var isConfigured: Bool { !apiKey.isEmpty }

    // Takes its key, store and session so tests can run it unconfigured, or against a
    // stubbed network and a scratch store instead of the App Group the widget reads.
    init(apiKey: String, defaults: UserDefaults = AppGroupSettings.defaults, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.defaults = defaults
        self.session = session
        verses = LiveCachedVerse.storedESVVerses(in: defaults)
    }

    /// When the last download reached the API.
    var lastFetchDate: Date? {
        defaults.object(forKey: AppGroupSettings.Keys.esvLastFetchDate) as? Date
    }

    /// The earliest the next download can start.
    var nextFetchDate: Date? {
        lastFetchDate?.addingTimeInterval(Self.minimumFetchInterval)
    }

    func cachedVerse(for reference: String) -> LiveCachedVerse? {
        verses.first { $0.fetchedRef == reference }
    }

    func isFetchDue(at now: Date) -> Bool {
        // A last download dated in the future means the clock moved back: don't wait on it.
        guard let lastFetchDate, lastFetchDate <= now else { return true }
        return now.timeIntervalSince(lastFetchDate) >= Self.minimumFetchInterval
    }

    /// Downloads what `settings` show next, once 48 hours have passed since the last download.
    func refreshIfDue(settings: WidgetSettings, favorites: [Favorite], now: Date = Date()) async {
        guard isConfigured, !isRefreshing, isFetchDue(at: now) else { return }
        isRefreshing = true
        defer { isRefreshing = false }
        let plan = await Task.detached(priority: .utility) {
            Self.plannedVerses(settings: settings, favorites: favorites, from: now)
        }.value
        await update(with: plan, now: now)
    }

    /// Downloads, in one request, the verses of `plan` not already here, then keeps just the
    /// planned verses. Does nothing within 48 hours of the last download, or when every
    /// planned verse is already here.
    func update(with plan: [SharedVerseRecord], now: Date = Date()) async {
        guard isConfigured, isFetchDue(at: now) else { return }
        let stored = Dictionary(verses.map { ($0.fetchedRef, $0) }, uniquingKeysWith: { first, _ in first })
        let missing = Array(plan.filter { stored[$0.verseRef] == nil }.prefix(Self.maxVersesPerRequest))
        guard !missing.isEmpty, let request = Self.request(for: missing, apiKey: apiKey) else { return }

        isFetching = true
        defer { isFetching = false }
        error = nil
        do {
            let (data, response) = try await session.data(for: request)
            recordFetch(at: now)
            switch (response as? HTTPURLResponse)?.statusCode ?? 0 {
            case 200...299:
                let downloaded = try Self.verses(from: data, requested: missing)
                store(plan.compactMap { stored[$0.verseRef] ?? downloaded[$0.verseRef] })
            case 401, 403:
                error = "ESV API key rejected. Check your configuration."
            case 429:
                error = "The ESV service is busy. More ESV verses will download later."
            default:
                error = "Could not download ESV verses."
            }
        } catch let urlError as URLError {
            guard urlError.code != .cancelled else { return }
            if !Self.failedBeforeReachingServer(urlError) {
                recordFetch(at: now)
            }
            error = "Could not download ESV verses. Check your connection."
        } catch is CancellationError {
        } catch {
            // The response arrived but couldn't be read.
            self.error = "Could not download ESV verses."
        }
    }

    private func recordFetch(at date: Date) {
        defaults.set(date, forKey: AppGroupSettings.Keys.esvLastFetchDate)
    }

    private func store(_ newVerses: [LiveCachedVerse]) {
        verses = newVerses
        if let data = try? JSONEncoder().encode(newVerses) {
            defaults.set(data, forKey: AppGroupSettings.Keys.esvVerseCache)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
}

extension ESVBibleService {
    /// Crossway's limits on the ESV verses one device keeps: 500 in all, and no more than
    /// half of any book.
    struct Allowance {
        private var total: Int
        private var perBook: [Int: Int]
        private let bookVerseCounts: [Int: Int]

        /// The room left beside verses, from the books `keptBookIds`, already on the device.
        init(keptBookIds: [Int], bookVerseCounts: [Int: Int]) {
            total = keptBookIds.count
            perBook = keptBookIds.reduce(into: [:]) { $0[$1, default: 0] += 1 }
            self.bookVerseCounts = bookVerseCounts
        }

        /// Takes room for one more verse from `bookId`, if the limits leave any.
        mutating func admit(bookId: Int) -> Bool {
            let inBook = perBook[bookId, default: 0]
            guard total < ESVBibleService.maxStoredVerses, inBook < bookVerseCounts[bookId, default: 0] / 2 else {
                return false
            }
            total += 1
            perBook[bookId] = inBook + 1
            return true
        }
    }

    private nonisolated static let referenceCode = VerseSelectionService.referenceTranslationCode(for: "ESV")

    /// The verses to keep for `settings`: those it shows from `now` on, as far as Crossway's
    /// limits allow beside the ESV verses saved as favorites.
    nonisolated static func plannedVerses(
        settings: WidgetSettings,
        favorites: [Favorite],
        from now: Date,
        database: ScriptureDatabase = .shared,
        defaults: UserDefaults = AppGroupSettings.defaults
    ) -> [SharedVerseRecord] {
        var allowance = Allowance(
            keptBookIds: savedFavoriteBookIds(favorites, database: database),
            bookVerseCounts: database.bookVerseCounts(translationCode: referenceCode)
        )
        return VerseSelectionService.upcomingRecords(
            for: settings, from: now, favorites: favorites, limit: maxStoredVerses, database: database, defaults: defaults
        ) { verse in
            // A favorite saved with ESV text comes back as that text: nothing to download.
            verse.translationCode == referenceCode && allowance.admit(bookId: verse.bookId)
        }
    }

    /// Whether Crossway's limits leave room to save one more verse from `bookId` with its ESV text.
    nonisolated static func canSaveFavorite(bookId: Int, favorites: [Favorite], database: ScriptureDatabase = .shared) -> Bool {
        var allowance = Allowance(
            keptBookIds: savedFavoriteBookIds(favorites, database: database),
            bookVerseCounts: database.bookVerseCounts(translationCode: referenceCode)
        )
        return allowance.admit(bookId: bookId)
    }

    /// The books of the favorites saved with ESV text, which count against Crossway's limits.
    private nonisolated static func savedFavoriteBookIds(_ favorites: [Favorite], database: ScriptureDatabase) -> [Int] {
        favorites.filter { $0.translationCode == "ESV" }.compactMap { database.verse(id: $0.verseId)?.bookId }
    }

    /// One request for `verses`, each asked for by the API's numeric id. Verse numbers stay on
    /// so a psalm title or an acrostic letter printed before a verse can be cut off.
    nonisolated static func request(for verses: [SharedVerseRecord], apiKey: String) -> URLRequest? {
        var components = URLComponents(string: "https://api.esv.org/v3/passage/text/")
        components?.queryItems = [
            URLQueryItem(name: "q", value: verses.map { String(passageId(for: $0)) }.joined(separator: ",")),
            URLQueryItem(name: "include-passage-references", value: "false"),
            URLQueryItem(name: "include-verse-numbers", value: "true"),
            URLQueryItem(name: "include-first-verse-numbers", value: "true"),
            URLQueryItem(name: "include-footnotes", value: "false"),
            URLQueryItem(name: "include-footnote-body", value: "false"),
            URLQueryItem(name: "include-headings", value: "false"),
            URLQueryItem(name: "include-short-copyright", value: "false")
        ]
        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url, timeoutInterval: 30)
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    /// The API's id for a verse: book, then chapter and verse as three digits each (John 3:16 is 43003016).
    nonisolated static func passageId(for verse: SharedVerseRecord) -> Int {
        verse.bookId * 1_000_000 + verse.chapter * 1_000 + verse.verse
    }

    /// The downloaded verses, keyed by the reference each was requested for. A passage that
    /// spans more than one verse is left out: the API widens a verse the ESV omits, such as
    /// Matthew 17:21, into its neighbours.
    nonisolated static func verses(from data: Data, requested: [SharedVerseRecord]) throws -> [String: LiveCachedVerse] {
        let response = try JSONDecoder().decode(ESVResponse.self, from: data)
        let requestedById = Dictionary(requested.map { (passageId(for: $0), $0) }, uniquingKeysWith: { first, _ in first })
        var verses: [String: LiveCachedVerse] = [:]
        for (index, range) in response.parsed.enumerated() where index < response.passages.count {
            guard range.count == 2, range[0] == range[1], let verse = requestedById[range[0]] else { continue }
            let text = verseText(fromPassage: response.passages[index])
            guard !text.isEmpty else { continue }
            let ref = response.passageMeta.flatMap { index < $0.count ? $0[index].canonical : nil } ?? verse.verseRef
            verses[verse.verseRef] = LiveCachedVerse(ref: ref, text: text, fetchedRef: verse.verseRef)
        }
        return verses
    }

    /// A passage's text without its verse number, anything printed before the number (a psalm
    /// title or an acrostic letter), or the API's poetry line breaks and indentation.
    nonisolated static func verseText(fromPassage passage: String) -> String {
        let marker = #"\[\d+(:\d+)?\]"#
        var text = Substring(passage)
        if let firstMarker = text.range(of: marker, options: .regularExpression) {
            text = text[firstMarker.upperBound...]
        }
        return text.replacingOccurrences(of: marker, with: " ", options: .regularExpression)
            .split(whereSeparator: \.isWhitespace)
            .joined(separator: " ")
    }

    /// Failures that mean the request never left the device, so they don't start the 48-hour wait.
    nonisolated static func failedBeforeReachingServer(_ error: URLError) -> Bool {
        [.notConnectedToInternet, .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed,
         .internationalRoamingOff, .dataNotAllowed, .callIsActive].contains(error.code)
    }
}

private struct ESVResponse: Decodable {
    struct PassageMeta: Decodable {
        let canonical: String
    }

    let parsed: [[Int]]
    let passages: [String]
    let passageMeta: [PassageMeta]?

    enum CodingKeys: String, CodingKey {
        case parsed
        case passages
        case passageMeta = "passage_meta"
    }
}
