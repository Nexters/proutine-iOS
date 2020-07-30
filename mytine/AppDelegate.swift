//
//  AppDelegate.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/10.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let sb = UIStoryboard(name: "HomeRootine", bundle: .main)
        window?.rootViewController = sb.instantiateViewController(withIdentifier: "CalendarNC")
        return true
        
//        let storage = MemoryStorage()
//        let coordinator = SceneCoordinator(window: window!)
//        let listViewModel = RoutineListViewModel(title: "July.19-25", sceneCoordinator: coordinator, storage: storage)
//        let listScene = Scene.list(listViewModel)
//        coordinator.transition(to: listScene, using: .root, animated: false)
//
//        return true
    }
}

