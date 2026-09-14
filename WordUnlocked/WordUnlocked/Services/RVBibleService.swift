import Foundation

// Loads Recovery Version verses from Living Stream Ministry's API (https://api.lsm.org).
// LSM's terms of use forbid storing any amount of the text for offline use, so a verse is
// held in memory while the app runs and never written anywhere; the Lock Screen widget and
// wallpapers show the reference translation instead. Each response carries the
// attribution LSM requires beside the verse.
@MainActor
final class RVBibleService: ObservableObject {
    static let shared = RVBibleService(
        appId: Bundle.main.infoDictionary?["LSMAppId"] as? String ?? "",
        token: Bundle.main.infoDictionary?["LSMToken"] as? String ?? ""
    )

    /// LSM's attribution statement as the API returned it on 2026-09-14, for a response that
    /// doesn't carry one. LSM may change it, so a verse shows the one from its own response.
    nonisolated static let defaultAttribution =
        "Holy Bible Recovery Version (text-only edition) © 2025 Living Stream Ministry www.lsm.org"

    struct LoadedVerse: Equatable {
        let ref: String
        let text: String
        let attribution: String
    }

    @Published private(set) var isFetching = false
    @Published private(set) var error: String?
    /// Verses loaded this session, by the reference they were requested for. Memory only.
    @Published private(set) var loadedVerses: [String: LoadedVerse] = [:]

    private let appId: String
    private let token: String
    private let session: URLSession
    private var inFlightReference: String?

    var isConfigured: Bool { !token.isEmpty }

    // Takes its credentials and session so tests can run it unconfigured or against a stubbed network.
    init(appId: String, token: String, session: URLSession = .shared) {
        self.appId = appId
        self.token = token
        self.session = session
    }

    func verse(for reference: String) -> LoadedVerse? {
        loadedVerses[reference]
    }

    // Fetch a verse reference from the LSM API. Uses standard format: "John 3:16", "Rom. 8:28".
    // A verse already loaded this session never reaches the network again.
    func fetch(reference: String) async {
        guard loadedVerses[reference] == nil else {
            error = nil
            return
        }
        guard reference != inFlightReference else { return }
        error = nil
        guard isConfigured else {
            error = "LSM API not configured."
            return
        }
        guard let request = Self.request(for: reference, appId: appId, token: token) else {
            error = "Invalid URL."
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

        do {
            let (data, response) = try await session.data(for: request)
            switch (response as? HTTPURLResponse)?.statusCode ?? 0 {
            case 200...299:
                guard let verse = try Self.verse(from: data) else {
                    report("Verse not available.", for: reference)
                    return
                }
                loadedVerses[reference] = verse
            case 401, 403:
                report("LSM API credentials rejected. Check your configuration.", for: reference)
            case 429:
                report("The Recovery Version service is busy. Try again later.", for: reference)
            default:
                report("Could not load verse. Check your connection.", for: reference)
            }
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

    nonisolated static func request(for reference: String, appId: String, token: String) -> URLRequest? {
        var components = URLComponents(string: "https://api.lsm.org/recver/txo.php")
        components?.queryItems = [
            URLQueryItem(name: "String", value: reference),
            URLQueryItem(name: "Out", value: "json")
        ]
        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url, timeoutInterval: 15)
        let credential = appId.isEmpty ? "\(token):" : "\(appId):\(token)"
        request.setValue("Basic \(Data(credential.utf8).base64EncodedString())", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    /// The first verse of an LSM response, with the attribution LSM asks apps to show beside it.
    nonisolated static func verse(from data: Data) throws -> LoadedVerse? {
        let response = try JSONDecoder().decode(LSMResponse.self, from: data)
        guard let first = response.verses.first, !first.text.isEmpty else { return nil }
        let attribution = response.copyright?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return LoadedVerse(ref: first.ref, text: first.text, attribution: attribution.isEmpty ? defaultAttribution : attribution)
    }
}

private struct LSMResponse: Decodable {
    let verses: [LSMVerse]
    let copyright: String?
}

private struct LSMVerse: Decodable {
    let ref: String
    let text: String
}
