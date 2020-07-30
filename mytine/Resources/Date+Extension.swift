//
//  Date+Extension.swift
//  mytine
//
//  Created by 남수김 on 2020/07/27.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation

extension Date {
    private static func simpleDateFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.timeZone = .current
        formatter.dateFormat = format
        return formatter
    }
    
    func makeRootineId() -> String {
        let formatter = Date.simpleDateFormatter(format: "yyyyMMdd")
        let dateString = formatter.string(from: self)
        
        return dateString
    }
    
    // 월 시작요일 계산
    static func startWeekday(year: String, month: String) -> Int {
        let formatter = simpleDateFormatter(format: "yyyyMMdd")
        let dateString = "\(year)\(month)01"
        guard let date = formatter.date(from: dateString) else {
            return -1
        }
        let weekday = Calendar.current.component(.weekday, from: date)
        // sun:1 mon:2 tue:3 wed:4 thr:5 fri:6 sat:7
        return weekday
    }
    
    static func isLeapYear(_ year: Int) -> Bool {

        let isLeapYear = ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))

        return isLeapYear
    }
    
    func getMonth() -> Int {
        let month = Calendar.current.component(.month, from: self)
        return month
    }
    
    func getYear() -> Int {
        let year = Calendar.current.component(.year, from: self)
        return year
    }
    
    func getWeekday() -> Int {
        let weekDay = Calendar.current.component(.weekday, from: self)
        return weekDay
    }
}
