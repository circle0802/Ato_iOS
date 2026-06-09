//
//  APIError.swift
//  Ato
//
//  Created by Codex on 6/9/26.
//

import Foundation
@preconcurrency import Moya

struct APIErrorResponse: Decodable {
    let error: String
}

enum APIError: LocalizedError {
    case invalidResponse
    case serverMessage(String)
    case moya(MoyaError)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "응답을 처리할 수 없습니다."
        case .serverMessage(let message):
            return message
        case .moya(let error):
            return error.localizedDescription
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
