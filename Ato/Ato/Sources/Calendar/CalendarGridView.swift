//
//  CalendarGridView.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import SwiftUI

struct CalendarGridView: View {
    let days: [CalendarDay]
    let isToday: (Date) -> Bool
    let isSelected: (Date) -> Bool
    let hasAnniversary: (Date) -> Bool
    let onSelect: (Date) -> Void

    private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    var body: some View {
        VStack(spacing: 18) {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(Array(weekdays.enumerated()), id: \.offset) { index, weekday in
                    Text(weekday)
                        .font(.ato(.semiBold, 13))
                        .foregroundStyle(index == 0 ? Color.red : Color.gray200)
                        .frame(height: 28)
                }
            }

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(days) { day in
                    if let date = day.date, let dayNumber = day.day {
                        CalendarDayCell(
                            day: dayNumber,
                            isToday: isToday(date),
                            isSelected: isSelected(date),
                            hasAnniversary: hasAnniversary(date)
                        ) {
                            onSelect(date)
                        }
                    } else {
                        Color.clear
                            .frame(height: 56)
                    }
                }
            }
        }
    }
}

private struct CalendarDayCell: View {
    let day: Int
    let isToday: Bool
    let isSelected: Bool
    let hasAnniversary: Bool
    let onTap: () -> Void

    private var foregroundColor: Color {
        if isToday {
            return Color.gray50
        }

        if isSelected {
            return Color.orange400
        }

        return Color.black
    }

    private var backgroundColor: Color {
        if isToday {
            return Color.orange400
        }

        if isSelected {
            return Color.orange100.opacity(0.45)
        }

        return Color.clear
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 5) {
                Text("\(day)")
                    .font(.ato(.regular, 17))
                    .foregroundStyle(foregroundColor)
                    .frame(height: 28)

                Circle()
                    .fill(hasAnniversary ? (isToday ? Color.gray50 : Color.orange400) : Color.clear)
                    .frame(width: 5, height: 5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CalendarGridView(
        days: CalendarViewModel().days,
        isToday: { Calendar.atoCalendar.isDateInToday($0) },
        isSelected: { _ in false },
        hasAnniversary: { _ in true },
        onSelect: { _ in }
    )
    .padding(30)
}
