//
//  RoutineListViewModel.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/29.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RoutineListViewModel: CommonViewModel {
    var routineList: Observable<[Routine]> {
        return storage.routineList()
    }
}
