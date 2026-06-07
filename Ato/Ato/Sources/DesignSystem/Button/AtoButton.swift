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
    let action: () -> Void

    init(
        _ title: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ato(.semiBold, 20))
                .foregroundStyle(.white)
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .background(isEnabled ? Color.orange400 : Color.gray200)
                .clipShape(RoundedRectangle(cornerRadius: 32))
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
