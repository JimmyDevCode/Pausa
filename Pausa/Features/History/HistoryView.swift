import SwiftData
import SwiftUI

private struct WritingItem: Identifiable {
    enum Kind {
        case journal
        case chat
    }

    let id: String
    let kind: Kind
    let title: String
    let body: String
    let timestamp: Date
}

private enum WritingFilter: String, CaseIterable, Identifiable {
    case notes
    case messages

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .notes:
            AppStrings.Writings.filterNotes
        case .messages:
            AppStrings.Writings.filterMessages
        }
    }
}

struct HistoryView: View {
    let openRoute: (AppRoute) -> Void

    @Query(sort: \EmotionalCheckIn.createdAt, order: .reverse) private var checkIns: [EmotionalCheckIn]
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var journalEntries: [JournalEntry]
    @Query(sort: \ChatMessageRecord.createdAt, order: .reverse) private var chatMessages: [ChatMessageRecord]
    @Query(sort: \ExerciseSessionRecord.completedAt, order: .reverse) private var sessions: [ExerciseSessionRecord]

    init(openRoute: @escaping (AppRoute) -> Void) {
        self.openRoute = openRoute
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                summaryCard

                if writingPreview.isEmpty {
                    emptyState
                } else {
                    writingsPreviewSection
                }
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

    private var writingPreview: [WritingItem] {
        Array(allWritings.prefix(3))
    }

    private var allWritings: [WritingItem] {
        let journalItems = journalEntries.map { entry in
            WritingItem(
                id: "journal-\(entry.id.uuidString)",
                kind: .journal,
                title: String(localized: AppStrings.History.Item.journalTitle),
                body: journalPreview(entry),
                timestamp: entry.createdAt
            )
        }

        let chatItems = chatMessages
            .filter(\.isFromUser)
            .map { message in
                WritingItem(
                    id: "chat-\(message.id.uuidString)",
                    kind: .chat,
                    title: String(localized: AppStrings.History.Item.chatTitle),
                    body: message.text,
                    timestamp: message.createdAt
                )
            }

        return (journalItems + chatItems).sorted(by: { $0.timestamp > $1.timestamp })
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

    private var writingsPreviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(AppStrings.History.previewTitle)
                .font(.appSection)
                .foregroundStyle(AppTheme.textPrimary)

            AppCard {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(writingPreview.enumerated()), id: \.element.id) { index, item in
                        if index > 0 {
                            Divider()
                                .padding(.vertical, 14)
                        }

                        writingRow(item)
                    }

                    Divider()
                        .padding(.vertical, 14)

                    Button(String(localized: AppStrings.History.previewButton)) {
                        openRoute(.writings)
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
            }
        }
    }

    private func writingRow(_ item: WritingItem) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(tint(for: item.kind).opacity(0.9))
                    .frame(width: 42, height: 42)
                Image(systemName: icon(for: item.kind))
                    .foregroundStyle(AppTheme.tint)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)
                    Spacer()
                    Text(item.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(AppTheme.textSecondary)
                }

                Text(item.body)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func journalPreview(_ entry: JournalEntry) -> String {
        let candidates = [entry.feelingText, entry.neededText, entry.affectingText, entry.supportText]
        return candidates.first(where: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) ?? ""
    }

    private func icon(for kind: WritingItem.Kind) -> String {
        switch kind {
        case .journal:
            "square.and.pencil"
        case .chat:
            "ellipsis.message"
        }
    }

    private func tint(for kind: WritingItem.Kind) -> Color {
        switch kind {
        case .journal:
            AppTheme.secondarySurface
        case .chat:
            AppTheme.peach
        }
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
                Text(AppStrings.History.previewEmptyBody)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                Button(String(localized: AppStrings.History.previewButton)) {
                    openRoute(.writings)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
    }
}

struct WritingsView: View {
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var journalEntries: [JournalEntry]
    @Query(sort: \ChatMessageRecord.createdAt, order: .reverse) private var chatMessages: [ChatMessageRecord]
    @State private var selectedFilter: WritingFilter = .notes
    @State private var selectedEntry: JournalEntry?

    private var notes: [JournalEntry] {
        journalEntries
    }

    private var messages: [ChatMessageRecord] {
        chatMessages.filter(\.isFromUser)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Picker("", selection: $selectedFilter) {
                    ForEach(WritingFilter.allCases) { filter in
                        Text(filter.title).tag(filter)
                    }
                }
                .pickerStyle(.segmented)

                if selectedFilter == .notes {
                    notesSection
                } else {
                    messagesSection
                }
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
            ForEach(notes, id: \.id) { entry in
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
        }
    }

    @ViewBuilder
    private var messagesSection: some View {
        if messages.isEmpty {
            emptyCard(body: AppStrings.Writings.emptyBody)
        } else {
            ForEach(messages, id: \.id) { message in
                AppCard {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(AppStrings.History.Item.chatTitle)
                                .font(.headline)
                                .foregroundStyle(AppTheme.textPrimary)
                            Spacer()
                            Text(message.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.footnote)
                                .foregroundStyle(AppTheme.textSecondary)
                        }

                        Text(message.text)
                            .foregroundStyle(AppTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
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
