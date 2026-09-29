import Testing
import Foundation
@testable import WordUnlocked

@Suite("MemorizationService")
struct MemorizationServiceTests {

    @Test func aSevenDayPlanTakesOneStepPerLocalCalendarDay() {
        let calendar = Calendar.current
        // Started at 9 PM, so the second morning after is under 48 hours on, but day 2.
        let start = calendar.date(from: DateComponents(year: 2026, month: 9, day: 12, hour: 21))!
        let plan = MemorizationPlan(verseId: 212, durationDays: 7, difficulty: .medium, startDate: start)
        let phases = (0...7).map { day in
            let morning = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: day, to: start)!)!
            return MemorizationService.phase(of: plan, on: morning)
        }

        #expect(phases == [.fullVerse, .fullVerse, .partialBlank, .partialBlank, .firstLetters, .referenceOnly, .referenceOnly, .review])
    }

    @Test func aPausedPlanShowsTheWholeVerse() {
        var plan = MemorizationPlan(verseId: 212, durationDays: 7, difficulty: .medium, startDate: Date())
        plan.enabled = false

        #expect(MemorizationService.phase(of: plan) == .review)
    }

    @Test func eachStepShowsTheVerseItsOwnWay() {
        let text = "For God so loved the world"

        #expect(MemorizationService.text(text, in: .fullVerse, difficulty: .medium) == text)
        #expect(MemorizationService.text(text, in: .partialBlank, difficulty: .medium) == "For God ___ loved the _____")
        #expect(MemorizationService.text(text, in: .firstLetters, difficulty: .medium) == "F G S L T W")
        #expect(MemorizationService.text(text, in: .referenceOnly, difficulty: .medium) == nil)
        #expect(MemorizationService.text(text, in: .review, difficulty: .medium) == text)
    }

    @Test func harderPlansBlankMoreWords() {
        let text = "one two three four five six seven eight nine ten"
        func blanks(_ difficulty: MemorizationPlan.Difficulty) -> Int {
            MemorizationService.partialBlank(text, difficulty: difficulty).split(separator: " ").filter { $0.hasPrefix("_") }.count
        }

        #expect(blanks(.easy) == 2)
        #expect(blanks(.medium) == 3)
        #expect(blanks(.hard) == 5)
    }
}
