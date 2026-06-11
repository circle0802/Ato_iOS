//
//  AnniversaryRowCard.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct AnniversaryRowCard: View {
    let anniversary: Anniversary
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 20) {
                Text(anniversary.dDay)
                    .font(.ato(.bold, 19))
                    .foregroundStyle(Color.orange400)
                    .frame(width: 70, height: 64)
                    .background(Color.orange100.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                VStack(alignment: .leading, spacing: 8) {
                    Text(anniversary.title)
                        .font(.ato(.semiBold, 19))
                        .foregroundStyle(Color.gray400)

                    Text("\(anniversary.personName) \(anniversary.dateText)")
                        .font(.ato(.regular, 15))
                        .foregroundStyle(Color.gray200)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 23, weight: .regular))
                    .foregroundStyle(Color.gray200)
            }
            .padding(.leading, 18)
            .padding(.trailing, 22)
            .frame(height: 84)
            .background(Color.gray50)
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.gray100.opacity(0.58), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AnniversaryRowCard(anniversary: Anniversary.sampleItems[0]) {}
        .padding(25)
        .background(Color.gray50)
}
