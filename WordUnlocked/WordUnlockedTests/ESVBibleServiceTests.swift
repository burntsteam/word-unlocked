import Testing
import Foundation
@testable import WordUnlocked

// ESVBibleService reads/writes a 500-verse rolling cache to AppGroupSettings (a
// shared UserDefaults suite) and fetches verses over the network. The network
// path is out of bounds for a unit test, so this suite covers the guard clauses
// in fetch(reference:), the read-only cachedVerse(for:) lookup, and the real
// eviction algorithm itself.
//
// The eviction rule is exercised through ESVBibleService.applyingStore(_:to:),
// a pure static function, so these tests never touch the shared App Group
// UserDefaults suite that the Lock Screen widget reads.
//
// Tests build their own keyless instance instead of using .shared: this suite
// runs inside the app (TEST_HOST), whose Info.plist carries the real ESV key,
// so the singleton would make live requests and persist the results to the
// widget's App Group store.
@Suite("ESVBibleService")
@MainActor
struct ESVBibleServiceTests {

    @Test func maxCacheCountMatchesTheESVLicenseCap() {
        // Crossway's ESV API license caps local storage at 500 verses; this
        // constant is the only thing enforcing that, so pin it directly.
        #expect(ESVBibleService.maxCacheCount == 500)
    }

    @Test func isConfiguredOnlyWithANonEmptyAPIKey() {
        // The same check gates the Translations row and fetch(reference:).
        #expect(ESVBibleService(apiKey: "").isConfigured == false)
        #expect(ESVBibleService(apiKey: "test-key").isConfigured == true)
    }

    @Test func cachedVerseReturnsNilForAReferenceThatWasNeverFetched() {
        let unknownReference = "Unfetched Reference \(UUID().uuidString)"
        #expect(ESVBibleService(apiKey: "").cachedVerse(for: unknownReference) == nil)
    }

    @Test func fetchWithoutAnAPIKeyFailsWithAConfigurationErrorAndNeverStartsFetching() async {
        let service = ESVBibleService(apiKey: "")

        // An empty key always takes fetch(reference:)'s early-return branch --
        // no network call is ever attempted here.
        await service.fetch(reference: "John 3:16")

        #expect(service.error == "ESV API key not configured.")
        #expect(service.isFetching == false)
    }

    @Test func fetchReturnsImmediatelyWhenAlreadyFetching() async {
        let service = ESVBibleService(apiKey: "")
        service.isFetching = true
        service.error = "sentinel"

        await service.fetch(reference: "John 3:16")

        // `error = nil` runs unconditionally at the top of fetch(reference:),
        // before the `isFetching` guard, so it's always cleared -- but the
        // guard itself must still return early without flipping isFetching.
        #expect(service.error == nil)
        #expect(service.isFetching == true)
    }

    // MARK: - eviction rule (pure, no persistence)

    @Test func applyingStoreUpsertsByFetchedRefInsteadOfDuplicating() {
        let a = LiveCachedVerse(ref: "John 3:16", text: "First text", fetchedRef: "A")
        let b = LiveCachedVerse(ref: "Romans 8:28", text: "Other text", fetchedRef: "B")

        var cache = ESVBibleService.applyingStore(a, to: [])
        cache = ESVBibleService.applyingStore(b, to: cache)
        #expect(cache.map(\.fetchedRef) == ["A", "B"])

        // Re-storing A must upsert in place, not append.
        let updated = LiveCachedVerse(ref: "John 3:16", text: "Updated text", fetchedRef: "A")
        cache = ESVBibleService.applyingStore(updated, to: cache)

        #expect(cache.count == 2)                       // no growth from the re-store
        #expect(cache.map(\.fetchedRef) == ["B", "A"])  // A moved to most-recent
        #expect(cache.last?.text == "Updated text")     // carrying the new text
    }

    @Test func applyingStoreEvictsExactlyTheOldestPastTheCapKeepingOldestFirst() {
        let cap = ESVBibleService.maxCacheCount
        let refs = (0..<cap).map { "ref-\($0)" }

        var cache: [LiveCachedVerse] = []
        for ref in refs {
            cache = ESVBibleService.applyingStore(
                LiveCachedVerse(ref: ref, text: ref, fetchedRef: ref), to: cache)
        }
        #expect(cache.map(\.fetchedRef) == refs)
        #expect(cache.count == cap)

        // One more entry evicts exactly the single oldest and lands at the end.
        let extra = LiveCachedVerse(ref: "extra", text: "extra", fetchedRef: "extra")
        cache = ESVBibleService.applyingStore(extra, to: cache)

        #expect(cache.count == cap)
        #expect(cache.map(\.fetchedRef) == Array(refs.dropFirst()) + ["extra"])
    }

    @Test func applyingStoreOnAnEmptyCacheYieldsASingleEntry() {
        let only = LiveCachedVerse(ref: "Ps 23:1", text: "t", fetchedRef: "only")
        #expect(ESVBibleService.applyingStore(only, to: []).map(\.fetchedRef) == ["only"])
    }
}

// MARK: - Still not covered
//
// fetch(reference:)'s network path and the JSON decoding of a live ESV
// response are not exercised here -- both require a real URLSession round
// trip. The persistence half of store(_:) (the AppGroupSettings write) is
// likewise uncovered by design: it stays private, and the logic worth
// testing was extracted into applyingStore(_:to:) above.
