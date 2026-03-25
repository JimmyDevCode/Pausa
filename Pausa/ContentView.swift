import SwiftData
import SwiftUI

enum AppRoute: Hashable {
    case checkIn
    case immediateHelp
    case exercises
    case exercise(ExerciseDefinition)
    case journaling
    case supportChat
    case history
    case writings
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
                    HomeView(
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
                            JournalingView(services: services)
                        case .supportChat:
                            SupportChatView(services: services, openRoute: { path.append($0) })
                        case .history:
                            HistoryView(openRoute: { path.append($0) })
                        case .writings:
                            WritingsView()
                        case .profile:
                            ProfileView(profile: profile)
                        }
                    }
                }
            } else {
                OnboardingView(services: services)
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
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
