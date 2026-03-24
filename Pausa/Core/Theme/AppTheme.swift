import SwiftUI

enum AppTheme {
    static let background = Color(red: 0.96, green: 0.97, blue: 0.98)
    static let surface = Color.white.opacity(0.84)
    static let secondarySurface = Color(red: 0.91, green: 0.96, blue: 0.95)
    static let tint = Color(red: 0.18, green: 0.60, blue: 0.62)
    static let tintSoft = Color(red: 0.78, green: 0.91, blue: 0.90)
    static let peach = Color(red: 0.98, green: 0.86, blue: 0.79)
    static let lavender = Color(red: 0.87, green: 0.85, blue: 0.97)
    static let textPrimary = Color(red: 0.13, green: 0.18, blue: 0.21)
    static let textSecondary = Color(red: 0.37, green: 0.44, blue: 0.47)
    static let warning = Color(red: 0.84, green: 0.41, blue: 0.30)
    static let layoutPadding: CGFloat = 20
    static let layoutPaddingLarge: CGFloat = 24
    static let cardRadius: CGFloat = 28
    static let buttonRadius: CGFloat = 20
    static let iconRadius: CGFloat = 18
    static let shadowRadius: CGFloat = 18

    static var pageGradient: LinearGradient {
        LinearGradient(
            colors: [background, Color.white, secondarySurface.opacity(0.9)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension Font {
    static let appTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let appSection = Font.system(.title3, design: .rounded, weight: .semibold)
    static let appBody = Font.system(.body, design: .rounded)
}
