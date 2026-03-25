import Foundation

enum AppStrings {
    enum Common {
        static let ctaOpen: LocalizedStringResource = "common.cta.open"
        static let ctaViewDetails: LocalizedStringResource = "common.cta.view_details"
        static let ctaViewExercise: LocalizedStringResource = "common.cta.view_exercise"
    }

    enum Chat {
        static let buttonOpenSuggestion: LocalizedStringResource = "chat.button.open_suggestion"
        static let buttonSend: LocalizedStringResource = "chat.button.send"
        static let disclaimer: LocalizedStringResource = "chat.disclaimer"
        static let navigationTitle: LocalizedStringResource = "chat.navigation.title"
        static let placeholder: LocalizedStringResource = "chat.placeholder"
        static let replyAbrumado: LocalizedStringResource = "chat.reply.abrumado"
        static let replyAnsiedad: LocalizedStringResource = "chat.reply.ansiedad"
        static let replyDefault: LocalizedStringResource = "chat.reply.default"
        static let replyIntenso: LocalizedStringResource = "chat.reply.intenso"
        static let replySueno: LocalizedStringResource = "chat.reply.sueno"
        static let replyUrgent: LocalizedStringResource = "chat.reply.urgent"
    }

    enum CheckIn {
        static let buttonSave: LocalizedStringResource = "checkin.button.save"
        static let emotionSubtitle: LocalizedStringResource = "checkin.emotion.subtitle"
        static let emotionTitle: LocalizedStringResource = "checkin.emotion.title"
        static let navigationTitle: LocalizedStringResource = "checkin.navigation.title"
        static let stressTitle: LocalizedStringResource = "checkin.stress.title"
        static let stressValueFormat: LocalizedStringResource = "checkin.stress.value_format"
    }

    enum Desired {
        static let calma: LocalizedStringResource = "desired.calma"
        static let claridad: LocalizedStringResource = "desired.claridad"
        static let descanso: LocalizedStringResource = "desired.descanso"
        static let enfoque: LocalizedStringResource = "desired.enfoque"
        static let ligereza: LocalizedStringResource = "desired.ligereza"
    }

    enum Emotion {
        static let abrumado: LocalizedStringResource = "emotion.abrumado"
        static let ansioso: LocalizedStringResource = "emotion.ansioso"
        static let cansado: LocalizedStringResource = "emotion.cansado"
        static let frustrado: LocalizedStringResource = "emotion.frustrado"
        static let tranquilo: LocalizedStringResource = "emotion.tranquilo"
        static let triste: LocalizedStringResource = "emotion.triste"
    }

    enum EmotionSupport {
        static let abrumado: LocalizedStringResource = "emotion_support.abrumado"
        static let ansioso: LocalizedStringResource = "emotion_support.ansioso"
        static let cansado: LocalizedStringResource = "emotion_support.cansado"
        static let frustrado: LocalizedStringResource = "emotion_support.frustrado"
        static let tranquilo: LocalizedStringResource = "emotion_support.tranquilo"
        static let triste: LocalizedStringResource = "emotion_support.triste"
    }

