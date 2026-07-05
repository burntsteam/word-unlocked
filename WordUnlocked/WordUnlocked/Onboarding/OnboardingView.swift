import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding", store: AppGroupSettings.defaults) private var hasCompletedOnboarding = false
    @State private var page = 0

    private let pageCount = 6

    var body: some View {
        TabView(selection: $page) {
            OnboardingWelcomeView {
                page = 1
            }
            .tag(0)

            OnboardingTranslationView {
                page = 2
            }
            .tag(1)

            OnboardingModeView {
                page = 3
            }
            .tag(2)

            OnboardingThemeView {
                page = 4
            }
            .tag(3)

            OnboardingWidgetInstructionsView {
                page = 5
            }
            .tag(4)

            OnboardingCompleteView(hasCompletedOnboarding: $hasCompletedOnboarding)
                .tag(5)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            OnboardingProgressDots(currentPage: page, pageCount: pageCount)
                .padding(.bottom, 88)
        }
    }
}

private struct OnboardingProgressDots: View {
    let currentPage: Int
    let pageCount: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.accentColor : Color.secondary.opacity(0.35))
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentPage ? 1.15 : 1)
            }
        }
        .accessibilityLabel("Onboarding page \(currentPage + 1) of \(pageCount)")
    }
}
