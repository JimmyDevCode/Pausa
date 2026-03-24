import Foundation
import SwiftData

enum EmotionalState: String, CaseIterable, Codable, Identifiable {
    case tranquilo
    case cansado
    case ansioso
    case frustrado
    case abrumado
    case triste

    var id: String { rawValue }

    var localizedTitle: String {
        switch self {
        case .tranquilo: String(localized: AppStrings.Emotion.tranquilo)
        case .cansado: String(localized: AppStrings.Emotion.cansado)
        case .ansioso: String(localized: AppStrings.Emotion.ansioso)
        case .frustrado: String(localized: AppStrings.Emotion.frustrado)
        case .abrumado: String(localized: AppStrings.Emotion.abrumado)
        case .triste: String(localized: AppStrings.Emotion.triste)
        }
    }

    var supportiveCopy: String {
        switch self {
        case .tranquilo: String(localized: AppStrings.EmotionSupport.tranquilo)
        case .cansado: String(localized: AppStrings.EmotionSupport.cansado)
        case .ansioso: String(localized: AppStrings.EmotionSupport.ansioso)
        case .frustrado: String(localized: AppStrings.EmotionSupport.frustrado)
        case .abrumado: String(localized: AppStrings.EmotionSupport.abrumado)
        case .triste: String(localized: AppStrings.EmotionSupport.triste)
        }
    }
}

enum FocusArea: String, CaseIterable, Codable, Identifiable {
    case estres = "Estrés"
    case ansiedad = "Ansiedad"
    case agotamiento = "Agotamiento"
    case sueno = "Sueño"
    case enfoque = "Carga mental"

    var id: String { rawValue }

    var localizedTitle: String {
        switch self {
        case .estres: String(localized: AppStrings.Focus.estres)
        case .ansiedad: String(localized: AppStrings.Focus.ansiedad)
        case .agotamiento: String(localized: AppStrings.Focus.agotamiento)
        case .sueno: String(localized: AppStrings.Focus.sueno)
        case .enfoque: String(localized: AppStrings.Focus.enfoque)
        }
    }
}

enum DesiredFeeling: String, CaseIterable, Codable, Identifiable {
    case calma = "Más calma"
    case claridad = "Más claridad"
    case descanso = "Más descanso"
    case enfoque = "Más foco"
    case ligereza = "Más ligereza"

    var id: String { rawValue }

    var localizedTitle: String {
        switch self {
        case .calma: String(localized: AppStrings.Desired.calma)
        case .claridad: String(localized: AppStrings.Desired.claridad)
        case .descanso: String(localized: AppStrings.Desired.descanso)
        case .enfoque: String(localized: AppStrings.Desired.enfoque)
        case .ligereza: String(localized: AppStrings.Desired.ligereza)
        }
    }
}

@Model
final class UserProfile {
    var id: UUID
    var nickname: String
    var preferredFeeling: String
    var mainConcern: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        nickname: String,
        preferredFeeling: String,
        mainConcern: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.nickname = nickname
        self.preferredFeeling = preferredFeeling
        self.mainConcern = mainConcern
        self.createdAt = createdAt
    }
}

@Model
final class EmotionalCheckIn {
    var id: UUID
    var emotion: String
    var stressLevel: Int
    var recommendationTitle: String
    var recommendationBody: String
    var recommendationRoute: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        emotion: String,
        stressLevel: Int,
        recommendationTitle: String,
        recommendationBody: String,
        recommendationRoute: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.emotion = emotion
        self.stressLevel = stressLevel
        self.recommendationTitle = recommendationTitle
        self.recommendationBody = recommendationBody
        self.recommendationRoute = recommendationRoute
        self.createdAt = createdAt
    }
}

@Model
final class JournalEntry {
    var id: UUID
    var feelingText: String
    var affectingText: String
    var neededText: String
    var supportText: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        feelingText: String,
        affectingText: String,
        neededText: String,
        supportText: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.feelingText = feelingText
        self.affectingText = affectingText
        self.neededText = neededText
        self.supportText = supportText
        self.createdAt = createdAt
    }
}

@Model
final class ExerciseSessionRecord {
    var id: UUID
    var exerciseID: String
    var title: String
    var source: String
    var helpfulness: Int?
    var completedAt: Date

    init(
        id: UUID = UUID(),
        exerciseID: String,
        title: String,
        source: String,
        helpfulness: Int? = nil,
        completedAt: Date = .now
    ) {
        self.id = id
        self.exerciseID = exerciseID
        self.title = title
        self.source = source
        self.helpfulness = helpfulness
        self.completedAt = completedAt
    }
}

@Model
final class ToolUsageEvent {
    var id: UUID
    var name: String
    var metadata: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        metadata: String = "",
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.metadata = metadata
        self.createdAt = createdAt
    }
}

@Model
final class ChatMessageRecord {
    var id: UUID
    var text: String
    var isFromUser: Bool
    var suggestedRoute: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        text: String,
        isFromUser: Bool,
        suggestedRoute: String = "",
        createdAt: Date = .now
    ) {
        self.id = id
        self.text = text
        self.isFromUser = isFromUser
        self.suggestedRoute = suggestedRoute
        self.createdAt = createdAt
    }
}
