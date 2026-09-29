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

    /// A short line for Today and the widget saying what this phase asks of you.
    var caption: String {
        switch self {
        case .fullVerse: "Read it through"
        case .partialBlank: "Fill in the blanks"
        case .firstLetters: "First letters"
        case .referenceOnly: "Recite it from memory"
        case .review: "Review"
        }
    }
}

extension MemorizationPlan {
    /// A plan for `verseId` from its first step. A plan is known by its verse's id.
    init(verseId: Int, durationDays: Int, difficulty: Difficulty, startDate: Date = Date()) {
        self.init(
            id: verseId, verseId: verseId, startDate: startDate, durationDays: durationDays,
            difficulty: difficulty, currentPhase: .fullVerse, enabled: true
        )
    }

    /// The plan saved in `defaults`, if there is one that can be read.
    static func saved(in defaults: UserDefaults) -> MemorizationPlan? {
        guard let data = defaults.data(forKey: AppGroupSettings.Keys.memorizationPlan) else { return nil }
        return try? JSONDecoder().decode(MemorizationPlan.self, from: data)
    }
}
