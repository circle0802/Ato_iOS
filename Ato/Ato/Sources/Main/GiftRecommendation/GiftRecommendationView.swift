//
//  GiftRecommendationView.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct GiftRecommendationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = GiftRecommendationViewModel()
    @State private var resultRecommendation: GiftRecommendationDTO?
    
    private let genders = ["남성", "여성", "무관"]
    private let moods = ["감성적인", "실용적인", "유머/특이한", "고급스러운", "심플한"]
    private let categories = ["패션", "전자기기", "취미용품", "뷰티/건강", "홈/리빙", "감성/추억", "식품"]
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    basicInfoSection
                    hobbySection
                    moodSection
                    categorySection
                    noteSection

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.ato(.regular, 14))
                            .foregroundStyle(Color.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 33)
                .padding(.bottom, 76)
            }
        }
        .safeAreaInset(edge: .bottom) {
            AtoButton(
                viewModel.isLoading ? "추천 받는 중..." : "AI 추천 받기",
                isEnabled: viewModel.isSubmitEnabled,
                systemImageName: "sparkles"
            ) {
                viewModel.submit()
            }
                .padding(.horizontal, 28)
                .padding(.bottom, 10)
                .background(Color.gray50)
        }
        .background(Color.gray50)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.recommendation) { _, recommendation in
            resultRecommendation = recommendation
        }
        .navigationDestination(item: $resultRecommendation) { recommendation in
            GiftRecommendationResultView(recommendation: recommendation)
        }
    }
    
    private var navigationBar: some View {
        ZStack {
            Text("선물 추천")
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
    
    private var progressBar: some View {
        GeometryReader { geometry in
            HStack(spacing: 10) {
                Capsule()
                    .fill(Color.orange300)
                    .frame(width: geometry.size.width * 0.5)
                
                Capsule()
                    .fill(Color.gray100.opacity(0.55))
            }
        }
        .frame(height: 10)
    }
    
    private var basicInfoSection: some View {
        GiftFormSection(title: "기본 정보") {
            VStack(spacing: 16) {
                AtoTextField(
                    title: "나이",
                    placeholder: "25",
                    text: $viewModel.age,
                    keyboardType: .numberPad
                )
                
                AtoTextField(
                    title: "예산 (원)",
                    placeholder: "50000",
                    text: $viewModel.budget,
                    keyboardType: .numberPad
                )
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("성별")
                    .font(.ato(.semiBold, 18))
                    .foregroundStyle(Color.gray200)
                
                ThreeColumnChipGrid(items: genders, selections: [viewModel.selectedGender]) { gender in
                    viewModel.selectedGender = gender
                }
            }
            
            AtoTextField(
                title: "상황",
                placeholder: "예: 생일, 기념일, 졸업",
                text: $viewModel.occasion
            )

            AtoTextField(
                title: "관계",
                placeholder: "예: 여자친구, 친구, 부모님",
                text: $viewModel.relation
            )
        }
    }
    
    private var hobbySection: some View {
        GiftFormSection(title: "취미 & 관심사") {
            AtoTextField(
                title: "취미",
                placeholder: "예: 음악, 여행, 게임, 운동",
                text: $viewModel.hobby
            )
            
            AtoTextField(
                title: "관심사",
                placeholder: "예: 패션, 기술, 요리, 영화",
                text: $viewModel.interest
            )
        }
    }
    
    private var moodSection: some View {
        GiftFormSection(title: "선물 분위기") {
            FlexibleChipGrid(
                items: moods,
                selections: viewModel.selectedMood.map { [$0] } ?? []
            ) { mood in
                viewModel.selectedMood = viewModel.selectedMood == mood ? nil : mood
            }
        }
    }
    
    private var categorySection: some View {
        GiftFormSection(title: "선물 카테고리") {
            ThreeColumnChipGrid(items: categories, selections: viewModel.selectedCategories) { category in
                if viewModel.selectedCategories.contains(category) {
                    viewModel.selectedCategories.remove(category)
                } else {
                    viewModel.selectedCategories.insert(category)
                }
            }
        }
    }

    private var noteSection: some View {
        GiftFormSection(title: "기타 사항") {
            AtoTextEditor(
                title: "기타 사항",
                placeholder: "예: 선호 브랜드, 피해야 할 선물, 특별한 상황",
                text: $viewModel.note,
                maxLength: 200,
                showsTitle: false
            )
        }
    }
}

private struct GiftFormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(title)
                .font(.ato(.bold, 18))
                .foregroundStyle(Color.gray400)
            
            content
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray50)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.gray100.opacity(0.7), lineWidth: 1)
        }
    }
}

private struct ThreeColumnChipGrid<Selection: Collection>: View where Selection.Element == String {
    let items: [String]
    let selections: Selection
    let onTap: (String) -> Void
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 4),
        count: 3
    )
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(items, id: \.self) { item in
                AtoChipButton(
                    item,
                    isSelected: selections.contains(item)
                ) {
                    onTap(item)
                }
            }
        }
    }
}

private struct FlexibleChipGrid: View {
    let items: [String]
    let selections: Set<String>
    let onTap: (String) -> Void
    
    private let columns = [
        GridItem(.adaptive(minimum: 98), spacing: 4)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 4) {
            ForEach(items, id: \.self) { item in
                AtoChipButton(
                    item,
                    isSelected: selections.contains(item)
                ) {
                    onTap(item)
                }
            }
        }
    }
}

#Preview {
    GiftRecommendationView()
}
