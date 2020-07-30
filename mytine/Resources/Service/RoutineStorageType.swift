//
//  RoutineStorageType.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/30.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation
import RxSwift

protocol RoutineStorageType {
    ///CRUD 처리 메소드 선언
    //구독자가 원하는 방식으로 작업 결과 처리 가능, 작업 결과가 필요 없는 경우도 있기 때문에 추가
    @discardableResult
    func createRoutine(content: String) -> Observable<Routine>
    
    @discardableResult
    func routineList() -> Observable<[Routine]>
    
//    @discardableResult
//    func update(routine: Routine, content: String) -> Observable<Routine>
    
    @discardableResult
    func delete(routine: Routine) -> Observable<Routine>
}
