//
//  AuthAPI.swift
//  Ato
//
//  Created by Codex on 6/9/26.
//

import Foundation
@preconcurrency import Alamofire
@preconcurrency import Moya

enum AuthAPI {
    case nicknameCheck(nickname: String)
    case signup(request: AuthRequest)
    case login(request: AuthRequest)
}

extension AuthAPI: TargetType {
    nonisolated var baseURL: URL {
        APIConstants.baseURL
    }

    nonisolated var path: String {
        switch self {
        case .nicknameCheck:
            return "/api/auth/nickname-check"
        case .signup:
            return "/api/auth/signup"
        case .login:
            return "/api/auth/login"
        }
    }

    nonisolated var method: Moya.Method {
        switch self {
        case .nicknameCheck:
            return .get
        case .signup, .login:
            return .post
        }
    }

    nonisolated var task: Task {
        switch self {
        case .nicknameCheck(let nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.queryString
            )
        case .signup(let request), .login(let request):
            return .requestParameters(
                parameters: [
                    "nickname": request.nickname,
                    "password": request.password
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    nonisolated var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
