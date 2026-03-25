import SwiftUI
import UIKit

private enum AvatarSource {
    case camera
    case library
}

struct ProfileView: View {
    let profile: UserProfile

    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                profileHeader
                aboutCard
                editButton
                secondaryCards
            }
            .padding(20)
            .padding(.bottom, 44)
        }
        .background(AppTheme.pageGradient.ignoresSafeArea())
        .navigationTitle(String(localized: AppStrings.Profile.navigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isEditing) {
            EditProfileView(profile: profile)
                .presentationDetents([.medium, .large])
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 14) {
            profileAvatar(size: 108)

            VStack(spacing: 6) {
                Text(displayName)
                    .font(.appTitle)
                    .foregroundStyle(AppTheme.textPrimary)
                    .multilineTextAlignment(.center)

                Text(profileSubtitle)
                    .font(.appBody)
                    .foregroundStyle(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }

    private var aboutCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 14) {
                Text(AppStrings.Profile.aboutTitle)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                profileLine(
                    title: String(localized: AppStrings.Profile.fieldPreferredFeeling),
                    value: profile.localizedPreferredFeeling
                )

                Divider()

                profileLine(
                    title: String(localized: AppStrings.Profile.fieldConcern),
                    value: profile.localizedMainConcern
                )
            }
        }
    }

    private var editButton: some View {
        Button(String(localized: AppStrings.Profile.editButton)) {
            isEditing = true
        }
        .buttonStyle(PrimaryButtonStyle())
    }

    private var secondaryCards: some View {
        VStack(alignment: .leading, spacing: 12) {
            AppCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text(AppStrings.Profile.privacyTitle)
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)
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
                    Text(AppStrings.Profile.responsibleBody)
                        .foregroundStyle(AppTheme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var displayName: String {
        let trimmed = profile.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? String(localized: AppStrings.Preview.nickname) : trimmed
    }

    private var profileSubtitle: String {
        String(
            format: String(localized: AppStrings.Profile.subtitleFormat),
            locale: Locale(identifier: "es"),
            profile.localizedPreferredFeeling.lowercased(),
            profile.localizedMainConcern.lowercased()
        )
    }

    private func profileAvatar(size: CGFloat) -> some View {
        Group {
            if let avatarImage {
                Image(uiImage: avatarImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Text(initials)
                    .font(.system(size: size * 0.3, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.tint)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        LinearGradient(
                            colors: [AppTheme.tintSoft, Color.white.opacity(0.96)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(Color.white.opacity(0.82), lineWidth: 3)
        }
        .shadow(color: AppTheme.tint.opacity(0.12), radius: 14, x: 0, y: 8)
    }

    private var avatarImage: UIImage? {
        guard let data = profile.avatarData, let image = UIImage(data: data) else { return nil }
        return image
    }

    private var initials: String {
        let pieces = displayName.split(separator: " ")
        let letters = pieces.prefix(2).compactMap { $0.first }
        return letters.isEmpty ? "P" : String(letters).uppercased()
    }

    private func profileLine(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.textSecondary)
            Text(value)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct EditProfileView: View {
    let profile: UserProfile

    @Environment(\.dismiss) private var dismiss
    @State private var isShowingPhotoOptions = false
    @State private var isShowingImagePicker = false
    @State private var selectedSource: AvatarSource = .library

    var body: some View {
        @Bindable var bindableProfile = profile

        NavigationStack {
            Form {
                Section {
                    VStack(spacing: 12) {
                        avatarPreview

                        Button {
                            isShowingPhotoOptions = true
                        } label: {
                            Text(profile.avatarData == nil ? AppStrings.Profile.choosePhoto : AppStrings.Profile.editPhoto)
                                .font(.headline)
                                .foregroundStyle(AppTheme.tint)
                        }

                        Text(AppStrings.Profile.photoHint)
                            .font(.footnote)
                            .foregroundStyle(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }

                Section {
                    TextField(String(localized: AppStrings.Profile.fieldNickname), text: $bindableProfile.nickname)
                    Picker(String(localized: AppStrings.Profile.fieldPreferredFeeling), selection: $bindableProfile.preferredFeeling) {
                        ForEach(DesiredFeeling.allCases) { feeling in
                            Text(feeling.localizedTitle).tag(feeling.rawValue)
                        }
                    }

                    Picker(String(localized: AppStrings.Profile.fieldConcern), selection: $bindableProfile.mainConcern) {
                        ForEach(FocusArea.allCases) { concern in
                            Text(concern.localizedTitle).tag(concern.rawValue)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.pageGradient.ignoresSafeArea())
            .navigationTitle(String(localized: AppStrings.Profile.editTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: AppStrings.Profile.doneButton)) {
                        dismiss()
                    }
                }
            }
            .confirmationDialog(
                String(localized: AppStrings.Profile.editPhoto),
                isPresented: $isShowingPhotoOptions,
                titleVisibility: .visible
            ) {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button(String(localized: AppStrings.Profile.cameraOption)) {
                        selectedSource = .camera
                        isShowingImagePicker = true
                    }
                }

                Button(String(localized: AppStrings.Profile.libraryOption)) {
                    selectedSource = .library
                    isShowingImagePicker = true
                }

                if profile.avatarData != nil {
                    Button(String(localized: AppStrings.Profile.removePhotoOption), role: .destructive) {
                        profile.avatarData = nil
                    }
                }

                Button(String(localized: AppStrings.Profile.cancelOption), role: .cancel) {}
            }
            .sheet(isPresented: $isShowingImagePicker) {
                LegacyImagePicker(sourceType: selectedSource == .camera ? .camera : .photoLibrary) { image in
                    profile.avatarData = image.jpegData(compressionQuality: 0.9)
                }
            }
        }
    }

    private var avatarPreview: some View {
        Group {
            if let data = profile.avatarData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.tintSoft, Color.white.opacity(0.95)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(AppTheme.tint)
                    }
            }
        }
        .frame(width: 92, height: 92)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(Color.white.opacity(0.82), lineWidth: 3)
        }
    }
}

private struct LegacyImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void

    @Environment(\.dismiss) private var dismiss

    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked, dismiss: dismiss)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = sourceType
        controller.allowsEditing = true
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let onImagePicked: (UIImage) -> Void
        let dismiss: DismissAction

        init(onImagePicked: @escaping (UIImage) -> Void, dismiss: DismissAction) {
            self.onImagePicked = onImagePicked
            self.dismiss = dismiss
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss()
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
                onImagePicked(image)
            }
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(profile: UserProfile(nickname: String(localized: AppStrings.Preview.nickname), preferredFeeling: DesiredFeeling.calma.rawValue, mainConcern: FocusArea.estres.rawValue))
    }
}
