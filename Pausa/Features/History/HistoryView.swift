import SwiftData
import SwiftUI

struct HistoryView: View {
    let openRoute: (AppRoute) -> Void

    @Query(sort: \EmotionalCheckIn.createdAt, order: .reverse) private var checkIns: [EmotionalCheckIn]
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var journalEntries: [JournalEntry]
    @Query(sort: \ExerciseSessionRecord.completedAt, order: .reverse) private var sessions: [ExerciseSessionRecord]

    init(openRoute: @escaping (AppRoute) -> Void) {
        self.openRoute = openRoute
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                summaryCard
                insightCard
                writingsAccessCard
            }
            .padding(AppTheme.layoutPadding)
            .padding(.bottom, 44)
        }
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.History.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var weekCheckIns: [EmotionalCheckIn] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .now
        return checkIns.filter { $0.createdAt >= weekAgo }
    }

    private var notesCount: Int {
        journalEntries.count
    }

    private var weekSessions: [ExerciseSessionRecord] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .now
        return sessions.filter { $0.completedAt >= weekAgo }
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

                Text(
                    String(
                        format: String(localized: AppStrings.History.summaryBodyFormat),
                        locale: Locale(identifier: "es"),
                        weekCheckIns.count,
                        sessions.count
                    )
                )
                .foregroundStyle(AppTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10) {
                    metricPill(value: "\(weekCheckIns.count)", label: String(localized: AppStrings.History.metricWeek))
                    metricPill(value: "\(sessions.count)", label: String(localized: AppStrings.History.metricExercises))
                }

                if let commonEmotion {
                    Text(
                        String(
                            format: String(localized: AppStrings.History.summaryCommonEmotionFormat),
                            locale: Locale(identifier: "es"),
                            commonEmotion.lowercased()
                        )
                    )
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.tint)
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(24)
        }
    }

    private var commonEmotion: String? {
        Dictionary(grouping: weekCheckIns, by: \.localizedEmotion)
            .mapValues(\.count)
            .max(by: { $0.value < $1.value })?
            .key
    }

    private var weeklyToolLabel: String? {
        let candidates: [(String, Int)] = [
            (String(localized: AppStrings.History.metricExercises), weekSessions.count),
            (String(localized: AppStrings.History.writingsTitle), notesCount)
        ]

        guard let top = candidates
            .filter({ $0.1 > 0 })
            .max(by: { $0.1 < $1.1 }) else { return nil }

        return top.0.lowercased()
    }

    private var weeklyInsightText: String {
        switch (commonEmotion?.lowercased(), weeklyToolLabel) {
        case let (emotion?, tool?):
            String(
                format: String(localized: AppStrings.History.insightComboFormat),
                locale: Locale(identifier: "es"),
                emotion,
                tool
            )
        case let (emotion?, nil):
            String(
                format: String(localized: AppStrings.History.insightEmotionFormat),
                locale: Locale(identifier: "es"),
                emotion
            )
        case let (nil, tool?):
            String(
                format: String(localized: AppStrings.History.insightToolFormat),
                locale: Locale(identifier: "es"),
                tool
            )
        case (nil, nil):
            String(localized: AppStrings.History.insightEmpty)
        }
    }

    private var insightCard: some View {
        AccentCard(tint: AppTheme.tintSoft) {
            VStack(alignment: .leading, spacing: 10) {
                Text(AppStrings.History.insightTitle)
                    .font(.appSection)
                    .foregroundStyle(AppTheme.textPrimary)

                Text(weeklyInsightText)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var writingsAccessCard: some View {
        AccentCard(tint: AppTheme.secondarySurface) {
            VStack(alignment: .leading, spacing: 6) {
                Text(AppStrings.History.writingsTitle)
                    .font(.appSection)
                    .foregroundStyle(AppTheme.textPrimary)

                Text(writingsBodyText)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                Button(String(localized: AppStrings.History.previewButton)) {
                    openRoute(.writings)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
    }

    private var writingsBodyText: String {
        guard notesCount > 0 else {
            return String(localized: AppStrings.History.writingsEmptyBody)
        }

        return String(
            format: String(localized: AppStrings.History.writingsBodyFormat),
            locale: Locale(identifier: "es"),
            notesCount
        )
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
}

struct WritingsView: View {
    private let pageSize = 6

    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var journalEntries: [JournalEntry]
    @State private var selectedEntry: JournalEntry?
    @State private var notesPage = 0

    private var notes: [JournalEntry] {
        journalEntries
    }

    private var notePageCount: Int {
        max(1, Int(ceil(Double(notes.count) / Double(pageSize))))
    }

    private var pagedNotes: [JournalEntry] {
        let start = min(notesPage * pageSize, max(0, notes.count - 1))
        let end = min(start + pageSize, notes.count)
        guard start < end else { return [] }
        return Array(notes[start..<end])
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                notesSection
            }
            .padding(AppTheme.layoutPadding)
            .padding(.bottom, 44)
        }
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.Writings.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedEntry) { entry in
            journalEntryDetail(entry)
                .presentationDetents([.medium, .large])
        }
    }

    @ViewBuilder
    private var notesSection: some View {
        if notes.isEmpty {
            emptyCard(body: AppStrings.Writings.emptyBody)
        } else {
            ForEach(pagedNotes, id: \.id) { entry in
                Button {
                    selectedEntry = entry
                } label: {
                    AppCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(entryPreviewTitle(entry))
                                .font(.headline)
                                .foregroundStyle(AppTheme.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)

                            if let previewBody = entryPreviewBody(entry) {
                                Text(previewBody)
                                    .foregroundStyle(AppTheme.textSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            HStack {
                                Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.footnote)
                                    .foregroundStyle(AppTheme.textSecondary)

                                Spacer()
                                CardCTA(title: String(localized: AppStrings.Common.ctaViewDetails))
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
            }

            paginationControls(
                currentPage: notesPage,
                pageCount: notePageCount,
                totalCount: notes.count,
                previousAction: { notesPage = max(0, notesPage - 1) },
                nextAction: { notesPage = min(notePageCount - 1, notesPage + 1) }
            )
        }
    }

    private func paginationControls(
        currentPage: Int,
        pageCount: Int,
        totalCount: Int,
        previousAction: @escaping () -> Void,
        nextAction: @escaping () -> Void
    ) -> some View {
        PaginationControls(
            currentPage: currentPage,
            pageCount: pageCount,
            previousTitle: String(localized: AppStrings.Journaling.buttonBack),
            nextTitle: String(localized: AppStrings.Journaling.buttonNext),
            onPrevious: previousAction,
            onNext: nextAction
        )
        .opacity(totalCount > pageSize ? 1 : 0.94)
    }

    private func emptyCard(body: LocalizedStringResource) -> some View {
        AccentCard(tint: AppTheme.secondarySurface) {
            VStack(alignment: .leading, spacing: 10) {
                Text(AppStrings.Writings.emptyTitle)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
                Text(body)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func entryPreviewTitle(_ entry: JournalEntry) -> String {
        let candidates = [entry.feelingText, entry.neededText, entry.affectingText, entry.supportText]
        return candidates.first(where: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
            ?? String(localized: AppStrings.Journaling.detailTitle)
    }

    private func entryPreviewBody(_ entry: JournalEntry) -> String? {
        [entry.affectingText, entry.neededText, entry.supportText]
            .first(where: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
    }

    private func journalEntryDetail(_ entry: JournalEntry) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text(AppStrings.Journaling.detailTitle)
                    .font(.appSection)
                    .foregroundStyle(AppTheme.textPrimary)

                Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)

                detailSection(title: AppStrings.Journaling.fieldFeeling, text: entry.feelingText)
                detailSection(title: AppStrings.Journaling.fieldAffecting, text: entry.affectingText)
                detailSection(title: AppStrings.Journaling.fieldNeeded, text: entry.neededText)
                detailSection(title: AppStrings.Journaling.fieldSupport, text: entry.supportText)
            }
            .padding(24)
        }
    }

    @ViewBuilder
    private func detailSection(title: LocalizedStringResource, text: String) -> some View {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            SessionInfoCard(
                title: String(localized: title),
                message: trimmedText
            )
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView(openRoute: { _ in })
    }
    .modelContainer(PersistenceController.preview.container)
}
