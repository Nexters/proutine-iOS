//
//  CalendarManager.swift
//  mytine
//
//  Created by 남수김 on 2020/07/27.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation

class CalendarManager {
    var dayOfMonth: Int = 0
    var month: Int {
        didSet {
            dayOfMonth = getDayOfMonth()
            print(month)
        }
    }
    
    var year: Int {
        didSet {
            print(year)
        }
    }
    
    init(date: Date) {
        year = date.getYear()
        month = date.getMonth()
        dayOfMonth = getDayOfMonth()
    }
    
    func getDayOfMonth() -> Int {
        switch self.month {
        case 1,3,5,7,8,10,12:
            return 31
        case 4,6,9,11:
            return 30
        case 2:
            if Date.isLeapYear(year) {
                return 29
            } else {
                return 28
            }
        default:
            return 0
        }
    }
    
    func nextMonth() {
        month += 1
        if month > 12 {
            month = 1
            year += 1
        }
    }
    
    func beforeMonth() {
        month -= 1
        if month < 1 {
            month = 12
            year -= 1
        }
    }
}
