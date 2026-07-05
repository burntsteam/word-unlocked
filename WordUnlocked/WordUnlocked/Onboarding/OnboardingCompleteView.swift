import SwiftUI

struct OnboardingCompleteView: View {
    @Binding var hasCompletedOnboarding: Bool

    var body: some View {
        VStack(spacing: 26) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72, weight: .semibold))
                .foregroundStyle(.green)

            VStack(spacing: 12) {
                Text("You're all set!")
                    .font(.largeTitle.weight(.bold))
                    .multilineTextAlignment(.center)

                Text("Word Unlocked is ready with your selected translation, verse mode, and theme. You can change any setting later from the app.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()

            Button("Get Started") {
                hasCompletedOnboarding = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
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
            Text(title)
                .font(.largeTitle.weight(.bold))
                .multilineTextAlignment(.center)
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
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 26) {
            Spacer()
            OnboardingHeader(systemImage: systemImage, title: title, subtitle: subtitle)
            Text(detail)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Button(buttonTitle, action: action)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        }
        .padding(24)
    }
}
