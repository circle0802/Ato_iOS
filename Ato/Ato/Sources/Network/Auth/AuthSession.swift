//
//  AuthSession.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import Foundation

enum AuthSession {
    nonisolated static var token: String? {
        UserDefaults.standard.string(forKey: "auth.token")
    }

    nonisolated static var nickname: String {
        UserDefaults.standard.string(forKey: "auth.nickname") ?? "하원"
    }

    nonisolated static func save(_ response: AuthResponse) {
        UserDefaults.standard.set(response.token, forKey: "auth.token")
        UserDefaults.standard.set(response.user.nickname, forKey: "auth.nickname")
    }

    nonisolated static func clear() {
        UserDefaults.standard.removeObject(forKey: "auth.token")
        UserDefaults.standard.removeObject(forKey: "auth.nickname")
    }
}
