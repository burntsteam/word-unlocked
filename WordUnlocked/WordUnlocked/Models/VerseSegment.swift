import Foundation

struct VerseSegment: Identifiable, Codable, Equatable {
    let id: String
    let verseId: Int
    let index: Int
    let totalCount: Int
    let text: String

    var progressText: String {
        "\(index + 1)/\(totalCount)"
    }
}

