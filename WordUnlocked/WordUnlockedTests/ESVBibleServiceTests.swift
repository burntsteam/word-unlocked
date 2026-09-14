import Testing
import Foundation
@testable import WordUnlocked

// ESVBibleService keeps downloaded ESV verses in the App Group suite the Lock Screen widget
// reads, and downloads over the network. Every test gives it a scratch UserDefaults suite
// and, where it downloads, a URLSession whose requests StubURLProtocol answers, so no test
// touches the widget's store or spends the shared API key. The live download test at the
// end is the exception, and runs only when asked for (see liveAPITestsEnabled).
//
// Tests build their own instances instead of using .shared: this suite runs inside the app
// (TEST_HOST), whose Info.plist carries the real ESV key.
@Suite("ESVBibleService", .serialized)
@MainActor
struct ESVBibleServiceTests {
    private let john316 = verse(43, 3, 16, ref: "John 3:16")
    private let genesis11 = verse(1, 1, 1, ref: "Gen 1:1")

    @Test func limitsMatchCrosswaysTermsAndTheSharedKeysBudget() {
        #expect(ESVBibleService.maxStoredVerses == 500)
        #expect(ESVBibleService.minimumFetchInterval == 48 * 60 * 60)
    }

    @Test func isConfiguredOnlyWithANonEmptyAPIKey() {
        #expect(ESVBibleService(apiKey: "", defaults: unwrittenDefaults()).isConfigured == false)
        #expect(ESVBibleService(apiKey: "test-key", defaults: unwrittenDefaults()).isConfigured == true)
    }

    @Test func oneRequestAsksForEveryVerseByIdAndFitsTheAPIsRequestLine() throws {
        let verses = (0..<ESVBibleService.maxVersesPerRequest).map { verse(66, 22, $0 % 21 + 1) }
        let request = try #require(ESVBibleService.request(for: verses, apiKey: "test-key"))
        let url = try #require(request.url)

        // The API refuses a request line over 4,094 bytes; the whole URL stands in generously.
        #expect(url.absoluteString.utf8.count + "GET  HTTP/1.1".utf8.count < 4_094)
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Token test-key")
        let ids = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first { $0.name == "q" }?.value
        #expect(ids?.hasPrefix("66022001,66022002,66022003") == true)
    }

