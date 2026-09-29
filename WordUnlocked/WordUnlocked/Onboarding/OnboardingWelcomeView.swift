import SwiftUI

struct OnboardingWelcomeView: View {
    var body: some View {
        OnboardingPageLayout(
            systemImage: "book.fill",
            title: "Word Unlocked",
            subtitle: "Put scripture on your Lock Screen. Private, with no account.",
            detail: "Choose how verses rotate and pick a look for your widget. Five translations are built in and work without a connection."
        )
    }
}
