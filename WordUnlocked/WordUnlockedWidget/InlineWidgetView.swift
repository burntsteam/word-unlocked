import SwiftUI
import WidgetKit

struct InlineWidgetView: View {
    let entry: VerseEntry

    var body: some View {
        // One line above the clock: the reference, its translation, then as much of the verse
        // as fits, cut at a word.
        let reference = entry.translationCode.isEmpty ? entry.shortRef : "\(entry.shortRef) \(entry.translationCode)"
        if let text = entry.verseText {
            Text("\(reference) · \(LongVerseService.excerpt(from: text, maxChars: 40))")
        } else {
            Text(reference)
        }
    }
}
