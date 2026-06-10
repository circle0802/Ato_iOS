//
//  QuickActionGridView.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct QuickActionGridView: View {
    let actions: [HomeQuickAction]
    let onSelect: (HomeQuickAction) -> Void

    init(
        actions: [HomeQuickAction],
        onSelect: @escaping (HomeQuickAction) -> Void = { _ in }
    ) {
        self.actions = actions
        self.onSelect = onSelect
    }

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 14),
        count: 3
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(actions) { action in
                QuickActionButton(action: action) {
                    onSelect(action)
                }
            }
        }
    }
}

private struct QuickActionButton: View {
    let action: HomeQuickAction
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 17) {
                Image(systemName: action.systemImageName)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.orange300)
                    .clipShape(Circle())

                Text(action.title)
                    .font(.ato(.semiBold, 17))
                    .foregroundStyle(Color.gray300)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 104)
            .padding(.vertical, 18)
            .background(Color.orange100.opacity(0.48))
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    QuickActionGridView(actions: HomeQuickAction.homeActions)
        .padding(25)
        .background(Color.gray50)
}
