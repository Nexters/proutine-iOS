//
//  Routine.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/30.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation

struct Routine: Equatable {
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
    
    init(id: Int, emoji: String, title: String, goal: String, repeatDays: [Int], count: Int) {
        self.id = id
        self.emoji = emoji
        self.title = title
        self.goal = goal
        self.repeatDays = repeatDays
        self.count = count
    }
    
//    init(original: Routine, updatedContent: String) {
//        self = original
//        self.content = updatedContent
//    }
}
