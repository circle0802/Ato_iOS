//
//  MessageGenerationView.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import SwiftUI

struct MessageGenerationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MessageGenerationViewModel()
    @State private var resultMessage: GeneratedMessageDTO?

    private let tones = ["감성적인", "따뜻한", "유쾌한", "정중한", "담백한", "센스있는"]

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    basicInfoSection
                    toneSection
                    contextSection

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
                viewModel.isLoading ? "작성 중..." : "AI 메시지 작성",
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
        .onChange(of: viewModel.message) { _, message in
            resultMessage = message
        }
        .navigationDestination(item: $resultMessage) { message in
            MessageGenerationResultView(message: message)
        }
    }

    private var navigationBar: some View {
        ZStack {
            Text("축하 메시지 작성")
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

    private var basicInfoSection: some View {
        MessageFormSection(title: "기본 정보") {
            AtoTextField(
                title: "관계",
                placeholder: "예: 친구, 연인, 부모님",
                text: $viewModel.relation
            )

            AtoTextField(
                title: "상황",
                placeholder: "예: 생일, 졸업, 승진",
                text: $viewModel.situation
            )

            AtoTextField(
                title: "이름",
                placeholder: "예: 하원",
                text: $viewModel.targetName
            )
        }
    }

    private var toneSection: some View {
        MessageFormSection(title: "감성 스타일") {
            MessageToneChipGrid(
                items: tones,
                selectedItem: viewModel.selectedTone
            ) { tone in
                viewModel.selectedTone = viewModel.selectedTone == tone ? nil : tone
            }
        }
    }

    private var contextSection: some View {
        MessageFormSection(title: "기타") {
            AtoTextEditor(
                title: "기타",
                placeholder: "예: 오래 알고 지낸 친구, 최근 힘든 일을 이겨낸 상황",
                text: $viewModel.extraContext,
                maxLength: 200,
                showsTitle: false
            )
        }
    }
}

private struct MessageFormSection<Content: View>: View {
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

private struct MessageToneChipGrid: View {
    let items: [String]
    let selectedItem: String?
    let onTap: (String) -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 98), spacing: 4)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 4) {
            ForEach(items, id: \.self) { item in
                AtoChipButton(
                    item,
                    isSelected: selectedItem == item
                ) {
                    onTap(item)
                }
            }
        }
    }
}

#Preview {
    MessageGenerationView()
}
