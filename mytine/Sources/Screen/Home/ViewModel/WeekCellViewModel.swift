//
//  WeekCellViewModel.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/30.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation
import RxCocoa

enum TableType {
    case weekHeader, dashboard, tabHeader, routine
}

class WeekCellViewModel {
    let week: Int
    let dayString: String
    let date: String
    let dayRoutine: BehaviorRelay<[DayRootine]> = .init(value: [])
    let isSelectObservable: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let routine: BehaviorRelay<[Rootine]> = .init(value: [])
    
    init(week: Int, dayString: String, date: String) {
        self.dayString = dayString
        self.date = date
        self.week = week
        fetchWeekRoutine()
    }
    
    func fetchWeekRoutine() {
         let weekInfo = FMDBManager.shared.selectWeekRootine(week: week)
        let indexs = weekInfo[0].rootinesIdx.components(separatedBy: .whitespacesAndNewlines)
        fetchRoutine(routineIndex: indexs)
    }
    
    func fetchRoutine(routineIndex: [String]) {
        routineIndex.forEach {
            if let id = Int($0) {
                let routine = FMDBManager.shared.selectRootine(id: id)
                self.routine.accept(self.routine.value + routine)
            }
        }
        
    }
}
