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

    init?(storedValue: String) {
        let normalized = storedValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)

        switch normalized {
        case Self.tranquilo.rawValue:
            self = .tranquilo
        case Self.cansado.rawValue:
            self = .cansado
        case Self.ansioso.rawValue:
            self = .ansioso
        case Self.frustrado.rawValue:
            self = .frustrado
        case Self.abrumado.rawValue:
            self = .abrumado
        case Self.triste.rawValue:
            self = .triste
        default:
            return nil
        }
    }
}

enum FocusArea: String, CaseIterable, Codable, Identifiable {
    case estres
    case ansiedad
    case agotamiento
    case sueno
    case enfoque

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

    init?(storedValue: String) {
        let normalized = storedValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)

        switch normalized {
        case Self.estres.rawValue, "estres":
            self = .estres
        case Self.ansiedad.rawValue:
            self = .ansiedad
        case Self.agotamiento.rawValue:
            self = .agotamiento
        case Self.sueno.rawValue, "sueno":
            self = .sueno
        case Self.enfoque.rawValue, "carga mental":
            self = .enfoque
        default:
            return nil
        }
    }
}

enum DesiredFeeling: String, CaseIterable, Codable, Identifiable {
    case calma
    case claridad
    case descanso
    case enfoque
    case ligereza

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

    init?(storedValue: String) {
        let normalized = storedValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)

        switch normalized {
        case Self.calma.rawValue, "mas calma":
            self = .calma
        case Self.claridad.rawValue, "mas claridad":
            self = .claridad
        case Self.descanso.rawValue, "mas descanso":
            self = .descanso
        case Self.enfoque.rawValue, "mas foco":
            self = .enfoque
        case Self.ligereza.rawValue, "mas ligereza":
            self = .ligereza
        default:
            return nil
        }
    }
}

@Model
final class UserProfile {
    var id: UUID
    var nickname: String
    var avatarData: Data?
    var preferredFeeling: String
    var mainConcern: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        nickname: String,
        avatarData: Data? = nil,
        preferredFeeling: String,
        mainConcern: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.nickname = nickname
        self.avatarData = avatarData
        self.preferredFeeling = preferredFeeling
        self.mainConcern = mainConcern
        self.createdAt = createdAt
    }

    var localizedPreferredFeeling: String {
        DesiredFeeling(storedValue: preferredFeeling)?.localizedTitle ?? preferredFeeling
    }

    var localizedMainConcern: String {
        FocusArea(storedValue: mainConcern)?.localizedTitle ?? mainConcern
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

    var localizedEmotion: String {
        EmotionalState(storedValue: emotion)?.localizedTitle ?? emotion
    }

    var localizedEmotionLowercased: String {
        localizedEmotion.lowercased()
    }

    var localizedRecommendationTitle: String {
        AppRecommendationText(rawValue: recommendationTitle)?.localizedValue ?? recommendationTitle
    }

    var localizedRecommendationBody: String {
        AppRecommendationText(rawValue: recommendationBody)?.localizedValue ?? recommendationBody
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

enum AppRecommendationText: String {
    case abrumadoBody = "recommendation.abrumado.body"
    case abrumadoButton = "recommendation.abrumado.button"
    case abrumadoTitle = "recommendation.abrumado.title"
    case ansiosoBody = "recommendation.ansioso.body"
    case ansiosoBodyHigh = "recommendation.ansioso.body_high"
    case ansiosoButton = "recommendation.ansioso.button"
    case ansiosoTitle = "recommendation.ansioso.title"
    case cansadoBody = "recommendation.cansado.body"
    case cansadoButton = "recommendation.cansado.button"
    case cansadoTitle = "recommendation.cansado.title"
    case frustradoBody = "recommendation.frustrado.body"
    case frustradoButton = "recommendation.frustrado.button"
    case frustradoTitle = "recommendation.frustrado.title"
    case tranquiloBody = "recommendation.tranquilo.body"
    case tranquiloButton = "recommendation.tranquilo.button"
    case tranquiloTitle = "recommendation.tranquilo.title"
    case tristeBody = "recommendation.triste.body"
    case tristeButton = "recommendation.triste.button"
    case tristeTitle = "recommendation.triste.title"

    var localizedValue: String {
        switch self {
        case .abrumadoBody: String(localized: AppStrings.Recommendation.abrumadoBody)
        case .abrumadoButton: String(localized: AppStrings.Recommendation.abrumadoButton)
        case .abrumadoTitle: String(localized: AppStrings.Recommendation.abrumadoTitle)
        case .ansiosoBody: String(localized: AppStrings.Recommendation.ansiosoBody)
        case .ansiosoBodyHigh: String(localized: AppStrings.Recommendation.ansiosoBodyHigh)
        case .ansiosoButton: String(localized: AppStrings.Recommendation.ansiosoButton)
        case .ansiosoTitle: String(localized: AppStrings.Recommendation.ansiosoTitle)
        case .cansadoBody: String(localized: AppStrings.Recommendation.cansadoBody)
        case .cansadoButton: String(localized: AppStrings.Recommendation.cansadoButton)
        case .cansadoTitle: String(localized: AppStrings.Recommendation.cansadoTitle)
        case .frustradoBody: String(localized: AppStrings.Recommendation.frustradoBody)
        case .frustradoButton: String(localized: AppStrings.Recommendation.frustradoButton)
        case .frustradoTitle: String(localized: AppStrings.Recommendation.frustradoTitle)
        case .tranquiloBody: String(localized: AppStrings.Recommendation.tranquiloBody)
        case .tranquiloButton: String(localized: AppStrings.Recommendation.tranquiloButton)
        case .tranquiloTitle: String(localized: AppStrings.Recommendation.tranquiloTitle)
        case .tristeBody: String(localized: AppStrings.Recommendation.tristeBody)
        case .tristeButton: String(localized: AppStrings.Recommendation.tristeButton)
        case .tristeTitle: String(localized: AppStrings.Recommendation.tristeTitle)
        }
    }
}
