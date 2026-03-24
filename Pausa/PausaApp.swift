import SwiftData
import SwiftUI

@main
struct PausaApp: App {
    @State private var services = AppServices()
    private let container = PersistenceController.shared.container

    var body: some Scene {
        WindowGroup {
            ContentView(services: services)
        }
        .modelContainer(container)
    }
}