    @Test func verseTextDropsTheNumberWhatComesBeforeItAndPoetryLayout() {
        #expect(ESVBibleService.verseText(fromPassage: "A Psalm of David.\n\n    [1] The LORD is my shepherd; I shall not want.\n    \n\n")
            == "The LORD is my shepherd; I shall not want.")
        #expect(ESVBibleService.verseText(fromPassage: "Nun\n\n    [105] Your word is a lamp to my feet\n        and a light to my path.\n")
            == "Your word is a lamp to my feet and a light to my path.")
        #expect(ESVBibleService.verseText(fromPassage: "  [16] “For God so loved the world.”\n\n") == "“For God so loved the world.”")
    }

    @Test func downloadedVersesAreKeyedByTheirRequestedReferenceAndWidenedPassagesAreDropped() throws {
        // The ESV omits Matthew 17:21, so the API answers with verses 20 to 22 instead.
        let omitted = verse(40, 17, 21, ref: "Matt 17:21")
        let data = esvResponse([
            (43003016, 43003016, "John 3:16", "  [16] For God so loved the world.\n\n"),
            (40017020, 40017022, "Matthew 17:20–22", "  [20] He said to them. [22] As they were gathering.\n\n")
        ])

        let verses = try ESVBibleService.verses(from: data, requested: [john316, omitted])

        #expect(verses.keys.sorted() == ["John 3:16"])
        #expect(verses["John 3:16"]?.ref == "John 3:16")
        #expect(verses["John 3:16"]?.text == "For God so loved the world.")
    }

    @Test func allowanceStopsAtHalfOfABookAndAt500VersesCountingFavorites() {
        // Jude has 25 verses, so 12 may be kept, and one is already a favorite.
        var jude = ESVBibleService.Allowance(keptBookIds: [65], bookVerseCounts: [65: 25])
        #expect((0..<20).filter { _ in jude.admit(bookId: 65) }.count == 11)

        var large = ESVBibleService.Allowance(keptBookIds: [19, 19, 19], bookVerseCounts: [19: 2_461, 20: 915, 23: 1_292])
        #expect((0..<600).filter { large.admit(bookId: [19, 20, 23][$0 % 3]) }.count == 497)
    }

    @Test func plannedVersesFollowTheModeFromNowWithinCrosswaysLimits() throws {
        let now = try #require(Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 1, hour: 9)))
        var reading = WidgetSettings.defaultSettings
        reading.activeMode = .chapter
        reading.translationCode = "ESV"
        reading.chapterBookId = 65
        reading.chapterNumber = 1

        let plan = withScratchSuite([
            AppGroupSettings.Keys.chapterEndBehavior: WidgetSettings.ChapterEndBehavior.nextChapter.rawValue,
            AppGroupSettings.Keys.chapterStartDate: now
        ]) { defaults in
            ESVBibleService.plannedVerses(settings: reading, favorites: [], from: now, defaults: defaults)
        }

        // Reading from Jude on into Revelation: half of each book at most.
        let bookVerseCounts = ScriptureDatabase.shared.bookVerseCounts(translationCode: "KJV")
        #expect(plan.first?.verseRef == "Jude 1:1")
        #expect(plan.filter { $0.bookId == 65 }.count == 12)
        #expect(plan.filter { $0.bookId == 66 }.count == 202)
        #expect(plan.count <= ESVBibleService.maxStoredVerses)
        #expect(Dictionary(grouping: plan, by: \.bookId).allSatisfy { $0.value.count <= bookVerseCounts[$0.key, default: 0] / 2 })
        #expect(plan.allSatisfy { $0.translationCode == "KJV" })
    }

    @Test func aDownloadKeepsThePlannedVersesInOrderAndStartsThe48HourWait() async {
        await withScratchStore { defaults in
            StubURLProtocol.stub(host: "api.esv.org") { request in
                (response(to: request), esvResponse([
                    (43003016, 43003016, "John 3:16", "  [16] For God so loved the world.\n\n"),
                    (1001001, 1001001, "Genesis 1:1", "  [1] In the beginning.\n\n")
                ]))
            }
            let service = ESVBibleService(apiKey: "test-key", defaults: defaults, session: StubURLProtocol.session())
            let now = Date()

            await service.update(with: [genesis11, john316], now: now)

            #expect(service.error == nil)
            #expect(service.verses.map(\.fetchedRef) == ["Gen 1:1", "John 3:16"])
            #expect(service.cachedVerse(for: "Gen 1:1")?.text == "In the beginning.")
            #expect(service.lastFetchDate == now)
            #expect(LiveCachedVerse.storedESVVerses(in: defaults).map(\.fetchedRef) == ["Gen 1:1", "John 3:16"])
            #expect(StubURLProtocol.requestCount(host: "api.esv.org") == 1)
        }
    }

    @Test func noDownloadStartsWithin48HoursOfTheLastOne() async {
        await withScratchStore { defaults in
            StubURLProtocol.stub(host: "api.esv.org") { request in
                (response(to: request), esvResponse([(43003016, 43003016, "John 3:16", "[16] For God so loved the world.")]))
            }
            let service = ESVBibleService(apiKey: "test-key", defaults: defaults, session: StubURLProtocol.session())
            let start = Date()

            await service.update(with: [john316], now: start)
            await service.update(with: [john316, genesis11], now: start.addingTimeInterval(47 * 60 * 60))
            #expect(StubURLProtocol.requestCount(host: "api.esv.org") == 1)

            await service.update(with: [john316, genesis11], now: start.addingTimeInterval(48 * 60 * 60))
            #expect(StubURLProtocol.requestCount(host: "api.esv.org") == 2)
        }
    }

    @Test func nothingIsRequestedWhenEveryPlannedVerseIsAlreadyHere() async {
        await withScratchStore { defaults in
            StubURLProtocol.stub(host: "api.esv.org") { request in
                (response(to: request), esvResponse([(43003016, 43003016, "John 3:16", "[16] For God so loved the world.")]))
            }
            let service = ESVBibleService(apiKey: "test-key", defaults: defaults, session: StubURLProtocol.session())
            let start = Date()

            await service.update(with: [john316], now: start)
            await service.update(with: [john316], now: start.addingTimeInterval(49 * 60 * 60))

            #expect(StubURLProtocol.requestCount(host: "api.esv.org") == 1)
            #expect(service.lastFetchDate == start)
        }
    }

    @Test func aRefusedRequestIsReportedAndStillWaits48Hours() async {
        await withScratchStore { defaults in
            StubURLProtocol.stub(host: "api.esv.org") { request in (response(to: request, status: 429), Data()) }
            let service = ESVBibleService(apiKey: "test-key", defaults: defaults, session: StubURLProtocol.session())
            let now = Date()

            await service.update(with: [john316], now: now)

            #expect(service.error == "The ESV service is busy. More ESV verses will download later.")
            #expect(service.lastFetchDate == now)
            #expect(service.verses.isEmpty)
        }
    }

    @Test func beingOfflineDoesNotStartThe48HourWait() async {
        await withScratchStore { defaults in
            StubURLProtocol.stub(host: "api.esv.org") { _ in throw URLError(.notConnectedToInternet) }
            let service = ESVBibleService(apiKey: "test-key", defaults: defaults, session: StubURLProtocol.session())

            await service.update(with: [john316], now: Date())

            #expect(service.error == "Could not download ESV verses. Check your connection.")
            #expect(service.lastFetchDate == nil)
        }
    }

    @Test(.enabled(if: liveAPITestsEnabled))
    func liveDownloadReturnsTheESVTextOfJohn316AndPsalm23() async throws {
        let key = try #require(Bundle.main.infoDictionary?["ESVApiKey"] as? String)
        try #require(!key.isEmpty)
        let database = ScriptureDatabase.shared
        let john = try #require(database.verse(verseRef: "John 3:16", translationCode: "KJV"))
        let psalm = try #require(database.verse(verseRef: "Ps 23:1", translationCode: "KJV"))

        await withScratchStore { defaults in
            let service = ESVBibleService(apiKey: key, defaults: defaults)

            await service.update(with: [john, psalm], now: Date())

            #expect(service.error == nil)
            #expect(service.cachedVerse(for: "John 3:16")?.text.hasPrefix("“For God so loved the world") == true)
            #expect(service.cachedVerse(for: "Ps 23:1")?.text == "The LORD is my shepherd; I shall not want.")
        }
    }
}

