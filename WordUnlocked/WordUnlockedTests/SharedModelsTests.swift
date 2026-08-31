import Testing
import Foundation
@testable import WordUnlocked

// LiveCachedVerse (and its RVCachedVerse alias, defined in
// Shared/Models/SharedModels.swift) is exactly what ESVBibleService and
// RVBibleService persist to AppGroupSettings via JSONEncoder/JSONDecoder. Both
// services load their cache with `try? JSONDecoder().decode(...)`, so a decode
// failure is swallowed silently and the cache just comes back empty on next
// launch. These tests lock down the wire format so that failure mode would
// show up here first.
@Suite("LiveCachedVerse / RVCachedVerse decoding")
struct SharedModelsTests {

    @Test func singleVerseRoundTripsThroughJSON() throws {
        let original = LiveCachedVerse(ref: "John 3:16", text: "For God so loved the world...", fetchedRef: "John 3:16")

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(LiveCachedVerse.self, from: data)

        #expect(decoded.ref == original.ref)
        #expect(decoded.text == original.text)
        #expect(decoded.fetchedRef == original.fetchedRef)
    }

    @Test func arrayOfVersesRoundTripsThroughJSON() throws {
        // This is the exact on-disk shape ESVBibleService persists: [LiveCachedVerse].
        let original = [
            LiveCachedVerse(ref: "John 3:16", text: "Text A", fetchedRef: "John 3:16"),
            LiveCachedVerse(ref: "Romans 8:28", text: "Text B", fetchedRef: "Rom. 8:28")
        ]

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode([LiveCachedVerse].self, from: data)

        #expect(decoded.count == 2)
        #expect(decoded.map(\.fetchedRef) == ["John 3:16", "Rom. 8:28"])
        #expect(decoded.map(\.text) == ["Text A", "Text B"])
    }

    @Test func rvCachedVerseRoundTripsThroughJSON() throws {
        // RVBibleService persists a single RVCachedVerse (not an array). It's a
        // `typealias` for LiveCachedVerse today, so this is really the same
        // round-trip as above -- kept as its own test so a future split of the
        // two types into distinct declarations gets caught here.
        let original = RVCachedVerse(ref: "Rom. 8:28", text: "And we know...", fetchedRef: "Rom. 8:28")

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(RVCachedVerse.self, from: data)

        #expect(decoded.ref == original.ref)
        #expect(decoded.text == original.text)
        #expect(decoded.fetchedRef == original.fetchedRef)
    }

    @Test func decodingLocksTheExpectedWireKeys() throws {
        // LiveCachedVerse has no explicit CodingKeys, so the property names ARE
        // the persisted JSON keys. A rename would silently change the format
        // that's already sitting in users' AppGroupSettings. Pin it here.
        let json = """
        {"ref":"John 3:16","text":"For God so loved the world...","fetchedRef":"Jn 3:16"}
        """

        let decoded = try JSONDecoder().decode(LiveCachedVerse.self, from: Data(json.utf8))

        #expect(decoded.ref == "John 3:16")
        #expect(decoded.text == "For God so loved the world...")
        #expect(decoded.fetchedRef == "Jn 3:16")
    }

    @Test func decodingFailsWhenARequiredKeyIsMissing() {
        // Documents the exact failure mode ESVBibleService.init() guards against
        // with `try?`: a shape mismatch throws DecodingError, which is swallowed,
        // and the persisted cache silently comes back empty on next launch.
        let json = """
        {"ref":"John 3:16","text":"For God so loved the world..."}
        """

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(LiveCachedVerse.self, from: Data(json.utf8))
        }
    }
}
