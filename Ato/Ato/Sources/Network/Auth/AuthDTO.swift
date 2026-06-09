//
//  AuthDTO.swift
//  Ato
//
//  Created by Codex on 6/9/26.
//

import Foundation

struct AuthRequest: Sendable {
    let nickname: String
    let password: String
}

struct NicknameCheckResponse: Decodable {
    let nickname: String
    let available: Bool
}

struct AuthResponse: Decodable {
    let token: String
    let user: AuthUser
}

struct AuthUser: Decodable {
    let id: String
    let nickname: String
}
