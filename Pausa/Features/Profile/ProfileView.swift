import SwiftUI

struct ProfileView: View {
    let profile: UserProfile

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                AppCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(profile.nickname)
                            .font(.appTitle)
                            .foregroundStyle(AppTheme.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(String(format: String(localized: AppStrings.Profile.seekingFormat), locale: Locale(identifier: "es"), profile.preferredFeeling))
                            .foregroundStyle(AppTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(String(format: String(localized: AppStrings.Profile.focusFormat), locale: Locale(identifier: "es"), profile.mainConcern))
                            .foregroundStyle(AppTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                AppCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(AppStrings.Profile.privacyTitle)
                            .font(.headline)
                            .foregroundStyle(AppTheme.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(AppStrings.Profile.privacyBody)
                            .foregroundStyle(AppTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                AppCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(AppStrings.Profile.responsibleTitle)
                            .font(.headline)
                            .foregroundStyle(AppTheme.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(AppStrings.Profile.responsibleBody)
                            .foregroundStyle(AppTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(20)
        }
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.Profile.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProfileView(profile: UserProfile(nickname: "Ari", preferredFeeling: "Más calma", mainConcern: "Estrés"))
    }
}
