//
//  MainTabView.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            content

            AtoTabBar(selectedTab: $selectedTab)
        }
        .background(Color.gray50)
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private var content: some View {
        switch selectedTab {
        case .calendar:
            CalendarView()
        case .home:
            HomeView()
        case .my:
            MyPageView()
        }
    }
}

#Preview {
    MainTabView()
}
