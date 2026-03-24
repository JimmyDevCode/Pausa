import Foundation

struct SupportRecommendation {
    let title: String
    let body: String
    let route: AppRoute
    let buttonTitle: String
}

struct RecommendationEngine {
    func recommendation(for emotion: EmotionalState, stressLevel: Int) -> SupportRecommendation {
        switch emotion {
        case .ansioso:
            SupportRecommendation(
                title: String(localized: AppStrings.Recommendation.ansiosoTitle),
                body: stressLevel >= 7
                    ? String(localized: AppStrings.Recommendation.ansiosoBodyHigh)
                    : String(localized: AppStrings.Recommendation.ansiosoBody),
                route: .exercise(ExerciseLibrary.all[0]),
                buttonTitle: String(localized: AppStrings.Recommendation.ansiosoButton)
            )
        case .abrumado:
            SupportRecommendation(
                title: String(localized: AppStrings.Recommendation.abrumadoTitle),
                body: String(localized: AppStrings.Recommendation.abrumadoBody),
                route: .exercise(ExerciseLibrary.all[4]),
                buttonTitle: String(localized: AppStrings.Recommendation.abrumadoButton)
            )
        case .frustrado:
            SupportRecommendation(
                title: String(localized: AppStrings.Recommendation.frustradoTitle),
                body: String(localized: AppStrings.Recommendation.frustradoBody),
                route: .exercise(ExerciseLibrary.all[2]),
                buttonTitle: String(localized: AppStrings.Recommendation.frustradoButton)
            )
        case .cansado:
            SupportRecommendation(
                title: String(localized: AppStrings.Recommendation.cansadoTitle),
                body: String(localized: AppStrings.Recommendation.cansadoBody),
                route: .exercise(ExerciseLibrary.all[3]),
                buttonTitle: String(localized: AppStrings.Recommendation.cansadoButton)
            )
        case .triste:
            SupportRecommendation(
                title: String(localized: AppStrings.Recommendation.tristeTitle),
                body: String(localized: AppStrings.Recommendation.tristeBody),
                route: .journaling,
                buttonTitle: String(localized: AppStrings.Recommendation.tristeButton)
            )
        case .tranquilo:
            SupportRecommendation(
                title: String(localized: AppStrings.Recommendation.tranquiloTitle),
                body: String(localized: AppStrings.Recommendation.tranquiloBody),
                route: .journaling,
                buttonTitle: String(localized: AppStrings.Recommendation.tranquiloButton)
            )
        }
    }
}
