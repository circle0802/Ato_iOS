//
//  LoginView.swift
//  Ato
//
//  Created by hawon on 6/7/26.
//
import SwiftUI

struct LoginView: View {
    @State private var nickname = ""
    @State private var password = ""

    private var isLoginEnabled: Bool {
        !nickname.isEmpty && !password.isEmpty
    }

    var body: some View {
        VStack(spacing: 36) {
            Spacer()

            VStack(spacing: 4) {
                Text("아토")
                    .font(.ato(.semiBold, 32))
                    .foregroundStyle(Color.orange400)

                Text("AI 선물 추천 서비스")
                    .font(.ato(.regular, 20))
                    .foregroundStyle(Color.gray100)
            }

            AtoTextField(
                title: "별명",
                placeholder: "별명을 입력해주세요",
                text: $nickname
            )

            AtoTextField(
                title: "비밀번호",
                placeholder: "비밀번호를 입력해주세요",
                text: $password,
                isSecure: true
            )

            AtoButton("로그인", isEnabled: isLoginEnabled) {}

            NavigationLink {
                SignupView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                Text("회원가입")
                    .font(.ato(.regular, 16))
                    .foregroundStyle(Color.orange300)
                    .underline()
            }

            Spacer()
        }
        .padding(.horizontal, 32)
        .background(Color.gray50)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView()
}
