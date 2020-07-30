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
    var rootinesIdx: String
}

struct DayRootine {
    let id: String
    var retrospect: String
    let week: Int
    var complete: [Int] // 1:완료루틴 0:미완료루틴
    var rootinesState: [Int] // 루틴순서 (완료시 뒤로)
    
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
    
    func getRootineState() -> String {
        let tempString = rootinesState.map{ String($0) }.joined(separator: " ")
        return tempString
    }
}

struct Rootine {
    let id: Int //id, PK
    var emoji: String //이모지
    var title: String
    var goal: String
    var repeatDays: [Int]  //반복요일 1이면 반복요일해당 [월,화,수...토,일] 7개 맞춰주기
    var count: Int // 0일때 디비에서 삭제
    
    func getRepeatDay() -> String {
        let tempString = repeatDays.map{ String($0) }.joined(separator: " ")
        return tempString
    }

}
