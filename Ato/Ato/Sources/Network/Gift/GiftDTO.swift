//
//  GiftDTO.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation

struct GiftRecommendationRequest: Sendable {
    let age: Int
    let gender: String
    let relation: String
    let occasion: String
    let hobbies: [String]
    let interests: [String]
    let budgetMin: Int
    let budgetMax: Int
    let mood: String
    let categories: [String]
    let extraContext: String?
}

struct GiftRecommendationResponse: Decodable {
    let recommendation: GiftRecommendationDTO
}

struct GiftRecommendationDTO: Decodable, Identifiable, Hashable {
    let id: String
    let userId: String
    let input: GiftRecommendationInputDTO
    let items: [GiftRecommendationItemDTO]
    let createdAt: String
}

struct GiftRecommendationInputDTO: Decodable, Hashable {
    let age: Int
    let gender: String
    let relation: String
    let occasion: String
    let hobbies: [String]
    let interests: [String]
    let budgetMin: Int
    let budgetMax: Int
    let mood: String
    let categories: [String]
    let extraContext: String?
}

struct GiftRecommendationItemDTO: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let category: String
    let imageUrl: String
    let reason: String
    let price: Int
    let ranking: Int
    let detail: String
    let purchaseUrl: String?
    let saved: Bool
}
