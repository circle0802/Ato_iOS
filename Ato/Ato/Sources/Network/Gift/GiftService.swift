//
//  GiftService.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation
@preconcurrency import Moya

final class GiftService {
    private let provider: MoyaProvider<GiftAPI>
    private let decoder = JSONDecoder()

    init(provider: MoyaProvider<GiftAPI> = MoyaProvider<GiftAPI>(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }

    func createRecommendation(_ request: GiftRecommendationRequest) async throws -> GiftRecommendationDTO {
        let response = try await self.request(
            .createRecommendation(request: request),
            as: GiftRecommendationResponse.self
        )
        return response.recommendation
    }

    private func request<Response: Decodable>(
        _ target: GiftAPI,
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
