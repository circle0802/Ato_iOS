//
//  AnniversaryListSection.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct AnniversaryListSection: View {
    let anniversaries: [Anniversary]
    let isLoading: Bool
    let onSeeAll: () -> Void
    let onSelect: (Anniversary) -> Void

    init(
        anniversaries: [Anniversary],
        isLoading: Bool,
        onSeeAll: @escaping () -> Void = {},
        onSelect: @escaping (Anniversary) -> Void = { _ in }
    ) {
        self.anniversaries = anniversaries
        self.isLoading = isLoading
        self.onSeeAll = onSeeAll
        self.onSelect = onSelect
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                Text("기념일 리스트")
                    .font(.ato(.bold, 20))
                    .foregroundStyle(Color.gray400)

                Spacer()

                Button(action: onSeeAll) {
                    Text("전체보기")
                        .font(.ato(.semiBold, 16))
                        .foregroundStyle(Color.orange400)
                }
                .buttonStyle(.plain)
            }

            VStack(spacing: 14) {
                if anniversaries.isEmpty {
                    AnniversaryEmptyListView(isLoading: isLoading)
                } else {
                    ForEach(anniversaries) { anniversary in
                        AnniversaryRowCard(anniversary: anniversary) {
                            onSelect(anniversary)
                        }
                    }
                }
            }
        }
    }
}

private struct AnniversaryEmptyListView: View {
    let isLoading: Bool

    var body: some View {
        HStack {
            Spacer()

            Text(isLoading ? "기념일을 불러오는 중이에요." : "등록된 기념일이 없어요.")
                .font(.ato(.regular, 16))
                .foregroundStyle(Color.gray200)

            Spacer()
        }
        .frame(height: 84)
        .background(Color.gray50)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.gray100.opacity(0.58), lineWidth: 1)
        }
    }
}

#Preview {
    AnniversaryListSection(anniversaries: Anniversary.sampleItems, isLoading: false)
        .padding(25)
        .background(Color.gray50)
}
