//
//  AtoTabBar.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct AtoTabBar: View {
    @Binding var selectedTab: MainTab

    var body: some View {
        HStack {
            ForEach(MainTab.allCases, id: \.self) { tab in
                AtoTabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
            }
        }
        .padding(.horizontal, 34)
        .padding(.top, 11)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity)
        .background(Color.gray50)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.gray100.opacity(0.72))
                .frame(height: 1)
        }
    }
}

private struct AtoTabBarItem: View {
    let tab: MainTab
    let isSelected: Bool
    let action: () -> Void

    private var tintColor: Color {
        isSelected ? Color.orange400 : Color.gray200
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: tab.systemImageName)
                    .font(.system(size: 24, weight: .semibold))
                    .frame(height: 30)

                Text(tab.title)
                    .font(.ato(.semiBold, 14))
                    .lineLimit(1)
            }
            .foregroundStyle(tintColor)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AtoTabBar(selectedTab: .constant(.home))
}
