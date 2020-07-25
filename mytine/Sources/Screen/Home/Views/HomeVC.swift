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
    var dropDown: DropDown?
    private let downButton = UIButton()
    var weekList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var routineList: [String] = ["혜연 케어", "애리 케어", "재환 케어", "승희 케어", "유진 케어", "수빈 케어", "남수 케어", "허벅지 불타오르기", "오빠 괴롭히기"]
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dropView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDownButton()
        setListDropDown()
        setupTableView()
        //      self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //      self.navigationController?.navigationBar.shadowImage = UIImage()
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
    
    /// Left bar button Item
    @IBAction func showCalendar(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Right bar button Item
    @IBAction func addRoutine(_ sender: UIBarButtonItem) {
        let dvc = self.storyboard?.instantiateViewController(identifier: "EditVC") as! EditVC
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    /// Drop down button
    func setupTableView() {
        let nib = UINib(nibName: HomeRootineCVCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: HomeRootineCVCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setDownButton() {
        self.navigationController?.navigationBar.addSubview(downButton)
        downButton.setImage(UIImage(named: "icDownArrow"), for: .selected)
        downButton.setImage(UIImage(named: "icUpArrow"), for: .normal)
        downButton.clipsToBounds = true
        downButton.translatesAutoresizingMaskIntoConstraints = false
        downButton.addTarget(self, action: #selector(clickDownButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            downButton.leftAnchor.constraint(equalTo: (self.navigationController?.navigationBar.centerXAnchor)!, constant: 45),
            downButton.bottomAnchor.constraint(equalTo: (self.navigationController?.navigationBar.bottomAnchor)!, constant: -10),
            downButton.widthAnchor.constraint(equalToConstant: 24),
            downButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    @objc func clickDownButton(){
        downButton.isSelected = !downButton.isSelected
        if downButton.isSelected == true {
            self.dropDown?.reloadAllComponents()
            dropDown?.show()
        }
        else {
//            UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
//                self.downButton.transform = .identity
//                self.view.layoutIfNeeded()
//            })
        }
    }
    
    func setListDropDown(){
        let dropList : [String] = ["July.3-10", "July.11-18", "July.19-25"]
        dropDown = DropDown()
        dropDown?.anchorView = dropView
        self.dropDown?.cellHeight = 36
        self.dropDown?.backgroundColor = UIColor.white
        self.dropDown?.selectionBackgroundColor = UIColor.dropSelectColor
        DropDown.appearance().setupCornerRadius(10)
        dropDown?.dataSource = dropList
        dropDown?.bottomOffset = CGPoint(x: 0, y:(dropDown?.anchorView?.plainView.bounds.height)!+6)
        dropDown?.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.textAlignment = .center
            cell.optionLabel.font = UIFont(name: "Montserrat-Bold", size: 17)
        }
    }
}
// MARK:- 요일별 루틴 체크 collection view
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
// MARK:- 일별 루틴 체크 table view
extension HomeVC: UITableViewDelegate {
    
}
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return routineList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "WeekTVCell", for: indexPath) as! WeekTVCell
//            cell.weekLabel.text = weekList[indexPath.row]
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekTVCell", for: indexPath) as? WeekTVCell else {
                return .init()
            }
            cell.bind()
            
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
        if indexPath.section == 1 {
            let doneAction = UIContextualAction(style: .normal, title: "함") { (action, view, bool) in
                print("루틴 완료")
            }
            doneAction.backgroundColor = UIColor.doneColor
            
            return UISwipeActionsConfiguration(actions: [doneAction])
        }
        else {
            return UISwipeActionsConfiguration.init()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 1 {
            let cancelAction = UIContextualAction(style: .normal, title: "취소") { (action, view, bool) in
                //            let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineTVCell", for: indexPath) as! RoutineTVCell
                //            cell.backView.backgroundColor = .lightGray
                print("완료 취소")
            }
            cancelAction.backgroundColor = UIColor.doneColor
            return UISwipeActionsConfiguration(actions: [cancelAction])
        }
        else {
            return UISwipeActionsConfiguration.init()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 400
        } else {
            return 75
        }
    }
}
