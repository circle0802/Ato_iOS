//
//  HomeView.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var formMode: AnniversaryFormMode?
    @State private var isShowingAllAnniversaries = false
    @State private var isShowingGiftRecommendation = false
    @State private var isShowingMessageGeneration = false

    private let quickActions = HomeQuickAction.homeActions

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 26) {
                headerView
                    .padding(.top, 36)

                if let closestAnniversary = viewModel.closestAnniversary {
                    HighlightAnniversaryCard(anniversary: closestAnniversary)
                } else {
                    EmptyAnniversaryCard(isLoading: viewModel.isLoading)
                }

                QuickActionGridView(actions: quickActions) { action in
                    handleQuickAction(action)
                }

                if let errorMessage = viewModel.errorMessage {
                    HomeErrorView(message: errorMessage) {
                        viewModel.load()
                    }
                }

                AnniversaryListSection(
                    anniversaries: viewModel.anniversaries,
                    isLoading: viewModel.isLoading,
                    onSeeAll: {
                        isShowingAllAnniversaries = true
                    }
                ) { anniversary in
                    formMode = .edit(anniversary)
                }
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 112)
        }
        .background(Color.gray50)
        .task {
            viewModel.load()
        }
        .navigationDestination(item: $formMode) { mode in
            AnniversaryFormView(mode: mode)
        }
        .navigationDestination(isPresented: $isShowingAllAnniversaries) {
            AllAnniversariesView()
        }
        .navigationDestination(isPresented: $isShowingGiftRecommendation) {
            GiftRecommendationView()
        }
        .navigationDestination(isPresented: $isShowingMessageGeneration) {
            MessageGenerationView()
        }
        .onChange(of: formMode) { _, newValue in
            if newValue == nil {
                viewModel.load()
            }
        }
    }

    private func handleQuickAction(_ action: HomeQuickAction) {
        switch action.kind {
        case .anniversaryForm:
            formMode = .create
        case .giftRecommendation:
            isShowingGiftRecommendation = true
        case .messageRecommendation:
            isShowingMessageGeneration = true
        }
    }

    private var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("안녕하세요")
                    .font(.ato(.regular, 20))
                    .foregroundStyle(Color.gray200)

                Text("\(viewModel.nickname)님, 반가워요!")
                    .font(.ato(.bold, 24))
                    .foregroundStyle(Color.gray400)
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "gift")
                    .font(.system(size: 31, weight: .regular))
                    .foregroundStyle(Color.gray200)
                    .frame(width: 62, height: 62)
                    .background(Color.gray100.opacity(0.22))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .padding(.top, 3)
        }
    }
}

#Preview {
    HomeView()
}
