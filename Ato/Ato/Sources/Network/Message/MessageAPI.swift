//
//  MessageAPI.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation
@preconcurrency import Alamofire
@preconcurrency import Moya

enum MessageAPI {
    case generate(request: MessageGenerationRequest)
}

extension MessageAPI: TargetType {
    nonisolated var baseURL: URL {
        APIConstants.baseURL
    }

    nonisolated var path: String {
        switch self {
        case .generate:
            return "/api/messages/generate"
        }
    }

    nonisolated var method: Moya.Method {
        switch self {
        case .generate:
            return .post
        }
    }

    nonisolated var task: Task {
        switch self {
        case .generate(let request):
            return .requestParameters(
                parameters: Self.parameters(from: request),
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

    private nonisolated static func parameters(from request: MessageGenerationRequest) -> [String: Any] {
        var parameters: [String: Any] = [
            "relation": request.relation,
            "situation": request.situation,
            "tone": request.tone,
            "targetName": request.targetName
        ]

        if let extraContext = request.extraContext {
            parameters["extraContext"] = extraContext
        }

        return parameters
    }
}
