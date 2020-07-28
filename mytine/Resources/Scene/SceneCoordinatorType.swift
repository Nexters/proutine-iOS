//
//  SceneCoordinatorType.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/29.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable
}
