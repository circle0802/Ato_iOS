//
//  MyPageView.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import PhotosUI
import SwiftUI
import UIKit

struct MyPageView: View {
    @StateObject private var viewModel = MyPageViewModel()
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isShowingDeleteAlert = false
    @State private var isShowingLogoutAlert = false
    @State private var isShowingLogin = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                headerView
                    .padding(.top, 36)

                profileSummaryView

                notificationSettingsView

                statusView

                accountActionsView
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 112)
        }
        .background(Color.gray50)
        .task {
            viewModel.load()
        }
        .refreshable {
            viewModel.load()
        }
        .alert("회원탈퇴", isPresented: $isShowingDeleteAlert) {
            Button("취소", role: .cancel) {}
            Button("탈퇴", role: .destructive) {
                viewModel.deleteAccount()
            }
        } message: {
            Text("계정을 탈퇴하면 로그인 정보가 삭제돼요.")
        }
        .alert("로그아웃", isPresented: $isShowingLogoutAlert) {
            Button("취소", role: .cancel) {}
            Button("로그아웃", role: .destructive) {
                viewModel.logout()
            }
        } message: {
            Text("현재 계정에서 로그아웃할까요?")
        }
        .navigationDestination(isPresented: $isShowingLogin) {
            LoginView()
                .navigationBarBackButtonHidden(true)
        }
        .onChange(of: selectedPhotoItem) { _, newValue in
            loadSelectedPhoto(newValue)
        }
        .onChange(of: viewModel.notificationEnabled) { _, isEnabled in
            viewModel.updateNotificationEnabled(isEnabled)
        }
        .onChange(of: viewModel.didLogout) { _, didLogout in
            isShowingLogin = didLogout
        }
        .onChange(of: viewModel.didDeleteAccount) { _, didDeleteAccount in
            isShowingLogin = didDeleteAccount
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("마이페이지")
                .font(.ato(.bold, 28))
                .foregroundStyle(Color.gray400)

            Text("내 프로필을 관리해요")
                .font(.ato(.regular, 18))
                .foregroundStyle(Color.gray200)
        }
    }

    private var profileSummaryView: some View {
        HStack(spacing: 16) {
            editableProfileImageView

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.user?.nickname ?? AuthSession.nickname)
                    .font(.ato(.bold, 22))
                    .foregroundStyle(Color.gray400)

                Text("가입일 \(viewModel.joinedDateText)")
                    .font(.ato(.regular, 15))
                    .foregroundStyle(Color.gray200)
            }

            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var editableProfileImageView: some View {
        PhotosPicker(
            selection: $selectedPhotoItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            ZStack(alignment: .bottomTrailing) {
                profileImageView

                Image(systemName: "camera.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 26, height: 26)
                    .background(Color.orange400)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    }
            }
        }
        .buttonStyle(.plain)
    }

    private var profileImageView: some View {
        ZStack {
            Circle()
                .fill(Color.orange100)

            if let selectedProfileImageData = viewModel.selectedProfileImageData,
               let image = UIImage(data: selectedProfileImageData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } else if let localImageData = ProfileImageStorage.localImageData(from: viewModel.user?.profileImageUrl),
                      let image = UIImage(data: localImageData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } else if let profileImageUrl = viewModel.user?.profileImageUrl, !profileImageUrl.isEmpty {
                AtoRemoteImage(urlString: profileImageUrl) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Color.orange400)
                }
                .clipShape(Circle())
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(Color.orange400)
            }
        }
        .frame(width: 64, height: 64)
    }

    private var notificationSettingsView: some View {
        VStack(spacing: 16) {
            Toggle(isOn: $viewModel.notificationEnabled) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("알림")
                        .font(.ato(.semiBold, 18))
                        .foregroundStyle(Color.gray400)

                    Text(viewModel.notificationEnabled ? "기념일 알림을 받을게요" : "기념일 알림을 받지 않을게요")
                        .font(.ato(.regular, 14))
                        .foregroundStyle(Color.gray200)
                }
            }
            .tint(Color.orange400)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    @ViewBuilder
    private var statusView: some View {
        if viewModel.isLoading {
            Label("프로필을 불러오는 중이에요.", systemImage: "arrow.clockwise")
                .font(.ato(.regular, 14))
                .foregroundStyle(Color.gray200)
        } else if viewModel.isUpdatingProfileImage {
            Label("프로필 이미지를 변경하는 중이에요.", systemImage: "photo")
                .font(.ato(.regular, 14))
                .foregroundStyle(Color.gray200)
        } else if viewModel.isUpdatingNotificationSettings {
            Label("알림 설정을 변경하는 중이에요.", systemImage: "bell")
                .font(.ato(.regular, 14))
                .foregroundStyle(Color.gray200)
        } else if let errorMessage = viewModel.errorMessage {
            Label(errorMessage, systemImage: "exclamationmark.circle")
                .font(.ato(.regular, 14))
                .foregroundStyle(Color.red)
        } else if let successMessage = viewModel.successMessage {
            Label(successMessage, systemImage: "checkmark.circle")
                .font(.ato(.regular, 14))
                .foregroundStyle(Color.green)
        }
    }

    private var accountActionsView: some View {
        VStack(spacing: 12) {
            accountActionButton(
                title: "로그아웃",
                systemImageName: "rectangle.portrait.and.arrow.right",
                tintColor: Color.gray300
            ) {
                isShowingLogoutAlert = true
            }

            accountActionButton(
                title: viewModel.isDeleting ? "탈퇴 처리 중..." : "회원탈퇴",
                systemImageName: "trash",
                tintColor: Color.red
            ) {
                isShowingDeleteAlert = true
            }
            .disabled(viewModel.isDeleting)
        }
    }

    private func accountActionButton(
        title: String,
        systemImageName: String,
        tintColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImageName)
                    .font(.system(size: 16, weight: .semibold))

                Text(title)
                    .font(.ato(.semiBold, 16))
            }
            .foregroundStyle(tintColor)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .overlay {
                RoundedRectangle(cornerRadius: 26)
                    .stroke(tintColor.opacity(0.28), lineWidth: 1)
            }
        }
    }

    private func loadSelectedPhoto(_ item: PhotosPickerItem?) {
        guard let item else { return }

        Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self) {
                    viewModel.updateProfileImage(with: data)
                }
            } catch {
                viewModel.errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
    }
}
