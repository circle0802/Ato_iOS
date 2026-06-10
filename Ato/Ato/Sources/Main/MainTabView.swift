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
            PlaceholderTabView(title: "캘린더")
        case .home:
            HomeView()
        case .my:
            PlaceholderTabView(title: "마이")
        }
    }
}

private struct PlaceholderTabView: View {
    let title: String

    var body: some View {
        VStack {
            Spacer()

            Text(title)
                .font(.ato(.bold, 24))
                .foregroundStyle(Color.gray400)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray50)
        .padding(.bottom, 88)
    }
}

#Preview {
    MainTabView()
}
