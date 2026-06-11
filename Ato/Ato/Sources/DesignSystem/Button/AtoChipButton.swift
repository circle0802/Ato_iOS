//
//  AtoChipButton.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct AtoChipButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    init(
        _ title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ato(.semiBold, 14))
                .foregroundStyle(isSelected ? Color.gray50 : Color.gray300)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
                .frame(height: 32)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.orange400 : Color.gray100.opacity(0.34))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        AtoChipButton("감성적인", isSelected: true) {}
        AtoChipButton("실용적인", isSelected: false) {}
    }
    .padding(24)
    .background(Color.gray50)
}
