//
//  HomeModels.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import Foundation

struct Anniversary: Identifiable, Equatable, Hashable {
    let id: String
    let dDay: String
    let title: String
    let personName: String
    let dateText: String

    init(
        id: String,
        dDay: String,
        title: String,
        personName: String,
        dateText: String
    ) {
        self.id = id
        self.dDay = dDay
        self.title = title
        self.personName = personName
        self.dateText = dateText
    }

    init(dto: AnniversaryDTO) {
        self.id = dto.id
        self.dDay = Self.dDayText(from: dto.dDay)
        self.title = dto.title
        self.personName = dto.targetName
        self.dateText = dto.nextDate
    }

    private static func dDayText(from dDay: Int) -> String {
        if dDay == 0 {
            return "D-Day"
        }

        if dDay < 0 {
            return "D+\(abs(dDay))"
        }

        return "D-\(dDay)"
    }
}

struct HomeQuickAction: Identifiable, Equatable {
    let id = UUID()
    let kind: HomeQuickActionKind
    let title: String
    let systemImageName: String
}

enum HomeQuickActionKind: Equatable {
    case anniversaryForm
    case giftRecommendation
    case messageRecommendation
}

extension Anniversary {
    static let sampleItems: [Anniversary] = [
        Anniversary(id: "preview-1", dDay: "D-27", title: "700일 기념일", personName: "도휘", dateText: "2026-05-28"),
        Anniversary(id: "preview-2", dDay: "D-100", title: "700일 기념일", personName: "도휘", dateText: "2026-05-28"),
        Anniversary(id: "preview-3", dDay: "D-100", title: "700일 기념일", personName: "도휘", dateText: "2026-05-28")
    ]
}

extension HomeQuickAction {
    static let homeActions: [HomeQuickAction] = [
        HomeQuickAction(kind: .anniversaryForm, title: "기념일 등록", systemImageName: "calendar.badge.plus"),
        HomeQuickAction(kind: .giftRecommendation, title: "선물 추천", systemImageName: "gift"),
        HomeQuickAction(kind: .messageRecommendation, title: "메시지 추천", systemImageName: "text.bubble")
    ]
}
