import SwiftUI

/// Five tabs, so none falls under More. Translations live in Settings.
struct MainTabView: View {
    enum Tab: Hashable {
        case today, modes, search, favorites, settings
    }

    @State private var selection = Tab.today

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                TodayView()
            }
            .tabItem {
                Label("Today", systemImage: "sun.horizon.fill")
            }
            .tag(Tab.today)

            NavigationStack {
                ModesView()
            }
            .tabItem {
                Label("Modes", systemImage: "rectangle.3.group.fill")
            }
            .tag(Tab.modes)

            NavigationStack {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(Tab.search)

            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
            .tag(Tab.favorites)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
            .tag(Tab.settings)
        }
        // Tapping a widget opens the app on Today, whichever tab was open before.
        .onOpenURL { url in
            if url == VerseEntry.todayURL {
                selection = .today
            }
        }
    }
}
