import Foundation

enum ThemeService {
    static var themes: [WidgetTheme] {
        WidgetTheme.allThemes
    }

    static func theme(id: String) -> WidgetTheme {
        WidgetTheme.theme(id: id)
    }
}

