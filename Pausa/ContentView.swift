import SwiftData
import SwiftUI

enum AppRoute: Hashable {
    case checkIn
    case immediateHelp
    case exercises
    case exercise(ExerciseDefinition)
    case journaling
    case history
    case writings
    case profile
}

private enum MainTab: Hashable {
    case home
    case write
    case pause
    case progress
    case profile
}

struct ContentView: View {
    let services: AppServices

    @Query(sort: \UserProfile.createdAt) private var profiles: [UserProfile]
    @State private var path: [AppRoute] = []

    init(services: AppServices) {
        self.services = services
    }

    var body: some View {
        Group {
            if let profile = profiles.first {
                NavigationStack(path: $path) {
                    MainTabView(
                        profile: profile,
                        services: services,
                        openRoute: { path.append($0) }
                    )
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .checkIn:
                            CheckInView(services: services, openRoute: { path.append($0) })
                        case .immediateHelp:
                            ImmediateHelpView(openRoute: { path.append($0) })
                        case .exercises:
                            ExercisesView(openRoute: { path.append($0) })
                        case .exercise(let exercise):
                            ExerciseSessionView(exercise: exercise, services: services)
                        case .journaling:
                            JournalingView(services: services, openRoute: { path.append($0) })
                        case .history:
                            HistoryView(openRoute: { path.append($0) })
                        case .writings:
                            WritingsView()
                        case .profile:
                            ProfileView(profile: profile, services: services)
                        }
                    }
                }
            } else {
                OnboardingView(services: services)
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .tint(AppTheme.tint)
        .onOpenURL { url in
            guard profiles.first != nil, let route = AppRoute(url: url) else { return }
            path = [route]
        }
    }
}

#Preview {
    ContentView(services: AppServices())
        .modelContainer(PersistenceController.preview.container)
}

private struct MainTabView: View {
    let profile: UserProfile
    let services: AppServices
    let openRoute: (AppRoute) -> Void

    @State private var selectedTab: MainTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(
                profile: profile,
                services: services,
                openRoute: openRoute
            )
            .tabItem {
                Label(String(localized: AppStrings.Tab.home), systemImage: "house")
            }
            .tag(MainTab.home)

            JournalingView(services: services, openRoute: openRoute)
                .tabItem {
                    Label(String(localized: AppStrings.Tab.write), systemImage: "square.and.pencil")
                }
                .tag(MainTab.write)

            ImmediateHelpView(openRoute: openRoute)
                .tabItem {
                    Label(String(localized: AppStrings.Tab.pause), systemImage: "bolt.heart.fill")
                }
                .tag(MainTab.pause)

            HistoryView(openRoute: openRoute)
                .tabItem {
                    Label(String(localized: AppStrings.Tab.progress), systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(MainTab.progress)

            ProfileView(profile: profile, services: services)
                .tabItem {
                    Label(String(localized: AppStrings.Tab.profile), systemImage: "person")
                }
                .tag(MainTab.profile)
        }
        .tint(AppTheme.tint)
    }
}
