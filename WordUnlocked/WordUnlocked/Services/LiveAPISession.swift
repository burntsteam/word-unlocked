import Foundation

/// The session both live translations use. It keeps no cache: LSM's terms forbid storing
/// any Recovery Version text, Crossway's allow at most 500 ESV verses on a device, and a
/// disk cache would also keep each request's API key.
enum LiveAPISession {
    static let shared: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration)
    }()

    /// Builds before 27 September 2026 fetched through URLSession.shared, whose disk cache
    /// kept verse text and keys. The app clears that cache at every launch.
    static func removeCachedResponses() {
        URLCache.shared.removeAllCachedResponses()
    }
}
