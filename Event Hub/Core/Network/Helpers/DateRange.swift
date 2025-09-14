//
//  DateRange.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//

import Foundation

struct DateRange {
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
}
