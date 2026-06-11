//
//  MessageDTO.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation

struct MessageGenerationRequest: Sendable {
    let relation: String
    let situation: String
    let tone: String
    let targetName: String
    let extraContext: String?
}

struct MessageGenerationResponse: Decodable {
    let message: GeneratedMessageDTO
}

struct GeneratedMessageDTO: Decodable, Identifiable, Hashable {
    let id: String
    let userId: String
    let content: String
    let relation: String
    let situation: String
    let tone: String
    let favorite: Bool
    let createdAt: String
}
