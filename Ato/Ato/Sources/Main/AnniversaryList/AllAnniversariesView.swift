//
//  AllAnniversariesView.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct AllAnniversariesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AllAnniversariesViewModel()
    @State private var formMode: AnniversaryFormMode?

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 36) {
                    sortControl

                    if let errorMessage = viewModel.errorMessage {
                        HomeErrorView(message: errorMessage) {
                            viewModel.load()
                        }
                    }

                    VStack(spacing: 14) {
                        if viewModel.anniversaries.isEmpty {
                            emptyView
                        } else {
                            ForEach(viewModel.anniversaries) { anniversary in
                                AnniversaryRowCard(anniversary: anniversary) {
                                    formMode = .edit(anniversary)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 44)
                .padding(.bottom, 40)
            }
        }
        .background(Color.gray50)
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.load()
        }
        .navigationDestination(item: $formMode) { mode in
            AnniversaryFormView(mode: mode)
        }
        .onChange(of: formMode) { _, newValue in
            if newValue == nil {
                viewModel.load()
            }
        }
    }

    private var navigationBar: some View {
        ZStack {
            Text("기념일 전체보기")
                .font(.ato(.bold, 20))
                .foregroundStyle(Color.gray400)

            HStack {
                AtoBackButton {
                    dismiss()
                }

                Spacer()
            }
        }
        .padding(.horizontal, 25)
        .padding(.top, 28)
        .frame(height: 80)
    }

    private var sortControl: some View {
        HStack(spacing: 12) {
            SortButton(
                title: "D-Day 순",
                isSelected: viewModel.selectedSort == .dday
            ) {
                viewModel.selectedSort = .dday
            }

            SortButton(
                title: "날짜 순",
                isSelected: viewModel.selectedSort == .date
            ) {
                viewModel.selectedSort = .date
            }

            Spacer()
        }
    }

    private var emptyView: some View {
        HStack {
            Spacer()

            Text(viewModel.isLoading ? "기념일을 불러오는 중이에요." : "등록된 기념일이 없어요.")
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

private struct SortButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ato(.semiBold, 14))
                .foregroundStyle(isSelected ? Color.gray50 : Color.gray200)
                .padding(.horizontal, 17)
                .frame(height: 32)
                .background(isSelected ? Color.orange400 : Color.gray100.opacity(0.32))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AllAnniversariesView()
}
