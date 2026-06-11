//
//  GiftAPI.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation
@preconcurrency import Alamofire
@preconcurrency import Moya

enum GiftAPI {
    case createRecommendation(request: GiftRecommendationRequest)
}

extension GiftAPI: TargetType {
    nonisolated var baseURL: URL {
        APIConstants.baseURL
    }

    nonisolated var path: String {
        switch self {
        case .createRecommendation:
            return "/api/gifts/recommendations"
        }
    }

    nonisolated var method: Moya.Method {
        switch self {
        case .createRecommendation:
            return .post
        }
    }

    nonisolated var task: Task {
        switch self {
        case .createRecommendation(let request):
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

    private nonisolated static func parameters(from request: GiftRecommendationRequest) -> [String: Any] {
        var parameters: [String: Any] = [
            "age": request.age,
            "gender": request.gender,
            "relation": request.relation,
            "occasion": request.occasion,
            "hobbies": request.hobbies,
            "interests": request.interests,
            "budgetMin": request.budgetMin,
            "budgetMax": request.budgetMax,
            "mood": request.mood,
            "categories": request.categories
        ]

        if let extraContext = request.extraContext {
            parameters["extraContext"] = extraContext
        }

        return parameters
    }
}
