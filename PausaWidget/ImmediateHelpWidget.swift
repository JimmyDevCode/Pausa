import SwiftUI
import WidgetKit

struct ImmediateHelpEntry: TimelineEntry {
    let date: Date
}

struct ImmediateHelpProvider: TimelineProvider {
    func placeholder(in context: Context) -> ImmediateHelpEntry {
        ImmediateHelpEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (ImmediateHelpEntry) -> Void) {
        completion(ImmediateHelpEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ImmediateHelpEntry>) -> Void) {
        let entry = ImmediateHelpEntry(date: .now)
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct ImmediateHelpWidgetView: View {
    @Environment(\.widgetFamily) private var family

    private let immediateHelpURL = URL(string: "pausa://immediate-help")!
    private let accent = Color(red: 0.80, green: 0.31, blue: 0.33)
    private let softAccent = Color(red: 0.98, green: 0.90, blue: 0.86)
    private let softBackground = Color(red: 0.99, green: 0.97, blue: 0.95)

    var body: some View {
        Link(destination: immediateHelpURL) {
            Group {
                switch family {
                case .systemMedium:
                    mediumWidget
                default:
                    smallWidget
                }
            }
            .containerBackground(for: .widget) {
                softBackground
            }
        }
    }

    private var smallWidget: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [softAccent, .white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(accent.opacity(0.10))
                .frame(width: 88, height: 88)
                .offset(x: 18, y: -22)

            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.white.opacity(0.92))
                        .frame(width: 48, height: 48)

                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(accent)
                }

                Spacer(minLength: 0)

                Text("Alivio")
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundStyle(.black.opacity(0.88))
                    .lineLimit(1)

                Text("Inmediato")
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundStyle(.black.opacity(0.88))
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text("Abrir")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))

                    Image(systemName: "arrow.right")
                        .font(.system(size: 11, weight: .bold))
                }
                .foregroundStyle(accent)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(.white.opacity(0.95), in: Capsule())
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var mediumWidget: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [softAccent, .white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(accent.opacity(0.10))
                .frame(width: 132, height: 132)
                .offset(x: 30, y: -34)

            HStack(alignment: .bottom, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(.white.opacity(0.92))
                                .frame(width: 54, height: 54)

                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(accent)
                        }

                        Text("Alivio inmediato")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.black.opacity(0.88))
                            .lineLimit(2)
                    }

                    Text("Abre una ayuda breve para bajar la tensión en este momento.")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(.black.opacity(0.62))
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                VStack(alignment: .trailing, spacing: 10) {
                    Text("1 min")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(accent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.95), in: Capsule())

                    HStack(spacing: 6) {
                        Text("Abrir")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))

                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundStyle(accent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.white.opacity(0.95), in: Capsule())
                }
            }
            .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}

struct ImmediateHelpWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "ImmediateHelpWidget", provider: ImmediateHelpProvider()) { _ in
            ImmediateHelpWidgetView()
        }
        .configurationDisplayName("Alivio inmediato")
        .description("Abre la app directo en ayuda inmediata.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
