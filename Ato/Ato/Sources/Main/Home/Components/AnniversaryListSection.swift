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
    let onSelect: (Anniversary) -> Void

    init(
        anniversaries: [Anniversary],
        isLoading: Bool,
        onSelect: @escaping (Anniversary) -> Void = { _ in }
    ) {
        self.anniversaries = anniversaries
        self.isLoading = isLoading
        self.onSelect = onSelect
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                Text("기념일 리스트")
                    .font(.ato(.bold, 20))
                    .foregroundStyle(Color.gray400)

                Spacer()

                Button(action: {}) {
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
                        AnniversaryRowView(anniversary: anniversary) {
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

private struct AnniversaryRowView: View {
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
    AnniversaryListSection(anniversaries: Anniversary.sampleItems, isLoading: false)
        .padding(25)
        .background(Color.gray50)
}
