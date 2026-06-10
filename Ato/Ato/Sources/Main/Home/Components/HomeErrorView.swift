//
//  HomeErrorView.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct HomeErrorView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(message)
                .font(.ato(.regular, 15))
                .foregroundStyle(Color.red)
                .lineLimit(2)

            Spacer()

            Button(action: retryAction) {
                Text("재시도")
                    .font(.ato(.semiBold, 14))
                    .foregroundStyle(Color.orange400)
                    .padding(.horizontal, 14)
                    .frame(height: 32)
                    .background(Color.orange100.opacity(0.62))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Color.gray50)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray100.opacity(0.58), lineWidth: 1)
        }
    }
}

#Preview {
    HomeErrorView(message: "응답을 처리할 수 없습니다.") {}
        .padding(25)
        .background(Color.gray50)
}
