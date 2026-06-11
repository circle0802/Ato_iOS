//
//  GiftRecommendationViewModel.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation
import Combine

@MainActor
final class GiftRecommendationViewModel: ObservableObject {
    @Published var age = ""
    @Published var budget = ""
    @Published var selectedGender = "무관"
    @Published var relation = ""
    @Published var occasion = ""
    @Published var hobby = ""
    @Published var interest = ""
    @Published var selectedMood: String?
    @Published var selectedCategories: Set<String> = []
    @Published var note = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var recommendation: GiftRecommendationDTO?

    private let giftService: GiftService

    var isSubmitEnabled: Bool {
        makeRequest() != nil && !isLoading
    }

    init(giftService: GiftService? = nil) {
        self.giftService = giftService ?? GiftService()
    }

    func submit() {
        guard let request = makeRequest(), !isLoading else {
            errorMessage = "필수 정보를 입력해주세요."
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                recommendation = try await giftService.createRecommendation(request)
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }

    private func makeRequest() -> GiftRecommendationRequest? {
        guard
            let ageValue = Int(age),
            let budgetValue = Int(budget),
            ageValue > 0,
            budgetValue > 0,
            let mood = selectedMood,
            !trimmed(relation).isEmpty,
            !trimmed(occasion).isEmpty,
            !selectedCategories.isEmpty
        else {
            return nil
        }

        return GiftRecommendationRequest(
            age: ageValue,
            gender: selectedGender,
            relation: trimmed(relation),
            occasion: trimmed(occasion),
            hobbies: splitList(hobby),
            interests: splitList(interest),
            budgetMin: 0,
            budgetMax: budgetValue,
            mood: mood,
            categories: selectedCategories.sorted(),
            extraContext: trimmed(note).isEmpty ? nil : trimmed(note)
        )
    }

    private func splitList(_ value: String) -> [String] {
        value
            .split { character in
                character == "," || character == "，" || character == " "
            }
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
