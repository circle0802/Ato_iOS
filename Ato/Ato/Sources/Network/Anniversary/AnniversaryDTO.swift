//
//  AnniversaryDTO.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import Foundation

struct AnniversariesResponse: Decodable {
    let anniversaries: [AnniversaryDTO]
}

struct AnniversaryDetailResponse: Decodable {
    let anniversary: AnniversaryDTO
}

struct NearestAnniversaryResponse: Decodable {
    let anniversary: AnniversaryDTO?
}

struct AnniversaryRequest: Sendable {
    let title: String
    let targetName: String
    let relation: String
    let date: String
    let memo: String?
    let `repeat`: Bool
    let notificationEnabled: Bool
    let notificationDays: [Int]
}

struct AnniversaryDTO: Decodable, Identifiable {
    let title: String
    let targetName: String
    let relation: String
    let date: String
    let memo: String?
    let `repeat`: Bool
    let notificationEnabled: Bool
    let notificationDays: [Int]
    let id: String
    let userId: String
    let nextDate: String
    let dDay: Int
    let createdAt: String
    let updatedAt: String
}
