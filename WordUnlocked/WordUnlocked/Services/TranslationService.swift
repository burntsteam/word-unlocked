import Foundation

enum TranslationService {
    static var allTranslations: [Translation] {
        ScriptureDatabase.shared.translations().map(translation(from:))
    }

    static var availableOffline: [Translation] {
        allTranslations.filter(\.offlineAvailable)
    }

    private static func translation(from record: SharedTranslationRecord) -> Translation {
        Translation(
            id: record.id,
            code: record.code,
            displayName: record.displayName,
            publisher: record.publisher,
            copyrightNotice: record.copyrightNotice,
            licenseStatus: Translation.LicenseStatus(rawValue: record.licenseStatus) ?? .publicDomain,
            attribution: record.attribution,
            offlineAvailable: record.offlineAvailable,
            enabled: record.enabled
        )
    }
}

