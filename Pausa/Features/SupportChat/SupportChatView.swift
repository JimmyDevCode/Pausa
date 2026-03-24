import Observation
import SwiftData
import SwiftUI

@Observable
final class SupportChatViewModel {
    private let services: AppServices

    var draft = ""
    var isInfoPresented = false

    init(services: AppServices) {
        self.services = services
    }

    func send(context: ModelContext) {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        context.insert(ChatMessageRecord(text: text, isFromUser: true))
        services.track(.chatMessageSent, in: context)

        let reply = services.supportChatEngine.reply(to: text)
        context.insert(
            ChatMessageRecord(
                text: reply.text,
                isFromUser: false,
                suggestedRoute: reply.route?.storageKey ?? ""
            )
        )
        draft = ""
    }

    func sendQuickReply(_ text: String, context: ModelContext) {
        draft = text
        send(context: context)
    }
}

struct SupportChatView: View {
    let services: AppServices
    let openRoute: (AppRoute) -> Void

    @State private var viewModel: SupportChatViewModel
    @Query(sort: \ChatMessageRecord.createdAt) private var messages: [ChatMessageRecord]
    @Environment(\.modelContext) private var modelContext

    init(services: AppServices, openRoute: @escaping (AppRoute) -> Void) {
        self.services = services
        self.openRoute = openRoute
        _viewModel = State(initialValue: SupportChatViewModel(services: services))
    }

    var body: some View {
        @Bindable var bindableViewModel = viewModel

        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(messages, id: \.id) { message in
                            chatBubble(message)
                                .id(message.id)
                        }
                    }
                    .padding(20)
                }
                .onChange(of: messages.count) {
                    if let last = messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        quickReplyChip(EmotionalState.ansioso.localizedTitle)
                        quickReplyChip(EmotionalState.abrumado.localizedTitle)
                        quickReplyChip(EmotionalState.cansado.localizedTitle)
                        quickReplyChip(EmotionalState.triste.localizedTitle)
                    }
                }

                HStack(spacing: 12) {
                    TextField(String(localized: AppStrings.Chat.placeholder), text: $bindableViewModel.draft, axis: .vertical)
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.white)
                        )

                    Button(String(localized: AppStrings.Chat.buttonSend)) {
                        viewModel.send(context: modelContext)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .frame(width: 110)
                }
            }
            .padding(20)
            .background(AppTheme.background)
        }
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.Chat.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isInfoPresented = true
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(AppTheme.tint)
                }
            }
        }
        .sheet(isPresented: $bindableViewModel.isInfoPresented) {
            chatInfoSheet
                .presentationDetents([.medium, .large])
        }
    }

    @ViewBuilder
    private func chatBubble(_ message: ChatMessageRecord) -> some View {
        VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 8) {
            HStack {
                if message.isFromUser { Spacer() }
                Text(message.text)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(message.isFromUser ? AppTheme.tint : Color.white.opacity(0.92))
                    )
                    .foregroundStyle(message.isFromUser ? .white : AppTheme.textPrimary)
                if !message.isFromUser { Spacer() }
            }

            if !message.suggestedRoute.isEmpty, let route = route(from: message.suggestedRoute) {
                Button(String(localized: AppStrings.Chat.buttonOpenSuggestion)) {
                    openRoute(route)
                }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppTheme.tint)
            }
        }
    }

    private func route(from key: String) -> AppRoute? {
        AppRoute(storageKey: key)
    }

    private func quickReplyChip(_ text: String) -> some View {
        Button(text) {
            viewModel.sendQuickReply(text, context: modelContext)
        }
        .buttonStyle(.bordered)
        .clipShape(Capsule())
        .tint(AppTheme.tint)
    }

    private var chatInfoSheet: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(AppStrings.Chat.disclaimer)
                .font(.appBody)
                .foregroundStyle(AppTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            Button(String(localized: AppStrings.Chat.buttonOpenSuggestion)) {
                viewModel.isInfoPresented = false
                openRoute(.immediateHelp)
            }
            .buttonStyle(SecondaryButtonStyle())

            Spacer(minLength: 0)
        }
        .padding(24)
    }
}

#Preview {
    NavigationStack {
        SupportChatView(services: AppServices(), openRoute: { _ in })
    }
    .modelContainer(PersistenceController.preview.container)
}
