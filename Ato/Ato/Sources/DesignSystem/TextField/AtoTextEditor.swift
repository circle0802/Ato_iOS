//
//  AtoTextEditor.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

struct AtoTextEditor: View {
    let title: String
    let placeholder: String
    let maxLength: Int
    let showsTitle: Bool
    @Binding var text: String

    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        maxLength: Int = 200,
        showsTitle: Bool = true
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.maxLength = maxLength
        self.showsTitle = showsTitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                if showsTitle {
                    Text(title)
                        .font(.ato(.semiBold, 18))
                        .foregroundStyle(Color.gray200)
                }

                Spacer()

                Text("\(text.count)/\(maxLength)")
                    .font(.ato(.regular, 13))
                    .foregroundStyle(Color.gray200)
            }

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.ato(.regular, 18))
                        .foregroundStyle(Color.gray100)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 17)
                }

                TextEditor(text: $text)
                    .font(.ato(.regular, 18))
                    .foregroundStyle(Color.gray400)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 9)
                    .frame(minHeight: 118)
                    .background(Color.clear)
                    .onChange(of: text) { _, newValue in
                        if newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
            }
            .frame(minHeight: 118)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.gray100, lineWidth: 1)
            }
        }
    }
}

#Preview {
    AtoTextEditor(
        title: "기타 사항",
        placeholder: "예: 선호 브랜드, 피해야 할 선물, 특별한 상황",
        text: .constant("")
    )
    .padding(24)
    .background(Color.gray50)
}
