//
//  LoginViewModel.swift
//  Ato
//
//  Created by Codex on 6/9/26.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var nickname = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var authResponse: AuthResponse?

    private let authService: AuthService

    var isLoginEnabled: Bool {
        !nickname.isEmpty && !password.isEmpty && !isLoading
    }

    init(authService: AuthService? = nil) {
        self.authService = authService ?? AuthService()
    }

    func login() {
        guard isLoginEnabled else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await authService.login(nickname: nickname, password: password)
                AuthSession.save(response)
                authResponse = response
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }
}
