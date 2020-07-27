//
//  HomeRootineViewController.swift
//  mytine
//
//  Created by 남수김 on 2020/07/25.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class HomeRootineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    func testWeek() {
//        FMDBManager.shared.createTable()
//        FMDBManager.shared.addWeek()
//
//        print("select all------")
//        FMDBManager.shared.selectWeekRootine(week: 0)
//        print("update")
//        FMDBManager.shared.updateWeekRootine(rootinesList: [3,2,3,4], week: 2)
//        print("select------")
//        FMDBManager.shared.selectWeekRootine(week: 2)
//    }
//
//    func testRootine() {
//         루틴생성
//        let mockRootine1 = Rootine(id: -1, emoji: "😳", title: "타이틀1", goal: "목표1", repeatDays: [1,1,0,0,0,0,0], count: 2)
//        var mockRootine2 = Rootine(id: 2, emoji: "🏀", title: "타이틀2", goal: "목표2", repeatDays: [1,0,0,0,1,0,1], count: 0)
//        FMDBManager.shared.createRootine(rootine: mockRootine1)
//        FMDBManager.shared.createRootine(rootine: mockRootine2)
//
//         루틴조회
//        print("-----select---------")
//        FMDBManager.shared.selectRootine(id: 0)
//        mockRootine2.count = 0
//
//         루틴수정
//        print("------update--------")
//        FMDBManager.shared.updateRootine(rootine: mockRootine2)
//        print("-------select-------")
//        FMDBManager.shared.selectRootine(id: 0)
//
//         루틴제거
//        print("------delete--------")
//        FMDBManager.shared.deleteRootine(id: 1)
//        print("-------select-------")
//        FMDBManager.shared.selectRootine(id: 0)
//    }
//
//    func testDay() {
//         일루틴생성
//        let mockDay1 = DayRootine(id: "20200721", retrospect: "회고를적기", week: 1, complete: [1,1,0])
//        var mockDay2 = DayRootine(id: "20200723", retrospect: "회고를적기2", week: 2, complete: [1,0,0,0])
//        FMDBManager.shared.createDayRootine(rootine: mockDay1)
//        FMDBManager.shared.createDayRootine(rootine: mockDay2)
//        FMDBManager.shared.selectDayRootine(week: 0)
//
//         일루틴수정
//        print("-----update-----")
//        mockDay2.complete = [1,1,1,0]
//        FMDBManager.shared.updateDayRootine(rootine: mockDay2)
//        FMDBManager.shared.selectDayRootine(week: 0)
//    }
    
    
    func setupCollectionView() {
        let nib = UINib(nibName: HomeRootineCVCell.nibName, bundle: nil)
//        rootineCollectionView.register(nib, forCellWithReuseIdentifier: HomeRootineCVCell.reuseIdentifier)
//        rootineCollectionView.dataSource = self
//        rootineCollectionView.delegate = self
    }
}
//
//extension HomeRootineViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRootineCVCell.reuseIdentifier, for: indexPath) as? HomeRootineCVCell else {
//            return .init()
//        }
//        cell.bind()
//        return cell
//    }
//
//}
//
//extension HomeRootineViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //TODO: 요일넓이 + 루틴갯수 * 루틴한칸넓이
//        return CGSize(width: 600, height: 400)
//    }
//}
