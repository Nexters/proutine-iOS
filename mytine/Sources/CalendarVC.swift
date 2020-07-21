//
//  CalendarVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/10.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class CalendarVC: UIViewController {
    var months = ["July", "August"]
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    @IBOutlet var calendarCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarCV.delegate = self
        calendarCV.dataSource = self
        calendarCV.allowsMultipleSelection = false
        let dvc = self.storyboard?.instantiateViewController(identifier: "HomeVC3") as! HomeVC3
        self.navigationController?.pushViewController(dvc, animated: false)
    }
}
extension CalendarVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dvc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC3") as! HomeVC3
        
        dvc.index = indexPath
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}
extension CalendarVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return months.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 31
        }else {
            return 31
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CheckCVCell", for: indexPath) as! CheckCVCell
        
        cell.dataLabel.text = String(indexPath.row+1)
        cell.checkLabel.text = "🟢"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let rect = CGRect(x: 10, y: 10, width: 100, height: 100)
        let view = UICollectionReusableView(frame: rect)
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CheckReusableView", for: indexPath) as! CheckReusableView
            if indexPath.section == 0 {
                headerView.monthLabel.text = months[0]
            } else {
                headerView.monthLabel.text = months[1]
            }
            return headerView
        default:
            return view
        }
    }
}
