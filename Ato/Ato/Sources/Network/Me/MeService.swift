//
//  MeService.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation
@preconcurrency import Moya

final class MeService {
    private let provider: MoyaProvider<MeAPI>
    private let decoder = JSONDecoder()

    init(provider: MoyaProvider<MeAPI> = MoyaProvider<MeAPI>(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }

    func fetchProfile() async throws -> MeUser {
        let response = try await request(.profile, as: MeResponse.self)
        return response.user
    }

    func updateProfileImage(_ request: UpdateProfileImageRequest) async throws -> MeUser {
        let response = try await self.request(.updateProfileImage(request: request), as: MeResponse.self)
        return response.user
    }

    func updateNotificationSettings(_ request: UpdateNotificationSettingsRequest) async throws -> MeUser {
        let response = try await self.request(.updateNotificationSettings(request: request), as: MeResponse.self)
        return response.user
    }

    func deleteAccount() async throws {
        try await requestVoid(.delete)
    }

    private func request<Response: Decodable>(
        _ target: MeAPI,
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

    private func requestVoid(_ target: MeAPI) async throws {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { [decoder] result in
                switch result {
                case .success(let response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        continuation.resume()
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
