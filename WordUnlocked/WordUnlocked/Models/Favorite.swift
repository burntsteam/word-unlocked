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

