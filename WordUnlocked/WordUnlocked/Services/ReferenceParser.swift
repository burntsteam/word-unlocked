import Foundation

/// A Bible reference as people type it: "Psalm 23", "1 Kings 2:3", "Rom 8:28-30".
struct VerseQuery: Equatable {
    let bookId: Int
    let chapter: Int
    /// The verses asked for, or nil for the whole chapter.
    let verses: ClosedRange<Int>?
}

enum ReferenceParser {
    /// `text` read as a book, a chapter, and optionally a verse or a range of verses, or nil
    /// when it isn't one. A book alone is left to word search, since "Mark" or "Job" may be
    /// a word the person is looking for.
    static func parse(_ text: String, books: [SharedBookRecord]) -> VerseQuery? {
        let lowered = text.lowercased()
        let range = NSRange(lowered.startIndex..., in: lowered)
        guard let match = pattern.firstMatch(in: lowered, range: range),
              let bookText = group(1, of: match, in: lowered),
              let chapter = group(2, of: match, in: lowered).flatMap(Int.init),
              let book = book(named: bookText, in: books),
              chapter >= 1, book.chapterCount == 1 || chapter <= book.chapterCount else {
            return nil
        }
        let first = group(3, of: match, in: lowered).flatMap(Int.init)
        let last = group(4, of: match, in: lowered).flatMap(Int.init)
        guard let first else {
            // A book of one chapter is cited by verse alone: "Jude 3" is Jude 1:3.
            return book.chapterCount == 1
                ? VerseQuery(bookId: book.id, chapter: 1, verses: chapter...chapter)
                : VerseQuery(bookId: book.id, chapter: chapter, verses: nil)
        }
        return VerseQuery(bookId: book.id, chapter: chapter, verses: first...max(first, last ?? first))
    }

    /// The book a typed name means: a full name, the database's abbreviation, a common
    /// alternative, or the start of exactly one book's name.
    static func book(named text: String, in books: [SharedBookRecord]) -> SharedBookRecord? {
        let key = normalized(text)
        guard !key.isEmpty else { return nil }
        if let id = aliases[key] {
            return books.first { $0.id == id }
        }
        if let exact = books.first(where: { normalized($0.name) == key || normalized($0.abbreviation) == key }) {
            return exact
        }
        guard key.count >= 3 else { return nil }
        let candidates = books.filter { normalized($0.name).hasPrefix(key) }
        return candidates.count == 1 ? candidates[0] : nil
    }

    // "<book> <chapter>[:<verse>[-<verse>]]", where the book may start with a number or ordinal.
    private static let pattern = try! NSRegularExpression(
        pattern: #"^\s*((?:[1-3]|i{1,3}|first|second|third)?\s*[a-z][a-z .]*?)\s*(\d{1,3})(?:\s*[:.]\s*(\d{1,3})(?:\s*[-–—]\s*(\d{1,3}))?)?\s*$"#
    )

    private static let aliases: [String: Int] = [
        "psalm": 19, "psa": 19, "pss": 19,
        "songofsongs": 22, "canticles": 22,
        "mt": 40, "mk": 41, "lk": 42, "jn": 43, "jhn": 43,
        "philem": 57, "phm": 57,
        "1jn": 62, "2jn": 63, "3jn": 64,
        "revelations": 66
    ]

    /// Lowercase, with ordinals as digits and no spaces or periods: "I Kings" becomes "1kings".
    private static func normalized(_ text: String) -> String {
        var words = text.lowercased().split(whereSeparator: { $0 == " " || $0 == "." }).map(String.init)
        let ordinals = ["i": "1", "ii": "2", "iii": "3", "first": "1", "second": "2", "third": "3"]
        if words.count > 1, let digit = ordinals[words[0]] {
            words[0] = digit
        }
        return words.joined()
    }

    private static func group(_ index: Int, of match: NSTextCheckingResult, in text: String) -> String? {
        let range = match.range(at: index)
        guard range.location != NSNotFound, let swiftRange = Range(range, in: text) else { return nil }
        return String(text[swiftRange]).trimmingCharacters(in: .whitespaces)
    }
}
