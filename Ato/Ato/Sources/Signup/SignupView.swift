//
//  SignupView.swift
//  Ato
//
//  Created by hawon on 6/7/26.
//
import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var nickname = ""
    @State private var password = ""
    @State private var passwordConfirm = ""

    private var isSignupEnabled: Bool {
        !nickname.isEmpty && !password.isEmpty && password == passwordConfirm
    }

    var body: some View {
        VStack(spacing: 36) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(Color.gray400)
                        .frame(width: 44, height: 44, alignment: .leading)
                }

                Spacer()
            }

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
                    text: $nickname
                )
                
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Text("중복확인")
                            .font(.ato(.medium, 14))
                            .foregroundStyle(Color.orange400)
                            .frame(width: 82, height: 32)
                            .background(Color.orange100)
                            .clipShape(Capsule())
                    }
                }
            }

            VStack(spacing: 12) {
                AtoTextField(
                    title: "비밀번호",
                    placeholder: "비밀번호를 입력해주세요",
                    text: $password,
                    isSecure: true
                )
                
                HStack {
                    Text("비밀번호 형식은~")
                        .font(.ato(.regular, 16))
                        .foregroundStyle(Color.green)
                    
                    Spacer()
                }
            }

            AtoTextField(
                title: "비밀번호 확인",
                placeholder: "비밀번호를 한 번 더 입력해주세요",
                text: $passwordConfirm,
                isSecure: true
            )

            AtoButton("회원가입", isEnabled: isSignupEnabled) {}

            Spacer()
        }
        .padding(.horizontal, 32)
        .background(Color.gray50)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignupView()
}
