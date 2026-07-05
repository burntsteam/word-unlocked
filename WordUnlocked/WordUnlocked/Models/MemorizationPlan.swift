import Foundation

struct MemorizationPlan: Identifiable, Codable {
    let id: Int
    var verseId: Int
    var startDate: Date
    var durationDays: Int
    var difficulty: Difficulty
    var currentPhase: Phase
    var enabled: Bool

    enum Difficulty: String, Codable {
        case easy
        case medium
        case hard
    }

    enum Phase: Int, Codable {
        case fullVerse = 1
        case partialBlank = 2
        case firstLetters = 3
        case referenceOnly = 4
        case review = 5
    }
}

extension MemorizationPlan.Difficulty: CaseIterable, Identifiable {
    var id: String { rawValue }

    var title: String {
        switch self {
        case .easy: "Easy"
        case .medium: "Medium"
        case .hard: "Hard"
        }
    }
}

extension MemorizationPlan.Phase {
    var title: String {
        switch self {
        case .fullVerse: "Full Verse"
        case .partialBlank: "Partial Blank"
        case .firstLetters: "First Letters"
        case .referenceOnly: "Reference Only"
        case .review: "Review"
        }
    }
}

