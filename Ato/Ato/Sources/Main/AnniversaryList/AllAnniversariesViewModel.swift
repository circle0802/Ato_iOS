//
//  AllAnniversariesViewModel.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import Foundation
import Combine

@MainActor
final class AllAnniversariesViewModel: ObservableObject {
    @Published private(set) var anniversaries: [Anniversary] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedSort: AnniversarySort = .dday {
        didSet {
            if oldValue != selectedSort {
                load()
            }
        }
    }

    private let anniversaryService: AnniversaryService

    init(anniversaryService: AnniversaryService? = nil) {
        self.anniversaryService = anniversaryService ?? AnniversaryService()
    }

    func load() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await anniversaryService.fetchAnniversaries(sort: selectedSort)
                anniversaries = response.map(Anniversary.init(dto:))
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }
}
