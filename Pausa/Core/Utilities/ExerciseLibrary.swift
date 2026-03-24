import Foundation

struct ExerciseTag: Hashable {
    let title: String
}

enum ExerciseEvidenceLevel: String, Hashable {
    case investigado
    case complementario

    var title: String {
        switch self {
        case .investigado:
            String(localized: AppStrings.ExerciseEvidence.investigadoTitle)
        case .complementario:
            String(localized: AppStrings.ExerciseEvidence.complementarioTitle)
        }
    }

    var shortTitle: String {
        switch self {
        case .investigado:
            String(localized: AppStrings.ExerciseEvidence.investigadoShort)
        case .complementario:
            String(localized: AppStrings.ExerciseEvidence.complementarioShort)
        }
    }
}

struct ExerciseReference: Identifiable, Hashable {
    let title: String
    let source: String
    let url: String

    var id: String { url }
}

struct ExerciseDefinition: Identifiable, Hashable {
    let id: String
    let title: String
    let summary: String
    let durationSeconds: Int
    let detail: String
    let evidenceLevel: ExerciseEvidenceLevel
    let evidenceSummary: String
    let originStory: String
    let careNote: String?
    let references: [ExerciseReference]
    let closingPrompt: String

    var quickTags: [ExerciseTag] {
        switch id {
        case "breathing-444":
            [
                ExerciseTag(title: String(localized: AppStrings.Exercise.Tag.respira)),
                ExerciseTag(title: String(localized: AppStrings.Exercise.Tag.calma))
            ]
        case "inhale-exhale":
            [
                ExerciseTag(title: String(localized: AppStrings.Exercise.Tag.respira)),
                ExerciseTag(title: String(localized: AppStrings.Exercise.Tag.ritmo))
            ]
        case "grounding":
            [
                ExerciseTag(title: String(localized: AppStrings.Exercise.Tag.presente)),
                ExerciseTag(title: String(localized: AppStrings.Exercise.Tag.enfoque))
            ]
        case "relax":
            [
                ExerciseTag(title: String(localized: AppStrings.Exercise.Tag.suelta)),
                ExerciseTag(title: String(localized: AppStrings.Exercise.Tag.body))
            ]
        case "anti-stress-pause":
            [
                ExerciseTag(title: String(localized: AppStrings.Exercise.Tag.pausa)),
                ExerciseTag(title: String(localized: AppStrings.Exercise.Tag.calma))
            ]
        default:
            []
        }
    }
}

