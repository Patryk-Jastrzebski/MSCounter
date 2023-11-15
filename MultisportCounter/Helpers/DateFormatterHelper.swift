//
//  DateFormatterHelper.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 08/11/2023.
//

import Foundation

enum DateFormat: String {
    case dateAndTimeWithPartialMonth = "dd MMM yyyy, HH:mm"
    case `default` = "dd MMMM yyyy"
}

final class DateFormatterHelper {

    static let shared = DateFormatterHelper(timeZone: TimeZone(identifier: "UTC")!)

    init(timeZone: TimeZone = TimeZone.current) {
        self.calendar.timeZone = timeZone
    }
    
    private lazy var isoDateFormatter = ISO8601DateFormatter()
    private lazy var dateFormatter = DateFormatter()
    
    private lazy var dateFormatterWithTimeZone: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.locale = Locale(identifier: "pl-PL")
        return dateFormatter
    }()

    lazy var calendar: Calendar = {
        let calendar = Calendar(identifier: .gregorian)
        return calendar
    }()

    func date(from string: String?, format: DateFormat = .default, withTimeZone: Bool = true) -> Date? {
        guard let string = string else { return nil }
        let dateFormatter = getFormatter(withTimeZone: withTimeZone)
        dateFormatter.dateFormat = format.rawValue
        
        if let date = dateFormatter.date(from: string) {
            return date
        } else if let date = isoDateFormatter.date(from: string) {
            return date
        }
        return nil
    }

    func string(from date: Date?, format: DateFormat = .default, withTimeZone: Bool = false) -> String? {
        guard let date = date else { return nil }
        let dateFormatter = getFormatter(withTimeZone: withTimeZone)
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }
    
    func getFormatter(withTimeZone: Bool) -> DateFormatter {
        withTimeZone ? dateFormatterWithTimeZone : dateFormatter
    }
}
