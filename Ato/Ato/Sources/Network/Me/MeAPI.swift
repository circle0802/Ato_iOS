//
//  MeAPI.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation
@preconcurrency import Alamofire
@preconcurrency import Moya

enum MeAPI {
    case profile
    case updateProfileImage(request: UpdateProfileImageRequest)
    case updateNotificationSettings(request: UpdateNotificationSettingsRequest)
    case delete
}

extension MeAPI: TargetType {
    nonisolated var baseURL: URL {
        APIConstants.baseURL
    }

    nonisolated var path: String {
        switch self {
        case .profile, .delete:
            return "/api/me"
        case .updateProfileImage:
            return "/api/me/profile-image"
        case .updateNotificationSettings:
            return "/api/me/notification-settings"
        }
    }

    nonisolated var method: Moya.Method {
        switch self {
        case .profile:
            return .get
        case .updateProfileImage, .updateNotificationSettings:
            return .patch
        case .delete:
            return .delete
        }
    }

    nonisolated var task: Task {
        switch self {
        case .profile, .delete:
            return .requestPlain
        case .updateProfileImage(let request):
            var parameters: [String: Any] = [:]
            parameters["profileImageUrl"] = request.profileImageUrl ?? NSNull()

            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .updateNotificationSettings(let request):
            return .requestParameters(
                parameters: ["notificationEnabled": request.notificationEnabled],
                encoding: JSONEncoding.default
            )
        }
    }

    nonisolated var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]

        if let token = AuthSession.token {
            headers["Authorization"] = "Bearer \(token)"
        }

        return headers
    }
}
