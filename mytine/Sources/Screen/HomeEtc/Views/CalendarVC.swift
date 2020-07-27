//
//  CalendarVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/10.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

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
