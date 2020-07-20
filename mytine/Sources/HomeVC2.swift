//
//  HomeVC2.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/17.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class HomeVC2: UIViewController {
    var todayData = 15
    var routineList = ["혜연 케어", "애리 케어", "재환 케어", "승희 케어", "유진 케어", "수빈 케어", "남수 케어"]
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    @IBAction func showEditing(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
    }
}
extension HomeVC2: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "다했다 !!!!") { (action, view, bool) in
            print("루틴 완료")
        }
        doneAction.backgroundColor = UIColor.mainGreen
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
}
extension HomeVC2: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if routineList.count == 0{
            tableView.setEmptyView(message: "등록한 루틴이 없습니다.", image: "")
        }else {
            tableView.restore()
        }
        return routineList.count
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.routineList[sourceIndexPath.row]
        routineList.remove(at: sourceIndexPath.row)
        routineList.insert(movedObject, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCVCell", for: indexPath) as! CheckCVCell
            if indexPath.row == 0 {
                cell.checkBtn[0].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .topLeft, secondCorner: .topRight)
                cell.checkBtn[1].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .topLeft, secondCorner: .topRight)
                cell.checkBtn[2].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .topLeft, secondCorner: .topRight)
                cell.checkBtn[3].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .topLeft, secondCorner: .topRight)
                cell.checkBtn[4].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .topLeft, secondCorner: .topRight)
                cell.checkBtn[5].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .topLeft, secondCorner: .topRight)
                cell.checkBtn[6].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .topLeft, secondCorner: .topRight)
            }
            else if indexPath.row == routineList.count-1{
                cell.checkBtn[0].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .bottomLeft, secondCorner: .bottomRight)
                cell.checkBtn[1].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .bottomLeft, secondCorner: .bottomRight)
                cell.checkBtn[2].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .bottomLeft, secondCorner: .bottomRight)
                cell.checkBtn[3].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .bottomLeft, secondCorner: .bottomRight)
                cell.checkBtn[4].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .bottomLeft, secondCorner: .bottomRight)
                cell.checkBtn[5].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .bottomLeft, secondCorner: .bottomRight)
                cell.checkBtn[6].viewRoundedCustom(cornerRadius: 10, borderColor: UIColor.gray, firstCorner: .bottomLeft, secondCorner: .bottomRight)
            }
            else {
                cell.checkBtn[0].viewBorder(borderColor: UIColor.lightGray, borderWidth: 0.5)
                cell.checkBtn[1].viewBorder(borderColor: UIColor.lightGray, borderWidth: 0.5)
                cell.checkBtn[2].viewBorder(borderColor: UIColor.lightGray, borderWidth: 0.5)
                cell.checkBtn[3].viewBorder(borderColor: UIColor.lightGray, borderWidth: 0.5)
                cell.checkBtn[4].viewBorder(borderColor: UIColor.lightGray, borderWidth: 0.5)
                cell.checkBtn[5].viewBorder(borderColor: UIColor.lightGray, borderWidth: 0.5)
                cell.checkBtn[6].viewBorder(borderColor: UIColor.lightGray, borderWidth: 0.5)
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineTVCell", for: indexPath) as! RoutineTVCell
//            cell.numLabel.text = "\(indexPath.row+1)"
//            cell.listLabel.text = "\(routineList[indexPath.row])"
            return cell
        }
    }
}
