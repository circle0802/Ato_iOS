//
//  HighlightAnniversaryCard.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct HighlightAnniversaryCard: View {
    let anniversary: Anniversary

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text("가장 가까운 기념일")
                    .font(.ato(.medium, 16))
                    .foregroundStyle(.gray50)

                Spacer()

                Text(anniversary.dDay)
                    .font(.ato(.bold, 16))
                    .foregroundStyle(Color.orange200)
                    .padding(.horizontal, 15)
                    .frame(height: 42)
                    .background(Color.orange100)
                    .clipShape(Capsule())
            }

            VStack(alignment: .leading, spacing: 16) {
                Text(anniversary.title)
                    .font(.ato(.bold, 24))
                    .foregroundStyle(.gray50)

                Text(anniversary.personName)
                    .font(.ato(.regular, 16))
                    .foregroundStyle(.gray50)
            }

            HStack(spacing: 8) {
                Spacer()

                Image(systemName: "calendar")
                    .font(.system(size: 16, weight: .semibold))

                Text(anniversary.dateText)
                    .font(.ato(.semiBold, 16))
            }
            .foregroundStyle(.white)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, minHeight: 298 / 2)
        .background(Color.orange400)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    HighlightAnniversaryCard(anniversary: Anniversary.sampleItems[0])
        .padding(25)
        .background(Color.gray50)
}