    enum Exercise {
        static let antiStressPauseClosing: LocalizedStringResource = "exercise.anti_stress_pause.closing"
        static let antiStressPauseDetail: LocalizedStringResource = "exercise.anti_stress_pause.detail"
        static let antiStressPauseEvidence: LocalizedStringResource = "exercise.anti_stress_pause.evidence"
        static let antiStressPauseOrigin: LocalizedStringResource = "exercise.anti_stress_pause.origin"
        static let antiStressPauseSummary: LocalizedStringResource = "exercise.anti_stress_pause.summary"
        static let antiStressPauseTitle: LocalizedStringResource = "exercise.anti_stress_pause.title"
        static let badgeContext: LocalizedStringResource = "exercise.badge.context"
        static let breathing444Care: LocalizedStringResource = "exercise.breathing_444.care"
        static let breathing444Closing: LocalizedStringResource = "exercise.breathing_444.closing"
        static let breathing444Detail: LocalizedStringResource = "exercise.breathing_444.detail"
        static let breathing444Evidence: LocalizedStringResource = "exercise.breathing_444.evidence"
        static let breathing444Origin: LocalizedStringResource = "exercise.breathing_444.origin"
        static let breathing444Summary: LocalizedStringResource = "exercise.breathing_444.summary"
        static let breathing444Title: LocalizedStringResource = "exercise.breathing_444.title"
        static let durationFormat: LocalizedStringResource = "exercise.duration_format"
        static let durationMinutesFormat: LocalizedStringResource = "exercise.duration_minutes_format"
        static let durationOneMinute: LocalizedStringResource = "exercise.duration_one_minute"
        static let durationSecondsFormat: LocalizedStringResource = "exercise.duration_seconds_format"
        static let groundingClosing: LocalizedStringResource = "exercise.grounding.closing"
        static let groundingDetail: LocalizedStringResource = "exercise.grounding.detail"
        static let groundingEvidence: LocalizedStringResource = "exercise.grounding.evidence"
        static let groundingOrigin: LocalizedStringResource = "exercise.grounding.origin"
        static let groundingSummary: LocalizedStringResource = "exercise.grounding.summary"
        static let groundingTitle: LocalizedStringResource = "exercise.grounding.title"
        static let inhaleExhaleCare: LocalizedStringResource = "exercise.inhale_exhale.care"
        static let inhaleExhaleClosing: LocalizedStringResource = "exercise.inhale_exhale.closing"
        static let inhaleExhaleDetail: LocalizedStringResource = "exercise.inhale_exhale.detail"
        static let inhaleExhaleEvidence: LocalizedStringResource = "exercise.inhale_exhale.evidence"
        static let inhaleExhaleOrigin: LocalizedStringResource = "exercise.inhale_exhale.origin"
        static let inhaleExhaleSummary: LocalizedStringResource = "exercise.inhale_exhale.summary"
        static let inhaleExhaleTitle: LocalizedStringResource = "exercise.inhale_exhale.title"
        static let navigationTitle: LocalizedStringResource = "exercise.navigation.title"
        static let relaxCare: LocalizedStringResource = "exercise.relax.care"
        static let relaxClosing: LocalizedStringResource = "exercise.relax.closing"
        static let relaxDetail: LocalizedStringResource = "exercise.relax.detail"
        static let relaxEvidence: LocalizedStringResource = "exercise.relax.evidence"
        static let relaxOrigin: LocalizedStringResource = "exercise.relax.origin"
        static let relaxSummary: LocalizedStringResource = "exercise.relax.summary"
        static let relaxTitle: LocalizedStringResource = "exercise.relax.title"

        enum Session {
            static let buttonPause: LocalizedStringResource = "exercise.session.button.pause"
            static let buttonStart: LocalizedStringResource = "exercise.session.button.start"
            static let care: LocalizedStringResource = "exercise.session.care"
            static let context: LocalizedStringResource = "exercise.session.context"
            static let feedbackALittle: LocalizedStringResource = "exercise.session.feedback.a_little"
            static let feedbackNo: LocalizedStringResource = "exercise.session.feedback.no"
            static let feedbackQuestion: LocalizedStringResource = "exercise.session.feedback.question"
            static let feedbackYes: LocalizedStringResource = "exercise.session.feedback.yes"
            static let navigationTitle: LocalizedStringResource = "exercise.session.navigation.title"
            static let repeatNote: LocalizedStringResource = "exercise.session.repeat_note"
            static let statusCompleted: LocalizedStringResource = "exercise.session.status.completed"
            static let statusReady: LocalizedStringResource = "exercise.session.status.ready"
            static let statusRunning: LocalizedStringResource = "exercise.session.status.running"
            static let whatWeKnow: LocalizedStringResource = "exercise.session.what_we_know"

