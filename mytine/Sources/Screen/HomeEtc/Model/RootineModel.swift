//
//  RootineModel.swift
//  mytine
//
//  Created by 남수김 on 2020/07/27.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation

struct WeekRootine {
    let week: Int
    let rootinesIdx: String
}

struct DayRootine {
    let id: String
    var retrospect: String
    let week: Int
    let complete: [Int]
    
    func getComplete() -> String {
        let tempString = complete.map{ String($0) }.joined(separator: " ")
        return tempString
    }
    
    func getRootineRate() -> String {
        let total: Float = Float(complete.count)
        if total == 0 {
            return "0.0"
        }
        
        let completeCount = complete.filter{ $0 == 1 }.count
        let rate = Float(completeCount)/total
        return String(format: "%.1f", rate)
    }
}

struct Rootine {
    let id = 1 //id, PK
    let emoji: String //이모지
    let title: String
    let goal: String
    let repeatDays: [Int]  //반복요일 1이면 반복요일해당 [월,화,수...토,일]
    let count = 1 // 0일때 디비에서 삭제
    
    func getRepeatDay() -> String {
        let tempString = repeatDays.map{ String($0) }.joined(separator: " ")
        return tempString
    }
    
}
