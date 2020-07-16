//
//  HomeVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/10.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    var routineList = ["혜연 케어", "애리 케어", "재환 케어", "승희 케어", "유진 케어", "수빈 케어", "남수 케어"]
    @IBOutlet var routineCV: UICollectionView!
    @IBOutlet var routineTV: UITableView!
    @IBOutlet var day1Label: UILabel!
    @IBOutlet var day2Label: UILabel!
    @IBOutlet var day3Label: UILabel!
    @IBOutlet var day4Label: UILabel!
    @IBOutlet var day5Label: UILabel!
    @IBOutlet var day6Label: UILabel!
    @IBOutlet var day7Label: UILabel!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routineCV.dataSource = self
        routineTV.dataSource = self
        routineTV.delegate = self
        setUI()
        collectionViewHeight.constant = CGFloat(50 * routineList.count)
        tableViewHeight.constant =  self.view.frame.size.height - (80 + 60) - CGFloat((50 * routineList.count))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let index = routineTV.indexPathForSelectedRow {
            routineTV.deselectRow(at: index, animated: true)
        }
    }
    
    func setUI() {
        day1Label.viewRounded(cornerRadius: 5)
        day2Label.viewRounded(cornerRadius: 5)
        day3Label.viewRounded(cornerRadius: 5)
        day4Label.viewRounded(cornerRadius: 5)
        day5Label.viewRounded(cornerRadius: 5)
        day6Label.viewRounded(cornerRadius: 5)
        day7Label.viewRounded(cornerRadius: 5)
    }
}
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7 * routineList.count * 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let checkCell = routineCV.dequeueReusableCell(withReuseIdentifier: "CheckCell", for: indexPath)
        checkCell.viewRounded(cornerRadius: 5)
        return checkCell
    }
}
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            if routineList.count == 0{
                routineTV.setEmptyView(message: "등록한 루틴이 없습니다.", image: "")
            }else {
                routineTV.restore()
            }
            return routineList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let dateCell = routineTV.dequeueReusableCell(withIdentifier: "DateCell")
            return dateCell!
        }
        else {
            let listCell = routineTV.dequeueReusableCell(withIdentifier: "RoutineTVCell", for: indexPath) as! RoutineTVCell
            
            listCell.numLabel.text = "\(indexPath.row + 1)"
            listCell.listLabel.text = "\(routineList[indexPath.row])"
            
            return listCell
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            self.routineList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
}
extension HomeVC: UITableViewDelegate{
    //    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        let filterAction = UIContextualAction(style: .normal, title: "LEFT") { (action, view, bool) in
    //            print("Swiped to left filter")
    //        }
    //        filterAction.backgroundColor = UIColor.gray
    //
    //        return UISwipeActionsConfiguration(actions: [filterAction])
    //    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "다했다 !!!!") { (action, view, bool) in
            print("루틴 완료")
            tableView.deleteRows(at: [indexPath], with: .fade)
            //
            self.routineList.remove(at: indexPath.row)
        }
        doneAction.backgroundColor = UIColor.mainGreen
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
}
