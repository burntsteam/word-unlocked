import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                TodayView()
            }
            .tabItem {
                Label("Today", systemImage: "sun.horizon.fill")
            }

            NavigationStack {
                ModesView()
            }
            .tabItem {
                Label("Modes", systemImage: "rectangle.3.group.fill")
            }

            NavigationStack {
                TranslationsView()
            }
            .tabItem {
                Label("Translations", systemImage: "character.book.closed.fill")
            }

            NavigationStack {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "bookmark.fill")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "slider.horizontal.3")
            }
        }
    }
}
