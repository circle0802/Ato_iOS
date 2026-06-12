//
//  CalendarMonth.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation

struct CalendarMonth: Equatable {
    let year: Int
    let month: Int

    init(date: Date, calendar: Calendar = .atoCalendar) {
        let components = calendar.dateComponents([.year, .month], from: date)
        self.year = components.year ?? 2026
        self.month = components.month ?? 1
    }

    init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }

    var title: String {
        "\(year)년 \(month)월"
    }

    func addingMonths(_ value: Int, calendar: Calendar = .atoCalendar) -> CalendarMonth {
        guard
            let date = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
            let nextDate = calendar.date(byAdding: .month, value: value, to: date)
        else {
            return self
        }

        return CalendarMonth(date: nextDate, calendar: calendar)
    }
}

struct CalendarDay: Identifiable, Equatable {
    let id = UUID()
    let date: Date?

    var day: Int? {
        guard let date else { return nil }
        return Calendar.atoCalendar.component(.day, from: date)
    }
}

extension Calendar {
    static var atoCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.firstWeekday = 1
        return calendar
    }
}

extension DateFormatter {
    static let atoDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = .atoCalendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
