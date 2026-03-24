import SwiftData
import SwiftUI

struct HistoryView: View {
    @Query(sort: \EmotionalCheckIn.createdAt, order: .reverse) private var checkIns: [EmotionalCheckIn]
    @Query(sort: \ExerciseSessionRecord.completedAt, order: .reverse) private var sessions: [ExerciseSessionRecord]
    @Query(sort: \ToolUsageEvent.createdAt, order: .reverse) private var usage: [ToolUsageEvent]
    @State private var toolPage = 0

    init() {}

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                summaryCard
                if weekCheckIns.isEmpty && usage.isEmpty {
                    emptyState
                } else {
                    repeatedEmotions
                    mostUsedTools
                }
            }
            .padding(AppTheme.layoutPadding)
        }
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.History.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var weekCheckIns: [EmotionalCheckIn] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .now
        return checkIns.filter { $0.createdAt >= weekAgo }
    }

    private var summaryCard: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.lavender.opacity(0.9), Color.white.opacity(0.95), AppTheme.tintSoft.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 150, height: 150)
                .offset(x: 180, y: -10)

            VStack(alignment: .leading, spacing: 14) {
                Text(AppStrings.History.summaryTitle)
                    .font(.appSection)
                    .foregroundStyle(AppTheme.textPrimary)

                Text(String(format: String(localized: AppStrings.History.summaryBodyFormat), locale: Locale(identifier: "es"), weekCheckIns.count, sessions.count))
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10) {
                    metricPill(value: "\(weekCheckIns.count)", label: String(localized: AppStrings.History.metricWeek))
                    metricPill(value: "\(sessions.count)", label: String(localized: AppStrings.History.metricExercises))
                }

                if let common = emotionCounts.max(by: { $0.value < $1.value }) {
                    Text(String(format: String(localized: AppStrings.History.summaryCommonEmotionFormat), locale: Locale(identifier: "es"), common.key.lowercased()))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.tint)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(24)
        }
    }

    private var repeatedEmotions: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(AppStrings.History.repeatedEmotionsTitle)
                .font(.appSection)
                .foregroundStyle(AppTheme.textPrimary)

            ForEach(emotionCounts.sorted(by: { $0.value > $1.value }), id: \.key) { item in
                AccentCard(tint: AppTheme.tintSoft) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(item.key)
                                .font(.headline)
                                .foregroundStyle(AppTheme.textPrimary)
                            Spacer()
                            Text("\(item.value)x")
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(AppTheme.tintSoft)
                                .overlay(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(AppTheme.tint)
                                        .frame(width: max(32, geometry.size.width * CGFloat(item.value) / CGFloat(maxEmotionCount)))
                                }
                        }
                        .frame(height: 12)
                    }
                }
            }
        }
    }

    private var mostUsedTools: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(AppStrings.History.toolsTitle)
                .font(.appSection)
                .foregroundStyle(AppTheme.textPrimary)

            GeometryReader { proxy in
                let items = Array(toolCounts.sorted(by: { $0.value > $1.value }).prefix(4))

                VStack(spacing: 12) {
                    TabView(selection: $toolPage) {
                        ForEach(Array(items.enumerated()), id: \.element.key) { index, item in
                            AccentCard(tint: AppTheme.peach) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(item.key.replacingOccurrences(of: "_", with: " ").capitalized)
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.textPrimary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("\(item.value)")
                                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                                        .foregroundStyle(AppTheme.tint)
                                    Text(AppStrings.History.toolsRecentUses)
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.textSecondary)
                                }
                                .frame(maxHeight: .infinity, alignment: .topLeading)
                            }
                            .frame(width: proxy.size.width, height: 142, alignment: .topLeading)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    CarouselPageIndicator(
                        count: items.count,
                        currentIndex: toolPage
                    )
                }
                .frame(height: 160)
            }
        }
    }

    private var emotionCounts: [String: Int] {
        Dictionary(grouping: weekCheckIns, by: \.emotion).mapValues(\.count)
    }

    private var maxEmotionCount: Int {
        max(1, emotionCounts.values.max() ?? 1)
    }

    private var toolCounts: [String: Int] {
        Dictionary(grouping: usage, by: \.name).mapValues(\.count)
    }

    private func metricPill(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.textPrimary)
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.7))
        )
    }

    private var emptyState: some View {
        AccentCard(tint: AppTheme.secondarySurface) {
            VStack(alignment: .leading, spacing: 10) {
                Text(AppStrings.History.emptyTitle)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
                Text(AppStrings.History.emptyBody)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
    .modelContainer(PersistenceController.preview.container)
}
