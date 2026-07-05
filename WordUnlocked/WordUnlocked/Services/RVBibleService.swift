import Foundation

// RVCachedVerse is defined in Shared/Models/SharedModels.swift (shared with widget extension).

@MainActor
final class RVBibleService: ObservableObject {
    static let shared = RVBibleService()

    @Published var isFetching = false
    @Published var error: String?
    @Published private(set) var cachedVerse: RVCachedVerse?

    private var appId: String {
        Bundle.main.infoDictionary?["LSMAppId"] as? String ?? ""
    }

    private var token: String {
        Bundle.main.infoDictionary?["LSMToken"] as? String ?? ""
    }

    private init() {
        if let data = AppGroupSettings.defaults.data(forKey: AppGroupSettings.Keys.rvCachedVerse) {
            if let verse = try? JSONDecoder().decode(RVCachedVerse.self, from: data) {
                cachedVerse = verse
            } else {
                AppGroupSettings.defaults.removeObject(forKey: AppGroupSettings.Keys.rvCachedVerse)
            }
        }
    }

    // Fetch a verse reference from the LSM API. Uses standard format: "John 3:16", "Rom. 8:28".
    func fetch(reference: String) async {
        #if DEBUG
        if let local = ScriptureDatabase.shared.verse(verseRef: reference, translationCode: "RV") {
            let verse = RVCachedVerse(ref: local.verseRef, text: local.text, fetchedRef: reference)
            cachedVerse = verse
            if let encoded = try? JSONEncoder().encode(verse) {
                AppGroupSettings.defaults.set(encoded, forKey: AppGroupSettings.Keys.rvCachedVerse)
            }
            return
        }
        #endif
        error = nil
        guard !isFetching else { return }
        guard !token.isEmpty else {
            error = "LSM API not configured."
            return
        }

        isFetching = true
        defer { isFetching = false }

        let encoded = reference.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? reference
        guard let url = URL(string: "https://api.lsm.org/recver/txo.php?String=\(encoded)&Out=json") else {
            error = "Invalid URL."
            return
        }

        var request = URLRequest(url: url, timeoutInterval: 15)
        let credential = appId.isEmpty ? "\(token):" : "\(appId):\(token)"
        if let credData = credential.data(using: .utf8) {
            request.setValue("Basic \(credData.base64EncodedString())", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                error = "Could not load verse. Check your connection."
                return
            }
            if http.statusCode == 401 || http.statusCode == 403 {
                error = "LSM API credentials rejected. Check your configuration."
                return
            }
            guard (200...299).contains(http.statusCode) else {
                error = "Could not load verse. Check your connection."
                return
            }
            let decoded = try JSONDecoder().decode(LSMResponse.self, from: data)
            guard let first = decoded.verses.first, !first.text.isEmpty else {
                error = "Verse not available."
                return
            }
            let verse = RVCachedVerse(ref: first.ref, text: first.text, fetchedRef: reference)
            cachedVerse = verse
            if let encoded = try? JSONEncoder().encode(verse) {
                AppGroupSettings.defaults.set(encoded, forKey: AppGroupSettings.Keys.rvCachedVerse)
            }
        } catch is CancellationError {
        } catch {
            self.error = "Could not load verse: \(error.localizedDescription)"
        }
    }
}

private struct LSMResponse: Decodable {
    let verses: [LSMVerse]
}

private struct LSMVerse: Decodable {
    let ref: String
    let text: String
}
