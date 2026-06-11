//
//  MessageGenerationResultView.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import SwiftUI

struct MessageGenerationResultView: View {
    @Environment(\.dismiss) private var dismiss
    let message: GeneratedMessageDTO

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    headerCard
                    messageCard
                }
                .padding(.horizontal, 28)
                .padding(.top, 33)
                .padding(.bottom, 48)
            }
        }
        .background(Color.gray50)
        .navigationBarBackButtonHidden(true)
    }

    private var navigationBar: some View {
        ZStack {
            Text("작성 결과")
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

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 18, weight: .semibold))

                Text("AI 작성")
                    .font(.ato(.semiBold, 16))
            }
            .foregroundStyle(Color.orange400)

            Text("\(message.targetDescription)을 위한 \(message.tone) 메시지")
                .font(.ato(.bold, 22))
                .foregroundStyle(Color.gray400)
                .fixedSize(horizontal: false, vertical: true)

            Text("\(message.relation) · \(message.situation)")
                .font(.ato(.regular, 15))
                .foregroundStyle(Color.gray200)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange100.opacity(0.45))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var messageCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(message.content)
                .font(.ato(.regular, 18))
                .foregroundStyle(Color.gray400)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)

            AtoButton(
                "복사하기",
                systemImageName: "doc.on.doc",
                height: 48,
                fontSize: 17
            ) {
                UIPasteboard.general.string = message.content
            }
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

private extension GeneratedMessageDTO {
    var targetDescription: String {
        relation.isEmpty ? "상대" : relation
    }
}

#Preview {
    MessageGenerationResultView(
        message: GeneratedMessageDTO(
            id: UUID().uuidString,
            userId: UUID().uuidString,
            content: "하원아, 생일 진심으로 축하해. 오래 함께한 시간만큼 앞으로도 네 하루에 다정한 순간이 많이 쌓였으면 좋겠어.",
            relation: "친구",
            situation: "생일",
            tone: "감성적인",
            favorite: false,
            createdAt: "2026-06-11T03:24:14.624Z"
        )
    )
}