/// Tests that call the real APIs run only on request, since each run spends the shared
/// keys' quota: `TEST_RUNNER_LIVE_API_TESTS=1 xcodebuild test …`.
let liveAPITestsEnabled = ProcessInfo.processInfo.environment["LIVE_API_TESTS"] == "1"

/// Answers requests to a host with a canned response, so a service's network path runs
/// without the network. Handlers are keyed by host because the ESV and Recovery Version
/// suites run alongside each other, each serialized within itself.
final class StubURLProtocol: URLProtocol {
    typealias Handler = (URLRequest) throws -> (HTTPURLResponse, Data)

    private static let lock = NSLock()
    private static var handlers: [String: Handler] = [:]
    private static var requestCounts: [String: Int] = [:]

    static func stub(host: String, _ handler: @escaping Handler) {
        lock.withLock {
            handlers[host] = handler
            requestCounts[host] = 0
        }
    }

    static func requestCount(host: String) -> Int {
        lock.withLock { requestCounts[host, default: 0] }
    }

    static func session() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let host = request.url?.host ?? ""
        let handler = Self.lock.withLock { () -> Handler? in
            Self.requestCounts[host, default: 0] += 1
            return Self.handlers[host]
        }
        do {
            guard let handler else { throw URLError(.unsupportedURL) }
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

func response(to request: URLRequest, status: Int = 200) -> HTTPURLResponse {
    HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!
}

/// A verse record carrying just what a download needs.
private func verse(_ bookId: Int, _ chapter: Int, _ verse: Int, ref: String? = nil) -> SharedVerseRecord {
    SharedVerseRecord(
        id: bookId * 1_000_000 + chapter * 1_000 + verse, translationId: 1, translationCode: "KJV",
        bookId: bookId, bookName: "", chapter: chapter, verse: verse, verseRef: ref ?? "\(bookId) \(chapter):\(verse)",
        text: "", charCount: 0, wordCount: 0, fitCategory: "short", excerpt: "", segmentCount: 1
    )
}

/// An ESV API response holding one passage per (first verse id, last verse id, canonical reference, text).
private func esvResponse(_ passages: [(Int, Int, String, String)]) -> Data {
    try! JSONSerialization.data(withJSONObject: [
        "query": "",
        "canonical": "",
        "parsed": passages.map { [$0.0, $0.1] },
        "passage_meta": passages.map { ["canonical": $0.2] },
        "passages": passages.map(\.3)
    ])
}

// A suite nothing writes to.
private func unwrittenDefaults() -> UserDefaults {
    UserDefaults(suiteName: "ESVBibleServiceTests.\(UUID().uuidString)")!
}

// A throwaway suite holding `values`, removed once `body` returns.
private func withScratchSuite<T>(_ values: [String: Any], _ body: (UserDefaults) -> T) -> T {
    let name = "ESVBibleServiceTests.\(UUID().uuidString)"
    let defaults = UserDefaults(suiteName: name)!
    defer { UserDefaults.standard.removePersistentDomain(forName: name) }
    values.forEach { defaults.set($0.value, forKey: $0.key) }
    return body(defaults)
}

// A throwaway store for a service to write to, removed once `body` finishes.
@MainActor
private func withScratchStore(_ body: (UserDefaults) async -> Void) async {
    let name = "ESVBibleServiceTests.\(UUID().uuidString)"
    let defaults = UserDefaults(suiteName: name)!
    await body(defaults)
    UserDefaults.standard.removePersistentDomain(forName: name)
}
