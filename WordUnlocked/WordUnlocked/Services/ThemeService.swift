import SwiftUI

enum ThemeService {
    /// The fixed themes; Automatic is offered beside them and resolves to one of them.
    static var themes: [WidgetTheme] {
        WidgetTheme.allThemes
    }

    static func theme(id: String, colorScheme: ColorScheme) -> WidgetTheme {
        WidgetTheme.theme(id: id, colorScheme: colorScheme)
    }
}
