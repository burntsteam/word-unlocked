import SwiftUI

struct OnboardingCompleteView: View {
    var body: some View {
        // Centred when it fits; at the largest text sizes it scrolls instead of clipping.
        ViewThatFits(in: .vertical) {
            content
            ScrollView { content }
        }
    }

    private var content: some View {
        VStack(spacing: 26) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72, weight: .semibold))
                .foregroundStyle(.green)
                .accessibilityHidden(true)

            VStack(spacing: 12) {
                Text("You're all set!")
                    .font(.largeTitle.weight(.bold))
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)

                Text("Word Unlocked is ready with your translation, verse mode, and theme. You can change any of them later in the app.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding(24)
    }
}

struct OnboardingHeader: View {
    let systemImage: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(.tint)
                .accessibilityHidden(true)
            Text(title)
                .font(.largeTitle.weight(.bold))
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct OnboardingPageLayout: View {
    let systemImage: String
    let title: String
    let subtitle: String
    let detail: String

    var body: some View {
        ScrollView {
            VStack(spacing: 26) {
                OnboardingHeader(systemImage: systemImage, title: title, subtitle: subtitle)
                Text(detail)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(24)
            .padding(.top, 80)
        }
    }
}
