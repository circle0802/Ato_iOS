//
//  SignupView.swift
//  Ato
//
//  Created by hawon on 6/7/26.
//
import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SignupViewModel()

    var body: some View {
        VStack(spacing: 36) {
            HStack {
                AtoBackButton {
                    dismiss()
                }

                Spacer()
            }
            .padding(.top, -16)

            VStack(spacing: 0) {
                Text("아토")
                    .font(.ato(.semiBold, 32))
                    .foregroundStyle(Color.orange400)

                Text("AI 선물 추천 서비스")
                    .font(.ato(.regular, 20))
                    .foregroundStyle(Color.gray100)
            }

            VStack(spacing: 12) {
                AtoTextField(
                    title: "별명",
                    placeholder: "별명을 입력해주세요",
                    text: Binding(
                        get: { viewModel.nickname },
                        set: { viewModel.updateNickname($0) }
                    )
                )
                
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.checkNickname()
                    }) {
                        Text(viewModel.isCheckingNickname ? "확인중" : "중복확인")
                            .font(.ato(.medium, 14))
                            .foregroundStyle(Color.orange400)
                            .frame(width: 82, height: 32)
                            .background(Color.orange100)
                            .clipShape(Capsule())
                    }
                    .disabled(!viewModel.isNicknameCheckEnabled)
                }

                if let nicknameCheckMessage = viewModel.nicknameCheckMessage {
                    HStack {
                        Text(nicknameCheckMessage)
                            .font(.ato(.regular, 14))
                            .foregroundStyle(viewModel.isNicknameAvailable ? Color.green : Color.red)

                        Spacer()
                    }
                }
            }

            VStack(spacing: 12) {
                AtoTextField(
                    title: "비밀번호",
                    placeholder: "비밀번호를 입력해주세요",
                    text: $viewModel.password,
                    isSecure: true
                )
                
                HStack {
                    Text("영어와 숫자를 포함해 8자 이상 입력해주세요.")
                        .font(.ato(.regular, 16))
                        .foregroundStyle(viewModel.isPasswordFormatValid ? Color.green : Color.gray200)
                    
                    Spacer()
                }
            }

            AtoTextField(
                title: "비밀번호 확인",
                placeholder: "비밀번호를 한 번 더 입력해주세요",
                text: $viewModel.passwordConfirm,
                isSecure: true
            )

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.ato(.regular, 14))
                    .foregroundStyle(Color.red)
            }

            AtoButton(
                viewModel.isLoading ? "가입 중..." : "회원가입",
                isEnabled: viewModel.isSignupEnabled
            ) {
                viewModel.signup()
            }

            Spacer()
        }
        .padding(.horizontal, 32)
        .background(Color.gray50)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.didSignup) { _, didSignup in
            if didSignup {
                dismiss()
            }
        }
    }
}

#Preview {
    SignupView()
}
