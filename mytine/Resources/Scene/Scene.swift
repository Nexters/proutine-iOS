//
//  Scene.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/29.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

/// 앱에서 구현할 Scene과 연관된 ViewModel을 연관 값으로 저장
enum Scene {
    case list(RoutineListViewModel)
}

/// 스토리보드의 Scene을 생성하고 연관 값에 저장된 ViewModel을 binding해서 return
extension Scene {
    func instantiate(from storyboard: String = "Home") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "RoutineNav") as? UINavigationController else {
                fatalError()
            }
            guard var routineVC = nav.viewControllers.first as? RoutineVC else {
                fatalError()
            }
            
            routineVC.bind(viewModel: viewModel)
            return nav
        }
    }
}
