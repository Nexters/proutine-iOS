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
    }
    
    func checkWeek() {
        
        
        if let firstDate = UserDefaults.standard.string(forKey: UserDefaultKeyName.firstEnter.getString) {
            let beforeRecentDate = UserDefaults.standard.string(forKey: UserDefaultKeyName.recentEnter.getString)
            
        } else {
            UserDefaults.standard.set(Date().makeRootineId(),
                                      forKey: UserDefaultKeyName.firstEnter.getString)
        }
        
        let newRecentDate = Date().makeRootineId()
                   UserDefaults.standard.set(newRecentDate,
                                             forKey: UserDefaultKeyName.recentEnter.getString)
    }
    
}

