//
//  CommonViewModel.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/30.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel: NSObject {
    let title: Driver<String>  //navigation item Title
    let sceneCoordinator: SceneCoordinatorType
    let storage: RoutineStorageType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: RoutineStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
