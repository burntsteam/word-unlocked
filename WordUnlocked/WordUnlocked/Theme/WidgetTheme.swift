import SwiftUI

struct WidgetTheme: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let backgroundHex: String
    let textHex: String
    let accentHex: String
    let fontDesign: Font.Design

    enum CodingKeys: CodingKey {
        case id
        case name
        case backgroundHex
        case textHex
        case accentHex
        case fontDesign
    }

    init(id: String, name: String, backgroundHex: String, textHex: String, accentHex: String, fontDesign: Font.Design) {
        self.id = id
        self.name = name
        self.backgroundHex = backgroundHex
        self.textHex = textHex
        self.accentHex = accentHex
        self.fontDesign = fontDesign
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        backgroundHex = try container.decode(String.self, forKey: .backgroundHex)
        textHex = try container.decode(String.self, forKey: .textHex)
        accentHex = try container.decode(String.self, forKey: .accentHex)
        let design = try container.decode(String.self, forKey: .fontDesign)
        fontDesign = WidgetTheme.fontDesign(named: design)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(backgroundHex, forKey: .backgroundHex)
        try container.encode(textHex, forKey: .textHex)
        try container.encode(accentHex, forKey: .accentHex)
        try container.encode(WidgetTheme.name(for: fontDesign), forKey: .fontDesign)
    }

    var colors: ThemeColors {
        ThemeColors(
            background: Color(hex: backgroundHex),
            text: Color(hex: textHex),
            accent: Color(hex: accentHex)
        )
    }

    static let allThemes: [WidgetTheme] = [
        WidgetTheme(id: "minimal-light", name: "Minimal Light", backgroundHex: "#F8F7F2", textHex: "#1F2933", accentHex: "#476C5E", fontDesign: .default),
        WidgetTheme(id: "minimal-dark", name: "Minimal Dark", backgroundHex: "#101418", textHex: "#F2F5F7", accentHex: "#8DD7C7", fontDesign: .default),
        WidgetTheme(id: "parchment", name: "Parchment", backgroundHex: "#F2E6C9", textHex: "#3B2F24", accentHex: "#8B5E34", fontDesign: .serif),
        WidgetTheme(id: "soft-sunrise", name: "Soft Sunrise", backgroundHex: "#F7E8DF", textHex: "#2E3138", accentHex: "#C86548", fontDesign: .rounded),
        WidgetTheme(id: "midnight", name: "Midnight", backgroundHex: "#111827", textHex: "#E5EEF6", accentHex: "#7AA2F7", fontDesign: .default),
        WidgetTheme(id: "cathedral", name: "Cathedral", backgroundHex: "#18251F", textHex: "#EEF2E6", accentHex: "#D3AA58", fontDesign: .serif),
        WidgetTheme(id: "monochrome", name: "Monochrome", backgroundHex: "#F1F1EF", textHex: "#181818", accentHex: "#6B7280", fontDesign: .monospaced),
        WidgetTheme(id: "classic-serif", name: "Classic Serif", backgroundHex: "#FBF8F1", textHex: "#22211F", accentHex: "#5B6C3B", fontDesign: .serif),
        WidgetTheme(id: "modern-sans", name: "Modern Sans", backgroundHex: "#EEF6F8", textHex: "#1E2A30", accentHex: "#2A7D8F", fontDesign: .default),
        WidgetTheme(id: "discipline", name: "Discipline", backgroundHex: "#F4F0E8", textHex: "#232323", accentHex: "#9B3D30", fontDesign: .monospaced)
    ]

    static func theme(id: String) -> WidgetTheme {
        allThemes.first { $0.id == id } ?? allThemes[0]
    }

    private static func fontDesign(named name: String) -> Font.Design {
        switch name {
        case "serif": .serif
        case "rounded": .rounded
        case "monospaced": .monospaced
        default: .default
        }
    }

    private static func name(for design: Font.Design) -> String {
        switch design {
        case .serif: "serif"
        case .rounded: "rounded"
        case .monospaced: "monospaced"
        default: "default"
        }
    }
}

