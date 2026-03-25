import SwiftUI

struct ImmediateHelpView: View {
    let openRoute: (AppRoute) -> Void
    @State private var selectedExercise: ExerciseDefinition?
    @State private var exercisePage = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                AppCard {
                    VStack(alignment: .leading, spacing: 14) {
                        Text(AppStrings.ImmediateHelp.headerTitle)
                            .font(.appTitle)
                            .foregroundStyle(AppTheme.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(AppStrings.ImmediateHelp.headerBody)
                            .foregroundStyle(AppTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                GeometryReader { proxy in
                    VStack(spacing: 12) {
                        TabView(selection: $exercisePage) {
                            ForEach(Array(ExerciseLibrary.immediateHelp.enumerated()), id: \.element.id) { index, exercise in
                                Button {
                                    selectedExercise = exercise
                                } label: {
                                    AppCard {
                                        VStack(alignment: .leading, spacing: 16) {
                                            QuickActionRow(
                                                icon: icon(for: exercise.id),
                                                title: exercise.title,
                                                subtitle: "\(exercise.summary) · \(LocalizedFormatting.exerciseDuration(exercise.durationSeconds))",
                                                showsChevron: false
                                            )

                                            HStack {
                                                Spacer()
                                                CardCTA(title: String(localized: AppStrings.Common.ctaViewDetails))
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                }
                                .frame(width: proxy.size.width - 28, height: 164, alignment: .topLeading)
                                .buttonStyle(.plain)
                                .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))

                        CarouselPageIndicator(
                            count: ExerciseLibrary.immediateHelp.count,
                            currentIndex: exercisePage
                        )
                    }
                }
                .frame(height: 182)

                AppCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(AppStrings.ImmediateHelp.intenseTitle)
                            .font(.headline)
                            .foregroundStyle(AppTheme.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(AppStrings.ImmediateHelp.intenseBody)
                            .foregroundStyle(AppTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(20)
        }
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.ImmediateHelp.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedExercise) { exercise in
            immediateHelpSheet(exercise)
                .presentationDetents([.medium, .large])
        }
    }

    private func icon(for id: String) -> String {
        switch id {
        case "breathing-444": "lungs.fill"
        case "grounding": "dot.scope"
        default: "pause.circle"
        }
    }

    private func immediateHelpSheet(_ exercise: ExerciseDefinition) -> some View {
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

#Preview {
    NavigationStack {
        ImmediateHelpView(openRoute: { _ in })
    }
}
