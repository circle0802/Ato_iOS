//
//  AnniversaryService.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import Foundation
@preconcurrency import Moya

final class AnniversaryService {
    private let provider: MoyaProvider<AnniversaryAPI>
    private let decoder = JSONDecoder()

    init(provider: MoyaProvider<AnniversaryAPI> = MoyaProvider<AnniversaryAPI>(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }

    func fetchNearest() async throws -> AnniversaryDTO? {
        let response = try await request(.nearest, as: NearestAnniversaryResponse.self)
        return response.anniversary
    }

    func fetchUpcoming(limit: Int = 5) async throws -> [AnniversaryDTO] {
        let response = try await request(.upcoming(limit: limit), as: AnniversariesResponse.self)
        return response.anniversaries
    }

    func fetchCalendar(year: Int, month: Int) async throws -> AnniversaryCalendarResponse {
        try await request(.calendar(year: year, month: month), as: AnniversaryCalendarResponse.self)
    }

    func fetchAnniversaries(sort: AnniversarySort = .dday) async throws -> [AnniversaryDTO] {
        let response = try await request(.list(sort: sort), as: AnniversariesResponse.self)
        return response.anniversaries
    }

    func fetchAnniversary(id: String) async throws -> AnniversaryDTO {
        let response = try await request(.detail(id: id), as: AnniversaryDetailResponse.self)
        return response.anniversary
    }

    func createAnniversary(_ request: AnniversaryRequest) async throws -> AnniversaryDTO {
        let response = try await self.request(.create(request: request), as: AnniversaryDetailResponse.self)
        return response.anniversary
    }

    func updateAnniversary(id: String, request: AnniversaryRequest) async throws -> AnniversaryDTO {
        let response = try await self.request(.update(id: id, request: request), as: AnniversaryDetailResponse.self)
        return response.anniversary
    }

    private func request<Response: Decodable>(
        _ target: AnniversaryAPI,
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
