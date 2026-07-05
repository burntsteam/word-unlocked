import SwiftUI

@main
struct WordUnlockedApp: App {
    @StateObject private var settingsStore = SettingsStore()
    @AppStorage("hasCompletedOnboarding", store: AppGroupSettings.defaults) private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView().environmentObject(settingsStore)
            } else {
                OnboardingView().environmentObject(settingsStore)
            }
        }
    }
}
