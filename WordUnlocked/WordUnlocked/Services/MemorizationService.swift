import Foundation

enum MemorizationService {
    static func displayText(verse: Verse, plan: MemorizationPlan) -> String {
        let phase = currentPhase(plan: plan)
        switch phase {
        case .fullVerse:
            return verse.text
        case .partialBlank:
            return partialBlank(verse.text, difficulty: plan.difficulty)
        case .firstLetters:
            return LongVerseService.firstLetters(from: verse.text)
        case .referenceOnly:
            return verse.verseRef
        case .review:
            return verse.text
        }
    }

    static func currentPhase(plan: MemorizationPlan) -> MemorizationPlan.Phase {
        guard plan.enabled else { return .review }
        let elapsed = Calendar.current.dateComponents([.day], from: plan.startDate, to: Date()).day ?? 0
        let progress = Double(max(elapsed, 0)) / Double(max(plan.durationDays, 1))

        switch progress {
        case ..<0.2:
            return .fullVerse
        case ..<0.45:
            return .partialBlank
        case ..<0.7:
            return .firstLetters
        case ..<0.9:
            return .referenceOnly
        default:
            return .review
        }
    }

    static func partialBlank(_ text: String, difficulty: MemorizationPlan.Difficulty) -> String {
        let blankEvery: Int
        switch difficulty {
        case .easy:
            blankEvery = 5
        case .medium:
            blankEvery = 3
        case .hard:
            blankEvery = 2
        }

        return text
            .split(separator: " ")
            .enumerated()
            .map { index, word in
                (index + 1).isMultiple(of: blankEvery) ? String(repeating: "_", count: max(3, word.count)) : String(word)
            }
            .joined(separator: " ")
    }
}

