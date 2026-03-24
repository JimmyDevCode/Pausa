import Foundation

extension AppRoute {
    static let deepLinkScheme = "pausa"

    var storageKey: String {
        switch self {
        case .checkIn: "checkIn"
        case .immediateHelp: "immediateHelp"
        case .exercises: "exercises"
        case .exercise(let exercise): "exercise:\(exercise.id)"
        case .journaling: "journaling"
        case .supportChat: "supportChat"
        case .history: "history"
        case .profile: "profile"
        }
    }

    init?(storageKey: String) {
        switch storageKey {
        case "checkIn":
            self = .checkIn
        case "immediateHelp":
            self = .immediateHelp
        case "exercises":
            self = .exercises
        case "journaling":
            self = .journaling
        case "supportChat":
            self = .supportChat
        case "history":
            self = .history
        case "profile":
            self = .profile
        default:
            guard storageKey.hasPrefix("exercise:") else { return nil }
            let id = storageKey.replacingOccurrences(of: "exercise:", with: "")
            guard let exercise = ExerciseLibrary.by(id: id) else { return nil }
            self = .exercise(exercise)
        }
    }

    var deepLinkURL: URL? {
        switch self {
        case .immediateHelp:
            URL(string: "\(Self.deepLinkScheme)://immediate-help")
        default:
            nil
        }
    }

    init?(url: URL) {
        guard url.scheme == Self.deepLinkScheme else { return nil }

        let normalizedTarget = (url.host ?? url.pathComponents.dropFirst().first ?? "")
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        switch normalizedTarget {
        case "immediate-help":
            self = .immediateHelp
        default:
            return nil
        }
    }
}
