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
        
        let dvc = self.storyboard?.instantiateViewController(identifier: "HomeVC3") as! HomeVC3
        self.navigationController?.pushViewController(dvc, animated: false)
    }
}
extension CalendarVC: UICollectionViewDelegate {
    
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
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CheckReusableView", for: indexPath) as! CheckReusableView
            headerView.monthLabel.text = months[indexPath.row]
            return headerView
        default:
            assert(false, "응 아니야")
        }
    }
}
