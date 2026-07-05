import Foundation

struct Book: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let abbreviation: String
    let testament: Testament
    let chapterCount: Int

    enum Testament: String, Codable {
        case old
        case new
    }
}

