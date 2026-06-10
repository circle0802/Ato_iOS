//
//  EmptyAnniversaryCard.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct EmptyAnniversaryCard: View {
    let isLoading: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("가장 가까운 기념일")
                .font(.ato(.medium, 16))
                .foregroundStyle(.white)

            Text(isLoading ? "기념일을 불러오는 중이에요" : "다가오는 기념일이 없어요")
                .font(.ato(.bold, 24))
                .foregroundStyle(.white)

            Text(isLoading ? "잠시만 기다려주세요" : "소중한 날을 등록해보세요")
                .font(.ato(.regular, 16))
                .foregroundStyle(.white.opacity(0.92))
        }
        .padding(.top, 24)
        .padding(.horizontal, 24)
        .padding(.bottom, 27)
        .frame(maxWidth: .infinity, minHeight: 298 / 2, alignment: .leading)
        .background(Color.orange400)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    EmptyAnniversaryCard(isLoading: false)
        .padding(25)
        .background(Color.gray50)
}
