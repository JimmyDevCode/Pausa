import Foundation

struct SupportRecommendation {
    let titleKey: AppRecommendationText
    let bodyKey: AppRecommendationText
    let route: AppRoute
    let buttonTitleKey: AppRecommendationText

    var title: String { titleKey.localizedValue }
    var body: String { bodyKey.localizedValue }
    var buttonTitle: String { buttonTitleKey.localizedValue }
}

struct RecommendationEngine {
    func recommendation(for emotion: EmotionalState, stressLevel: Int) -> SupportRecommendation {
        switch emotion {
        case .ansioso:
            SupportRecommendation(
                titleKey: .ansiosoTitle,
                bodyKey: stressLevel >= 7 ? .ansiosoBodyHigh : .ansiosoBody,
                route: .exercise(ExerciseLibrary.all[0]),
                buttonTitleKey: .ansiosoButton
            )
        case .abrumado:
            SupportRecommendation(
                titleKey: .abrumadoTitle,
                bodyKey: .abrumadoBody,
                route: .exercise(ExerciseLibrary.all[4]),
                buttonTitleKey: .abrumadoButton
            )
        case .frustrado:
            SupportRecommendation(
                titleKey: .frustradoTitle,
                bodyKey: .frustradoBody,
                route: .exercise(ExerciseLibrary.all[2]),
                buttonTitleKey: .frustradoButton
            )
        case .cansado:
            SupportRecommendation(
                titleKey: .cansadoTitle,
                bodyKey: .cansadoBody,
                route: .exercise(ExerciseLibrary.all[3]),
                buttonTitleKey: .cansadoButton
            )
        case .triste:
            SupportRecommendation(
                titleKey: .tristeTitle,
                bodyKey: .tristeBody,
                route: .journaling,
                buttonTitleKey: .tristeButton
            )
        case .tranquilo:
            SupportRecommendation(
                titleKey: .tranquiloTitle,
                bodyKey: .tranquiloBody,
                route: .journaling,
                buttonTitleKey: .tranquiloButton
            )
        }
    }
}
