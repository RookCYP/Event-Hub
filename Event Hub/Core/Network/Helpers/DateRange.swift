//
//  DateRange.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//

import Foundation

struct DateRange: Codable {
    let from: Date
    let to: Date
}

extension DateRange {
    static var next7Days: DateRange {
        let now = Date()
        let to = Calendar.current.date(byAdding: .day, value: 7, to: now)!
        return .init(from: now, to: to)
    }
    
    static var today: DateRange {
        let cal = Calendar.current
        let start = cal.startOfDay(for: Date())
        let end = cal.date(byAdding: .day, value: 1, to: start)!
        return .init(from: start, to: end)
    }
    static var thisMonth: DateRange {
        let cal = Calendar.current
        let now = Date()
        let startOfMonth = cal.dateInterval(of: .month, for: now)!.start
        let endOfMonth = cal.dateInterval(of: .month, for: now)!.end
        return .init(from: startOfMonth, to: endOfMonth)
    }
    
    static var nextMonth: DateRange {
        let cal = Calendar.current
        let now = Date()
        let nextMonth = cal.date(byAdding: .month, value: 1, to: now)!
        let start = cal.dateInterval(of: .month, for: nextMonth)!.start
        let end = cal.dateInterval(of: .month, for: nextMonth)!.end
        return .init(from: start, to: end)
    }
}
