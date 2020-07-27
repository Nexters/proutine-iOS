//
//  String+Extension.swift
//  mytine
//
//  Created by 남수김 on 2020/07/27.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation
extension String {
    private func simpleDateFormatter(format: String) -> DateFormatter {
           let formatter = DateFormatter()
           formatter.locale = Locale(identifier: "ko")
           formatter.timeZone = .current
           formatter.dateFormat = format
           return formatter
       }
    
    func simpleDateStringCompareWeek(compare: String, weekDay: Int) -> Int {
        let remainWeek = 7 - (weekDay-1)
        let formatter = simpleDateFormatter(format: "yyyyMMdd")
        guard let originDate = formatter.date(from: self),
        let compareDate = formatter.date(from: compare) else {
            return -1
        }
        let dateComponent = Calendar.current.dateComponents([.day], from: originDate, to: compareDate)
        print("------")
        print("\(self) \(compare)")
        
        var week = 0
        if dateComponent.day! > remainWeek {
            let betweenDay = (dateComponent.day! - remainWeek)
            week = betweenDay/7
            if betweenDay%7 != 0 {
                week += 1
            }
        }
        
        print("주차: \(week+1)")
        return week+1
    }
    
    func simpleDateStringGetWeekDay() -> Int {
        let formatter = simpleDateFormatter(format: "yyyyMMdd")
        guard let date = formatter.date(from: self) else {
            return -1
        }
        let weekDay = date.getWeekday()
        return weekDay
    }
}
