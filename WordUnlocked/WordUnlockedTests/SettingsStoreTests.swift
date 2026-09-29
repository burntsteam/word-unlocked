import Testing
import Foundation
@testable import WordUnlocked

// Saved favorites surviving what earlier builds and damaged data leave behind. Every store
// reads and writes a throwaway UserDefaults suite, never the App Group.
@Suite("SettingsStore", .serialized)
@MainActor
struct SettingsStoreTests {

    @Test func aFavoriteThatCantBeReadIsSkippedAndTheRestAreKeptUnchanged() throws {
        let good = Favorite(verseId: 44, verseRef: "Psalm 23:1", text: "The LORD is my shepherd; I shall not want.", translationCode: "KJV")
        var entries = try #require(try JSONSerialization.jsonObject(with: JSONEncoder().encode([good])) as? [Any])
        entries.append(["verseId": "not a number"])
        let data = try JSONSerialization.data(withJSONObject: entries)

        withScratchDefaults([AppGroupSettings.Keys.favorites: data]) { defaults in
            #expect(Favorite.saved(in: defaults) == [good])

            let store = SettingsStore(defaults: defaults)

            #expect(store.favorites == [good])
            // Nothing needed changing, so what was saved stays as it was.
            #expect(defaults.data(forKey: AppGroupSettings.Keys.favorites) == data)
        }
    }

    @Test func recoveryVersionFavoritesBecomeKingJamesAndReferencesAreWrittenOut() {
        let favorites = [
            Favorite(verseId: 212, verseRef: "John 3:16", text: "Recovery Version text", translationCode: "RV"),
            Favorite(verseId: 99_999_999, verseRef: "Nowhere 1:1", text: "Recovery Version text", translationCode: "RV"),
            Favorite(verseId: 44, verseRef: "Ps 23:1", text: "Saved text", translationCode: "KJV")
        ]

        let migrated = SettingsStore.migrated(favorites, database: .shared)

        #expect(migrated.map(\.verseId) == [212, 44])
        #expect(migrated.map(\.id) == [favorites[0].id, favorites[2].id])
        #expect(migrated[0].translationCode == "KJV")
        #expect(migrated[0].text == ScriptureDatabase.shared.verse(id: 212)?.text)
        #expect(migrated[1].verseRef == "Psalm 23:1")
        #expect(migrated[1].text == "Saved text")
    }

    @Test func launchingSavesMigratedFavoritesAndRemovesTheStoredRecoveryVersionVerse() throws {
        let favorites = [Favorite(verseId: 212, verseRef: "John 3:16", text: "Recovery Version text", translationCode: "RV")]
        let values: [String: Any] = [
            AppGroupSettings.Keys.favorites: try JSONEncoder().encode(favorites),
            "rvCachedVerse": Data("Recovery Version text".utf8)
        ]

        withScratchDefaults(values) { defaults in
            _ = SettingsStore(defaults: defaults)

            #expect(Favorite.saved(in: defaults).map(\.translationCode) == ["KJV"])
            #expect(defaults.object(forKey: "rvCachedVerse") == nil)
        }
    }

    @Test func aFavoriteKeepsTheTranslationOfItsOwnText() throws {
        let web = Verse(record: try #require(ScriptureDatabase.shared.verse(id: 2_000_001)))

        withScratchDefaults([:]) { defaults in
            let store = SettingsStore(defaults: defaults)

            store.toggleFavorite(web)
            #expect(store.favorites.map(\.translationCode) == ["WEB"])
            #expect(store.favorites.map(\.verseRef) == ["Genesis 1:1"])
            #expect(Favorite.saved(in: defaults) == store.favorites)

            store.toggleFavorite(web)
            #expect(store.favorites.isEmpty)
        }
    }

    @Test func reorderingFavoritesSavesTheNewOrder() {
        withScratchDefaults([:]) { defaults in
            let store = SettingsStore(defaults: defaults)
            for (id, ref) in [(1, "Genesis 1:1"), (44, "Psalm 23:1"), (212, "John 3:16")] {
                store.addFavorite(verseId: id, verseRef: ref, text: "", translationCode: "KJV")
            }

            store.moveFavorites(from: IndexSet(integer: 2), to: 0)

            #expect(store.favorites.map(\.verseId) == [212, 1, 44])
            #expect(Favorite.saved(in: defaults).map(\.verseId) == [212, 1, 44])
        }
    }
}
