//
//  CalendarVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/10.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit
//TODO: 달력 구현시 추가...
class CalendarVC: UIViewController {
    @IBOutlet var calendarCV: UICollectionView!
    
    private let calendar = CalendarManager(date: Date())
    private var dayCount = 0
    private var emptyDayCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        setupNavigation()
        setupMonth()
        setupCollectionView()
        
        FMDBManager.shared.selectWeekRootine(week: 0)
//        testWeek()
//        testDay()
    }
    
    func testWeek() {
        let mockDate1 = "20200703"
        let mockDate2 = "20200705"
        let mockDate3 = "20200706"
        let mockDate4 = "20200712"
        let mockDate5 = "20200713"
        let weekDay = mockDate1.simpleDateStringGetWeekDay()
        mockDate1.simpleDateStringCompareWeek(compare: mockDate2, weekDay: weekDay)
        mockDate1.simpleDateStringCompareWeek(compare: mockDate3, weekDay: weekDay)
        mockDate1.simpleDateStringCompareWeek(compare: mockDate4, weekDay: weekDay)
        mockDate1.simpleDateStringCompareWeek(compare: mockDate5, weekDay: weekDay)
    }
    
    func testDay() {
        //         일루틴생성
        let mockDay1 = DayRootine(id: "20200721", retrospect: "회고를적기", week: 1, complete: [1,1,0], rootinesState: [1,3,4])
        var mockDay2 = DayRootine(id: "20200723", retrospect: "회고를적기2", week: 2, complete: [1,0,0,0], rootinesState: [3,4,1])
        FMDBManager.shared.createDayRootine(rootine: mockDay1)
        FMDBManager.shared.createDayRootine(rootine: mockDay2)
        FMDBManager.shared.selectDayRootine(week: 0)
        
        //         일루틴수정
        print("-----update-----")
        mockDay2.complete = [1,1,1,0]
        mockDay2.rootinesState = [4,1,3]
        FMDBManager.shared.updateDayRootine(rootine: mockDay2)
        FMDBManager.shared.selectDayRootine(week: 0)
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 17)!]
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    func setupMonth() {
        emptyDayCount = Date.startWeekday(year: "2020", month: "07")-2
        dayCount = calendar.getDayOfMonth() + emptyDayCount
        calendarCV.reloadData()
    }
    
    func setupCollectionView() {
        calendarCV.delegate = self
        calendarCV.dataSource = self
        calendarCV.allowsMultipleSelection = false
    }
    
    
}
extension CalendarVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let dvc = storyboard.instantiateViewController(identifier: "HomeVC") as! HomeVC
        
        dvc.index = indexPath
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}
extension CalendarVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CheckCVCell", for: indexPath) as! CheckCVCell
        
        if indexPath.item > emptyDayCount-1 {
            cell.checkLabel.text = "🟢"
            let day = indexPath.item - emptyDayCount
            cell.dateLabel.text = "\(day+1)"
        } else {
            cell.checkLabel.text = "⚪️"
            cell.dateLabel.text = ""
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let rect = CGRect(x: 10, y: 10, width: 100, height: 100)
        let view = UICollectionReusableView(frame: rect)
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CheckReusableView", for: indexPath) as! CheckReusableView
                headerView.monthLabel.text = "7월"
            return headerView
        default:
            return view
        }
    }
}
