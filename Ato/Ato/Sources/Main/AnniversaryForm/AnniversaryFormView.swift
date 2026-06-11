//
//  AnniversaryFormView.swift
//  Ato
//
//  Created by Codex on 6/10/26.
//

import SwiftUI

enum AnniversaryFormMode: Equatable, Hashable {
    case create
    case edit(Anniversary)

    var navigationTitle: String {
        switch self {
        case .create:
            "기념일 등록"
        case .edit:
            "기념일 수정"
        }
    }

    var buttonTitle: String {
        switch self {
        case .create:
            "등록하기"
        case .edit:
            "수정하기"
        }
    }
}

extension AnniversaryFormMode: Identifiable {
    var id: String {
        switch self {
        case .create:
            "create"
        case .edit(let anniversary):
            "edit-\(anniversary.id)"
        }
    }
}

struct AnniversaryFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AnniversaryFormViewModel

    let mode: AnniversaryFormMode

    init(mode: AnniversaryFormMode = .create) {
        self.mode = mode
        _viewModel = StateObject(wrappedValue: AnniversaryFormViewModel(mode: mode))
    }

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView(showsIndicators: false) {
                VStack(spacing: 34) {
                    datePicker
                        .padding(.top, 42)

                    VStack(spacing: 30) {
                        AnniversaryFormTextField(
                            title: "기념일 이름",
                            placeholder: "최대 12글자",
                            maxLength: 12,
                            text: $viewModel.anniversaryName
                        )

                        AnniversaryFormTextField(
                            title: "대상 이름",
                            placeholder: "최대 8글자",
                            maxLength: 8,
                            text: $viewModel.targetName
                        )
                    }

                    VStack(spacing: 20) {
                        AnniversaryOptionRow(
                            title: "매년 반복",
                            subtitle: "내년에도 후년에도 기념일이 반복",
                            isOn: $viewModel.isRepeating,
                            tint: Color.orange400
                        )

                        AnniversaryOptionRow(
                            title: "알림 받기",
                            subtitle: "3일, 당일 알림 발송",
                            isOn: $viewModel.isNotificationEnabled,
                            tint: Color.orange400
                        )
                    }
                    .padding(.top, 1)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 120)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.ato(.regular, 14))
                    .foregroundStyle(Color.red)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 8)
            }

            submitButton
        }
        .background(Color.gray50)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.didSubmit) { _, didSubmit in
            if didSubmit {
                dismiss()
            }
        }
    }

    private var navigationBar: some View {
        ZStack {
            Text(mode.navigationTitle)
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

    private var datePicker: some View {
        DatePicker(
            "",
            selection: $viewModel.selectedDate,
            displayedComponents: .date
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .environment(\.locale, Locale(identifier: "ko_KR"))
        .frame(height: 178)
        .clipped()
        .tint(Color.orange400)
    }

    private var submitButton: some View {
        Button(action: {
            viewModel.submit()
        }) {
            Text(submitButtonTitle)
                .font(.ato(.semiBold, 20))
                .foregroundStyle(.white)
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .background(viewModel.isSubmitEnabled ? Color.orange400 : Color.gray200)
                .clipShape(RoundedRectangle(cornerRadius: 32))
        }
        .buttonStyle(.plain)
        .disabled(!viewModel.isSubmitEnabled)
        .padding(.horizontal, 32)
        .padding(.top, 16)
        .padding(.bottom, 32)
        .background(Color.gray50)
    }

    private var submitButtonTitle: String {
        guard viewModel.isLoading else {
            return mode.buttonTitle
        }

        switch mode {
        case .create:
            return "등록 중..."
        case .edit:
            return "수정 중..."
        }
    }
}

private struct AnniversaryFormTextField: View {
    let title: String
    let placeholder: String
    let maxLength: Int
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.ato(.semiBold, 18))
                .foregroundStyle(Color.gray200)

            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundStyle(Color.gray100)
            )
            .font(.ato(.regular, 18))
            .foregroundStyle(Color.gray400)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(.horizontal, 20)
            .frame(height: 56)
            .overlay {
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.gray100, lineWidth: 1)
            }
            .onChange(of: text) { _, newValue in
                if newValue.count > maxLength {
                    text = String(newValue.prefix(maxLength))
                }
            }
        }
    }
}

private struct AnniversaryOptionRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let tint: Color

    var body: some View {
        HStack(spacing: 18) {
            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(.ato(.bold, 18))
                    .foregroundStyle(Color.gray400)

                Text(subtitle)
                    .font(.ato(.semiBold, 16))
                    .foregroundStyle(Color.gray200)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(tint)
        }
        .padding(.horizontal, 17)
        .frame(height: 80)
        .background(Color.orange100.opacity(0.44))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview("Create") {
    AnniversaryFormView(mode: .create)
}

#Preview("Edit") {
    AnniversaryFormView(mode: .edit(Anniversary.sampleItems[0]))
}
