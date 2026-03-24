import Observation
import SwiftData
import SwiftUI

@Observable
final class OnboardingViewModel {
    private let services: AppServices

    enum Step: Int, CaseIterable {
        case welcome
        case nickname
        case desiredFeeling
        case concern
        case finish
    }

    var step: Step = .welcome
    var nickname = ""
    var desiredFeeling: DesiredFeeling = .calma
    var concern: FocusArea = .estres

    init(services: AppServices) {
        self.services = services
    }

    var progress: Double {
        Double(step.rawValue + 1) / Double(Step.allCases.count)
    }

    func next() {
        guard let nextStep = Step(rawValue: step.rawValue + 1) else { return }
        step = nextStep
    }

    func back() {
        guard let previousStep = Step(rawValue: step.rawValue - 1) else { return }
        step = previousStep
    }

    var canContinue: Bool {
        switch step {
        case .nickname:
            !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        default:
            true
        }
    }

    func completeOnboarding(context: ModelContext) {
        let profile = UserProfile(
            nickname: nickname.trimmingCharacters(in: .whitespacesAndNewlines),
            preferredFeeling: desiredFeeling.rawValue,
            mainConcern: concern.rawValue
        )
        context.insert(profile)
        services.track(
            .onboardingCompleted,
            metadata: [
                "preferred_feeling": desiredFeeling.rawValue,
                "main_concern": concern.rawValue
            ],
            in: context
        )
    }
}

struct OnboardingView: View {
    let services: AppServices

    @State private var viewModel: OnboardingViewModel
    @Environment(\.modelContext) private var modelContext

    init(services: AppServices) {
        self.services = services
        _viewModel = State(initialValue: OnboardingViewModel(services: services))
    }

