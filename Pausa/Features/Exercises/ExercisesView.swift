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
                Text(String(format: String(localized: AppStrings.Exercise.durationFormat), locale: Locale(identifier: "es"), LocalizedFormatting.exerciseDuration(exercise.durationSeconds)))
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

                Text(String(format: String(localized: AppStrings.Exercise.durationFormat), locale: Locale(identifier: "es"), LocalizedFormatting.exerciseDuration(exercise.durationSeconds)))
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
    private var activeStartDate: Date?
    private var accumulatedElapsedTime: TimeInterval = 0

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
        syncProgress(at: Date(), context: context)
    }

    func togglePlayback(context: ModelContext) {
        if !isRunning && remainingSeconds == exercise.durationSeconds {
            services.track(.exerciseStarted, metadata: ["exercise_id": exercise.id], in: context)
        }

        let now = Date()
        if isRunning {
            accumulatedElapsedTime = continuousElapsedTime(at: now)
            activeStartDate = nil
            isRunning = false
        } else {
            activeStartDate = now
            isRunning = true
            syncProgress(at: now, context: context)
        }
    }

    func saveFeedback(_ value: Int, context: ModelContext) {
        feedback = value
        saveSession(helpfulness: value, context: context)
    }

    var elapsedSeconds: Int {
        exercise.durationSeconds - remainingSeconds
    }

    func continuousElapsedTime(at date: Date) -> TimeInterval {
        accumulatedElapsedTime + (isRunning ? max(0, date.timeIntervalSince(activeStartDate ?? date)) : 0)
    }

    var currentCue: ExerciseSessionCue? {
        guard isRunning, !completed else { return nil }
        return ExerciseSessionPacing.cue(for: exercise, elapsedSeconds: elapsedSeconds)
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

    private func syncProgress(at date: Date, context: ModelContext) {
        guard !completed else { return }

        let elapsedTime = continuousElapsedTime(at: date)
        let newRemainingSeconds = max(0, exercise.durationSeconds - Int(elapsedTime.rounded(.down)))
        remainingSeconds = newRemainingSeconds

        if newRemainingSeconds == 0, isRunning {
            accumulatedElapsedTime = TimeInterval(exercise.durationSeconds)
            activeStartDate = nil
            isRunning = false
            completed = true

            if feedback == 0 {
                saveSession(helpfulness: nil, context: context)
            }
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

                TimelineView(.animation(minimumInterval: 1 / 30, paused: !viewModel.isRunning)) { context in
                    ExerciseBreathingOrb(
                        statusText: viewModel.statusText,
                        isRunning: viewModel.isRunning,
                        isCompleted: viewModel.completed,
                        orbState: ExerciseSessionPacing.orbState(
                            for: exercise,
                            elapsedTime: viewModel.continuousElapsedTime(at: context.date),
                            isRunning: viewModel.isRunning,
                            completed: viewModel.completed
                        )
                    )
                }

                if !viewModel.completed {
                    Button(viewModel.isRunning ? String(localized: AppStrings.Exercise.Session.buttonPause) : String(localized: AppStrings.Exercise.Session.buttonStart)) {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            viewModel.togglePlayback(context: modelContext)
                        }
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

private struct ExerciseBreathingOrb: View {
    let statusText: String
    let isRunning: Bool
    let isCompleted: Bool
    let orbState: ExerciseSessionOrbState

    var body: some View {
        ZStack {
            Circle()
                .fill(AppTheme.tint.opacity(0.08))
                .frame(width: 248, height: 248)
                .scaleEffect(orbState.haloScale)
                .blur(radius: 20)
                .opacity(orbState.haloOpacity)

            Circle()
                .stroke(AppTheme.tintSoft.opacity(0.5), lineWidth: 18)
                .frame(width: 238, height: 238)

            Circle()
                .trim(from: 0, to: orbState.ringTrim)
                .stroke(
                    AngularGradient(
                        colors: [AppTheme.peach.opacity(0.85), AppTheme.tint, AppTheme.tintSoft],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .frame(width: 238, height: 238)
                .rotationEffect(.degrees(-90))

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(min(1, orbState.innerOpacity + 0.1)),
                            AppTheme.tintSoft.opacity(0.95),
                            AppTheme.tint.opacity(0.34)
                        ],
                        center: .center,
                        startRadius: 8,
                        endRadius: 120
                    )
                )
                .frame(width: 220, height: 220)
                .scaleEffect(orbState.scale)
                .shadow(color: AppTheme.tint.opacity(0.12), radius: 24, y: 12)

            VStack(spacing: 12) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "wind")
                    .font(.system(size: 38))
                    .foregroundStyle(AppTheme.tint)
                    .scaleEffect(orbState.symbolScale)
                Text(statusText)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)
                    .frame(maxWidth: 150)
            }
            .padding(.horizontal, 34)
        }
        .frame(width: 280, height: 280)
        .animation(.easeInOut(duration: 0.45), value: isRunning)
        .animation(.spring(response: 0.5, dampingFraction: 0.82), value: isCompleted)
        .drawingGroup()
    }
}

#Preview {
    NavigationStack {
        ExerciseSessionView(exercise: ExerciseLibrary.all[0], services: AppServices())
    }
    .modelContainer(PersistenceController.preview.container)
}
