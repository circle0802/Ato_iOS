//
//  AnniversaryAPI.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import Foundation
@preconcurrency import Alamofire
@preconcurrency import Moya

enum AnniversarySort: String {
    case date
    case dday
}

enum AnniversaryAPI {
    case nearest
    case upcoming(limit: Int)
    case list(sort: AnniversarySort)
    case detail(id: String)
    case create(request: AnniversaryRequest)
    case update(id: String, request: AnniversaryRequest)
}

extension AnniversaryAPI: TargetType {
    nonisolated var baseURL: URL {
        APIConstants.baseURL
    }

    nonisolated var path: String {
        switch self {
        case .nearest:
            return "/api/anniversaries/nearest"
        case .upcoming:
            return "/api/anniversaries/upcoming"
        case .list, .create:
            return "/api/anniversaries"
        case .detail(let id), .update(let id, _):
            return "/api/anniversaries/\(id)"
        }
    }

    nonisolated var method: Moya.Method {
        switch self {
        case .nearest, .upcoming, .list, .detail:
            return .get
        case .create:
            return .post
        case .update:
            return .patch
        }
    }

    nonisolated var task: Task {
        switch self {
        case .nearest:
            return .requestPlain
        case .upcoming(let limit):
            return .requestParameters(
                parameters: ["limit": limit],
                encoding: URLEncoding.queryString
            )
        case .list(let sort):
            return .requestParameters(
                parameters: ["sort": sort.rawValue],
                encoding: URLEncoding.queryString
            )
        case .detail:
            return .requestPlain
        case .create(let request), .update(_, let request):
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

    private nonisolated static func parameters(from request: AnniversaryRequest) -> [String: Any] {
        var parameters: [String: Any] = [
            "title": request.title,
            "targetName": request.targetName,
            "relation": request.relation,
            "date": request.date,
            "repeat": request.repeat,
            "notificationEnabled": request.notificationEnabled,
            "notificationDays": request.notificationDays
        ]

        if let memo = request.memo {
            parameters["memo"] = memo
        }

        return parameters
    }
}
