import SwiftUI

struct OnboardingWelcomeView: View {
    let onContinue: () -> Void

    var body: some View {
        OnboardingPageLayout(
            systemImage: "book.fill",
            title: "Word Unlocked",
            subtitle: "Put scripture on your Lock Screen. Offline and private.",
            detail: "Choose how verses rotate, pick a readable theme, and keep the widget ready without accounts or network access.",
            buttonTitle: "Next",
            action: onContinue
        )
    }
}
