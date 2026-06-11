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

    var isNicknameFormatValid: Bool {
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedNickname.count >= 2 && Self.nicknamePattern.matches(trimmedNickname)
    }

    var isNicknameCheckEnabled: Bool {
        isNicknameFormatValid && !isCheckingNickname
    }

    var isPasswordFormatValid: Bool {
        let hasLetter = password.rangeOfCharacter(from: .letters) != nil
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasNoWhitespace = password.rangeOfCharacter(from: .whitespacesAndNewlines) == nil

        return (8...72).contains(password.count) && hasLetter && hasNumber && hasNoWhitespace
    }

    var isSignupEnabled: Bool {
        isNicknameFormatValid
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
        nicknameCheckMessage = validationMessage(for: nickname)
    }

    func checkNickname() {
        guard isNicknameFormatValid else {
            nicknameCheckMessage = validationMessage(for: nickname)
            isNicknameAvailable = false
            return
        }

        isCheckingNickname = true
        errorMessage = nil

        Task {
            do {
                let response = try await authService.checkNickname(nickname.trimmingCharacters(in: .whitespacesAndNewlines))
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
                let response = try await authService.signup(nickname: nickname, password: password)
                AuthSession.save(response)
                authResponse = response
                didSignup = true
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }

    private func validationMessage(for nickname: String) -> String? {
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedNickname.isEmpty {
            return nil
        }

        if trimmedNickname.count < 2 {
            return "별명은 2글자 이상 입력해주세요."
        }

        if !Self.nicknamePattern.matches(trimmedNickname) {
            return "별명은 한글, 영어, 숫자, _만 사용할 수 있어요."
        }

        return nil
    }

    private nonisolated static let nicknamePattern = try! NSRegularExpression(
        pattern: "^[가-힣a-zA-Z0-9_]+$"
    )
}

private extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(string.startIndex..<string.endIndex, in: string)
        return firstMatch(in: string, range: range) != nil
    }
}