            enum Cue {
                static let exhale: LocalizedStringResource = "exercise.session.cue.exhale"
                static let hold: LocalizedStringResource = "exercise.session.cue.hold"
                static let inhale: LocalizedStringResource = "exercise.session.cue.inhale"
                static let observe: LocalizedStringResource = "exercise.session.cue.observe"
                static let observeSounds: LocalizedStringResource = "exercise.session.cue.observe_sounds"
                static let observeTouch: LocalizedStringResource = "exercise.session.cue.observe_touch"
                static let pause: LocalizedStringResource = "exercise.session.cue.pause"
                static let pauseJaw: LocalizedStringResource = "exercise.session.cue.pause_jaw"
                static let pauseShoulders: LocalizedStringResource = "exercise.session.cue.pause_shoulders"
                static let release: LocalizedStringResource = "exercise.session.cue.release"
                static let releaseJaw: LocalizedStringResource = "exercise.session.cue.release_jaw"
                static let releaseShoulders: LocalizedStringResource = "exercise.session.cue.release_shoulders"
            }
        }

        enum Sources {
            static let body: LocalizedStringResource = "exercise.sources.body"
        }

        enum Tag {
            static let body: LocalizedStringResource = "exercise.tag.body"
            static let calma: LocalizedStringResource = "exercise.tag.calma"
            static let enfoque: LocalizedStringResource = "exercise.tag.enfoque"
            static let pausa: LocalizedStringResource = "exercise.tag.pausa"
            static let presente: LocalizedStringResource = "exercise.tag.presente"
            static let respira: LocalizedStringResource = "exercise.tag.respira"
            static let ritmo: LocalizedStringResource = "exercise.tag.ritmo"
            static let suelta: LocalizedStringResource = "exercise.tag.suelta"
        }
    }

    enum ExerciseEvidence {
        static let complementarioShort: LocalizedStringResource = "exercise_evidence.complementario.short"
        static let complementarioTitle: LocalizedStringResource = "exercise_evidence.complementario.title"
        static let investigadoShort: LocalizedStringResource = "exercise_evidence.investigado.short"
        static let investigadoTitle: LocalizedStringResource = "exercise_evidence.investigado.title"
    }

    enum Focus {
        static let agotamiento: LocalizedStringResource = "focus.agotamiento"
        static let ansiedad: LocalizedStringResource = "focus.ansiedad"
        static let enfoque: LocalizedStringResource = "focus.enfoque"
        static let estres: LocalizedStringResource = "focus.estres"
        static let sueno: LocalizedStringResource = "focus.sueno"
    }

    enum History {
        static let countFormat: LocalizedStringResource = "history.count_format"
        static let emptyBody: LocalizedStringResource = "history.empty.body"
        static let emptyTitle: LocalizedStringResource = "history.empty.title"
        static let metricExercises: LocalizedStringResource = "history.metric.exercises"
        static let metricWeek: LocalizedStringResource = "history.metric.week"
        static let navigationTitle: LocalizedStringResource = "history.navigation.title"
        static let previewButton: LocalizedStringResource = "history.preview.button"
        static let previewEmptyBody: LocalizedStringResource = "history.preview.empty_body"
        static let previewTitle: LocalizedStringResource = "history.preview.title"
        static let recentActivityTitle: LocalizedStringResource = "history.recent_activity.title"
        static let repeatedEmotionsTitle: LocalizedStringResource = "history.repeated_emotions.title"
        static let summaryBodyFormat: LocalizedStringResource = "history.summary.body_format"
        static let summaryCommonEmotionFormat: LocalizedStringResource = "history.summary.common_emotion_format"
        static let summaryTitle: LocalizedStringResource = "history.summary.title"
        static let toolsRecentUses: LocalizedStringResource = "history.tools.recent_uses"
        static let toolsTitle: LocalizedStringResource = "history.tools.title"
        static let writingsBodyFormat: LocalizedStringResource = "history.writings.body_format"
        static let writingsEmptyBody: LocalizedStringResource = "history.writings.empty_body"
        static let writingsTitle: LocalizedStringResource = "history.writings.title"

