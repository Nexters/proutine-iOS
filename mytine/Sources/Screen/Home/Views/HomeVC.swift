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
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dropView: UIView!
    
    var array: NSArray?
    var dropDown: DropDown?
    private let downButton = UIButton()
    var weekRoutineList: [WeekRootine] = []
    var dayRoutineList: [DayRootine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDownButton()
        setListDropDown()
        setupTableView()
        let user = UserDefaults.standard
        let thisWeek = user.integer(forKey: UserDefaultKeyName.recentWeek.getString)
        weekRoutineList = FMDBManager.shared.selectWeekRootine(week: thisWeek)
        dayRoutineList = FMDBManager.shared.selectDayRootine(week: thisWeek)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    func presentPopup() {
        guard let popup = self.storyboard?.instantiateViewController(identifier: "HomePopVC") as? HomePopVC else { return }
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true, completion: nil)
    }
    
    /// Drop down button
    func setupTableView() {
        let nib = UINib(nibName: WeekRootineTVCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: WeekRootineTVCell.reuseIdentifier)
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
            downButton.leftAnchor.constraint(equalTo: (self.navigationController?.navigationBar.centerXAnchor)!, constant: 65),
            downButton.bottomAnchor.constraint(equalTo: (self.navigationController?.navigationBar.bottomAnchor)!, constant: -10),
            downButton.widthAnchor.constraint(equalToConstant: 24),
            downButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc func clickDownButton() {
        downButton.isSelected = !downButton.isSelected
        if downButton.isSelected == true {
            self.dropDown?.reloadAllComponents()
            dropDown?.show()
        } else {
            //            UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            //                self.downButton.transform = .identity
            //                self.view.layoutIfNeeded()
            //            })
        }
    }
    
    func setListDropDown() {
        let dropList: [String] = ["7월 13일 - 7월 19일", "7월 20일 - 7월 26일", "7월 27일 - 8월 2일", "7월 27일 - 8월 2일", "7월 27일 - 8월 2일", "7월 27일 - 8월 2일"]
        dropDown = DropDown()
        dropDown?.anchorView = dropView
        self.dropDown?.cellHeight = 40
        self.dropDown?.backgroundColor = UIColor.white
        self.dropDown?.selectionBackgroundColor = UIColor.subFont
        DropDown.appearance().setupCornerRadius(10)
        dropDown?.dataSource = dropList
        dropDown?.bottomOffset = CGPoint(x: 0, y: (dropDown?.anchorView?.plainView.bounds.height)!+6)
        dropDown?.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.textAlignment = .center
            cell.optionLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        }
    }
    
    /// Left bar button Item
    @IBAction func showCalendar(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Right bar button Item
    @IBAction func addRoutine(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "HomeRootine", bundle: nil)
        guard let dvc = storyboard.instantiateViewController(identifier: "EditVC") as? EditVC else { return }
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}
//MARK:- 일별 루틴 체크 table view
extension HomeVC: UITableViewDelegate {
    
}
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        } else {
            if self.dayRoutineList.count == 0 {
                tableView.setEmptyView(message: "상단에 추가버튼을 눌러\n새로운 루틴을 생성해보세요!", image: "icDownArrow")
            } else {
                tableView.restore()
            }
            return dayRoutineList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekRootineTVCell.reuseIdentifier, for: indexPath) as? WeekRootineTVCell else {
                return .init()
            }
            cell.bind()
            
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTVCell.reuseIdentifier, for: indexPath) as? RoutineTVCell else {
                return .init()
            }
            
            cell.viewRounded(cornerRadius: 10)
            //            cell.timeLabel.text =
            // cell.listLabel.text = dayRoutineList[indexPath.row].
            //            cell.iconLabel.text =
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TouchCell") else {
                return .init()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TabTVCell.reuseIdentifier) as? TabTVCell else {
                return .init()
            }
            return cell
        } else {
            let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
            let myView = UIView(frame: rect)
            return myView
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 2 {
            let doneAction = UIContextualAction(style: .normal, title: "함") { (action, view, bool) in
                print("루틴 완료")
            }
            doneAction.backgroundColor = UIColor.subFont
            
            return UISwipeActionsConfiguration(actions: [doneAction])
        } else {
            return UISwipeActionsConfiguration.init()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 2 {
            let cancelAction = UIContextualAction(style: .normal, title: "취소") { (action, view, bool) in
                //            let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineTVCell", for: indexPath) as! RoutineTVCell
                //            cell.backView.backgroundColor = .lightGray
                print("완료 취소")
            }
            cancelAction.backgroundColor = UIColor.subFont
            return UISwipeActionsConfiguration(actions: [cancelAction])
        } else {
            return UISwipeActionsConfiguration.init()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2{
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 30
        } else if indexPath.section == 2 {
            return 75
        } else {
            return 20
        }
    }
}
