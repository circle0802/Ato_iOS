//
//  MeDTO.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation

struct MeResponse: Decodable {
    let user: MeUser
}

struct MeUser: Decodable, Equatable {
    let id: String
    let nickname: String
    let profileImageUrl: String?
    let notificationEnabled: Bool
    let createdAt: String
}

struct UpdateProfileImageRequest: Sendable {
    let profileImageUrl: String?
}

struct UpdateNotificationSettingsRequest: Sendable {
    let notificationEnabled: Bool
}