        enum Item {
            static let chatTitle: LocalizedStringResource = "history.item.chat.title"
            static let checkInTitle: LocalizedStringResource = "history.item.checkin.title"
            static let checkInBodyFormat: LocalizedStringResource = "history.item.checkin.body_format"
            static let exerciseTitle: LocalizedStringResource = "history.item.exercise.title"
            static let journalTitle: LocalizedStringResource = "history.item.journal.title"
        }

        enum Tool {
            static let checkInCompleted: LocalizedStringResource = "history.tool.checkin_completed"
            static let chatMessageSent: LocalizedStringResource = "history.tool.chat_message_sent"
            static let exerciseCompleted: LocalizedStringResource = "history.tool.exercise_completed"
            static let exerciseStarted: LocalizedStringResource = "history.tool.exercise_started"
            static let homeReturned: LocalizedStringResource = "history.tool.home_returned"
            static let immediateHelpUsed: LocalizedStringResource = "history.tool.immediate_help_used"
            static let journalingSaved: LocalizedStringResource = "history.tool.journaling_saved"
            static let onboardingCompleted: LocalizedStringResource = "history.tool.onboarding_completed"
        }
    }

    enum Home {
        static let checkInButtonEmpty: LocalizedStringResource = "home.checkin.button_empty"
        static let checkInButtonLatest: LocalizedStringResource = "home.checkin.button_latest"
        static let checkInSubtitleEmpty: LocalizedStringResource = "home.checkin.subtitle_empty"
        static let checkInTitleEmpty: LocalizedStringResource = "home.checkin.title_empty"
        static let checkInTitleLatest: LocalizedStringResource = "home.checkin.title_latest"
        static let disclaimer: LocalizedStringResource = "home.disclaimer"
        static let emergencyBody: LocalizedStringResource = "home.emergency.body"
        static let emergencyButton: LocalizedStringResource = "home.emergency.button"
        static let emergencyTitle: LocalizedStringResource = "home.emergency.title"
        static let headerGreetingFormat: LocalizedStringResource = "home.header.greeting_format"
        static let headerSubtitleEmpty: LocalizedStringResource = "home.header.subtitle_empty"
        static let headerSubtitleLatestFormat: LocalizedStringResource = "home.header.subtitle_latest_format"
        static let latestStateFormat: LocalizedStringResource = "home.latest_state.format"
        static let menuProfile: LocalizedStringResource = "home.menu.profile"
        static let metricCheckIns: LocalizedStringResource = "home.metric.checkins"
        static let metricExercises: LocalizedStringResource = "home.metric.exercises"
        static let metricNotes: LocalizedStringResource = "home.metric.notes"
        static let navigationTitle: LocalizedStringResource = "home.navigation.title"
        static let historyCardBody: LocalizedStringResource = "home.history_card.body"
        static let historyCardButton: LocalizedStringResource = "home.history_card.button"
        static let historyCardTitle: LocalizedStringResource = "home.history_card.title"
        static let progressLatestRecommendationFormat: LocalizedStringResource = "home.progress.latest_recommendation_format"
        static let progressSummaryFormat: LocalizedStringResource = "home.progress.summary_format"
        static let progressTitle: LocalizedStringResource = "home.progress.title"
        static let toolsTitle: LocalizedStringResource = "home.tools.title"
        static let toolsChatSubtitle: LocalizedStringResource = "home.tools.chat.subtitle"
        static let toolsChatTitle: LocalizedStringResource = "home.tools.chat.title"
        static let toolsExercisesSubtitle: LocalizedStringResource = "home.tools.exercises.subtitle"
        static let toolsExercisesTitle: LocalizedStringResource = "home.tools.exercises.title"
        static let toolsHistorySubtitle: LocalizedStringResource = "home.tools.history.subtitle"
        static let toolsHistoryTitle: LocalizedStringResource = "home.tools.history.title"
        static let toolsJournalingSubtitle: LocalizedStringResource = "home.tools.journaling.subtitle"
        static let toolsJournalingTitle: LocalizedStringResource = "home.tools.journaling.title"
    }

