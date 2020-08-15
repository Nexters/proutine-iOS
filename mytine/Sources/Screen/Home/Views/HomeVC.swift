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
    var rootinesIdx: [Int]
    var dayRoutine: [DayRootine]
}

class HomeVC: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dropView: UIView!
    var isExpanded = true
    var weekRootineModel: WeekRootineModel!
    var array: NSArray?
    private let downButton = UIButton()
    var weekList = ["가", "나", "다", "라", "마", "바"]
    var weekOriginalList = ["가", "나", "다", "라", "마", "바"]
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
        dropView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
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
        // 1. 전체 주간 루틴 리스트 불러오기
        weekRoutineList = FMDBManager.shared.selectWeekRootine(week: 0)
        
        // 2. 가장 최신 주차로 해당 주차 불러오기
        guard let thisWeek = weekRoutineList.last else { return }
        
        weekRootineModel = WeekRootineModel(week: thisWeek.week, rootinesIdx: thisWeek.rootines(), dayRoutine: dayRoutineList)
        
        if thisWeek.week == 1 {
            // 2-1. 만약 이번주가 처음이라면 다 빈칸으로 띄우기
            
        } else if dayRoutineList.count == 0 {
            // 2-2. 처음은 아닌데 데이루틴이 없다면 rootinesIdx로 Rootine 리스트 불러오기
            dayRoutineList = FMDBManager.shared.selectDayRootine(week: thisWeek.week)
            for id in weekRootineModel.rootinesIdx {
                let rootine = FMDBManager.shared.selectRootine(id: id)
                routineList.append(contentsOf: rootine)
            }
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
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc
    func clickDownButton() {
        downButton.isSelected = !downButton.isSelected
        if downButton.isSelected == true {
            UIView.animate(withDuration: 0.3) {
                self.downButton.transform = CGAffineTransform(rotationAngle: .pi)
            }
            dropView.isHidden = true
        } else {
            UIView.animate(withDuration: 0.3) {
                self.downButton.transform = .identity
            }
            dropView.isHidden = false
        }
    }
    
    @objc
    func handleExpandClose(button: UIButton) {
        
        let indexPaths = (0...5).map { IndexPath(row: $0, section: 0) }
        isExpanded = !isExpanded
        
        if !isExpanded {
            self.weekRoutineList.removeAll()
            tableView.deleteRows(at: indexPaths, with: .bottom)
        } else {
            print("wanna insert \(isExpanded)")
            // TODO: weekRoutineList의 전역 데이터 선언한 뒤 바꿔줄 것
            // self.weekRoutineList = self.weekOriginalList
            tableView.insertRows(at: indexPaths, with: .top)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "HomeRootine", bundle: nil)
        guard let dvc = storyboard.instantiateViewController(withIdentifier: "EditVC") as? EditVC else { return }
        dvc.rootine = routineList[indexPath.row]
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (isExpanded) ? weekRoutineList.count : 0
        } else if section == 1 {
            return 1
        } else {
            if self.routineList.count == 0 {
                tableView.setEmptyView(message: "상단에 추가버튼을 눌러\n새로운 루틴을 생성해보세요!", image: "dropdown")
            } else {
                tableView.restore()
            }
            return routineList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekRootineTVCell.reuseIdentifier, for: indexPath) as? WeekRootineTVCell else {
                return .init()
            }
            cell.bind()
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TabTVCell.reuseIdentifier) as? TabTVCell else {
                return .init()
            }
            cell.expandBtn.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTVCell.reuseIdentifier, for: indexPath) as? RoutineTVCell else {
                return .init()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 2 {
            let doneAction = UIContextualAction(style: .normal, title: "") { (action, view, bool) in
                print("루틴 완료")
            }
            doneAction.image = UIImage(named: "complete")
            doneAction.backgroundColor = UIColor.subBlue
            view.alpha = 0.5
            return UISwipeActionsConfiguration(actions: [doneAction])
        } else {
            return UISwipeActionsConfiguration.init()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 2 {
            let cancelAction = UIContextualAction(style: .normal, title: "") { (action, view, bool) in
                print("완료 취소")
            }
            cancelAction.image = UIImage(named: "undo")
            cancelAction.backgroundColor = UIColor.subBlue
            view.alpha = 1.0
            return UISwipeActionsConfiguration(actions: [cancelAction])
        } else {
            return UISwipeActionsConfiguration.init()
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
