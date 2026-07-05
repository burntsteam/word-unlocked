import Foundation

struct Topic: Identifiable, Codable, Equatable {
    let id: Int
    let slug: String
    let name: String
    let symbolName: String
    let summary: String
}