    enum ImmediateHelp {
        static let headerBody: LocalizedStringResource = "immediate_help.header.body"
        static let headerTitle: LocalizedStringResource = "immediate_help.header.title"
        static let intenseBody: LocalizedStringResource = "immediate_help.intense.body"
        static let intenseTitle: LocalizedStringResource = "immediate_help.intense.title"
        static let navigationTitle: LocalizedStringResource = "immediate_help.navigation.title"
    }

    enum Journaling {
        static let buttonBack: LocalizedStringResource = "journaling.button.back"
        static let buttonNext: LocalizedStringResource = "journaling.button.next"
        static let buttonSave: LocalizedStringResource = "journaling.button.save"
        static let detailTitle: LocalizedStringResource = "journaling.detail.title"
        static let emptyBody: LocalizedStringResource = "journaling.empty.body"
        static let emptyTitle: LocalizedStringResource = "journaling.empty.title"
        static let fieldAffecting: LocalizedStringResource = "journaling.field.affecting"
        static let fieldFeeling: LocalizedStringResource = "journaling.field.feeling"
        static let fieldNeeded: LocalizedStringResource = "journaling.field.needed"
        static let fieldSupport: LocalizedStringResource = "journaling.field.support"
        static let navigationTitle: LocalizedStringResource = "journaling.navigation.title"
        static let placeholder: LocalizedStringResource = "journaling.placeholder"
        static let previousEntries: LocalizedStringResource = "journaling.previous_entries"
        static let stepFormat: LocalizedStringResource = "journaling.step.format"
        static let stepReflectionBody: LocalizedStringResource = "journaling.step.reflection.body"
        static let stepReflectionTitle: LocalizedStringResource = "journaling.step.reflection.title"
        static let stepSupportBody: LocalizedStringResource = "journaling.step.support.body"
        static let stepSupportTitle: LocalizedStringResource = "journaling.step.support.title"
    }

    enum Tab {
        static let home: LocalizedStringResource = "tab.home"
        static let pause: LocalizedStringResource = "tab.pause"
        static let profile: LocalizedStringResource = "tab.profile"
        static let progress: LocalizedStringResource = "tab.progress"
        static let write: LocalizedStringResource = "tab.write"
    }

    enum WriteHub {
        static let archiveBody: LocalizedStringResource = "write_hub.archive.body"
        static let archiveButton: LocalizedStringResource = "write_hub.archive.button"
        static let archiveTitle: LocalizedStringResource = "write_hub.archive.title"
        static let body: LocalizedStringResource = "write_hub.body"
        static let chatBody: LocalizedStringResource = "write_hub.chat.body"
        static let chatTitle: LocalizedStringResource = "write_hub.chat.title"
        static let navigationTitle: LocalizedStringResource = "write_hub.navigation.title"
        static let notesBody: LocalizedStringResource = "write_hub.notes.body"
        static let notesTitle: LocalizedStringResource = "write_hub.notes.title"
        static let title: LocalizedStringResource = "write_hub.title"
    }

    enum Writings {
        static let emptyBody: LocalizedStringResource = "writings.empty.body"
        static let emptyTitle: LocalizedStringResource = "writings.empty.title"
        static let filterMessages: LocalizedStringResource = "writings.filter.messages"
        static let filterNotes: LocalizedStringResource = "writings.filter.notes"
        static let navigationTitle: LocalizedStringResource = "writings.navigation.title"
    }

