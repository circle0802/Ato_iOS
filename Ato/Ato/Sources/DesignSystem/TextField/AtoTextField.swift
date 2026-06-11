//
//  AtoTextField.swift
//  Ato
//
//  Created by hawon on 6/7/26.
//

import SwiftUI

struct AtoTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    let keyboardType: UIKeyboardType

    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.ato(.semiBold, 18))
                .foregroundStyle(Color.gray200)

            inputField
                .font(.ato(.regular, 18))
                .foregroundStyle(Color.gray400)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(keyboardType)
                .padding(.horizontal, 20)
                .frame(height: 56)
                .overlay {
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.gray100, lineWidth: 1)
                }
        }
    }

    @ViewBuilder
    private var inputField: some View {
        if isSecure {
            SecureField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundStyle(Color.gray100)
            )
        } else {
            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundStyle(Color.gray100)
            )
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        AtoTextField(
            title: "별명",
            placeholder: "별명을 입력해주세요",
            text: .constant("")
        )

        AtoTextField(
            title: "비밀번호",
            placeholder: "비밀번호를 입력해주세요",
            text: .constant(""),
            isSecure: true
        )
    }
    .padding(24)
}
