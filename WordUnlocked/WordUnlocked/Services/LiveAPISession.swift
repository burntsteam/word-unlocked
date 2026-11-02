import Foundation

/// The session both live translations use. It keeps no cache: LSM's terms forbid storing
/// any Recovery Version text, Crossway's allow at most 500 ESV verses on a device, and a
/// disk cache would also keep each request's API key.
enum LiveAPISession {
    static let shared = URLSession(configuration: configuration, delegate: RedirectGuard(), delegateQueue: nil)

    static var configuration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        // Each request carries its own key, so nothing else needs to be remembered or sent.
        configuration.httpCookieStorage = nil
        configuration.httpShouldSetCookies = false
        configuration.urlCredentialStorage = nil
        // A request's own timeout restarts with every byte; this limits the whole transfer.
        configuration.timeoutIntervalForResource = 60
        return configuration
    }

    /// Builds before 27 September 2026 fetched through URLSession.shared, whose disk cache
    /// kept verse text and keys. The app clears that cache at every launch.
    static func removeCachedResponses() {
        URLCache.shared.removeAllCachedResponses()
    }

    /// Whether a redirect may be followed: a redirected request keeps its headers, and with
    /// them the API key, so it has to stay on the same host over HTTPS.
    static func allowsRedirect(from origin: URL?, to destination: URL?) -> Bool {
        guard let host = origin?.host?.lowercased(), destination?.scheme?.lowercased() == "https" else { return false }
        return destination?.host?.lowercased() == host
    }
}

/// Leaves a refused redirect unfollowed, so the service sees it as a failed response.
final class RedirectGuard: NSObject, URLSessionTaskDelegate {
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void
    ) {
        let origin = task.originalRequest?.url ?? response.url
        completionHandler(LiveAPISession.allowsRedirect(from: origin, to: request.url) ? request : nil)
    }
}
