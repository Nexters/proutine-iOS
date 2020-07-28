//
//  TransitionModel.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/29.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case modal
}

enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
