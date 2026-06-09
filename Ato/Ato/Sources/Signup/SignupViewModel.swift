//
//  SignupViewModel.swift
//  Ato
//
//  Created by Codex on 6/9/26.
//

import Foundation
import Combine

@MainActor
final class SignupViewModel: ObservableObject {
    @Published var nickname = ""
    @Published var password = ""
    @Published var passwordConfirm = ""
    @Published var isLoading = false
    @Published var isCheckingNickname = false
    @Published var nicknameCheckMessage: String?
    @Published var errorMessage: String?
    @Published private(set) var isNicknameAvailable = false
    @Published private(set) var didSignup = false
    @Published private(set) var authResponse: AuthResponse?

    private let authService: AuthService

    var isPasswordFormatValid: Bool {
        let hasLetter = password.rangeOfCharacter(from: .letters) != nil
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasNoWhitespace = password.rangeOfCharacter(from: .whitespacesAndNewlines) == nil

        return (8...72).contains(password.count) && hasLetter && hasNumber && hasNoWhitespace
    }

    var isSignupEnabled: Bool {
        !nickname.isEmpty
        && isNicknameAvailable
        && isPasswordFormatValid
        && password == passwordConfirm
        && !isLoading
    }

    init(authService: AuthService? = nil) {
        self.authService = authService ?? AuthService()
    }

    func updateNickname(_ nickname: String) {
        self.nickname = nickname
        isNicknameAvailable = false
        nicknameCheckMessage = nil
    }

    func checkNickname() {
        guard !nickname.isEmpty else { return }

        isCheckingNickname = true
        errorMessage = nil

        Task {
            do {
                let response = try await authService.checkNickname(nickname)
                isNicknameAvailable = response.available
                nicknameCheckMessage = response.available ? "사용 가능한 별명이에요." : "이미 사용 중인 별명이에요."
            } catch {
                isNicknameAvailable = false
                errorMessage = error.localizedDescription
            }

            isCheckingNickname = false
        }
    }

    func signup() {
        guard isSignupEnabled else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                authResponse = try await authService.signup(nickname: nickname, password: password)
                didSignup = true
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }
}
