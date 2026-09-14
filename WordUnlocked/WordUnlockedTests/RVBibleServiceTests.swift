import Testing
import Foundation
@testable import WordUnlocked

// RVBibleService holds Recovery Version verses in memory only, because LSM's terms forbid
// storing the text. These tests answer its requests with StubURLProtocol (defined with the
// ESV tests), check that a loaded verse carries LSM's attribution and lands in no
// UserDefaults suite, and run the live request only when asked for (liveAPITestsEnabled).
@Suite("RVBibleService", .serialized)
@MainActor
struct RVBibleServiceTests {

    @Test func requestAsksForTheReferenceWithBasicAuthentication() throws {
        let request = try #require(RVBibleService.request(for: "John 3:16", appId: "app", token: "token"))

        #expect(request.value(forHTTPHeaderField: "Authorization") == "Basic \(Data("app:token".utf8).base64EncodedString())")
        let items = URLComponents(url: try #require(request.url), resolvingAgainstBaseURL: false)?.queryItems ?? []
        #expect(items.contains(URLQueryItem(name: "String", value: "John 3:16")))
        #expect(items.contains(URLQueryItem(name: "Out", value: "json")))
    }

    @Test func aLoadedVerseCarriesLSMsAttributionAndIsKeptInMemoryOnly() async {
        let text = "Stub Recovery Version text \(UUID().uuidString)"
        StubURLProtocol.stub(host: "api.lsm.org") { request in
            (response(to: request), lsmResponse(ref: "John 3:16", text: text, copyright: "Stub attribution"))
        }
        let service = RVBibleService(appId: "app", token: "token", session: StubURLProtocol.session())

        await service.fetch(reference: "John 3:16")

        #expect(service.error == nil)
        #expect(service.verse(for: "John 3:16") == RVBibleService.LoadedVerse(ref: "John 3:16", text: text, attribution: "Stub attribution"))
        for defaults in [AppGroupSettings.defaults, UserDefaults.standard] {
            #expect(!defaults.dictionaryRepresentation().values.contains { "\($0)".contains(text) })
        }

        // Looking at the same verse again is answered from memory.
        await service.fetch(reference: "John 3:16")
        #expect(StubURLProtocol.requestCount(host: "api.lsm.org") == 1)
    }

    @Test func rejectedCredentialsAreReported() async {
        StubURLProtocol.stub(host: "api.lsm.org") { request in (response(to: request, status: 401), Data()) }
        let service = RVBibleService(appId: "app", token: "token", session: StubURLProtocol.session())

        await service.fetch(reference: "John 3:16")

        #expect(service.error == "LSM API credentials rejected. Check your configuration.")
        #expect(service.verse(for: "John 3:16") == nil)
    }

    @Test func withoutATokenNothingIsRequested() async {
        StubURLProtocol.stub(host: "api.lsm.org") { request in (response(to: request), Data()) }
        let service = RVBibleService(appId: "app", token: "", session: StubURLProtocol.session())

        await service.fetch(reference: "John 3:16")

        #expect(service.error == "LSM API not configured.")
        #expect(StubURLProtocol.requestCount(host: "api.lsm.org") == 0)
    }

    @Test(.enabled(if: liveAPITestsEnabled))
    func liveFetchReturnsTheRecoveryVersionOfJohn316() async throws {
        let info = Bundle.main.infoDictionary
        let token = try #require(info?["LSMToken"] as? String)
        try #require(!token.isEmpty)
        let service = RVBibleService(appId: info?["LSMAppId"] as? String ?? "", token: token)

        await service.fetch(reference: "John 3:16")

        #expect(service.error == nil)
        #expect(service.verse(for: "John 3:16")?.text.hasPrefix("For God so loved the world") == true)
        #expect(service.verse(for: "John 3:16")?.attribution.contains("Living Stream Ministry") == true)
    }
}

private func lsmResponse(ref: String, text: String, copyright: String) -> Data {
    try! JSONSerialization.data(withJSONObject: [
        "inputstring": ref,
        "detected": ref,
        "verses": [["ref": ref, "text": text, "urlpfx": ""]],
        "message": "",
        "copyright": copyright
    ])
}
