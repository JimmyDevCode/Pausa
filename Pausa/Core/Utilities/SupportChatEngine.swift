import Foundation

struct SupportChatReply {
    let text: String
    let route: AppRoute?
}

struct SupportChatEngine {
    private let intenseKeywords = ["no puedo", "me supera", "muy mal", "colapsado", "crisis", "ataque"]
    private let urgentKeywords = ["hacerme daño", "lastimarme", "no quiero seguir", "suicid", "emergencia"]

    func reply(to message: String) -> SupportChatReply {
        let normalized = message.lowercased()

        if urgentKeywords.contains(where: normalized.contains) {
            return SupportChatReply(
                text: String(localized: AppStrings.Chat.replyUrgent),
                route: nil
            )
        }

        if normalized.contains("ans") || normalized.contains("nerv") {
            return SupportChatReply(
                text: String(localized: AppStrings.Chat.replyAnsiedad),
                route: .exercise(ExerciseLibrary.all[0])
            )
        }

        if normalized.contains("satur") || normalized.contains("abrum") || normalized.contains("demasiado") {
            return SupportChatReply(
                text: String(localized: AppStrings.Chat.replyAbrumado),
                route: .immediateHelp
            )
        }

        if intenseKeywords.contains(where: normalized.contains) {
            return SupportChatReply(
                text: String(localized: AppStrings.Chat.replyIntenso),
                route: .checkIn
            )
        }

        if normalized.contains("dorm") || normalized.contains("noche") {
            return SupportChatReply(
                text: String(localized: AppStrings.Chat.replySueno),
                route: .exercise(ExerciseLibrary.all[3])
            )
        }

        return SupportChatReply(
            text: String(localized: AppStrings.Chat.replyDefault),
            route: .journaling
        )
    }
}
