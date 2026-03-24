import Foundation
import Observation
import SwiftData

enum AnalyticsEvent: String {
    case onboardingCompleted = "onboarding_completed"
    case checkInCompleted = "checkin_completed"
    case immediateHelpUsed = "immediate_help_used"
    case exerciseStarted = "exercise_started"
    case exerciseCompleted = "exercise_completed"
    case journalingSaved = "journaling_saved"
    case chatMessageSent = "chat_message_sent"
    case homeReturned = "home_returned"
}

protocol AnalyticsTracking {
    func track(_ event: AnalyticsEvent, metadata: [String: String])
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
    let supportChatEngine: SupportChatEngine

    init(
        analytics: AnalyticsTracking = ConsoleAnalyticsTracker(),
        recommendationEngine: RecommendationEngine = RecommendationEngine(),
        supportChatEngine: SupportChatEngine = SupportChatEngine()
    ) {
        self.analytics = analytics
        self.recommendationEngine = recommendationEngine
        self.supportChatEngine = supportChatEngine
    }

    func track(_ event: AnalyticsEvent, metadata: [String: String] = [:], in context: ModelContext? = nil) {
        analytics.track(event, metadata: metadata)
        if let context {
            context.insert(ToolUsageEvent(name: event.rawValue, metadata: metadata.description))
        }
    }
}
