//
//  HomeViewModel.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var nickname = AuthSession.nickname
    @Published private(set) var closestAnniversary: Anniversary?
    @Published private(set) var anniversaries: [Anniversary] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let anniversaryService: AnniversaryService

    init(anniversaryService: AnniversaryService? = nil) {
        self.anniversaryService = anniversaryService ?? AnniversaryService()
    }

    func load() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        nickname = AuthSession.nickname

        Task {
            do {
                async let nearest = anniversaryService.fetchNearest()
                async let upcoming = anniversaryService.fetchUpcoming(limit: 5)

                let nearestDTO = try await nearest
                let upcomingDTOs = try await upcoming

                closestAnniversary = Anniversary(dto: nearestDTO)
                anniversaries = upcomingDTOs.map(Anniversary.init(dto:))
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }
}
