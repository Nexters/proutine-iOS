//
//  MemoryStorage.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/30.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation
import RxSwift

class MemoryStorage: RoutineStorageType {
    private var list = [
        Routine(id: 1, emoji: "😈", title: "루키케어", goal: "", repeatDays: [1,1,1,1,1,1,1], count: 1),
        Routine(id: 2, emoji: "🏃‍♀️", title: "운동", goal: "허벅지 불태우기", repeatDays: [1,0,1,0,1,0,0], count: 1)
    ]
    
    private lazy var store = BehaviorSubject<[Routine]>(value: list)
    
    @discardableResult
    func createRoutine(content: String) -> Observable<Routine> {
        let routine = Routine(id: 3, emoji: "🎅", title: "수염 관리", goal: "", repeatDays: [0,0,0,0,0,0,1], count: 1)
        list.insert(routine, at: 0)
        
        store.onNext(list)
        
        return Observable.just(routine)
    }
    
    @discardableResult
    func routineList() -> Observable<[Routine]> {
        return store
    }
    
//    @discardableResult
//    func update(routine: Routine, content: String) -> Observable<Routine> {
//        let updated = Routine(original: routine, updatedContent: content)
//        
//        if let index = list.firstIndex(where: { $0 == routine }) {
//            list.remove(at: index)
//            list.insert(updated, at: index)
//        }
//        
//        store.onNext(list)
//        
//        return Observable.just(updated)
//    }
    
    @discardableResult
    func delete(routine: Routine) -> Observable<Routine> {
        if let index = list.firstIndex(where: { $0 == routine}) {
            list.remove(at: index)
        }
        
        store.onNext(list)
        
        return Observable.just(routine)
    }
}
