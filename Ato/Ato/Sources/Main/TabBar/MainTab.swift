//
//  MainTab.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import Foundation

enum MainTab: CaseIterable {
    case calendar
    case home
    case my

    var title: String {
        switch self {
        case .calendar:
            "캘린더"
        case .home:
            "홈"
        case .my:
            "마이"
        }
    }

    var systemImageName: String {
        switch self {
        case .calendar:
            "calendar"
        case .home:
            "house"
        case .my:
            "person"
        }
    }
}
