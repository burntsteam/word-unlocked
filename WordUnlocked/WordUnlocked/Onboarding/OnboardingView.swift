import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding", store: AppGroupSettings.defaults) private var hasCompletedOnboarding = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var page = 0

    private let pageCount = 6

    var body: some View {
        TabView(selection: $page) {
            OnboardingWelcomeView().tag(0)
            OnboardingTranslationView().tag(1)
            OnboardingModeView().tag(2)
            OnboardingThemeView().tag(3)
            OnboardingWidgetInstructionsView().tag(4)
            OnboardingCompleteView().tag(5)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        // The dots and the button sit below every page, so the way forward is always in view
        // and a long page scrolls above them.
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 14) {
                OnboardingProgressDots(currentPage: page, pageCount: pageCount)
                Button(page == pageCount - 1 ? "Get Started" : "Next") {
                    if page == pageCount - 1 {
                        hasCompletedOnboarding = true
                    } else {
                        withAnimation(reduceMotion ? nil : .default) {
                            page += 1
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(.bar)
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Page \(currentPage + 1) of \(pageCount)")
    }
}
