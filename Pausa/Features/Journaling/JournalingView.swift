import Observation
import SwiftData
import SwiftUI

private enum JournalStep: Int, CaseIterable {
    case reflection
    case support

    var index: Int { rawValue + 1 }
}

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
    let openRoute: (AppRoute) -> Void

    @State private var viewModel: JournalingViewModel
    @State private var currentStep: JournalStep = .reflection
    @State private var selectedEntry: JournalEntry?
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
                        journalPaginationHeader

                        if currentStep == .reflection {
                            journalField(title: String(localized: AppStrings.Journaling.fieldFeeling), text: $bindableViewModel.feelingText)
                            journalField(title: String(localized: AppStrings.Journaling.fieldAffecting), text: $bindableViewModel.affectingText)
                        } else {
                            journalField(title: String(localized: AppStrings.Journaling.fieldNeeded), text: $bindableViewModel.neededText)
                            journalField(title: String(localized: AppStrings.Journaling.fieldSupport), text: $bindableViewModel.supportText)
                        }

                        HStack(spacing: 12) {
                            if currentStep == .support {
                                Button(String(localized: AppStrings.Journaling.buttonBack)) {
                                    currentStep = .reflection
                                }
                                .buttonStyle(SecondaryButtonStyle())
                            }

                            if currentStep == .reflection {
                                Button(String(localized: AppStrings.Journaling.buttonNext)) {
                                    currentStep = .support
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            } else {
                                Button(String(localized: AppStrings.Journaling.buttonSave)) {
                                    viewModel.save(context: modelContext)
                                    currentStep = .reflection
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(!viewModel.canSave)
                            }
                        }
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
                            AppCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(entryPreviewTitle(latestEntry))
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.textPrimary)
                                        .fixedSize(horizontal: false, vertical: true)

                                    if let previewBody = entryPreviewBody(latestEntry) {
                                        Text(previewBody)
                                            .foregroundStyle(AppTheme.textSecondary)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }

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
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.Journaling.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedEntry) { entry in
            journalEntryDetail(entry)
                .presentationDetents([.medium, .large])
        }
    }

    private var journalPaginationHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(
                String(
                    format: String(localized: AppStrings.Journaling.stepFormat),
                    locale: Locale(identifier: "es"),
                    currentStep.index,
                    JournalStep.allCases.count
                )
            )
            .font(.footnote.weight(.semibold))
            .foregroundStyle(AppTheme.tint)

            HStack(spacing: 8) {
                ForEach(JournalStep.allCases, id: \.rawValue) { step in
                    Capsule(style: .continuous)
                        .fill(step.rawValue <= currentStep.rawValue ? AppTheme.tint : AppTheme.tintSoft.opacity(0.45))
                        .frame(maxWidth: .infinity)
                        .frame(height: 6)
                }
            }

            Text(currentStepTitle)
                .font(.appSection)
                .foregroundStyle(AppTheme.textPrimary)

            Text(currentStepBody)
                .foregroundStyle(AppTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var currentStepTitle: LocalizedStringResource {
        switch currentStep {
        case .reflection:
            AppStrings.Journaling.stepReflectionTitle
        case .support:
            AppStrings.Journaling.stepSupportTitle
        }
    }

    private var currentStepBody: LocalizedStringResource {
        switch currentStep {
        case .reflection:
            AppStrings.Journaling.stepReflectionBody
        case .support:
            AppStrings.Journaling.stepSupportBody
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
        JournalingView(services: AppServices(), openRoute: { _ in })
    }
    .modelContainer(PersistenceController.preview.container)
}
