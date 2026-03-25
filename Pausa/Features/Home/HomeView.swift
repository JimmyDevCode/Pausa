import Observation
import SwiftData
import SwiftUI

@Observable
final class HomeViewModel {
    private let services: AppServices

    init(services: AppServices) {
        self.services = services
    }

    func trackAppear(context: ModelContext) {
        services.track(.homeReturned, in: context)
    }

    func openImmediateHelp(context: ModelContext, openRoute: (AppRoute) -> Void) {
        services.track(.immediateHelpUsed, in: context)
        openRoute(.immediateHelp)
    }

    func headerSubtitle(latestCheckIn: EmotionalCheckIn?) -> String {
        if let latestCheckIn {
            return String(format: String(localized: AppStrings.Home.headerSubtitleLatestFormat), locale: Locale(identifier: "es"), latestCheckIn.localizedEmotionLowercased)
        }
        return String(localized: AppStrings.Home.headerSubtitleEmpty)
    }

    func latestStateCopy(latestCheckIn: EmotionalCheckIn?) -> String {
        guard let latestCheckIn else { return "" }
        return String(format: String(localized: AppStrings.Home.latestStateFormat), locale: Locale(identifier: "es"), latestCheckIn.localizedEmotionLowercased, latestCheckIn.stressLevel, latestCheckIn.localizedRecommendationBody)
    }
}

struct HomeView: View {
    private struct HomeActionItem: Identifiable {
        let id: String
        let icon: String
        let title: String
        let subtitle: String
        let action: AppRoute
    }

    let profile: UserProfile
    let services: AppServices
    let openRoute: (AppRoute) -> Void

    @State private var viewModel: HomeViewModel
    @State private var actionPage = 0
    @Query(sort: \EmotionalCheckIn.createdAt, order: .reverse) private var checkIns: [EmotionalCheckIn]
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var journalEntries: [JournalEntry]
    @Query(sort: \ExerciseSessionRecord.completedAt, order: .reverse) private var sessions: [ExerciseSessionRecord]
    @Environment(\.modelContext) private var modelContext

    init(profile: UserProfile, services: AppServices, openRoute: @escaping (AppRoute) -> Void) {
        self.profile = profile
        self.services = services
        self.openRoute = openRoute
        _viewModel = State(initialValue: HomeViewModel(services: services))
    }

    private var profileInitial: String {
        let trimmedName = profile.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        return String(trimmedName.isEmpty ? "P" : trimmedName.prefix(1)).uppercased()
    }

