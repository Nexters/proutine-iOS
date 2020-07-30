//
//  RoutineListViewModel.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/29.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeViewModel {
    let weekCellModel: BehaviorRelay<[WeekCellViewModel]> = .init(value: [])
    
    func bind() {
        let mockWeekList = [
            WeekCellViewModel(week: 1, dayString: "월", date: "1"),
            WeekCellViewModel(week: 1, dayString: "월", date: "2"),
            WeekCellViewModel(week: 1, dayString: "월", date: "3"),
            WeekCellViewModel(week: 1, dayString: "월", date: "4"),
            WeekCellViewModel(week: 1, dayString: "월", date: "5"),
            WeekCellViewModel(week: 1, dayString: "월", date: "6"),
            WeekCellViewModel(week: 1, dayString: "월", date: "7"),
            WeekCellViewModel(week: 1, dayString: "월", date: "8"),
            WeekCellViewModel(week: 1, dayString: "월", date: "9"),
            WeekCellViewModel(week: 1, dayString: "월", date: "7"),
            WeekCellViewModel(week: 1, dayString: "월", date: "7"),
            WeekCellViewModel(week: 1, dayString: "월", date: "7"),
            WeekCellViewModel(week: 1, dayString: "월", date: "7"),
            WeekCellViewModel(week: 1, dayString: "월", date: "7")
        ]
        
        weekCellModel.accept(mockWeekList)
    }
}
