//
//  AnniversaryFormViewModel.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import Foundation
import Combine

@MainActor
final class AnniversaryFormViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var anniversaryName = ""
    @Published var targetName = ""
    @Published var isRepeating = true
    @Published var isNotificationEnabled = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var didSubmit = false

    private let mode: AnniversaryFormMode
    private let anniversaryService: AnniversaryService

    var isSubmitEnabled: Bool {
        !anniversaryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !targetName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !isLoading
    }

    init(
        mode: AnniversaryFormMode,
        anniversaryService: AnniversaryService? = nil
    ) {
        self.mode = mode
        self.anniversaryService = anniversaryService ?? AnniversaryService()

        if case .edit(let anniversary) = mode {
            anniversaryName = anniversary.title
            targetName = anniversary.personName
            selectedDate = Self.date(from: anniversary.dateText) ?? Date()
        }
    }

    func submit() {
        guard isSubmitEnabled else { return }

        switch mode {
        case .create:
            createAnniversary()
        case .edit(let anniversary):
            updateAnniversary(id: anniversary.id)
        }
    }

    private func createAnniversary() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                _ = try await anniversaryService.createAnniversary(makeRequest())
                didSubmit = true
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }

    private func updateAnniversary(id: String) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                _ = try await anniversaryService.updateAnniversary(id: id, request: makeRequest())
                didSubmit = true
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }

    private func makeRequest() -> AnniversaryRequest {
        AnniversaryRequest(
            title: anniversaryName.trimmingCharacters(in: .whitespacesAndNewlines),
            targetName: targetName.trimmingCharacters(in: .whitespacesAndNewlines),
            relation: "친구",
            date: Self.dateFormatter.string(from: selectedDate),
            memo: nil,
            repeat: isRepeating,
            notificationEnabled: isNotificationEnabled,
            notificationDays: isNotificationEnabled ? [3, 0] : []
        )
    }

    private static func date(from string: String) -> Date? {
        dateFormatter.date(from: string)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
