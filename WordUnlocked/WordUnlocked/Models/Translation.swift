import Foundation

struct Translation: Identifiable, Codable, Equatable {
    let id: Int
    let code: String
    let displayName: String
    let publisher: String
    let copyrightNotice: String
    let licenseStatus: LicenseStatus
    let attribution: String
    let offlineAvailable: Bool
    let enabled: Bool

    enum LicenseStatus: String, Codable {
        case publicDomain = "public_domain"
        case ccBySA = "cc_by_sa"
        case licensed = "licensed"
        case comingSoon = "coming_soon"
    }
}

