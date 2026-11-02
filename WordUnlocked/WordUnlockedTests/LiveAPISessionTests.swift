import Testing
import Foundation
@testable import WordUnlocked

// What the session both live translations use will and won't do with a request carrying an
// API key. Requests go to RedirectingURLProtocol, never the network.
@Suite("LiveAPISession", .serialized)
struct LiveAPISessionTests {
    private let origin = URL(string: "https://api.esv.org/v3/passage/text/")

    @Test func aRedirectIsFollowedOnlyOnTheSameHostOverHTTPS() {
        #expect(LiveAPISession.allowsRedirect(from: origin, to: URL(string: "https://api.esv.org/v3/passage/text")))
        #expect(LiveAPISession.allowsRedirect(from: origin, to: URL(string: "https://API.ESV.org/other")))
        #expect(!LiveAPISession.allowsRedirect(from: origin, to: URL(string: "http://api.esv.org/v3/passage/text/")))
        #expect(!LiveAPISession.allowsRedirect(from: origin, to: URL(string: "https://elsewhere.example/steal")))
        #expect(!LiveAPISession.allowsRedirect(from: origin, to: URL(string: "https://api.esv.org.elsewhere.example/")))
        #expect(!LiveAPISession.allowsRedirect(from: origin, to: nil))
        #expect(!LiveAPISession.allowsRedirect(from: nil, to: origin))
    }

    @Test func theGuardStopsARedirectToAnotherHostBeforeTheKeyReachesIt() async throws {
        let request = try #require(ESVBibleService.request(for: [verse], apiKey: "test-key"))
        let configuration = LiveAPISession.configuration
        configuration.protocolClasses = [RedirectingURLProtocol.self]

        // Without the guard the same redirect is followed, key and all, so this test can fail.
        RedirectingURLProtocol.reset()
        _ = try await URLSession(configuration: configuration).data(for: request)
        #expect(RedirectingURLProtocol.keysSeenElsewhere == ["Token test-key"])

        RedirectingURLProtocol.reset()
        let guarded = URLSession(configuration: configuration, delegate: RedirectGuard(), delegateQueue: nil)
        let (_, response) = try await guarded.data(for: request)
        #expect(RedirectingURLProtocol.keysSeenElsewhere.isEmpty)
        #expect((response as? HTTPURLResponse)?.statusCode == 302)
    }

    @Test func theSessionKeepsNothingBetweenRequests() {
        let configuration = LiveAPISession.shared.configuration

        #expect(configuration.urlCache == nil)
        #expect(configuration.httpCookieStorage == nil)
        #expect(configuration.urlCredentialStorage == nil)
        #expect(configuration.httpShouldSetCookies == false)
        #expect(configuration.timeoutIntervalForResource == 60)
        #expect(LiveAPISession.shared.delegate is RedirectGuard)
    }

    private var verse: SharedVerseRecord {
        SharedVerseRecord(
            id: 212, translationId: 1, translationCode: "KJV", bookId: 43, bookName: "John", chapter: 3, verse: 16,
            verseRef: "John 3:16", text: "", charCount: 0, wordCount: 0, fitCategory: "short", excerpt: "", segmentCount: 1
        )
    }
}

/// Redirects every request for api.esv.org to another host, and records the Authorization
/// header of any request that gets there.
final class RedirectingURLProtocol: URLProtocol {
    private static let lock = NSLock()
    private nonisolated(unsafe) static var keys: [String] = []

    static var keysSeenElsewhere: [String] { lock.withLock { keys } }
    static func reset() { lock.withLock { keys = [] } }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let url = request.url else { return }
        if url.host == "api.esv.org" {
            let response = HTTPURLResponse(url: url, statusCode: 302, httpVersion: nil, headerFields: ["Location": "https://elsewhere.example/"])!
            var redirect = request
            redirect.url = URL(string: "https://elsewhere.example/")
            client?.urlProtocol(self, wasRedirectedTo: redirect, redirectResponse: response)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        } else {
            Self.lock.withLock { Self.keys.append(request.value(forHTTPHeaderField: "Authorization") ?? "") }
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
