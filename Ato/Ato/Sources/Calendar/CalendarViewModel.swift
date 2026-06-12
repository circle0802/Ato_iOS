//
//  CalendarViewModel.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation
import Combine

@MainActor
final class CalendarViewModel: ObservableObject {
    @Published private(set) var displayedMonth = CalendarMonth(date: Date())
    @Published private(set) var anniversaries: [AnniversaryDTO] = []
    @Published var selectedDate: Date?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let calendar = Calendar.atoCalendar
    private let anniversaryService: AnniversaryService

    var days: [CalendarDay] {
        makeDays(for: displayedMonth)
    }

    var selectedDayTitle: String {
        guard let selectedDate else {
            return "\(displayedMonth.month)월 일정"
        }

        let day = calendar.component(.day, from: selectedDate)
        return "\(displayedMonth.month)월 \(day)일 일정"
    }

    var selectedAnniversaries: [AnniversaryDTO] {
        guard let selectedDate else { return [] }
        return anniversaries
            .filter { anniversary in
                guard let date = Self.date(from: anniversary.nextDate) ?? Self.date(from: anniversary.date) else {
                    return false
                }

                return calendar.isDate(date, inSameDayAs: selectedDate)
            }
            .sorted { $0.dDay < $1.dDay }
    }

    init(anniversaryService: AnniversaryService? = nil) {
        self.anniversaryService = anniversaryService ?? AnniversaryService()
        selectedDate = initialSelectedDate(for: displayedMonth)
    }

    func load() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await anniversaryService.fetchCalendar(
                    year: displayedMonth.year,
                    month: displayedMonth.month
                )
                anniversaries = response.anniversaries
                keepSelectedDateInDisplayedMonth()
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }

    func moveMonth(by value: Int) {
        displayedMonth = displayedMonth.addingMonths(value, calendar: calendar)
        selectedDate = initialSelectedDate(for: displayedMonth)
        load()
    }

    func select(_ date: Date) {
        selectedDate = date
    }

    func hasAnniversary(on date: Date) -> Bool {
        anniversaries.contains { anniversary in
            guard let anniversaryDate = Self.date(from: anniversary.nextDate) ?? Self.date(from: anniversary.date) else {
                return false
            }

            return calendar.isDate(anniversaryDate, inSameDayAs: date)
        }
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    func isSelected(_ date: Date) -> Bool {
        guard let selectedDate else { return false }
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }

    private func makeDays(for month: CalendarMonth) -> [CalendarDay] {
        guard
            let firstDate = calendar.date(from: DateComponents(year: month.year, month: month.month, day: 1)),
            let range = calendar.range(of: .day, in: .month, for: firstDate)
        else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: firstDate)
        let leadingEmptyDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        var days = (0..<leadingEmptyDays).map { _ in CalendarDay(date: nil) }

        for day in range {
            let date = calendar.date(from: DateComponents(year: month.year, month: month.month, day: day))
            days.append(CalendarDay(date: date))
        }

        let remainder = days.count % 7
        if remainder != 0 {
            days.append(contentsOf: (0..<(7 - remainder)).map { _ in CalendarDay(date: nil) })
        }

        return days
    }

    private func keepSelectedDateInDisplayedMonth() {
        if let selectedDate {
            let components = calendar.dateComponents([.year, .month], from: selectedDate)
            if components.year == displayedMonth.year && components.month == displayedMonth.month {
                return
            }
        }

        selectedDate = initialSelectedDate(for: displayedMonth)
    }

    private func initialSelectedDate(for month: CalendarMonth) -> Date? {
        let todayMonth = CalendarMonth(date: Date(), calendar: calendar)
        if todayMonth == month {
            return Date()
        }

        return calendar.date(from: DateComponents(year: month.year, month: month.month, day: 1))
    }

    private static func date(from string: String) -> Date? {
        DateFormatter.atoDate.date(from: string)
    }
}
