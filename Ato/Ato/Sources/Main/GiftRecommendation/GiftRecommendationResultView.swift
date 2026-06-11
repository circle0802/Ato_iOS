//
//  GiftRecommendationResultView.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import SwiftUI

struct GiftRecommendationResultView: View {
    @Environment(\.dismiss) private var dismiss
    let recommendation: GiftRecommendationDTO
    @State private var selectedSort: GiftRecommendationSort = .ranking

    private var sortedItems: [GiftRecommendationItemDTO] {
        switch selectedSort {
        case .ranking:
            return recommendation.items.sorted { $0.ranking < $1.ranking }
        case .price:
            return recommendation.items.sorted {
                if $0.price == $1.price {
                    return $0.ranking < $1.ranking
                }

                return $0.price < $1.price
            }
        case .category:
            return recommendation.items.sorted {
                if $0.category == $1.category {
                    return $0.ranking < $1.ranking
                }

                return $0.category < $1.category
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    resultSummary
                    sortControl

                    LazyVStack(spacing: 20) {
                        ForEach(sortedItems) { item in
                            GiftRecommendationItemCard(item: item)
                        }
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 26)
                .padding(.bottom, 40)
            }
        }
        .background(Color.gray50)
        .navigationBarBackButtonHidden(true)
    }

    private var navigationBar: some View {
        ZStack {
            Text("추천 결과")
                .font(.ato(.bold, 20))
                .foregroundStyle(Color.gray400)

            HStack {
                AtoBackButton {
                    dismiss()
                }

                Spacer()
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 28)
        .frame(height: 80)
    }

    private var resultSummary: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 13, weight: .semibold))

                Text("AI 추천")
                    .font(.ato(.semiBold, 16))
            }
            .foregroundStyle(Color.orange300)
            .padding(.horizontal, 16)
            .frame(height: 40)
            .background(Color.orange100.opacity(0.45))
            .clipShape(Capsule())

            Text("\(recommendation.items.count)개의 선물을 찾았어요")
                .font(.ato(.semiBold, 16))
                .foregroundStyle(Color.gray200)
        }
    }

    private var sortControl: some View {
        HStack(spacing: 12) {
            ForEach(GiftRecommendationSort.allCases) { sort in
                AtoChipButton(sort.title, isSelected: selectedSort == sort) {
                    selectedSort = sort
                }
            }
        }
    }
}

private enum GiftRecommendationSort: CaseIterable, Identifiable {
    case ranking
    case price
    case category

    var id: Self { self }

    var title: String {
        switch self {
        case .ranking:
            return "추천순"
        case .price:
            return "가격순"
        case .category:
            return "카테고리"
        }
    }
}

private struct GiftRecommendationItemCard: View {
    let item: GiftRecommendationItemDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GiftRecommendationImage(item: item)
                .frame(height: 248)
                .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top) {
                    Text(item.category)
                        .font(.ato(.semiBold, 13))
                        .foregroundStyle(Color.orange300)
                        .padding(.horizontal, 10)
                        .frame(height: 24)
                        .background(Color.orange100.opacity(0.45))
                        .clipShape(Capsule())

                    Spacer()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(item.name)
                        .font(.ato(.bold, 20))
                        .foregroundStyle(Color.gray400)
                        .lineLimit(2)

                    Text(item.reason)
                        .font(.ato(.regular, 15))
                        .foregroundStyle(Color.gray300)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(alignment: .lastTextBaseline) {
                    Text(item.price.priceText)
                        .font(.ato(.bold, 20))
                        .foregroundStyle(Color.orange300)

                    Spacer()

                    Text("\(item.ranking)위 추천")
                        .font(.ato(.regular, 15))
                        .foregroundStyle(Color.gray200)
                }
            }
            .padding(24)
        }
        .background(Color.gray50)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray100.opacity(0.75), lineWidth: 1)
        }
    }
}

private struct GiftRecommendationImage: View {
    let item: GiftRecommendationItemDTO

    var body: some View {
        ZStack {
            Color.gray100.opacity(0.45)

            if item.imageUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                placeholder
            } else {
                AtoRemoteImage(
                    urlString: item.imageUrl,
                    fallbackURLStrings: fallbackURLStrings
                ) {
                    placeholder
                }
            }
        }
        .clipped()
    }

    private var fallbackURLStrings: [String] {
        [fallbackImageURLString(for: item.category), fallbackImageURLString(for: item.name)]
            .compactMap { $0 }
    }

    private func fallbackImageURLString(for value: String) -> String? {
        if value.contains("전자") || value.contains("스피커") || value.contains("기기") {
            return "https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=900&q=80"
        }

        if value.contains("뷰티") || value.contains("향수") || value.contains("미용") {
            return "https://images.unsplash.com/photo-1596462502278-27bfdc403348?auto=format&fit=crop&w=900&q=80"
        }

        if value.contains("홈") || value.contains("리빙") || value.contains("유리") || value.contains("꽃") {
            return "https://images.unsplash.com/photo-1487070183336-b863922373d4?auto=format&fit=crop&w=900&q=80"
        }

        if value.contains("식품") || value.contains("디저트") || value.contains("케이크") {
            return "https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=900&q=80"
        }

        if value.contains("패션") || value.contains("가방") || value.contains("목걸이") || value.contains("티셔츠") || value.contains("레깅스") || value.contains("버킷햇") {
            return "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=900&q=80"
        }

        if value.contains("감성") || value.contains("추억") || value.contains("포토") {
            return "https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=900&q=80"
        }

        return "https://images.unsplash.com/photo-1513201099705-a9746e1e201f?auto=format&fit=crop&w=900&q=80"
    }

    private var placeholder: some View {
        VStack(spacing: 8) {
            Image(systemName: "gift")
                .font(.system(size: 28, weight: .medium))

            Text("이미지 준비 중")
                .font(.ato(.regular, 14))
        }
        .foregroundStyle(Color.gray200)
    }
}

private extension Int {
    var priceText: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let value = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(value)원"
    }
}

#Preview {
    GiftRecommendationResultView(
        recommendation: GiftRecommendationDTO(
            id: "preview",
            userId: "user",
            input: GiftRecommendationInputDTO(
                age: 29,
                gender: "여성",
                relation: "친구",
                occasion: "생일",
                hobbies: ["요가"],
                interests: ["향수"],
                budgetMin: 30000,
                budgetMax: 80000,
                mood: "감성적인",
                categories: ["전자기기"],
                extraContext: nil
            ),
            items: [
                GiftRecommendationItemDTO(
                    id: "item",
                    name: "휴대용 블루투스 스피커",
                    category: "전자기기",
                    imageUrl: "",
                    reason: "음악을 좋아하는 친구에게 잘 맞는 선물입니다.",
                    price: 89000,
                    ranking: 1,
                    detail: "작고 휴대하기 좋아요.",
                    purchaseUrl: "",
                    saved: false
                )
            ],
            createdAt: "2026-06-11T01:45:11.511Z"
        )
    )
}