    enum Onboarding {
        static let buttonBack: LocalizedStringResource = "onboarding.button.back"
        static let buttonContinue: LocalizedStringResource = "onboarding.button.continue"
        static let buttonStart: LocalizedStringResource = "onboarding.button.start"
        static let concernSubtitle: LocalizedStringResource = "onboarding.concern.subtitle"
        static let concernTitle: LocalizedStringResource = "onboarding.concern.title"
        static let desiredSubtitle: LocalizedStringResource = "onboarding.desired.subtitle"
        static let desiredTitle: LocalizedStringResource = "onboarding.desired.title"
        static let finishBodyFormat: LocalizedStringResource = "onboarding.finish.body_format"
        static let finishNote: LocalizedStringResource = "onboarding.finish.note"
        static let finishSubtitle: LocalizedStringResource = "onboarding.finish.subtitle"
        static let finishTitle: LocalizedStringResource = "onboarding.finish.title"
        static let nicknamePlaceholder: LocalizedStringResource = "onboarding.nickname.placeholder"
        static let nicknameSubtitle: LocalizedStringResource = "onboarding.nickname.subtitle"
        static let nicknameTitle: LocalizedStringResource = "onboarding.nickname.title"
        static let welcomeBody: LocalizedStringResource = "onboarding.welcome.body"
        static let welcomeNote: LocalizedStringResource = "onboarding.welcome.note"
        static let welcomeTitle: LocalizedStringResource = "onboarding.welcome.title"
    }

    enum Profile {
        static let aboutTitle: LocalizedStringResource = "profile.about.title"
        static let cameraOption: LocalizedStringResource = "profile.camera.option"
        static let cancelOption: LocalizedStringResource = "profile.cancel.option"
        static let choosePhoto: LocalizedStringResource = "profile.choose_photo"
        static let doneButton: LocalizedStringResource = "profile.done.button"
        static let editButton: LocalizedStringResource = "profile.edit.button"
        static let editPhoto: LocalizedStringResource = "profile.edit_photo"
        static let editTitle: LocalizedStringResource = "profile.edit.title"
        static let fieldConcern: LocalizedStringResource = "profile.field.concern"
        static let fieldNickname: LocalizedStringResource = "profile.field.nickname"
        static let fieldPreferredFeeling: LocalizedStringResource = "profile.field.preferred_feeling"
        static let focusFormat: LocalizedStringResource = "profile.focus_format"
        static let libraryOption: LocalizedStringResource = "profile.library.option"
        static let navigationTitle: LocalizedStringResource = "profile.navigation.title"
        static let openSettingsButton: LocalizedStringResource = "profile.open_settings.button"
        static let photoHint: LocalizedStringResource = "profile.photo_hint"
        static let privacyBody: LocalizedStringResource = "profile.privacy.body"
        static let privacyTitle: LocalizedStringResource = "profile.privacy.title"
        static let reminderTimeTitle: LocalizedStringResource = "profile.reminder_time.title"
        static let remindersBody: LocalizedStringResource = "profile.reminders.body"
        static let remindersDeniedBody: LocalizedStringResource = "profile.reminders.denied_body"
        static let remindersEnabledBodyFormat: LocalizedStringResource = "profile.reminders.enabled_body_format"
        static let remindersTitle: LocalizedStringResource = "profile.reminders.title"
        static let removePhotoOption: LocalizedStringResource = "profile.remove_photo.option"
        static let responsibleBody: LocalizedStringResource = "profile.responsible.body"
        static let responsibleTitle: LocalizedStringResource = "profile.responsible.title"
        static let seekingFormat: LocalizedStringResource = "profile.seeking_format"
        static let subtitleFormat: LocalizedStringResource = "profile.subtitle_format"
    }

    enum Notifications {
        static let dailyBody: LocalizedStringResource = "notifications.daily.body"
        static let dailyTitle: LocalizedStringResource = "notifications.daily.title"
    }

    enum Preview {
        static let chatAssistantText: LocalizedStringResource = "preview.chat.assistant_text"
        static let chatUserText: LocalizedStringResource = "preview.chat.user_text"
        static let journalAffecting: LocalizedStringResource = "preview.journal.affecting"
        static let journalFeeling: LocalizedStringResource = "preview.journal.feeling"
        static let journalNeeded: LocalizedStringResource = "preview.journal.needed"
        static let journalSupport: LocalizedStringResource = "preview.journal.support"
        static let nickname: LocalizedStringResource = "preview.nickname"
    }

