//
//  CalendarView.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var formMode: AnniversaryFormMode?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                monthHeader

                CalendarGridView(
                    days: viewModel.days,
                    isToday: viewModel.isToday,
                    isSelected: viewModel.isSelected,
                    hasAnniversary: viewModel.hasAnniversary,
                    onSelect: viewModel.select
                )

                scheduleSection
            }
            .padding(.horizontal, 31)
            .padding(.top, 46)
            .padding(.bottom, 112)
        }
        .background(Color.gray50)
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

    private var monthHeader: some View {
        HStack {
            Button {
                viewModel.moveMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.gray200)
                    .frame(width: 48, height: 48)
            }
            .buttonStyle(.plain)

            Spacer()

            Text(viewModel.displayedMonth.title)
                .font(.ato(.bold, 22))
                .foregroundStyle(Color.gray400)

            Spacer()

            Button {
                viewModel.moveMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.gray200)
                    .frame(width: 48, height: 48)
            }
            .buttonStyle(.plain)
        }
    }

    private var scheduleSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(viewModel.selectedDayTitle)
                .font(.ato(.bold, 17))
                .foregroundStyle(Color.gray400)

            if let errorMessage = viewModel.errorMessage {
                HomeErrorView(message: errorMessage) {
                    viewModel.load()
                }
            } else if viewModel.isLoading {
                CalendarEmptyScheduleView(text: "일정을 불러오는 중이에요.")
            } else if viewModel.selectedAnniversaries.isEmpty {
                CalendarEmptyScheduleView(text: "등록된 일정이 없어요.")
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.selectedAnniversaries) { anniversary in
                        CalendarScheduleCard(anniversary: anniversary) {
                            formMode = .edit(Anniversary(dto: anniversary))
                        }
                    }
                }
            }
        }
    }
}

private struct CalendarScheduleCard: View {
    let anniversary: AnniversaryDTO
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 18) {
                Image(systemName: "gift")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Color.orange400)
                    .frame(width: 62, height: 62)
                    .background(Color.orange100.opacity(0.5))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 7) {
                    Text(anniversary.title)
                        .font(.ato(.bold, 16))
                        .foregroundStyle(Color.gray400)
                        .lineLimit(1)

                    Text("\(anniversary.targetName) · \(anniversary.relation)")
                        .font(.ato(.regular, 13))
                        .foregroundStyle(Color.gray200)
                        .lineLimit(1)
                }

                Spacer()

                if anniversary.dDay >= 0 {
                    Text(anniversary.dDay == 0 ? "D-Day" : "D-\(anniversary.dDay)")
                        .font(.ato(.semiBold, 12))
                        .foregroundStyle(Color.orange400)
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 100)
            .background(Color.gray50)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray100.opacity(0.7), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct CalendarEmptyScheduleView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.ato(.regular, 16))
            .foregroundStyle(Color.gray200)
            .frame(maxWidth: .infinity)
            .frame(height: 86)
            .background(Color.gray50)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray100.opacity(0.7), lineWidth: 1)
            }
    }
}

#Preview {
    CalendarView()
}
