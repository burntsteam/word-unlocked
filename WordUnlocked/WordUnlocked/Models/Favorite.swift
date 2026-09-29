import Foundation

struct Favorite: Identifiable, Codable, Equatable {
    let id: UUID
    let verseId: Int
    let verseRef: String
    let text: String
    let translationCode: String
    let addedAt: Date

    init(id: UUID = UUID(), verseId: Int, verseRef: String, text: String, translationCode: String, addedAt: Date = Date()) {
        self.id = id
        self.verseId = verseId
        self.verseRef = verseRef
        self.text = text
        self.translationCode = translationCode
        self.addedAt = addedAt
    }
}

extension Favorite {
    /// The favorites saved in `defaults`. A favorite that can't be read is skipped, so one
    /// damaged entry or a future format change never costs the others.
    static func saved(in defaults: UserDefaults) -> [Favorite] {
        guard let data = defaults.data(forKey: AppGroupSettings.Keys.favorites),
              let entries = try? JSONDecoder().decode([Lossy<Favorite>].self, from: data) else {
            return []
        }
        return entries.compactMap(\.value)
    }
}

/// Decodes a value, or nil when that one value can't be read.
private struct Lossy<Value: Decodable>: Decodable {
    let value: Value?

    init(from decoder: Decoder) throws {
        value = try? Value(from: decoder)
    }
}