    enum Recommendation {
        static let abrumadoBody: LocalizedStringResource = "recommendation.abrumado.body"
        static let abrumadoButton: LocalizedStringResource = "recommendation.abrumado.button"
        static let abrumadoTitle: LocalizedStringResource = "recommendation.abrumado.title"
        static let ansiosoBody: LocalizedStringResource = "recommendation.ansioso.body"
        static let ansiosoBodyHigh: LocalizedStringResource = "recommendation.ansioso.body_high"
        static let ansiosoButton: LocalizedStringResource = "recommendation.ansioso.button"
        static let ansiosoTitle: LocalizedStringResource = "recommendation.ansioso.title"
        static let cansadoBody: LocalizedStringResource = "recommendation.cansado.body"
        static let cansadoButton: LocalizedStringResource = "recommendation.cansado.button"
        static let cansadoTitle: LocalizedStringResource = "recommendation.cansado.title"
        static let frustradoBody: LocalizedStringResource = "recommendation.frustrado.body"
        static let frustradoButton: LocalizedStringResource = "recommendation.frustrado.button"
        static let frustradoTitle: LocalizedStringResource = "recommendation.frustrado.title"
        static let tranquiloBody: LocalizedStringResource = "recommendation.tranquilo.body"
        static let tranquiloButton: LocalizedStringResource = "recommendation.tranquilo.button"
        static let tranquiloTitle: LocalizedStringResource = "recommendation.tranquilo.title"
        static let tristeBody: LocalizedStringResource = "recommendation.triste.body"
        static let tristeButton: LocalizedStringResource = "recommendation.triste.button"
        static let tristeTitle: LocalizedStringResource = "recommendation.triste.title"
    }

    enum Reference {
        static let breathworkReviewTitle: LocalizedStringResource = "reference.breathwork_review.title"
        static let narrativeReview: LocalizedStringResource = "reference.narrative_review"
        static let pranayamaReviewTitle: LocalizedStringResource = "reference.pranayama_review.title"
        static let systematicReview: LocalizedStringResource = "reference.systematic_review"
        static let yogaHealthTitle: LocalizedStringResource = "reference.yoga_health.title"
    }
}

enum LocalizedFormatting {
    static func exerciseDuration(_ seconds: Int) -> String {
        if seconds < 60 {
            return String(
                format: String(localized: AppStrings.Exercise.durationSecondsFormat),
                locale: Locale(identifier: "es"),
                seconds
            )
        }

        let minutes = seconds / 60
        if minutes == 1 {
            return String(localized: AppStrings.Exercise.durationOneMinute)
        }

        return String(
            format: String(localized: AppStrings.Exercise.durationMinutesFormat),
            locale: Locale(identifier: "es"),
            minutes
        )
    }

    static func historyCount(_ count: Int) -> String {
        String(
            format: String(localized: AppStrings.History.countFormat),
            locale: Locale(identifier: "es"),
            count
        )
    }

    static func toolEventName(_ name: String) -> String {
        switch name {
        case AnalyticsEvent.checkInCompleted.rawValue:
            String(localized: AppStrings.History.Tool.checkInCompleted)
        case AnalyticsEvent.chatMessageSent.rawValue:
            String(localized: AppStrings.History.Tool.chatMessageSent)
        case AnalyticsEvent.exerciseCompleted.rawValue:
            String(localized: AppStrings.History.Tool.exerciseCompleted)
        case AnalyticsEvent.exerciseStarted.rawValue:
            String(localized: AppStrings.History.Tool.exerciseStarted)
        case AnalyticsEvent.homeReturned.rawValue:
            String(localized: AppStrings.History.Tool.homeReturned)
        case AnalyticsEvent.immediateHelpUsed.rawValue:
            String(localized: AppStrings.History.Tool.immediateHelpUsed)
        case AnalyticsEvent.journalingSaved.rawValue:
            String(localized: AppStrings.History.Tool.journalingSaved)
        case AnalyticsEvent.onboardingCompleted.rawValue:
            String(localized: AppStrings.History.Tool.onboardingCompleted)
        default:
            name.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }
}
