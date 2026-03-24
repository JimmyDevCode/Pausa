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
            ToolUsageEvent.self,
            ChatMessageRecord.self
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
            nickname: "Ari",
            preferredFeeling: DesiredFeeling.calma.rawValue,
            mainConcern: FocusArea.estres.rawValue
        )
        context.insert(profile)

        context.insert(
            EmotionalCheckIn(
                emotion: EmotionalState.abrumado.rawValue,
                stressLevel: 8,
                recommendationTitle: "Prueba una pausa mental breve",
                recommendationBody: "Tu día se siente cargado. Una pausa de dos minutos puede bajar un poco la intensidad.",
                recommendationRoute: "immediateHelp"
            )
        )

        context.insert(
            JournalEntry(
                feelingText: "Estoy con demasiadas ventanas abiertas en la cabeza.",
                affectingText: "La acumulación de pendientes y mensajes.",
                neededText: "Necesito bajar la velocidad un rato.",
                supportText: "Respirar y ordenar una sola prioridad."
            )
        )

        context.insert(
            ExerciseSessionRecord(
                exerciseID: "breathing-444",
                title: "Respiración 4-4-4",
                source: "home",
                helpfulness: 4
            )
        )

        context.insert(ToolUsageEvent(name: "home_returned"))
        context.insert(ChatMessageRecord(text: "Hola, hoy me siento saturado.", isFromUser: true))
        context.insert(
            ChatMessageRecord(
                text: "Vamos despacio. Si quieres, puedo sugerirte una respiración corta o un check-in rápido.",
                isFromUser: false,
                suggestedRoute: "immediateHelp"
            )
        )
    }
}
