import Foundation

enum LongVerseService {
    static func fitCategory(charCount: Int) -> Verse.FitCategory {
        switch charCount {
        case 0...70:
            .short
        case 71...130:
            .medium
        case 131...210:
            .long
        default:
            .veryLong
        }
    }

    static func excerpt(from text: String, maxChars: Int) -> String {
        guard text.count > maxChars else { return text }
        let words = text.split(separator: " ")
        var result = ""

        for word in words {
            let candidate = result.isEmpty ? String(word) : "\(result) \(word)"
            if candidate.count + 1 > maxChars { break }
            result = candidate
        }

        if result.isEmpty {
            return String(text.prefix(maxChars)).trimmingCharacters(in: .whitespacesAndNewlines) + "..."
        }
        return result + "..."
    }

    static func segments(from text: String, maxCharsPerSegment: Int) -> [String] {
        guard text.count > maxCharsPerSegment else { return [text] }

        var segments: [String] = []
        var current = ""

        for word in text.split(separator: " ") {
            let candidate = current.isEmpty ? String(word) : "\(current) \(word)"
            if candidate.count > maxCharsPerSegment, !current.isEmpty {
                segments.append(current)
                current = String(word)
            } else {
                current = candidate
            }
        }

        if !current.isEmpty {
            segments.append(current)
        }

        return segments
    }

    static func firstLetters(from text: String) -> String {
        text
            .split(separator: " ")
            .compactMap { word in word.first.map(String.init) }
            .joined(separator: " ")
            .uppercased()
    }
}

