import Observation
import SwiftData
import SwiftUI

@Observable
final class CheckInViewModel {
    private let services: AppServices

    var step = 0
    var selectedEmotion: EmotionalState = .ansioso
    var stressLevel: Double = 6
    var recommendation: SupportRecommendation?
    var isRecommendationPresented = false

    init(services: AppServices) {
        self.services = services
    }

    func save(context: ModelContext) {
        let result = services.recommendationEngine.recommendation(
            for: selectedEmotion,
            stressLevel: Int(stressLevel.rounded())
        )
        recommendation = result

        context.insert(
            EmotionalCheckIn(
                emotion: selectedEmotion.rawValue,
                stressLevel: Int(stressLevel.rounded()),
                recommendationTitle: result.titleKey.rawValue,
                recommendationBody: result.bodyKey.rawValue,
                recommendationRoute: result.route.storageKey
            )
        )

        services.track(
            .checkInCompleted,
            metadata: [
                "emotion": selectedEmotion.rawValue,
                "stress_level": "\(Int(stressLevel.rounded()))"
            ],
            in: context
        )
        isRecommendationPresented = true
    }

    func nextStep() {
        step = min(step + 1, 1)
    }

    func previousStep() {
        step = max(step - 1, 0)
    }
}

struct CheckInView: View {
    let services: AppServices
    let openRoute: (AppRoute) -> Void

    @State private var viewModel: CheckInViewModel
    @Environment(\.modelContext) private var modelContext

    init(services: AppServices, openRoute: @escaping (AppRoute) -> Void) {
        self.services = services
        self.openRoute = openRoute
        _viewModel = State(initialValue: CheckInViewModel(services: services))
    }

    var body: some View {
        @Bindable var bindableViewModel = viewModel

        VStack(alignment: .leading, spacing: 18) {
            ProgressView(value: Double(viewModel.step + 1), total: 2)
                .tint(AppTheme.tint)

            TabView(selection: $bindableViewModel.step) {
                AppCard {
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(title: String(localized: AppStrings.CheckIn.emotionTitle), subtitle: String(localized: AppStrings.CheckIn.emotionSubtitle))
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], spacing: 10) {
                            ForEach(EmotionalState.allCases) { emotion in
                                Button {
                                    viewModel.selectedEmotion = emotion
                                } label: {
                                    MoodChip(title: emotion.localizedTitle, selected: viewModel.selectedEmotion == emotion)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .tag(0)

                AppCard {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(
                            title: String(localized: AppStrings.CheckIn.stressTitle),
                            subtitle: String(format: String(localized: AppStrings.CheckIn.stressValueFormat), locale: Locale(identifier: "es"), Int(viewModel.stressLevel.rounded()))
                        )
                        Slider(value: $bindableViewModel.stressLevel, in: 1...10, step: 1)
                            .tint(AppTheme.tint)
                        Text(viewModel.selectedEmotion.supportiveCopy)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxHeight: 320)

            HStack(spacing: 12) {
                if viewModel.step > 0 {
                    Button(String(localized: AppStrings.Onboarding.buttonBack)) {
                        withAnimation(.smooth) { viewModel.previousStep() }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }

                Button(String(localized: viewModel.step == 0 ? AppStrings.Onboarding.buttonContinue : AppStrings.CheckIn.buttonSave)) {
                    if viewModel.step == 0 {
                        withAnimation(.smooth) { viewModel.nextStep() }
                    } else {
                        viewModel.save(context: modelContext)
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            Spacer(minLength: 0)
        }
        .padding(20)
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.CheckIn.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $bindableViewModel.isRecommendationPresented) {
            if let recommendation = viewModel.recommendation {
                recommendationSheet(recommendation)
                    .presentationDetents([.medium, .large])
            }
        }
    }

    private func recommendationSheet(_ recommendation: SupportRecommendation) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(recommendation.title)
                .font(.appSection)
                .foregroundStyle(AppTheme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            Text(recommendation.body)
                .foregroundStyle(AppTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            Button(recommendation.buttonTitle) {
                viewModel.isRecommendationPresented = false
                openRoute(recommendation.route)
            }
            .buttonStyle(PrimaryButtonStyle())

            Spacer(minLength: 0)
        }
        .padding(24)
    }
}

#Preview {
    NavigationStack {
        CheckInView(services: AppServices(), openRoute: { _ in })
    }
    .modelContainer(PersistenceController.preview.container)
}