    private var latestCheckIn: EmotionalCheckIn? { checkIns.first }
    private var actionItems: [HomeActionItem] {
        [
            HomeActionItem(
                id: "exercises",
                icon: "wind",
                title: String(localized: AppStrings.Home.toolsExercisesTitle),
                subtitle: String(localized: AppStrings.Home.toolsExercisesSubtitle),
                action: .exercises
            ),
            HomeActionItem(
                id: "journaling",
                icon: "square.and.pencil",
                title: String(localized: AppStrings.Home.toolsJournalingTitle),
                subtitle: String(localized: AppStrings.Home.toolsJournalingSubtitle),
                action: .journaling
            ),
            HomeActionItem(
                id: "support-chat",
                icon: "ellipsis.message",
                title: String(localized: AppStrings.Home.toolsChatTitle),
                subtitle: String(localized: AppStrings.Home.toolsChatSubtitle),
                action: .supportChat
            ),
            HomeActionItem(
                id: "history",
                icon: "chart.bar.xaxis",
                title: String(localized: AppStrings.Home.toolsHistoryTitle),
                subtitle: String(localized: AppStrings.Home.toolsHistorySubtitle),
                action: .history
            )
        ]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                emergencyCard
                currentStateCard
                historyCard
                actionGrid
                progressCard
                responsibleCopy
            }
            .padding(AppTheme.layoutPadding)
        }
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.Home.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    openRoute(.profile)
                } label: {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [AppTheme.tintSoft, Color.white.opacity(0.98)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 34, height: 34)
                            .shadow(color: AppTheme.tint.opacity(0.12), radius: 8, x: 0, y: 4)
                            .overlay {
                                Circle()
                                    .stroke(Color.white.opacity(0.85), lineWidth: 1)
                            }

                        Text(profileInitial)
                        .font(.subheadline.weight(.bold))
                            .foregroundStyle(AppTheme.tint)
                    }
                }
            }
        }
        .onAppear {
            viewModel.trackAppear(context: modelContext)
        }
    }

    private var header: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.tintSoft, Color.white.opacity(0.92), AppTheme.lavender.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(Color.white.opacity(0.45))
                .frame(width: 140, height: 140)
                .offset(x: 180, y: -30)

            VStack(alignment: .leading, spacing: 10) {
                Text(String(format: String(localized: AppStrings.Home.headerGreetingFormat), locale: Locale(identifier: "es"), profile.nickname))
                    .font(.appTitle)
                    .foregroundStyle(AppTheme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(viewModel.headerSubtitle(latestCheckIn: latestCheckIn))
                    .font(.appBody)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                if let latestCheckIn {
                    HomePill(text: latestCheckIn.localizedEmotion)
                }
            }
            .padding(24)
        }
    }

    private var emergencyCard: some View {
        AccentCard(tint: AppTheme.peach) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "bolt.heart.fill")
                        .foregroundStyle(AppTheme.warning)
                    Text(AppStrings.Home.emergencyTitle)
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text(AppStrings.Home.emergencyBody)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                Button(String(localized: AppStrings.Home.emergencyButton)) {
                    viewModel.openImmediateHelp(context: modelContext, openRoute: openRoute)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }

    private var currentStateCard: some View {
        AccentCard(tint: AppTheme.tintSoft) {
            VStack(alignment: .leading, spacing: 14) {
                SectionHeader(
                    title: latestCheckIn == nil ? String(localized: AppStrings.Home.checkInTitleEmpty) : String(localized: AppStrings.Home.checkInTitleLatest),
                    subtitle: latestCheckIn == nil
                        ? String(localized: AppStrings.Home.checkInSubtitleEmpty)
                        : viewModel.latestStateCopy(latestCheckIn: latestCheckIn)
                )
                Button(String(localized: latestCheckIn == nil ? AppStrings.Home.checkInButtonEmpty : AppStrings.Home.checkInButtonLatest)) {
                    openRoute(.checkIn)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
    }

    private var actionGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(AppStrings.Home.toolsTitle)
                .font(.appSection)
                .foregroundStyle(AppTheme.textPrimary)

            GeometryReader { proxy in
                VStack(spacing: 12) {
                    TabView(selection: $actionPage) {
                        ForEach(Array(actionItems.enumerated()), id: \.element.id) { index, item in
                            actionCard(item: item)
                                .frame(width: proxy.size.width - 28, height: 164, alignment: .topLeading)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    CarouselPageIndicator(
                        count: actionItems.count,
                        currentIndex: actionPage
                    )
                }
            }
            .frame(height: 182)
        }
    }

    private var historyCard: some View {
        AccentCard(tint: AppTheme.lavender) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundStyle(AppTheme.tint)
                    Text(AppStrings.Home.historyCardTitle)
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Text(AppStrings.Home.historyCardBody)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                Button(String(localized: AppStrings.Home.historyCardButton)) {
                    openRoute(.history)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
    }

    private func actionCard(item: HomeActionItem) -> some View {
        Button {
            openRoute(item.action)
        } label: {
            AppCard {
                VStack(alignment: .leading, spacing: 16) {
                    QuickActionRow(
                        icon: item.icon,
                        title: item.title,
                        subtitle: item.subtitle,
                        showsChevron: false
                    )

                    HStack {
                        Spacer()
                        CardCTA(title: String(localized: AppStrings.Common.ctaOpen))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .buttonStyle(.plain)
    }

    private var progressCard: some View {
        AccentCard(tint: AppTheme.lavender) {
            VStack(alignment: .leading, spacing: 12) {
                Text(AppStrings.Home.progressTitle)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                ViewThatFits {
                    HStack(spacing: 10) {
                        progressBadges
                    }
                    VStack(spacing: 10) {
                        progressBadges
                    }
                }
            }
        }
    }

    private var responsibleCopy: some View {
        Text(AppStrings.Home.disclaimer)
            .font(.footnote)
            .foregroundStyle(AppTheme.textSecondary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 4)
    }

    private func progressBadge(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.textPrimary)
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.72))
        )
    }

    private var progressBadges: some View {
        Group {
            progressBadge(value: "\(checkIns.count)", label: String(localized: AppStrings.Home.metricCheckIns))
            progressBadge(value: "\(sessions.count)", label: String(localized: AppStrings.Home.metricExercises))
            progressBadge(value: "\(journalEntries.count)", label: String(localized: AppStrings.Home.metricNotes))
        }
    }

}

private struct HomePill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(AppTheme.textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.white.opacity(0.72))
            )
    }
}

#Preview {
    NavigationStack {
        HomeView(
            profile: UserProfile(nickname: String(localized: AppStrings.Preview.nickname), preferredFeeling: DesiredFeeling.calma.rawValue, mainConcern: FocusArea.estres.rawValue),
            services: AppServices()
        ) { _ in }
    }
    .modelContainer(PersistenceController.preview.container)
}
