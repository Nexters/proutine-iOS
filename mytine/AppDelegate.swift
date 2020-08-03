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
        checkWeek()
        print("현재 저장된 루틴::::::::")
        FMDBManager.shared.selectRootine(id: 0)
        print()
        print("현재 저장된 주차::::::::")
        FMDBManager.shared.selectWeekRootine(week: 0)
        print()
        print("현재 저장된 날::::::::")
        FMDBManager.shared.selectDayRootine(week: 0)
        
        print()
        print("::::::::::::App:::::::::::::::::")
        print("::::::::::::Open::::::::::::::::")

        let storyboard = UIStoryboard(name: "Home", bundle: .main)
        window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "HomeNav")

        return true
    }
    
    func checkWeek() {
        // 첫번째접속이아닌경우
        if let firstDate    // 처음접속날짜
            = UserDefaults.standard.string(forKey: UserDefaultKeyName.firstEnter.getString),
            let beforeRecentDate    // 최근접속날짜
            = UserDefaults.standard.string(forKey: UserDefaultKeyName.recentEnter.getString) {
            let beforeRecentWeek    // 최근주차
                = UserDefaults.standard.integer(forKey: UserDefaultKeyName.recentWeek.getString)
            
            let beforeRecentWeekDay = beforeRecentDate.simpleDateStringGetWeekDay()
            let newRecentDate = Date().makeRootineId()
            let week = firstDate.simpleDateStringCompareWeek(compare: newRecentDate,
                                                                    weekDay: beforeRecentWeekDay)
            
            let distance = week - beforeRecentWeek
            // 차이나는 주차만큼 WeekRootine생성
            if distance > 0 {
                let weekRootine = FMDBManager.shared.selectWeekRootine(week: beforeRecentWeek)
                // 주차 차이나는만큼 추가
                for _ in 0..<distance {
                    _ = FMDBManager.shared.addWeek(rootineIdx: weekRootine[0].rootinesIdx)
                }
            }
            print("firstDate - \(firstDate)")
            print("beforeRecentDate - \(beforeRecentDate)")
            print("beforeRecentWeek - \(beforeRecentWeek)")
            print("week - \(week)주차")
            print("distance - \(distance)차이")
            UserDefaults.standard.set(week,
                                      forKey: UserDefaultKeyName.recentWeek.getString)
            UserDefaults.standard.set(newRecentDate,
                                      forKey: UserDefaultKeyName.recentEnter.getString)
        } else {
            // 처음 들어올때 실행
            let newRecentDate = Date().makeRootineId()
            UserDefaults.standard.set(newRecentDate,
                                      forKey: UserDefaultKeyName.firstEnter.getString)
            UserDefaults.standard.set(newRecentDate,
                                      forKey: UserDefaultKeyName.recentEnter.getString)
            UserDefaults.standard.set(1,
                                      forKey: UserDefaultKeyName.recentWeek.getString)

            _ = FMDBManager.shared.createTable()
            _ = FMDBManager.shared.addWeek(rootineIdx: nil)
        }
    }
}
