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
    let id: Int
    var retrospect: String
    let week: Int
    var complete: [Int] // 완료루틴 Index
    // 완료 루틴index면 정렬시 뒤로빼기
    
    func getComplete() -> String {
        let tempString = complete.map{ String($0) }.joined(separator: " ")
        return tempString
    }

}

struct Rootine {
    let id: Int //id, PK
    var emoji: String //이모지
    var title: String
    var goal: String
    var repeatDays: [Int]  //반복요일 1이면 반복요일해당 [월,화,수...토,일] 7개 맞춰주기
    
    func getRepeatDay() -> String {
        let tempString = repeatDays.map{ String($0) }.joined(separator: " ")
        return tempString
    }
}