enum ExerciseLibrary {
    static let all: [ExerciseDefinition] = [
        ExerciseDefinition(
            id: "breathing-444",
            title: String(localized: AppStrings.Exercise.breathing444Title),
            summary: String(localized: AppStrings.Exercise.breathing444Summary),
            durationSeconds: 60,
            detail: String(localized: AppStrings.Exercise.breathing444Detail),
            evidenceLevel: .investigado,
            evidenceSummary: String(localized: AppStrings.Exercise.breathing444Evidence),
            originStory: String(localized: AppStrings.Exercise.breathing444Origin),
            careNote: String(localized: AppStrings.Exercise.breathing444Care),
            references: [
                ExerciseReference(
                    title: String(localized: AppStrings.Reference.breathworkReviewTitle),
                    source: String(localized: AppStrings.Reference.systematicReview),
                    url: "https://pmc.ncbi.nlm.nih.gov/articles/PMC10741869/"
                ),
                ExerciseReference(
                    title: String(localized: AppStrings.Reference.pranayamaReviewTitle),
                    source: String(localized: AppStrings.Reference.narrativeReview),
                    url: "https://pmc.ncbi.nlm.nih.gov/articles/PMC3415184/"
                )
            ],
            closingPrompt: String(localized: AppStrings.Exercise.breathing444Closing)
        ),
        ExerciseDefinition(
            id: "inhale-exhale",
            title: String(localized: AppStrings.Exercise.inhaleExhaleTitle),
            summary: String(localized: AppStrings.Exercise.inhaleExhaleSummary),
            durationSeconds: 75,
            detail: String(localized: AppStrings.Exercise.inhaleExhaleDetail),
            evidenceLevel: .investigado,
            evidenceSummary: String(localized: AppStrings.Exercise.inhaleExhaleEvidence),
            originStory: String(localized: AppStrings.Exercise.inhaleExhaleOrigin),
            careNote: String(localized: AppStrings.Exercise.inhaleExhaleCare),
            references: [
                ExerciseReference(
                    title: String(localized: AppStrings.Reference.breathworkReviewTitle),
                    source: String(localized: AppStrings.Reference.systematicReview),
                    url: "https://pmc.ncbi.nlm.nih.gov/articles/PMC10741869/"
                ),
                ExerciseReference(
                    title: String(localized: AppStrings.Reference.yogaHealthTitle),
                    source: "NCCIH",
                    url: "https://www.nccih.nih.gov/health/providers/digest/yoga-for-health"
                )
            ],
            closingPrompt: String(localized: AppStrings.Exercise.inhaleExhaleClosing)
        ),
        ExerciseDefinition(
            id: "grounding",
            title: String(localized: AppStrings.Exercise.groundingTitle),
            summary: String(localized: AppStrings.Exercise.groundingSummary),
            durationSeconds: 90,
            detail: String(localized: AppStrings.Exercise.groundingDetail),
            evidenceLevel: .complementario,
            evidenceSummary: String(localized: AppStrings.Exercise.groundingEvidence),
            originStory: String(localized: AppStrings.Exercise.groundingOrigin),
            careNote: nil,
            references: [],
            closingPrompt: String(localized: AppStrings.Exercise.groundingClosing)
        ),
        ExerciseDefinition(
            id: "relax",
            title: String(localized: AppStrings.Exercise.relaxTitle),
            summary: String(localized: AppStrings.Exercise.relaxSummary),
            durationSeconds: 80,
            detail: String(localized: AppStrings.Exercise.relaxDetail),
            evidenceLevel: .investigado,
            evidenceSummary: String(localized: AppStrings.Exercise.relaxEvidence),
            originStory: String(localized: AppStrings.Exercise.relaxOrigin),
            careNote: String(localized: AppStrings.Exercise.relaxCare),
            references: [
                ExerciseReference(
                    title: String(localized: AppStrings.Reference.breathworkReviewTitle),
                    source: String(localized: AppStrings.Reference.systematicReview),
                    url: "https://pmc.ncbi.nlm.nih.gov/articles/PMC10741869/"
                ),
                ExerciseReference(
                    title: String(localized: AppStrings.Reference.pranayamaReviewTitle),
                    source: String(localized: AppStrings.Reference.narrativeReview),
                    url: "https://pmc.ncbi.nlm.nih.gov/articles/PMC3415184/"
                )
            ],
            closingPrompt: String(localized: AppStrings.Exercise.relaxClosing)
        ),
        ExerciseDefinition(
            id: "anti-stress-pause",
            title: String(localized: AppStrings.Exercise.antiStressPauseTitle),
            summary: String(localized: AppStrings.Exercise.antiStressPauseSummary),
            durationSeconds: 120,
            detail: String(localized: AppStrings.Exercise.antiStressPauseDetail),
            evidenceLevel: .complementario,
            evidenceSummary: String(localized: AppStrings.Exercise.antiStressPauseEvidence),
            originStory: String(localized: AppStrings.Exercise.antiStressPauseOrigin),
            careNote: nil,
            references: [],
            closingPrompt: String(localized: AppStrings.Exercise.antiStressPauseClosing)
        )
    ]

    static let immediateHelp = [
        all[0],
        all[2],
        all[4]
    ]

    static func by(id: String) -> ExerciseDefinition? {
        all.first(where: { $0.id == id })
    }
}
