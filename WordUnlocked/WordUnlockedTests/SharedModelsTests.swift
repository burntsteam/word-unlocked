import Testing
import Foundation
@testable import WordUnlocked

// LiveCachedVerse (defined in Shared/Models/SharedModels.swift) is exactly what
// ESVBibleService writes to the App Group and the widget reads back. Both read it with
// `try? JSONDecoder().decode(...)`, so a decode failure is swallowed and the downloaded
// verses silently come back empty. These tests lock down the wire format so that failure
// mode would show up here first.
@Suite("LiveCachedVerse decoding")
struct SharedModelsTests {

    @Test func singleVerseRoundTripsThroughJSON() throws {
        let original = LiveCachedVerse(ref: "John 3:16", text: "For God so loved the world...", fetchedRef: "John 3:16")

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(LiveCachedVerse.self, from: data)

        #expect(decoded.ref == original.ref)
        #expect(decoded.text == original.text)
        #expect(decoded.fetchedRef == original.fetchedRef)
    }

    @Test func storedVersesReadBackWhatWasWrittenAndNothingFromCorruptData() throws {
        // The exact on-disk shape ESVBibleService writes: [LiveCachedVerse].
        let name = "SharedModelsTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: name))
        defer { UserDefaults.standard.removePersistentDomain(forName: name) }
        let original = [
            LiveCachedVerse(ref: "Psalm 23:1", text: "Text A", fetchedRef: "Ps 23:1"),
            LiveCachedVerse(ref: "Romans 8:28", text: "Text B", fetchedRef: "Rom 8:28")
        ]

        defaults.set(try JSONEncoder().encode(original), forKey: AppGroupSettings.Keys.esvVerseCache)
        let decoded = LiveCachedVerse.storedESVVerses(in: defaults)
        #expect(decoded.map(\.fetchedRef) == ["Ps 23:1", "Rom 8:28"])
        #expect(decoded.map(\.text) == ["Text A", "Text B"])

        defaults.set(Data("not json".utf8), forKey: AppGroupSettings.Keys.esvVerseCache)
        #expect(LiveCachedVerse.storedESVVerses(in: defaults).isEmpty)
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
        // Documents the exact failure mode storedESVVerses(in:) guards against with `try?`:
        // a shape mismatch throws DecodingError, which is swallowed, and the downloaded
        // verses silently come back empty.
        let json = """
        {"ref":"John 3:16","text":"For God so loved the world..."}
        """

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(LiveCachedVerse.self, from: Data(json.utf8))
        }
    }
}
