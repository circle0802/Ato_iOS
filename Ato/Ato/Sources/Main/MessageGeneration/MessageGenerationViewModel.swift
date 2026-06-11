//
//  MessageGenerationViewModel.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation
import Combine

@MainActor
final class MessageGenerationViewModel: ObservableObject {
    @Published var relation = ""
    @Published var situation = ""
    @Published var selectedTone: String?
    @Published var targetName = ""
    @Published var extraContext = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var message: GeneratedMessageDTO?

    private let messageService: MessageService

    var isSubmitEnabled: Bool {
        makeRequest() != nil && !isLoading
    }

    init(messageService: MessageService? = nil) {
        self.messageService = messageService ?? MessageService()
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
                message = try await messageService.generate(request)
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }

    private func makeRequest() -> MessageGenerationRequest? {
        guard
            !trimmed(relation).isEmpty,
            !trimmed(situation).isEmpty,
            let tone = selectedTone,
            !trimmed(targetName).isEmpty
        else {
            return nil
        }

        return MessageGenerationRequest(
            relation: trimmed(relation),
            situation: trimmed(situation),
            tone: tone,
            targetName: trimmed(targetName),
            extraContext: trimmed(extraContext).isEmpty ? nil : trimmed(extraContext)
        )
    }

    private func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
