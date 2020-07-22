//
//  HomeVC3.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/19.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit
import DropDown

class HomeVC: UIViewController {
    var array: NSArray?
    var index: IndexPath?
    // var dropDown: DropDown?
    var weekList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var routineList: [String] = []
    
    @IBOutlet var tableView: UITableView!
    // @IBOutlet var dropView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        let popup = self.storyboard?.instantiateViewController(identifier: "HomePopVC") as! HomePopVC
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    @IBAction func showCalendar(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addRoutine(_ sender: UIBarButtonItem) {
        let dvc = self.storyboard?.instantiateViewController(identifier: "EditVC") as! EditVC
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    
//    func setListDropDown(){
//        let dropList : [String] = ["1주차", "2주차", "3주차", "4주차", "5주차"]
//        dropDown = DropDown()
//        dropDown?.anchorView = dropView
//        // self.dropDown?.width = 168
//        self.dropDown?.backgroundColor = UIColor.white
//        self.dropDown?.selectionBackgroundColor = UIColor.dropSelectColor
//        self.dropDown?.cellHeight = 36
//        self.dropDown?.viewBorder(borderColor: .lightGray, borderWidth: 1)
//        DropDown.appearance().setupCornerRadius(10)
//        dropDown?.dataSource = dropList
//        dropDown?.bottomOffset = CGPoint(x: 0, y:(dropDown?.anchorView?.plainView.bounds.height)!+6)
//        dropDown?.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
//            cell.optionLabel.textAlignment = .center
//        }
//    }
}
extension HomeVC: UICollectionViewDelegate {
    
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            if routineList.count == 0 {
                tableView.setEmptyView(message: "새로운 루틴을 함께\n등록하러 가볼까요?", label: "루틴 등록하기")
            }else {
                tableView.restore()
            }
        }
        return routineList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCVCell", for: indexPath) as! WeekCVCell
        
        return cell
    }
}
extension HomeVC: UITableViewDelegate {
    
}
extension HomeVC: UITableViewDataSource {
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
            
            cell.viewRounded(cornerRadius: 10)
            //            cell.timeLabel.text =
            cell.listLabel.text = routineList[indexPath.row]
            //            cell.iconLabel.text =
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TabTVCell")
            
            return cell
        }
        else {
            let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
            let myView = UIView(frame: rect)
            return myView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "함") { (action, view, bool) in
            print("루틴 완료")
        }
        doneAction.backgroundColor = UIColor.doneColor
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cancelAction = UIContextualAction(style: .normal, title: "취소") { (action, view, bool) in
            self.view.viewRounded(cornerRadius: 10)
            print("완료 취소")
        }
        cancelAction.backgroundColor = UIColor.doneColor
        return UISwipeActionsConfiguration(actions: [cancelAction])
    }
}
