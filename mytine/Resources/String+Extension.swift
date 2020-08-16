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
    // 해당날짜가 포함된 그주의 처음과 끝날짜
    func weekFirstToEnd() -> String {
        let weekDay = self.simpleDateStringGetWeekDay()-2
        
        let before: Int
        let after: Int
        // 일요일
        if weekDay < 0 {
            before = 6
            after = 0
        } else {
            before = weekDay
            after = 6-weekDay
        }
        let formatter = simpleDateFormatter(format: "yyyyMMdd")
        guard let date = formatter.date(from: self),
            let startCalendar = Calendar.current.date(byAdding: .day, value: -before, to: date),
            let endCalendar = Calendar.current.date(byAdding: .day, value: after, to: date) else {
            return ""
        }
        formatter.dateFormat = "MM월 dd일"
        print("주차시작날짜:::: \(startCalendar)")
        print("주차끝날짜::::: \(endCalendar)")
        let startDay = formatter.string(from: startCalendar)
        let endDay = formatter.string(from: endCalendar)
        return "\(startDay) - \(endDay)"
        
    }
    
    // addDay일후
    func afterDayString(addDay: Int) -> String {
        let formatter = simpleDateFormatter(format: "yyyyMMdd")
        guard let date = formatter.date(from: self),
        let weekCalendar = Calendar.current.date(byAdding: .day, value: addDay, to: date) else {
            return ""
        }
        return formatter.string(from: weekCalendar)
    }
    // 주차 -> dayId
    func weekConvertToDayRoutineId() -> String {
        let formatter = simpleDateFormatter(format: "MM월 dd일")
        guard let date = formatter.date(from: self) else {
            return ""
        }
        formatter.dateFormat = "MMdd"
        let curYear = Date().getYear()
        let mmdd = formatter.string(from: date)
        return "\(curYear)\(mmdd)"
    }
}

extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }
    
    var containsEmoji: Bool { contains { $0.isEmoji } }
    
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
    
    var emojiString: String { emojis.map { String($0) }.reduce("", +) }
    
    var emojis: [Character] { filter { $0.isEmoji } }
    
    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}
