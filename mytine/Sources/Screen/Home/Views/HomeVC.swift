//
//  HomeVC3.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/19.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

struct WeekRootineModel {
    let week: Int
    var rootinesIdx: String
    var dayRoutine: [DayRootine]
}

class HomeVC: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dropView: UIView!
    
    var array: NSArray?
    private let downButton = UIButton()
    var testList = ["가", "나", "다", "라", "마", "바", "가", "나", "다", "라", "마", "바","가", "나", "다", "라", "마", "바"]
    var weekRoutineList: [WeekRootine] = []
    var dayRoutineList: [DayRootine] = []
    var routineList: [Rootine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setDownButton()
        setupTableView()
        setupCollectionView()
        loadRoutineDB()
        dropView.layer.cornerRadius = 12
        dropView.layer.shadowColor = UIColor.darkGray.cgColor
        dropView.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        dropView.layer.shadowRadius = 4.0
        dropView.layer.shadowOpacity = 0.5
        // dropView.layer.shadowPath = UIBezierPath(roundedRect: tableView.bounds, cornerRadius: 12).cgPath
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.mainFont,
         NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Bold", size: 17)!]
    }
    
    func setDownButton() {
        self.navigationController?.navigationBar.addSubview(downButton)
        downButton.setImage(UIImage(named: "dropdown"), for: .normal)
        downButton.clipsToBounds = true
        downButton.translatesAutoresizingMaskIntoConstraints = false
        downButton.addTarget(self, action: #selector(clickDownButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            downButton.leftAnchor.constraint(equalTo: (self.navigationController?.navigationBar.centerXAnchor)!, constant: 65),
            downButton.bottomAnchor.constraint(equalTo: (self.navigationController?.navigationBar.bottomAnchor)!, constant: -10),
            downButton.widthAnchor.constraint(equalToConstant: 24),
            downButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        dropView.isHidden = true
    }
    
    func loadRoutineDB() {
        let user = UserDefaults.standard
        let today = user.integer(forKey: UserDefaultKeyName.recentEnter.getString)
        let thisWeek = user.integer(forKey: UserDefaultKeyName.recentWeek.getString)
        weekRoutineList = FMDBManager.shared.selectWeekRootine(week: thisWeek)
        dayRoutineList = FMDBManager.shared.selectDayRootine(week: thisWeek)
        routineList = FMDBManager.shared.selectRootine(id: 0)
        
        print("****** thisWeek: \(thisWeek)")
        print("****** weekRoutineList: \(weekRoutineList)")
        print("****** routineList: \(routineList)")
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
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc
    func clickDownButton() {
        downButton.isSelected = !downButton.isSelected
        if downButton.isSelected == true {
            dropView.isHidden = true
        } else {
            dropView.isHidden = false
        }
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
//MARK:- 월 화 수 목 금 토 일 collection view
extension HomeVC: UICollectionViewDelegate {
    
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCVCell.reuseIdentifier, for: indexPath) as? WeekCVCell else {
            return .init()
        }
        cell.weekLabel.text = WeekCVCell.weekList[indexPath.row]
        return cell
    }
}

//MARK:- 일별 루틴 체크 table view
extension HomeVC: UITableViewDelegate {
    
}
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if self.testList.count == 0 {
                tableView.setEmptyView(message: "상단에 추가버튼을 눌러\n새로운 루틴을 생성해보세요!", image: "dropdown")
            } else {
                tableView.restore()
            }
            return testList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekRootineTVCell.reuseIdentifier, for: indexPath) as? WeekRootineTVCell else {
                return .init()
            }
            cell.bind()
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTVCell.reuseIdentifier, for: indexPath) as? RoutineTVCell else {
                return .init()
            }
            
            cell.viewRounded(cornerRadius: 10)
            //            cell.timeLabel.text =
            cell.listLabel.text = testList[indexPath.row]
            //            cell.iconLabel.text =
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
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
        if indexPath.section == 1 {
            let doneAction = UIContextualAction(style: .normal, title: "함") { (action, view, bool) in
                print("루틴 완료")
            }
            // doneAction.image = UIImage(named: <#T##String#>)
            doneAction.backgroundColor = UIColor.subFont
            return UISwipeActionsConfiguration(actions: [doneAction])
        } else {
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
            // cancelAction.image = UIImage(named: <#T##String#>)
            cancelAction.backgroundColor = UIColor.subFont
            return UISwipeActionsConfiguration(actions: [cancelAction])
        } else {
            return UISwipeActionsConfiguration.init()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 75
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 30
        } else {
            return 75
        }
    }
}
