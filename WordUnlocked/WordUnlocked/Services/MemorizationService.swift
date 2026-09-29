import Foundation

/// How a memorization plan shows its verse: the whole verse at first, then with words
/// blanked out, then only first letters, then only the reference, then the whole verse again
/// for review. The app and the Lock Screen widget both show it this way.
enum MemorizationService {
    /// The phase `plan` is in on `date`, counted in local calendar days from its start.
    static func phase(of plan: MemorizationPlan, on date: Date = Date(), calendar: Calendar = .current) -> MemorizationPlan.Phase {
        guard plan.enabled else { return .review }
        let days = calendar.dateComponents(
            [.day], from: calendar.startOfDay(for: plan.startDate), to: calendar.startOfDay(for: date)
        ).day ?? 0
        let progress = Double(max(days, 0)) / Double(max(plan.durationDays, 1))

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

    /// `text` as `phase` shows it, or nil when the phase shows only the reference.
    static func text(_ text: String, in phase: MemorizationPlan.Phase, difficulty: MemorizationPlan.Difficulty) -> String? {
        switch phase {
        case .fullVerse, .review:
            return text
        case .partialBlank:
            return partialBlank(text, difficulty: difficulty)
        case .firstLetters:
            return LongVerseService.firstLetters(from: text)
        case .referenceOnly:
            return nil
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
