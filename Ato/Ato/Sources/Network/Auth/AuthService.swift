//
//  AuthService.swift
//  Ato
//
//  Created by Codex on 6/9/26.
//

import Foundation
@preconcurrency import Moya

final class AuthService {
    private let provider: MoyaProvider<AuthAPI>
    private let decoder = JSONDecoder()

    init(provider: MoyaProvider<AuthAPI> = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }

    func checkNickname(_ nickname: String) async throws -> NicknameCheckResponse {
        try await request(.nicknameCheck(nickname: nickname), as: NicknameCheckResponse.self)
    }

    func signup(nickname: String, password: String) async throws -> AuthResponse {
        let request = AuthRequest(nickname: nickname, password: password)
        return try await self.request(.signup(request: request), as: AuthResponse.self)
    }

    func login(nickname: String, password: String) async throws -> AuthResponse {
        let request = AuthRequest(nickname: nickname, password: password)
        return try await self.request(.login(request: request), as: AuthResponse.self)
    }

    private func request<Response: Decodable>(
        _ target: AuthAPI,
        as responseType: Response.Type
    ) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { [decoder] result in
                switch result {
                case .success(let response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try decoder.decode(responseType, from: filteredResponse.data)
                        continuation.resume(returning: decodedResponse)
                    } catch let moyaError as MoyaError {
                        continuation.resume(throwing: self.parseError(from: moyaError, decoder: decoder))
                    } catch {
                        continuation.resume(throwing: APIError.unknown(error))
                    }
                case .failure(let error):
                    continuation.resume(throwing: APIError.moya(error))
                }
            }
        }
    }

    private func parseError(from error: MoyaError, decoder: JSONDecoder) -> APIError {
        guard case .statusCode(let response) = error else {
            return .moya(error)
        }

        if let errorResponse = try? decoder.decode(APIErrorResponse.self, from: response.data) {
            return .serverMessage(errorResponse.error)
        }

        return .invalidResponse
    }
}
