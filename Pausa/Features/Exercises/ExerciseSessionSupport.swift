import AVFoundation
import SwiftUI

struct ExerciseSessionCue: Equatable {
    let title: String
    let spokenText: String
    let scale: CGFloat
}

enum ExerciseSessionPacing {
    static func cue(for exercise: ExerciseDefinition, elapsedSeconds: Int) -> ExerciseSessionCue? {
        switch exercise.id {
        case "breathing-444":
            switch elapsedSeconds % 12 {
            case 0..<4:
                let text = String(localized: AppStrings.Exercise.Session.Cue.inhale)
                return ExerciseSessionCue(title: text, spokenText: text, scale: 1.12)
            case 4..<8:
                let text = String(localized: AppStrings.Exercise.Session.Cue.hold)
                return ExerciseSessionCue(title: text, spokenText: text, scale: 1.12)
            default:
                let text = String(localized: AppStrings.Exercise.Session.Cue.exhale)
                return ExerciseSessionCue(title: text, spokenText: text, scale: 0.94)
            }
        case "inhale-exhale":
            switch elapsedSeconds % 8 {
            case 0..<4:
                let text = String(localized: AppStrings.Exercise.Session.Cue.inhale)
                return ExerciseSessionCue(title: text, spokenText: text, scale: 1.1)
            default:
                let text = String(localized: AppStrings.Exercise.Session.Cue.exhale)
                return ExerciseSessionCue(title: text, spokenText: text, scale: 0.95)
            }
        case "grounding":
            switch elapsedSeconds % 18 {
            case 0..<6:
                return ExerciseSessionCue(
                    title: String(localized: AppStrings.Exercise.Session.Cue.observe),
                    spokenText: String(localized: AppStrings.Exercise.Session.Cue.observe),
                    scale: 1.0
                )
            case 6..<12:
                return ExerciseSessionCue(
                    title: String(localized: AppStrings.Exercise.Session.Cue.observe),
                    spokenText: String(localized: AppStrings.Exercise.Session.Cue.observeSounds),
                    scale: 1.02
                )
            default:
                return ExerciseSessionCue(
                    title: String(localized: AppStrings.Exercise.Session.Cue.observe),
                    spokenText: String(localized: AppStrings.Exercise.Session.Cue.observeTouch),
                    scale: 1.03
                )
            }
        case "relax":
            switch elapsedSeconds % 12 {
            case 0..<4:
                return ExerciseSessionCue(
                    title: String(localized: AppStrings.Exercise.Session.Cue.release),
                    spokenText: String(localized: AppStrings.Exercise.Session.Cue.release),
                    scale: 1.04
                )
            case 4..<8:
                return ExerciseSessionCue(
                    title: String(localized: AppStrings.Exercise.Session.Cue.release),
                    spokenText: String(localized: AppStrings.Exercise.Session.Cue.releaseJaw),
                    scale: 1.0
                )
            default:
                return ExerciseSessionCue(
                    title: String(localized: AppStrings.Exercise.Session.Cue.release),
                    spokenText: String(localized: AppStrings.Exercise.Session.Cue.releaseShoulders),
                    scale: 0.98
                )
            }
        case "anti-stress-pause":
            switch elapsedSeconds % 12 {
            case 0..<4:
                return ExerciseSessionCue(
                    title: String(localized: AppStrings.Exercise.Session.Cue.pause),
                    spokenText: String(localized: AppStrings.Exercise.Session.Cue.pause),
                    scale: 1.01
                )
            case 4..<8:
                return ExerciseSessionCue(
                    title: String(localized: AppStrings.Exercise.Session.Cue.pause),
                    spokenText: String(localized: AppStrings.Exercise.Session.Cue.pauseJaw),
                    scale: 1.03
                )
            default:
                return ExerciseSessionCue(
                    title: String(localized: AppStrings.Exercise.Session.Cue.pause),
                    spokenText: String(localized: AppStrings.Exercise.Session.Cue.pauseShoulders),
                    scale: 1.05
                )
            }
        default:
            return nil
        }
    }
}

final class ExerciseCuePlayer {
    private let synthesizer = AVSpeechSynthesizer()

    func play(_ text: String) {
        guard !text.isEmpty else { return }

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX") ?? AVSpeechSynthesisVoice(language: "es-ES")
        utterance.rate = 0.42
        utterance.volume = 0.35
        utterance.pitchMultiplier = 0.92
        synthesizer.speak(utterance)
    }

    func stop() {
        guard synthesizer.isSpeaking else { return }
        synthesizer.stopSpeaking(at: .immediate)
    }
}
