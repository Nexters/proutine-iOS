//
//  HomeVC3.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/19.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class HomeVC3: UIViewController {
    var array: NSArray?
    var weekList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var routineList = ["혜연 케어", "애리 케어", "재환 케어", "승희 케어", "유진 케어", "수빈 케어", "남수 케어", "허벅지 불타오르기", "오빠 괴롭히기"]
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let dvc = self.storyboard?.instantiateViewController(identifier: "HomePopVC") as! HomePopVC
        dvc.modalPresentationStyle = .overFullScreen
        dvc.modalTransitionStyle = .crossDissolve
        present(dvc, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
}
extension HomeVC3: UICollectionViewDelegate {
    
}

extension HomeVC3: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routineList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCVCell", for: indexPath) as! WeekCVCell
        
        return cell
    }
}
extension HomeVC3: UITableViewDelegate {
    
}
extension HomeVC3: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return weekList.count
        }else {
            return routineList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeekTVCell", for: indexPath) as! WeekTVCell
            
            cell.weekLabel.text = weekList[indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineTVCell", for: indexPath) as! RoutineTVCell
            
            //            cell.timeLabel.text =
            cell.listLabel.text = routineList[indexPath.row]
            //            cell.iconLabel.text =
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "WeekTVCell") as! WeekTVCell
//
//            cell.weekLabel.text = "월"
//
//            return cell
//        }
//        else {
//            let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
//            let myView = UIView(frame: rect)
//            return myView
//        }
//    }
}
