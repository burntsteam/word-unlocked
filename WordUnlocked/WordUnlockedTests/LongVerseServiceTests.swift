import Testing
@testable import WordUnlocked

// LongVerseService is pure string manipulation with no dependencies (no DB,
// no UserDefaults, no dates, no singletons), so every case below is verified
// directly against the algorithm in LongVerseService.swift by hand-counting
// characters rather than guessed at.
@Suite("LongVerseService")
struct LongVerseServiceTests {

    // MARK: - fitCategory(charCount:) boundaries
    // Bands: 0...70 short, 71...130 medium, 131...210 long, 211+ veryLong.

    @Test func fitCategoryAtZeroIsShort() {
        #expect(LongVerseService.fitCategory(charCount: 0) == .short)
    }

    @Test func fitCategoryAtShortUpperBoundIsShort() {
        #expect(LongVerseService.fitCategory(charCount: 70) == .short)
    }

    @Test func fitCategoryJustPastShortIsMedium() {
        #expect(LongVerseService.fitCategory(charCount: 71) == .medium)
    }

    @Test func fitCategoryAtMediumUpperBoundIsMedium() {
        #expect(LongVerseService.fitCategory(charCount: 130) == .medium)
    }

    @Test func fitCategoryJustPastMediumIsLong() {
        #expect(LongVerseService.fitCategory(charCount: 131) == .long)
    }

    @Test func fitCategoryAtLongUpperBoundIsLong() {
        #expect(LongVerseService.fitCategory(charCount: 210) == .long)
    }

    @Test func fitCategoryJustPastLongIsVeryLong() {
        #expect(LongVerseService.fitCategory(charCount: 211) == .veryLong)
    }

    @Test func fitCategoryWellPastLongIsVeryLong() {
        #expect(LongVerseService.fitCategory(charCount: 5000) == .veryLong)
    }

    // MARK: - excerpt(from:maxChars:)

    @Test func excerptOfEmptyStringIsEmpty() {
        #expect(LongVerseService.excerpt(from: "", maxChars: 50) == "")
    }

    @Test func excerptShorterThanLimitIsUnchanged() {
        let text = "Short verse"
        #expect(LongVerseService.excerpt(from: text, maxChars: 50) == text)
    }

    @Test func excerptExactlyAtLimitIsUnchanged() {
        let text = "1234567890" // exactly 10 characters
        #expect(LongVerseService.excerpt(from: text, maxChars: 10) == text)
    }

    @Test func excerptFarOverLimitBreaksOnWholeWords() {
        let text = "aaa bbb ccc ddd eee fff ggg" // 27 characters, 7 words of 3
        // "aaa"(3) -> "aaa bbb"(7) -> adding "ccc" would make 11, and
        // candidate.count + 1 > maxChars (12 > 11) stops it there.
        #expect(LongVerseService.excerpt(from: text, maxChars: 11) == "aaa bbb...")
    }

    @Test func excerptWithNoWhitespaceFallsBackToHardTruncation() {
        // No spaces means `split(separator: " ")` yields one giant "word", which
        // immediately overflows maxChars, so the loop never accepts a word and
        // falls back to a hard character truncation instead of word wrapping.
        let text = "abcdefghij" // 10 characters, no whitespace
        #expect(LongVerseService.excerpt(from: text, maxChars: 5) == "abcde...")
    }

    // MARK: - segments(from:maxCharsPerSegment:)

    @Test func segmentsOfEmptyStringReturnsSingleEmptySegment() {
        #expect(LongVerseService.segments(from: "", maxCharsPerSegment: 50) == [""])
    }

    @Test func segmentsShorterThanLimitReturnsSingleSegment() {
        let text = "Short verse"
        #expect(LongVerseService.segments(from: text, maxCharsPerSegment: 50) == [text])
    }

    @Test func segmentsExactlyAtLimitReturnsSingleSegment() {
        let text = "1234567890" // exactly 10 characters
        #expect(LongVerseService.segments(from: text, maxCharsPerSegment: 10) == [text])
    }

    @Test func segmentsFarOverLimitSplitsOnWordBoundaries() {
        let text = "aaa bbb ccc ddd eee fff ggg" // 27 characters, 7 words of 3
        // "aaa bbb ccc" (11) is the largest run <= 11 chars; "ddd" pushes to 15
        // so it starts a new segment, and so on.
        #expect(LongVerseService.segments(from: text, maxCharsPerSegment: 11) == [
            "aaa bbb ccc", "ddd eee fff", "ggg"
        ])
    }

    @Test func segmentsWithNoWhitespaceCannotSplitAndOverflowsSingleSegment() {
        // Documents a real limitation rather than asserting an invented "should":
        // a run with no spaces can't be split mid-word, so it comes back as one
        // oversized segment instead of being broken up or truncated to the limit.
        let text = "abcdefghij" // 10 characters, no whitespace
        #expect(LongVerseService.segments(from: text, maxCharsPerSegment: 5) == [text])
    }

    // MARK: - firstLetters(from:)

    @Test func firstLettersExtractsAndUppercasesInitials() {
        #expect(LongVerseService.firstLetters(from: "For God so loved") == "F G S L")
    }

    @Test func firstLettersOfEmptyStringIsEmpty() {
        #expect(LongVerseService.firstLetters(from: "") == "")
    }
}
