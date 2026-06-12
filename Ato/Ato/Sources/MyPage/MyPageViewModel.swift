//
//  MyPageViewModel.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation
import Combine

@MainActor
final class MyPageViewModel: ObservableObject {
    @Published private(set) var user: MeUser?
    @Published var nickname = ""
    @Published var profileImageUrl = ""
    @Published var selectedProfileImageData: Data?
    @Published var notificationEnabled = true
    @Published var isLoading = false
    @Published var isUpdatingProfileImage = false
    @Published var isUpdatingNotificationSettings = false
    @Published var isDeleting = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published private(set) var didDeleteAccount = false
    @Published private(set) var didLogout = false

    private let meService: MeService

    var joinedDateText: String {
        guard let createdAt = user?.createdAt else {
            return "-"
        }

        let dateText = String(createdAt.prefix(10)).replacingOccurrences(of: "-", with: ".")
        return dateText.isEmpty ? "-" : dateText
    }

    init(meService: MeService? = nil) {
        self.meService = meService ?? MeService()
    }

    func load() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        Task {
            do {
                let user = try await meService.fetchProfile()
                apply(user)
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }

    func updateProfileImage(with data: Data) {
        guard !isUpdatingProfileImage else { return }

        selectedProfileImageData = data
        isUpdatingProfileImage = true
        errorMessage = nil
        successMessage = nil

        Task {
            do {
                let profileImageUrl = try ProfileImageStorage.saveImageData(data)
                let request = UpdateProfileImageRequest(profileImageUrl: profileImageUrl)
                let user = try await meService.updateProfileImage(request)
                apply(user)
                successMessage = "프로필 이미지를 변경했어요."
            } catch {
                errorMessage = error.localizedDescription
            }

            isUpdatingProfileImage = false
        }
    }

    func updateNotificationEnabled(_ isEnabled: Bool) {
        guard user?.notificationEnabled != isEnabled, !isUpdatingNotificationSettings else {
            return
        }

        notificationEnabled = isEnabled
        isUpdatingNotificationSettings = true
        errorMessage = nil
        successMessage = nil

        Task {
            do {
                let request = UpdateNotificationSettingsRequest(notificationEnabled: isEnabled)
                let user = try await meService.updateNotificationSettings(request)
                apply(user)
                successMessage = "알림 설정을 변경했어요."
            } catch {
                notificationEnabled = user?.notificationEnabled ?? notificationEnabled
                errorMessage = error.localizedDescription
            }

            isUpdatingNotificationSettings = false
        }
    }

    func logout() {
        AuthSession.clear()
        didLogout = true
    }

    func deleteAccount() {
        guard !isDeleting else { return }

        isDeleting = true
        errorMessage = nil
        successMessage = nil

        Task {
            do {
                try await meService.deleteAccount()
                AuthSession.clear()
                didDeleteAccount = true
            } catch {
                errorMessage = error.localizedDescription
            }

            isDeleting = false
        }
    }

    private func apply(_ user: MeUser) {
        self.user = user
        nickname = user.nickname
        profileImageUrl = user.profileImageUrl ?? ""
        selectedProfileImageData = nil
        notificationEnabled = user.notificationEnabled
    }
}