    var body: some View {
        @Bindable var bindableViewModel = viewModel

        ZStack {
            AppTheme.pageGradient.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                ProgressView(value: viewModel.progress)
                    .tint(AppTheme.tint)

                TabView(selection: $bindableViewModel.step) {
                    stepPage(.welcome)
                        .tag(OnboardingViewModel.Step.welcome)
                    stepPage(.nickname)
                        .tag(OnboardingViewModel.Step.nickname)
                    stepPage(.desiredFeeling)
                        .tag(OnboardingViewModel.Step.desiredFeeling)
                    stepPage(.concern)
                        .tag(OnboardingViewModel.Step.concern)
                    stepPage(.finish)
                        .tag(OnboardingViewModel.Step.finish)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.smooth, value: viewModel.step)

                HStack(spacing: 12) {
                    if viewModel.step != .welcome {
                        Button(String(localized: AppStrings.Onboarding.buttonBack)) { withAnimation(.smooth) { viewModel.back() } }
                            .buttonStyle(SecondaryButtonStyle())
                    }

                    Button(String(localized: viewModel.step == .finish ? AppStrings.Onboarding.buttonStart : AppStrings.Onboarding.buttonContinue)) {
                        if viewModel.step == .finish {
                            viewModel.completeOnboarding(context: modelContext)
                        } else {
                            withAnimation(.smooth) { viewModel.next() }
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewModel.canContinue)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(24)
        }
    }

    private func stepPage(_ step: OnboardingViewModel.Step) -> some View {
        ScrollView {
            AppCard {
                VStack(alignment: .leading, spacing: 18) {
                    OnboardingStepAccent(
                        icon: accentIcon(for: step),
                        tint: accentTint(for: step)
                    )
                    content(for: step)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .scrollIndicators(.hidden)
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private func content(for step: OnboardingViewModel.Step) -> some View {
        @Bindable var bindableViewModel = viewModel

        switch step {
        case .welcome:
            VStack(alignment: .leading, spacing: 12) {
                Text(AppStrings.Onboarding.welcomeTitle)
                    .font(.appTitle)
                    .foregroundStyle(AppTheme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(AppStrings.Onboarding.welcomeBody)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(AppStrings.Onboarding.welcomeNote)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 6)
            }
        case .nickname:
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: String(localized: AppStrings.Onboarding.nicknameTitle), subtitle: String(localized: AppStrings.Onboarding.nicknameSubtitle))
                TextField(String(localized: AppStrings.Onboarding.nicknamePlaceholder), text: $bindableViewModel.nickname)
                    .textFieldStyle(.plain)
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.92))
                    )
            }
        case .desiredFeeling:
            VStack(alignment: .leading, spacing: 14) {
                SectionHeader(title: String(localized: AppStrings.Onboarding.desiredTitle), subtitle: String(localized: AppStrings.Onboarding.desiredSubtitle))
                VStack(spacing: 12) {
                    ForEach(DesiredFeeling.allCases) { item in
                        OnboardingChoiceCard(
                            title: item.localizedTitle,
                            icon: icon(for: item),
                            selected: viewModel.desiredFeeling == item
                        ) {
                            viewModel.desiredFeeling = item
                        }
                    }
                }
            }
        case .concern:
            VStack(alignment: .leading, spacing: 14) {
                SectionHeader(title: String(localized: AppStrings.Onboarding.concernTitle), subtitle: String(localized: AppStrings.Onboarding.concernSubtitle))
                VStack(spacing: 12) {
                    ForEach(FocusArea.allCases) { item in
                        OnboardingChoiceCard(
                            title: item.localizedTitle,
                            icon: icon(for: item),
                            selected: viewModel.concern == item
                        ) {
                            viewModel.concern = item
                        }
                    }
                }
            }
        case .finish:
            VStack(alignment: .leading, spacing: 14) {
                SectionHeader(title: String(localized: AppStrings.Onboarding.finishTitle), subtitle: String(localized: AppStrings.Onboarding.finishSubtitle))
                Text(String(format: String(localized: AppStrings.Onboarding.finishBodyFormat), locale: Locale(identifier: "es"), viewModel.desiredFeeling.localizedTitle.lowercased(), viewModel.concern.localizedTitle.lowercased()))
                    .foregroundStyle(AppTheme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(AppStrings.Onboarding.finishNote)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func icon(for feeling: DesiredFeeling) -> String {
        switch feeling {
        case .calma: "wind"
        case .claridad: "sun.max"
        case .descanso: "bed.double"
        case .enfoque: "scope"
        case .ligereza: "leaf"
        }
    }

    private func icon(for focus: FocusArea) -> String {
        switch focus {
        case .estres: "bolt.heart"
        case .ansiedad: "wind.circle"
        case .agotamiento: "battery.25"
        case .sueno: "moon"
        case .enfoque: "brain"
        }
    }

    private func accentIcon(for step: OnboardingViewModel.Step) -> String {
        switch step {
        case .welcome: "sparkles"
        case .nickname: "person.crop.circle"
        case .desiredFeeling: "wind"
        case .concern: "brain.head.profile"
        case .finish: "heart.circle"
        }
    }

    private func accentTint(for step: OnboardingViewModel.Step) -> Color {
        switch step {
        case .welcome: AppTheme.lavender
        case .nickname: AppTheme.tintSoft
        case .desiredFeeling: AppTheme.peach
        case .concern: AppTheme.secondarySurface
        case .finish: AppTheme.tintSoft
        }
    }
}

private struct OnboardingChoiceCard: View {
    let title: String
    let icon: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(selected ? AppTheme.tint.opacity(0.16) : AppTheme.secondarySurface)
                        .frame(width: 52, height: 52)
                    Image(systemName: icon)
                        .foregroundStyle(selected ? AppTheme.tint : AppTheme.textSecondary)
                }

                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(selected ? AppTheme.tint : AppTheme.textSecondary.opacity(0.6))
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(selected ? Color.white : AppTheme.surface.opacity(0.92))
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(selected ? AppTheme.tint.opacity(0.35) : Color.clear, lineWidth: 1.5)
                    }
            )
        }
        .buttonStyle(.plain)
    }
}

private struct OnboardingStepAccent: View {
    let icon: String
    let tint: Color

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [tint.opacity(0.95), Color.white.opacity(0.65)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 112)

            Circle()
                .fill(Color.white.opacity(0.45))
                .frame(width: 88, height: 88)
                .offset(x: 20, y: 12)

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.72))
                .frame(width: 72, height: 72)
                .overlay {
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(AppTheme.textPrimary)
                }
                .padding(.leading, 22)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    OnboardingView(services: AppServices())
        .modelContainer(PersistenceController.preview.container)
}
