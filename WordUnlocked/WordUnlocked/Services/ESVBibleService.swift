import Foundation

// Fetches verses live from the Crossway ESV API (https://api.esv.org).
// ESV text is licensed: the API license permits caching UP TO 500 verses
// locally, so we keep a bounded rolling cache (oldest evicted past the cap) for
// offline reading of recently-opened verses. Anything not cached is fetched
// live; with no connection, callers fall back to public-domain KJV.
@MainActor
final class ESVBibleService: ObservableObject {
    // ESV_API_KEY is supplied at build time via Config/Secrets.xcconfig.
    static let shared = ESVBibleService(
        apiKey: Bundle.main.infoDictionary?["ESVApiKey"] as? String ?? "")

    // Crossway's ESV API license cap on local storage.
    static let maxCacheCount = 500

    @Published var isFetching = false
    @Published var error: String?
    @Published private(set) var cache: [LiveCachedVerse] = []   // oldest first, <= maxCacheCount

    private let apiKey: String
    private var inFlightReference: String?

    // Without a key every fetch dead-ends on the guard below, so the UI hides the
    // translation rather than offering a choice that can only ever produce an error.
    static var isConfigured: Bool { shared.isConfigured }
    var isConfigured: Bool { !apiKey.isEmpty }

    // Takes the key as a parameter so tests can build an unconfigured instance
    // regardless of the key this build carries.
    init(apiKey: String) {
        self.apiKey = apiKey
        if let data = AppGroupSettings.defaults.data(forKey: AppGroupSettings.Keys.esvVerseCache),
           let decoded = try? JSONDecoder().decode([LiveCachedVerse].self, from: data) {
            cache = decoded
        }
    }

    // Returns the cached ESV text for a reference, if present (offline-safe).
    func cachedVerse(for reference: String) -> LiveCachedVerse? {
        cache.first { $0.fetchedRef == reference }
    }

    // Fetch a verse reference from the ESV API. Standard format: "John 3:16".
    // A cached reference never reaches the network: every install shares the key's quota.
    func fetch(reference: String) async {
        guard cachedVerse(for: reference) == nil else {
            error = nil
            return
        }
        guard reference != inFlightReference else { return }
        error = nil
        guard isConfigured else {
            error = "ESV API key not configured."
            return
        }

        inFlightReference = reference
        isFetching = true
        defer {
            if inFlightReference == reference {
                inFlightReference = nil
                isFetching = false
            }
        }

        var components = URLComponents(string: "https://api.esv.org/v3/passage/text/")
        components?.queryItems = [
            URLQueryItem(name: "q", value: reference),
            URLQueryItem(name: "include-passage-references", value: "false"),
            URLQueryItem(name: "include-verse-numbers", value: "false"),
            URLQueryItem(name: "include-first-verse-numbers", value: "false"),
            URLQueryItem(name: "include-footnotes", value: "false"),
            URLQueryItem(name: "include-headings", value: "false"),
            URLQueryItem(name: "include-short-copyright", value: "false"),
            URLQueryItem(name: "include-passage-horizontal-lines", value: "false"),
            URLQueryItem(name: "include-heading-horizontal-lines", value: "false")
        ]
        guard let url = components?.url else {
            report("Invalid URL.", for: reference)
            return
        }

        var request = URLRequest(url: url, timeoutInterval: 15)
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                report("Could not load verse. Check your connection.", for: reference)
                return
            }
            if http.statusCode == 401 || http.statusCode == 403 {
                report("ESV API key rejected. Check your configuration.", for: reference)
                return
            }
            if http.statusCode == 429 {
                report("The ESV service is busy. Try again later.", for: reference)
                return
            }
            guard (200...299).contains(http.statusCode) else {
                report("Could not load verse. Check your connection.", for: reference)
                return
            }
            let decoded = try JSONDecoder().decode(ESVResponse.self, from: data)
            let text = (decoded.passages.first ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let ref = decoded.canonical.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !text.isEmpty, !ref.isEmpty else {
                report("Verse not available.", for: reference)
                return
            }
            store(LiveCachedVerse(ref: ref, text: text, fetchedRef: reference))
        } catch is CancellationError {
        } catch let urlError as URLError where urlError.code == .cancelled {
        } catch {
            report("Could not load verse: \(error.localizedDescription)", for: reference)
        }
    }

    // Only the latest request may surface an error; a superseded one ends quietly.
    private func report(_ message: String, for reference: String) {
        if inFlightReference == reference {
            error = message
        }
    }

    // The eviction rule itself: upsert by fetchedRef, most-recent last, capped at
    // maxCacheCount. Kept pure and separate from persistence so tests can exercise it
    // without writing to the App Group suite the widget reads.
    static func applyingStore(_ verse: LiveCachedVerse,
                              to cache: [LiveCachedVerse]) -> [LiveCachedVerse] {
        var next = cache
        next.removeAll { $0.fetchedRef == verse.fetchedRef }
        next.append(verse)
        if next.count > maxCacheCount {
            next.removeFirst(next.count - maxCacheCount)
        }
        return next
    }

    private func store(_ verse: LiveCachedVerse) {
        cache = Self.applyingStore(verse, to: cache)
        if let data = try? JSONEncoder().encode(cache) {
            AppGroupSettings.defaults.set(data, forKey: AppGroupSettings.Keys.esvVerseCache)
        }
    }
}

private struct ESVResponse: Decodable {
    let canonical: String
    let passages: [String]
}
