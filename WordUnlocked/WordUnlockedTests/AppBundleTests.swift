import Testing
import Foundation
@testable import WordUnlocked

// What must never ship. These run inside the app (TEST_HOST), so Bundle.main is the built app.
@Suite("AppBundle")
struct AppBundleTests {

    @Test func theAppAsksForNoExceptionToSecureConnections() {
        #expect(Bundle.main.object(forInfoDictionaryKey: "NSAppTransportSecurity") == nil)
    }

    @Test func theAPIKeysAreNotInInfoPlist() {
        for key in ["ESV_API_KEY", "LSM_APP_ID", "LSM_TOKEN"] {
            #expect(Bundle.main.object(forInfoDictionaryKey: key) == nil, "\(key)")
        }
    }

    @Test func neitherTheKeysNorTheSeedTextAreCopiedIntoTheApp() {
        #expect(Bundle.main.url(forResource: "Secrets", withExtension: "xcconfig") == nil)
        // The local Recovery Version test file among them: LSM's terms forbid shipping its text.
        let seedFiles = (Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) ?? [])
            .filter { $0.lastPathComponent.hasPrefix("seed_") }
        #expect(seedFiles.isEmpty)
    }

    @Test func theDatabaseHoldsNoLicensedTextAndOffersNoLicensedTranslation() {
        for code in VerseSelectionService.liveTranslationCodes {
            #expect(ScriptureDatabase.shared.verseCount(translationCode: code) == 0, "\(code)")
        }
        let codes = Set(ScriptureDatabase.shared.translations().map(\.code))
        #expect(codes.isDisjoint(with: VerseSelectionService.liveTranslationCodes))
    }
}
