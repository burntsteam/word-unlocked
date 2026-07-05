import Foundation

struct WeeklyPlan: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let topicSlug: String
    let startsOn: Date
    let verseIds: [Int]
    var enabled: Bool
}

