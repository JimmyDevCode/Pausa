import Observation
import SwiftData
import SwiftUI

@Observable
final class JournalingViewModel {
    private let services: AppServices

    var feelingText = ""
    var affectingText = ""
    var neededText = ""
    var supportText = ""

    init(services: AppServices) {
        self.services = services
    }

    var canSave: Bool {
        [feelingText, affectingText, neededText, supportText]
            .contains { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    func save(context: ModelContext) {
        context.insert(
            JournalEntry(
                feelingText: feelingText,
                affectingText: affectingText,
                neededText: neededText,
                supportText: supportText
            )
        )
        services.track(.journalingSaved, in: context)
        feelingText = ""
        affectingText = ""
        neededText = ""
        supportText = ""
    }
}

struct JournalingView: View {
    let services: AppServices

    @State private var viewModel: JournalingViewModel
    @State private var selectedEntry: JournalEntry?
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    @Environment(\.modelContext) private var modelContext

    init(services: AppServices) {
        self.services = services
        _viewModel = State(initialValue: JournalingViewModel(services: services))
    }

    var body: some View {
        @Bindable var bindableViewModel = viewModel

        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                AppCard {
                    VStack(alignment: .leading, spacing: 14) {
                        journalField(title: String(localized: AppStrings.Journaling.fieldFeeling), text: $bindableViewModel.feelingText)
                        journalField(title: String(localized: AppStrings.Journaling.fieldAffecting), text: $bindableViewModel.affectingText)
                        journalField(title: String(localized: AppStrings.Journaling.fieldNeeded), text: $bindableViewModel.neededText)
                        journalField(title: String(localized: AppStrings.Journaling.fieldSupport), text: $bindableViewModel.supportText)
                        Button(String(localized: AppStrings.Journaling.buttonSave)) {
                            viewModel.save(context: modelContext)
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(!viewModel.canSave)
                    }
                }

                if !entries.isEmpty {
                    Text(AppStrings.Journaling.previousEntries)
                        .font(.appSection)
                        .foregroundStyle(AppTheme.textPrimary)

                    ForEach(entries.prefix(6), id: \.id) { entry in
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

                                    HStack(alignment: .center) {
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
                } else {
                    AccentCard(tint: AppTheme.secondarySurface) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(AppStrings.Journaling.emptyTitle)
                                .font(.headline)
                                .foregroundStyle(AppTheme.textPrimary)
                            Text(AppStrings.Journaling.emptyBody)
                                .foregroundStyle(AppTheme.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.Journaling.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedEntry) { entry in
            journalEntryDetail(entry)
                .presentationDetents([.medium, .large])
        }
    }

    private func journalField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)
            TextField(String(localized: AppStrings.Journaling.placeholder), text: text, axis: .vertical)
                .lineLimit(3...6)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                )
        }
    }

    private func entryPreviewTitle(_ entry: JournalEntry) -> String {
        let candidates = [entry.feelingText, entry.neededText, entry.affectingText, entry.supportText]
        return candidates.first(where: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) ?? String(localized: AppStrings.Journaling.detailTitle)
    }

    private func entryPreviewBody(_ entry: JournalEntry) -> String? {
        let preview = [entry.affectingText, entry.neededText, entry.supportText]
            .first(where: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
        return preview
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
        JournalingView(services: AppServices())
    }
    .modelContainer(PersistenceController.preview.container)
}
