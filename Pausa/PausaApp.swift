import SwiftData
import SwiftUI

@main
struct PausaApp: App {
    @State private var services = AppServices()
    private let container = PersistenceController.shared.container
    @AppStorage("daily_reminder_enabled") private var reminderEnabled = false
    @AppStorage("daily_reminder_hour") private var reminderHour = 20
    @AppStorage("daily_reminder_minute") private var reminderMinute = 0

    var body: some Scene {
        WindowGroup {
            ZStack {
                AppTheme.pageGradient.ignoresSafeArea()

                ContentView(services: services)
                    .task {
                        await services.syncDailyReminderIfNeeded(
                            enabled: reminderEnabled,
                            hour: reminderHour,
                            minute: reminderMinute
                        )
                    }
                    .background(Color.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
        }
        .modelContainer(container)
    }
}
