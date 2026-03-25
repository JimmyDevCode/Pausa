import SwiftUI

struct AppCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppTheme.layoutPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                    .fill(AppTheme.surface)
                    .overlay {
                        RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                            .stroke(Color.white.opacity(0.55), lineWidth: 1)
                    }
                    .shadow(color: Color.black.opacity(0.05), radius: AppTheme.shadowRadius, x: 0, y: 10)
            )
    }
}

struct AccentCard<Content: View>: View {
    let tint: Color
    let content: Content

    init(tint: Color, @ViewBuilder content: () -> Content) {
        self.tint = tint
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppTheme.layoutPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cardRadius + 2, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [tint.opacity(0.8), Color.white.opacity(0.95)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: AppTheme.shadowRadius, x: 0, y: 10)
            )
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        PrimaryButtonBody(configuration: configuration)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        SecondaryButtonBody(configuration: configuration)
    }
}

private struct PrimaryButtonBody: View {
    let configuration: ButtonStyle.Configuration
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        configuration.label
            .font(.headline)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .foregroundStyle(isEnabled ? .white : Color.white.opacity(0.82))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.buttonRadius, style: .continuous)
                    .fill(isEnabled ? AppTheme.tint : AppTheme.tint.opacity(0.38))
                    .scaleEffect(isEnabled && configuration.isPressed ? 0.98 : 1)
            )
            .opacity(isEnabled ? 1 : 0.75)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .animation(.easeOut(duration: 0.15), value: isEnabled)
    }
}

private struct SecondaryButtonBody: View {
    let configuration: ButtonStyle.Configuration
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        configuration.label
            .font(.headline)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .foregroundStyle(isEnabled ? AppTheme.textPrimary : AppTheme.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.buttonRadius, style: .continuous)
                    .fill(isEnabled ? AppTheme.secondarySurface : AppTheme.secondarySurface.opacity(0.65))
                    .overlay {
                        RoundedRectangle(cornerRadius: AppTheme.buttonRadius, style: .continuous)
                            .stroke(isEnabled ? AppTheme.tintSoft : AppTheme.tintSoft.opacity(0.55), lineWidth: 1)
                    }
                    .scaleEffect(isEnabled && configuration.isPressed ? 0.98 : 1)
            )
            .opacity(isEnabled ? 1 : 0.82)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .animation(.easeOut(duration: 0.15), value: isEnabled)
    }
}

struct MoodChip: View {
    let title: String
    let selected: Bool

    var body: some View {
        Text(title)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(selected ? .white : AppTheme.textPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule(style: .continuous)
                    .fill(selected ? AppTheme.tint : Color.white.opacity(0.7))
            )
            .overlay {
                Capsule(style: .continuous)
                    .stroke(selected ? Color.clear : AppTheme.tintSoft, lineWidth: 1)
            }
    }
}

struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.appSection)
                .foregroundStyle(AppTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            Text(subtitle)
                .font(.appBody)
                .foregroundStyle(AppTheme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct QuickActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var showsChevron: Bool = true

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.iconRadius, style: .continuous)
                    .fill(AppTheme.tintSoft)
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .foregroundStyle(AppTheme.tint)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)

            Spacer()

            if showsChevron {
                Image(systemName: "chevron.right")
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct SessionInfoCard: View {
    let title: String
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            Text(message)
                .font(.footnote)
                .foregroundStyle(AppTheme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.58))
        )
    }
}

struct InsightBadge: View {
    let title: String
    let tint: Color

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(AppTheme.textPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(tint.opacity(0.45))
            )
    }
}

struct CarouselPageIndicator: View {
    let count: Int
    let currentIndex: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(0..<count), id: \.self) { index in
                Capsule(style: .continuous)
                    .fill(index == currentIndex ? AppTheme.tint : AppTheme.tintSoft.opacity(0.9))
                    .frame(width: index == currentIndex ? 28 : 10, height: 6)
                    .animation(.easeOut(duration: 0.2), value: currentIndex)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct PaginationControls: View {
    let currentPage: Int
    let pageCount: Int
    let previousTitle: String
    let nextTitle: String
    let onPrevious: () -> Void
    let onNext: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(previousTitle, action: onPrevious)
                .buttonStyle(.plain)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(currentPage == 0 ? AppTheme.textSecondary : AppTheme.textPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    Capsule(style: .continuous)
                        .fill(currentPage == 0 ? AppTheme.secondarySurface.opacity(0.55) : AppTheme.secondarySurface)
                )
                .overlay {
                    Capsule(style: .continuous)
                        .stroke(AppTheme.tintSoft, lineWidth: 1)
                }
                .disabled(currentPage == 0)

            Spacer()

            VStack(spacing: 8) {
                Text("\(currentPage + 1) / \(pageCount)")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppTheme.tint)

                HStack(spacing: 6) {
                    ForEach(pageIndicatorIndices, id: \.self) { index in
                        Capsule(style: .continuous)
                            .fill(index == currentPage ? AppTheme.tint : AppTheme.tintSoft.opacity(0.85))
                            .frame(width: index == currentPage ? 22 : 8, height: 6)
                    }
                }
            }

            Spacer()

            Button(nextTitle, action: onNext)
                .buttonStyle(.plain)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(currentPage >= pageCount - 1 ? Color.white.opacity(0.82) : .white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    Capsule(style: .continuous)
                        .fill(currentPage >= pageCount - 1 ? AppTheme.tint.opacity(0.4) : AppTheme.tint)
                )
                .disabled(currentPage >= pageCount - 1)
        }
        .padding(.horizontal, 4)
    }

    private var pageIndicatorIndices: [Int] {
        guard pageCount > 5 else { return Array(0..<pageCount) }

        let start = max(0, min(currentPage - 2, pageCount - 5))
        let end = min(pageCount, start + 5)
        return Array(start..<end)
    }
}

struct CardCTA: View {
    let title: String

    var body: some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
            Image(systemName: "arrow.right")
                .font(.caption.weight(.bold))
        }
        .foregroundStyle(AppTheme.tint)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            Capsule(style: .continuous)
                .fill(Color.white.opacity(0.82))
        )
    }
}
