//
//  AtoBackButton.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct AtoBackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(Color.gray400)
                .frame(width: 44, height: 44, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AtoBackButton {}
        .padding(24)
        .background(Color.gray50)
}
