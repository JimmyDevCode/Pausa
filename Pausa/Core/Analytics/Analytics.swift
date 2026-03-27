import Foundation
import Observation
import SwiftData
import UserNotifications

enum AnalyticsEvent: String {
    case onboardingCompleted = "onboarding_completed"
    case checkInCompleted = "checkin_completed"
    case immediateHelpUsed = "immediate_help_used"
    case exerciseStarted = "exercise_started"
    case exerciseCompleted = "exercise_completed"
    case journalingSaved = "journaling_saved"
    case homeReturned = "home_returned"
}

protocol AnalyticsTracking {
    func track(_ event: AnalyticsEvent, metadata: [String: String])
}

protocol NotificationManaging {
    func authorizationStatus() async -> UNAuthorizationStatus
    func requestAuthorization() async -> Bool
    func syncDailyReminder(enabled: Bool, hour: Int, minute: Int) async
}

final class LocalNotificationManager: NotificationManaging {
    private let center = UNUserNotificationCenter.current()
    private let reminderIdentifier = "daily_wellbeing_reminder"

    func authorizationStatus() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }

    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    func syncDailyReminder(enabled: Bool, hour: Int, minute: Int) async {
        center.removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])
        guard enabled else { return }

        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else { return }

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let content = UNMutableNotificationContent()
        content.title = String(localized: AppStrings.Notifications.dailyTitle)
        content.body = String(localized: AppStrings.Notifications.dailyBody)
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: reminderIdentifier,
            content: content,
            trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        )

        try? await center.add(request)
    }
}

struct ConsoleAnalyticsTracker: AnalyticsTracking {
    func track(_ event: AnalyticsEvent, metadata: [String: String]) {
        print("ANALYTICS:", event.rawValue, metadata)
    }
}

@Observable
final class AppServices {
    let analytics: AnalyticsTracking
    let recommendationEngine: RecommendationEngine
    let notificationManager: NotificationManaging

    init(
        analytics: AnalyticsTracking = ConsoleAnalyticsTracker(),
        recommendationEngine: RecommendationEngine = RecommendationEngine(),
        notificationManager: NotificationManaging = LocalNotificationManager()
    ) {
        self.analytics = analytics
        self.recommendationEngine = recommendationEngine
        self.notificationManager = notificationManager
    }

    func track(_ event: AnalyticsEvent, metadata: [String: String] = [:], in context: ModelContext? = nil) {
        analytics.track(event, metadata: metadata)
        if let context {
            context.insert(ToolUsageEvent(name: event.rawValue, metadata: metadata.description))
        }
    }

    func syncDailyReminderIfNeeded(enabled: Bool, hour: Int, minute: Int) async {
        await notificationManager.syncDailyReminder(enabled: enabled, hour: hour, minute: minute)
    }
}
