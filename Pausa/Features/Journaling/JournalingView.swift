import Observation
import SwiftData
import SwiftUI

@Observable
final class JournalingViewModel {
    private let services: AppServices

    var feelingText = ""

    init(services: AppServices) {
        self.services = services
    }

    var canSave: Bool {
        !feelingText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func save(context: ModelContext) {
        context.insert(
            JournalEntry(
                feelingText: feelingText
            )
        )
        services.track(.journalingSaved, in: context)
        feelingText = ""
    }
}

struct JournalingView: View {
    let services: AppServices
    let openRoute: (AppRoute) -> Void

    @State private var viewModel: JournalingViewModel
    @State private var selectedEntry: JournalEntry?
    @FocusState private var isJournalFieldFocused: Bool
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    @Environment(\.modelContext) private var modelContext

    init(services: AppServices, openRoute: @escaping (AppRoute) -> Void) {
        self.services = services
        self.openRoute = openRoute
        _viewModel = State(initialValue: JournalingViewModel(services: services))
    }

    var body: some View {
        @Bindable var bindableViewModel = viewModel

        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                AppCard {
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(
                            title: "Escribe lo que te pasa",
                            subtitle: "Hazlo corto o largo. Solo escribe lo que te salga."
                        )

                        journalField(title: String(localized: AppStrings.Journaling.fieldFeeling), text: $bindableViewModel.feelingText)

                        Button(String(localized: AppStrings.Journaling.buttonSave)) {
                            isJournalFieldFocused = false
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

                    if let latestEntry = entries.first {
                        Button {
                            selectedEntry = latestEntry
                        } label: {
                            let preview = entryPreview(latestEntry)
                            AppCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(preview.title)
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.textPrimary)
                                        .fixedSize(horizontal: false, vertical: true)

                                    Text(preview.body)
                                        .foregroundStyle(AppTheme.textSecondary)
                                        .lineLimit(3)
                                        .truncationMode(.tail)
                                        .fixedSize(horizontal: false, vertical: true)

                                    HStack(alignment: .center) {
                                        Text(latestEntry.createdAt.formatted(date: .abbreviated, time: .shortened))
                                            .font(.footnote)
                                            .foregroundStyle(AppTheme.textSecondary)

                                        Spacer()
                                        CardCTA(title: String(localized: AppStrings.Common.ctaViewDetails))
                                    }
                                }
                            }
                        }
                        .buttonStyle(.plain)

                        Button(String(localized: AppStrings.History.previewButton)) {
                            openRoute(.writings)
                        }
                        .buttonStyle(SecondaryButtonStyle())
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
        .contentShape(Rectangle())
        .onTapGesture {
            isJournalFieldFocused = false
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
                .focused($isJournalFieldFocused)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                )
        }
    }

    private func entryPreview(_ entry: JournalEntry) -> (title: String, body: String) {
        let body = entry.feelingText.trimmingCharacters(in: .whitespacesAndNewlines)
        return (
            String(localized: AppStrings.Journaling.fieldFeeling),
            body.isEmpty ? String(localized: AppStrings.Journaling.emptyBody) : body
        )
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
        JournalingView(services: AppServices(), openRoute: { _ in })
    }
    .modelContainer(PersistenceController.preview.container)
}
