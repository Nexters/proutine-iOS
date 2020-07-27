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
        let tempString = complete.map{ String($0) }
        let result = tempString.joined(separator: " ")
        return result
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
