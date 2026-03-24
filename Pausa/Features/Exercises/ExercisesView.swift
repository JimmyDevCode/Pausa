import Observation
import SwiftData
import SwiftUI

struct ExercisesView: View {
    let openRoute: (AppRoute) -> Void
    @State private var selectedExercise: ExerciseDefinition?
    @State private var exercisePage = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(AppStrings.Exercise.navigationTitle)
                .font(.appSection)
                .foregroundStyle(AppTheme.textPrimary)
                .padding(.horizontal, 20)

            GeometryReader { proxy in
                VStack(spacing: 12) {
                    TabView(selection: $exercisePage) {
                        ForEach(Array(ExerciseLibrary.all.enumerated()), id: \.element.id) { index, exercise in
                            Button {
                                selectedExercise = exercise
                            } label: {
                                exerciseCard(exercise)
                                    .frame(width: proxy.size.width - 28, height: 232, alignment: .topLeading)
                            }
                            .buttonStyle(.plain)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    CarouselPageIndicator(
                        count: ExerciseLibrary.all.count,
                        currentIndex: exercisePage
                    )
                }
                .padding(.horizontal, 20)
                .frame(height: 260)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.Exercise.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedExercise) { exercise in
            exercisePreviewSheet(exercise)
                .presentationDetents([.medium, .large])
        }
    }

    private func exerciseCard(_ exercise: ExerciseDefinition) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: 18) {
                Text(exercise.title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                Text(exercise.summary)
                    .foregroundStyle(AppTheme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 8) {
                    ForEach(Array(exercise.quickTags.enumerated()), id: \.offset) { index, tag in
                        InsightBadge(
                            title: tag.title,
                            tint: index == 0 ? AppTheme.tint : AppTheme.peach
                        )
                    }
                }
                Text(String(format: String(localized: AppStrings.Exercise.durationFormat), locale: Locale(identifier: "es"), formattedDuration(exercise.durationSeconds)))
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(AppTheme.tint)

                HStack {
                    Spacer()
                    CardCTA(title: String(localized: AppStrings.Common.ctaViewExercise))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private func formattedDuration(_ seconds: Int) -> String {
        seconds >= 60 ? "\(seconds / 60) min" : "\(seconds) seg"
    }

    private func exercisePreviewSheet(_ exercise: ExerciseDefinition) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text(exercise.title)
                    .font(.appSection)
                    .foregroundStyle(AppTheme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(exercise.summary)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 8) {
                    ForEach(Array(exercise.quickTags.enumerated()), id: \.offset) { index, tag in
                        InsightBadge(
                            title: tag.title,
                            tint: index == 0 ? AppTheme.tint : AppTheme.peach
                        )
                    }
                }

                Text(String(format: String(localized: AppStrings.Exercise.durationFormat), locale: Locale(identifier: "es"), formattedDuration(exercise.durationSeconds)))
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(AppTheme.tint)

                if let careNote = exercise.careNote {
                    SessionInfoCard(
                        title: String(localized: AppStrings.Exercise.Session.care),
                        message: careNote
                    )
                }

                Button(String(localized: AppStrings.Exercise.Session.buttonStart)) {
                    selectedExercise = nil
                    openRoute(.exercise(exercise))
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

@Observable
final class ExerciseSessionViewModel {
    private let exercise: ExerciseDefinition
    private let services: AppServices

    var isRunning = false
    var remainingSeconds: Int
    var feedback: Int = 0
    var completed = false

    init(exercise: ExerciseDefinition, services: AppServices) {
        self.exercise = exercise
        self.services = services
        remainingSeconds = exercise.durationSeconds
    }

    func tick(context: ModelContext) {
        guard isRunning, remainingSeconds > 0 else { return }
        remainingSeconds -= 1
        if remainingSeconds == 0 {
            isRunning = false
            completed = true
            if feedback == 0 {
                saveSession(helpfulness: nil, context: context)
            }
        }
    }

    func togglePlayback(context: ModelContext) {
        if !isRunning && remainingSeconds == exercise.durationSeconds {
            services.track(.exerciseStarted, metadata: ["exercise_id": exercise.id], in: context)
        }
        isRunning.toggle()
    }

    func saveFeedback(_ value: Int, context: ModelContext) {
        feedback = value
        saveSession(helpfulness: value, context: context)
    }

    var elapsedSeconds: Int {
        exercise.durationSeconds - remainingSeconds
    }

    var currentCue: ExerciseSessionCue? {
        guard isRunning, !completed else { return nil }
        return ExerciseSessionPacing.cue(for: exercise, elapsedSeconds: elapsedSeconds)
    }

    var circleScale: CGFloat {
        currentCue?.scale ?? 1
    }

    var statusText: String {
        if completed {
            String(localized: AppStrings.Exercise.Session.statusCompleted)
        } else if let cueTitle = currentCue?.title {
            cueTitle
        } else if isRunning {
            String(localized: AppStrings.Exercise.Session.statusRunning)
        } else {
            String(localized: AppStrings.Exercise.Session.statusReady)
        }
    }

    private func saveSession(helpfulness: Int?, context: ModelContext) {
        let alreadySaved = try? context.fetch(FetchDescriptor<ExerciseSessionRecord>())
            .contains(where: { $0.title == exercise.title && Calendar.current.isDateInToday($0.completedAt) })

        guard alreadySaved != true else { return }

        context.insert(
            ExerciseSessionRecord(
                exerciseID: exercise.id,
                title: exercise.title,
                source: "session",
                helpfulness: helpfulness
            )
        )
        services.track(.exerciseCompleted, metadata: ["exercise_id": exercise.id], in: context)
    }
}

struct ExerciseSessionView: View {
    let exercise: ExerciseDefinition
    let services: AppServices

    @AppStorage("exercise_voice_cues_enabled") private var voiceCuesEnabled = false
    @State private var viewModel: ExerciseSessionViewModel
    @State private var cuePlayer = ExerciseCuePlayer()
    @State private var lastCueTitle: String?
    @Environment(\.modelContext) private var modelContext

    init(exercise: ExerciseDefinition, services: AppServices) {
        self.exercise = exercise
        self.services = services
        _viewModel = State(initialValue: ExerciseSessionViewModel(exercise: exercise, services: services))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text(exercise.title)
                    .font(.appTitle)
                    .foregroundStyle(AppTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text(exercise.detail)
                    .foregroundStyle(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)

                HStack(spacing: 8) {
                    ForEach(Array(exercise.quickTags.enumerated()), id: \.offset) { index, tag in
                        InsightBadge(
                            title: tag.title,
                            tint: index == 0 ? AppTheme.tint : AppTheme.peach
                        )
                    }
                }
                .padding(.horizontal)

                if let careNote = exercise.careNote {
                    SessionInfoCard(
                        title: String(localized: AppStrings.Exercise.Session.care),
                        message: careNote
                    )
                    .padding(.horizontal)
                }

                Text(timeString(viewModel.remainingSeconds))
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.tint)

                Circle()
                    .fill(AppTheme.tintSoft)
                    .frame(width: 220, height: 220)
                    .scaleEffect(viewModel.circleScale)
                    .animation(.easeInOut(duration: 0.9), value: viewModel.circleScale)
                    .overlay {
                        VStack(spacing: 12) {
                            Image(systemName: viewModel.completed ? "checkmark.circle.fill" : "wind")
                                .font(.system(size: 42))
                                .foregroundStyle(AppTheme.tint)
                            Text(viewModel.statusText)
                                .font(.headline)
                                .foregroundStyle(AppTheme.textPrimary)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                if !viewModel.completed {
                    Button(viewModel.isRunning ? String(localized: AppStrings.Exercise.Session.buttonPause) : String(localized: AppStrings.Exercise.Session.buttonStart)) {
                        viewModel.togglePlayback(context: modelContext)
                        syncCuePlayback(force: true)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal, 24)
                } else {
                    VStack(spacing: 16) {
                        Text(exercise.closingPrompt)
                            .foregroundStyle(AppTheme.textPrimary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(AppStrings.Exercise.Session.feedbackQuestion)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.textPrimary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)

                        HStack(spacing: 10) {
                            feedbackButton(
                                title: AppStrings.Exercise.Session.feedbackYes,
                                value: 5
                            )
                            feedbackButton(
                                title: AppStrings.Exercise.Session.feedbackALittle,
                                value: 3
                            )
                            feedbackButton(
                                title: AppStrings.Exercise.Session.feedbackNo,
                                value: 1
                            )
                        }
                        Text(AppStrings.Exercise.Session.repeatNote)
                            .font(.footnote)
                            .foregroundStyle(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .padding()
        }
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.Exercise.Session.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    voiceCuesEnabled.toggle()
                    if voiceCuesEnabled {
                        syncCuePlayback(force: true)
                    } else {
                        cuePlayer.stop()
                    }
                } label: {
                    Image(systemName: voiceCuesEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .foregroundStyle(AppTheme.tint)
                }
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            viewModel.tick(context: modelContext)
            syncCuePlayback()
        }
        .onDisappear {
            cuePlayer.stop()
        }
    }

    private func timeString(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainder = seconds % 60
        return String(format: "%02d:%02d", minutes, remainder)
    }

    @ViewBuilder
    private func feedbackButton(title: LocalizedStringResource, value: Int) -> some View {
        Button {
            viewModel.saveFeedback(value, context: modelContext)
        } label: {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(viewModel.feedback == value ? .white : AppTheme.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    Capsule(style: .continuous)
                        .fill(viewModel.feedback == value ? AppTheme.tint : Color.white.opacity(0.82))
                )
                .overlay {
                    Capsule(style: .continuous)
                        .stroke(viewModel.feedback == value ? Color.clear : AppTheme.tintSoft, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }

    private func syncCuePlayback(force: Bool = false) {
        guard viewModel.isRunning, !viewModel.completed, let cue = viewModel.currentCue else {
            lastCueTitle = nil
            cuePlayer.stop()
            return
        }

        defer { lastCueTitle = cue.spokenText }

        guard voiceCuesEnabled else { return }
        guard force || cue.spokenText != lastCueTitle else { return }
        cuePlayer.play(cue.spokenText)
    }
}

#Preview {
    NavigationStack {
        ExerciseSessionView(exercise: ExerciseLibrary.all[0], services: AppServices())
    }
    .modelContainer(PersistenceController.preview.container)
}
