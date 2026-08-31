import Foundation

// Fetches verses live from the Crossway ESV API (https://api.esv.org).
// ESV text is licensed: the API license permits caching UP TO 500 verses
// locally, so we keep a bounded rolling cache (oldest evicted past the cap) for
// offline reading of recently-opened verses. Anything not cached is fetched
// live; with no connection, callers fall back to public-domain KJV.
@MainActor
final class ESVBibleService: ObservableObject {
    static let shared = ESVBibleService()

    // Crossway's ESV API license cap on local storage.
    static let maxCacheCount = 500

    @Published var isFetching = false
    @Published var error: String?
    @Published private(set) var cache: [LiveCachedVerse] = []   // oldest first, <= maxCacheCount

    private var apiKey: String {
        Bundle.main.infoDictionary?["ESVApiKey"] as? String ?? ""
    }

    // ESV_API_KEY is supplied at build time via Config/Secrets.xcconfig. When it is
    // absent every fetch dead-ends on the guard below, so the UI hides the translation
    // rather than offering a choice that can only ever produce an error.
    static var isConfigured: Bool {
        !((Bundle.main.infoDictionary?["ESVApiKey"] as? String) ?? "").isEmpty
    }

    private init() {
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
    func fetch(reference: String) async {
        error = nil
        guard !isFetching else { return }
        guard !apiKey.isEmpty else {
            error = "ESV API key not configured."
            return
        }

        isFetching = true
        defer { isFetching = false }

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
            error = "Invalid URL."
            return
        }

        var request = URLRequest(url: url, timeoutInterval: 15)
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                error = "Could not load verse. Check your connection."
                return
            }
            if http.statusCode == 401 || http.statusCode == 403 {
                error = "ESV API key rejected. Check your configuration."
                return
            }
            guard (200...299).contains(http.statusCode) else {
                error = "Could not load verse. Check your connection."
                return
            }
            let decoded = try JSONDecoder().decode(ESVResponse.self, from: data)
            let text = (decoded.passages.first ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let ref = decoded.canonical.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !text.isEmpty, !ref.isEmpty else {
                error = "Verse not available."
                return
            }
            store(LiveCachedVerse(ref: ref, text: text, fetchedRef: reference))
        } catch is CancellationError {
        } catch {
            self.error = "Could not load verse: \(error.localizedDescription)"
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
