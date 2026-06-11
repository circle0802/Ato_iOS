//
//  AtoButton.swift
//  Ato
//
//  Created by hawon on 6/7/26.
//

import SwiftUI

struct AtoButton: View {
    let title: String
    let isEnabled: Bool
    let systemImageName: String?
    let height: CGFloat
    let fontSize: CGFloat
    let action: () -> Void

    init(
        _ title: String,
        isEnabled: Bool = true,
        systemImageName: String? = nil,
        height: CGFloat = 56,
        fontSize: CGFloat = 20,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.systemImageName = systemImageName
        self.height = height
        self.fontSize = fontSize
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImageName {
                    Image(systemName: systemImageName)
                        .font(.system(size: fontSize - 2, weight: .semibold))
                }

                Text(title)
                    .font(.ato(.semiBold, fontSize))
            }
            .foregroundStyle(.white)
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .background(isEnabled ? Color.orange400 : Color.gray200)
            .clipShape(RoundedRectangle(cornerRadius: height / 2))
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        AtoButton("로그인", isEnabled: true) {}
        AtoButton("로그인", isEnabled: false) {}
    }
    .padding(24)
}
