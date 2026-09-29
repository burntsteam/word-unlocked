import Foundation

// Throwaway UserDefaults suites, so tests never read or write the App Group the app and its
// widget share.

/// A suite nothing writes to, so choices saved in the App Group can't leak in.
func emptyDefaults() -> UserDefaults {
    UserDefaults(suiteName: "WordUnlockedTests.\(UUID().uuidString)")!
}

/// A throwaway suite holding `values`, removed once `body` returns.
func withScratchDefaults<T>(_ values: [String: Any], _ body: (UserDefaults) throws -> T) rethrows -> T {
    let name = "WordUnlockedTests.\(UUID().uuidString)"
    let defaults = UserDefaults(suiteName: name)!
    defer { UserDefaults.standard.removePersistentDomain(forName: name) }
    values.forEach { defaults.set($0.value, forKey: $0.key) }
    return try body(defaults)
}
