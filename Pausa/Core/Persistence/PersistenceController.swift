import SwiftData

@MainActor
struct PersistenceController {
    static let shared = PersistenceController()
    static let preview = PersistenceController(inMemory: true)

    let container: ModelContainer

    init(inMemory: Bool = false) {
        let schema = Schema([
            UserProfile.self,
            EmotionalCheckIn.self,
            JournalEntry.self,
            ExerciseSessionRecord.self,
            ToolUsageEvent.self
        ])

        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        container = try! ModelContainer(for: schema, configurations: configuration)

        if inMemory {
            PreviewSeeder.seed(into: container.mainContext)
        }
    }
}

@MainActor
enum PreviewSeeder {
    static func seed(into context: ModelContext) {
        let profile = UserProfile(
            nickname: String(localized: AppStrings.Preview.nickname),
            preferredFeeling: DesiredFeeling.calma.rawValue,
            mainConcern: FocusArea.estres.rawValue
        )
        context.insert(profile)

        context.insert(
            EmotionalCheckIn(
                emotion: EmotionalState.abrumado.rawValue,
                stressLevel: 8,
                recommendationTitle: AppRecommendationText.abrumadoTitle.rawValue,
                recommendationBody: AppRecommendationText.abrumadoBody.rawValue,
                recommendationRoute: "immediateHelp"
            )
        )

        context.insert(
            JournalEntry(
                feelingText: String(localized: AppStrings.Preview.journalFeeling)
            )
        )

        context.insert(
            ExerciseSessionRecord(
                exerciseID: "breathing-444",
                title: ExerciseLibrary.all.first(where: { $0.id == "breathing-444" })?.title ?? "",
                source: "home",
                helpfulness: 4
            )
        )

        context.insert(ToolUsageEvent(name: "home_returned"))
    }
}
