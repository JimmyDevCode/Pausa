import AVFoundation
import SwiftUI

struct ExerciseSessionCue: Equatable {
    let title: String
    let spokenText: String
    let scale: CGFloat
}

struct ExerciseSessionOrbState {
    let scale: CGFloat
    let haloScale: CGFloat
    let haloOpacity: Double
    let ringTrim: CGFloat
    let innerOpacity: Double
    let symbolScale: CGFloat
}

private struct ExerciseSessionBreathSegment {
    let duration: TimeInterval
    let startScale: CGFloat
    let endScale: CGFloat
    let startHaloScale: CGFloat
    let endHaloScale: CGFloat
    let startHaloOpacity: Double
    let endHaloOpacity: Double
    let startInnerOpacity: Double
    let endInnerOpacity: Double
    let startSymbolScale: CGFloat
    let endSymbolScale: CGFloat
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

    static func orbState(
        for exercise: ExerciseDefinition,
        elapsedTime: TimeInterval,
        isRunning: Bool,
        completed: Bool
    ) -> ExerciseSessionOrbState {
        guard !completed else {
            return ExerciseSessionOrbState(
                scale: 1.02,
                haloScale: 1.16,
                haloOpacity: 0.26,
                ringTrim: 1,
                innerOpacity: 0.92,
                symbolScale: 1
            )
        }

        guard isRunning else {
            return ExerciseSessionOrbState(
                scale: 0.9,
                haloScale: 1.04,
                haloOpacity: 0.16,
                ringTrim: 0.08,
                innerOpacity: 0.78,
                symbolScale: 0.96
            )
        }

        switch exercise.id {
        case "breathing-444":
            return interpolatedOrbState(
                elapsedTime: elapsedTime,
                segments: [
                    ExerciseSessionBreathSegment(
                        duration: 4,
                        startScale: 0.84,
                        endScale: 1.12,
                        startHaloScale: 1.02,
                        endHaloScale: 1.3,
                        startHaloOpacity: 0.14,
                        endHaloOpacity: 0.3,
                        startInnerOpacity: 0.74,
                        endInnerOpacity: 0.94,
                        startSymbolScale: 0.94,
                        endSymbolScale: 1.04
                    ),
                    ExerciseSessionBreathSegment(
                        duration: 4,
                        startScale: 1.12,
                        endScale: 1.12,
                        startHaloScale: 1.3,
                        endHaloScale: 1.34,
                        startHaloOpacity: 0.3,
                        endHaloOpacity: 0.22,
                        startInnerOpacity: 0.94,
                        endInnerOpacity: 0.9,
                        startSymbolScale: 1.04,
                        endSymbolScale: 1.02
                    ),
                    ExerciseSessionBreathSegment(
                        duration: 4,
                        startScale: 1.12,
                        endScale: 0.88,
                        startHaloScale: 1.34,
                        endHaloScale: 1.08,
                        startHaloOpacity: 0.22,
                        endHaloOpacity: 0.12,
                        startInnerOpacity: 0.9,
                        endInnerOpacity: 0.76,
                        startSymbolScale: 1.02,
                        endSymbolScale: 0.95
                    )
                ]
            )
        case "inhale-exhale":
            return interpolatedOrbState(
                elapsedTime: elapsedTime,
                segments: [
                    ExerciseSessionBreathSegment(
                        duration: 4,
                        startScale: 0.86,
                        endScale: 1.1,
                        startHaloScale: 1.04,
                        endHaloScale: 1.28,
                        startHaloOpacity: 0.15,
                        endHaloOpacity: 0.28,
                        startInnerOpacity: 0.76,
                        endInnerOpacity: 0.93,
                        startSymbolScale: 0.95,
                        endSymbolScale: 1.03
                    ),
                    ExerciseSessionBreathSegment(
                        duration: 4,
                        startScale: 1.1,
                        endScale: 0.9,
                        startHaloScale: 1.28,
                        endHaloScale: 1.08,
                        startHaloOpacity: 0.28,
                        endHaloOpacity: 0.14,
                        startInnerOpacity: 0.93,
                        endInnerOpacity: 0.78,
                        startSymbolScale: 1.03,
                        endSymbolScale: 0.96
                    )
                ]
            )
        default:
            let pulse = 0.5 - 0.5 * cos((elapsedTime / 6) * .pi * 2)
            return ExerciseSessionOrbState(
                scale: 0.96 + (0.06 * pulse),
                haloScale: 1.08 + (0.1 * pulse),
                haloOpacity: 0.14 + (0.06 * pulse),
                ringTrim: 0.18 + (0.64 * pulse),
                innerOpacity: 0.8 + (0.08 * pulse),
                symbolScale: 0.97 + (0.04 * pulse)
            )
        }
    }

    private static func interpolatedOrbState(
        elapsedTime: TimeInterval,
        segments: [ExerciseSessionBreathSegment]
    ) -> ExerciseSessionOrbState {
        let cycleDuration = segments.reduce(0) { $0 + $1.duration }
        guard cycleDuration > 0 else {
            return ExerciseSessionOrbState(
                scale: 1,
                haloScale: 1.1,
                haloOpacity: 0.2,
                ringTrim: 0.12,
                innerOpacity: 0.84,
                symbolScale: 1
            )
        }

        let cycleProgress = (elapsedTime.truncatingRemainder(dividingBy: cycleDuration) + cycleDuration)
            .truncatingRemainder(dividingBy: cycleDuration)
        var accumulated: TimeInterval = 0

        for segment in segments {
            let segmentEnd = accumulated + segment.duration
            if cycleProgress <= segmentEnd {
                let rawProgress = segment.duration > 0 ? (cycleProgress - accumulated) / segment.duration : 0
                let easedProgress = easedValue(rawProgress)

                return ExerciseSessionOrbState(
                    scale: interpolate(segment.startScale, segment.endScale, easedProgress),
                    haloScale: interpolate(segment.startHaloScale, segment.endHaloScale, easedProgress),
                    haloOpacity: interpolate(segment.startHaloOpacity, segment.endHaloOpacity, easedProgress),
                    ringTrim: max(0.08, min(1, CGFloat(cycleProgress / cycleDuration))),
                    innerOpacity: interpolate(segment.startInnerOpacity, segment.endInnerOpacity, easedProgress),
                    symbolScale: interpolate(segment.startSymbolScale, segment.endSymbolScale, easedProgress)
                )
            }
            accumulated = segmentEnd
        }

        return ExerciseSessionOrbState(
            scale: segments.last?.endScale ?? 1,
            haloScale: segments.last?.endHaloScale ?? 1.1,
            haloOpacity: segments.last?.endHaloOpacity ?? 0.2,
            ringTrim: 1,
            innerOpacity: segments.last?.endInnerOpacity ?? 0.84,
            symbolScale: segments.last?.endSymbolScale ?? 1
        )
    }

    private static func easedValue(_ progress: Double) -> Double {
        let clamped = max(0, min(1, progress))
        return 0.5 - 0.5 * cos(clamped * .pi)
    }

    private static func interpolate(_ start: CGFloat, _ end: CGFloat, _ progress: Double) -> CGFloat {
        start + ((end - start) * CGFloat(progress))
    }

    private static func interpolate(_ start: Double, _ end: Double, _ progress: Double) -> Double {
        start + ((end - start) * progress)
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
