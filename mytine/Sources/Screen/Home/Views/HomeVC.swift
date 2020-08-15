//
//  HomeVC3.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/19.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

enum CellType {
    case routine, retrospect
}

struct WeekRootineModel {
    var weekRoutine: WeekRootine
    var dayRoutine: [DayRootine]
    var routine: [Rootine]
}

class HomeVC: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dropView: UIView!
    var isExpanded = true
    private let downButton = UIButton()
    private var allWeekRoutine: [WeekRootine] = []
    private var curWeekRoutineModel: WeekRootineModel?
    // cell reload시 cellIndex 0으로 다시 초기화해주기
    private var dayRoutineCellIndex: Int = 0
    private var cellType: CellType = .routine {
        didSet {
            tableView.reloadSections(.init(integer: 2), with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setDownButton()
        setupRoutine()
        setupTableView()
        setupCollectionView()
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
    
    func setupRoutine() {
        allWeekRoutine = FMDBManager.shared.selectWeekRootine(week: 0)
        guard let weekRoutine = allWeekRoutine.last else {
            return
        }
        
        loadRoutineDB(week: weekRoutine.week)
    }
    
    func loadRoutineDB(week: Int) {
        let weekRoutine = allWeekRoutine[week-1]
        let dayRoutine = FMDBManager.shared.selectDayRootine(week: week)
        let routines = weekRoutine.rootines().map{ FMDBManager.shared.selectRootine(id: $0)[0] }
        
        curWeekRoutineModel = WeekRootineModel(weekRoutine: weekRoutine,
                                               dayRoutine: dayRoutine,
                                               routine: routines)
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
        isExpanded = !isExpanded
        tableView.reloadSections(.init(integer: 0), with: .bottom)
    }
    
    /// Left bar button Item
    @IBAction func showCalendar(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Right bar button Item
    @IBAction func addRoutine(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "HomeRootine", bundle: nil)
        guard let dvc = storyboard.instantiateViewController(identifier: "EditVC") as? EditVC else { return }
        dvc.curWeekRoutine = curWeekRoutineModel
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
        
        guard let curWeekRoutine = curWeekRoutineModel else {
            return .init()
        }
        
        let startDay = curWeekRoutine.weekRoutine.weekString.components(separatedBy: " - ")[0]
        if !curWeekRoutine.dayRoutine.isEmpty {
            let curDayRoutine = curWeekRoutine.dayRoutine[dayRoutineCellIndex]
            if String(curDayRoutine.id) ==  startDay.afterDayString(addDay: indexPath.item) {
                cell.bind(model: curDayRoutine,
                          dayRoutineCount: Float(curWeekRoutine.routine.count),
                          index: indexPath.item)
                dayRoutineCellIndex += 1
            } else {
                let dayId = Int(startDay
                    .weekConvertToDayRoutineId()
                    .afterDayString(addDay: indexPath.item))
                cell.bind(model: DayRootine(id: dayId!,
                                            retrospect: "",
                                            week: curWeekRoutine.weekRoutine.week,
                                            complete: []),
                          dayRoutineCount: Float(curWeekRoutine.routine.count),
                          index: indexPath.item)
            }
        } else {
            let dayId = Int(startDay
                .weekConvertToDayRoutineId()
                .afterDayString(addDay: indexPath.item))
            cell.bind(model: DayRootine(id: dayId!,
                                        retrospect: "",
                                        week: curWeekRoutine.weekRoutine.week,
                                        complete: []),
                      dayRoutineCount: Float(curWeekRoutine.routine.count),
                      index: indexPath.item)
        }
        return cell
    }
}

//MARK:- 일별 루틴 체크 table view
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let storyboard = UIStoryboard.init(name: "HomeRootine", bundle: nil)
            guard let dvc = storyboard.instantiateViewController(withIdentifier: "EditVC") as? EditVC else { return }
            dvc.rootine = curWeekRoutineModel?.routine[indexPath.row]
            self.navigationController?.pushViewController(dvc, animated: true)
        }
    }
}
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let curWeekRoutine = curWeekRoutineModel else {
            return 0
        }
        
        if section == 0 {
            return (isExpanded) ? curWeekRoutine.weekRoutine.rootines().count : 0
        } else if section == 1 {
            return 1
        } else {
            if curWeekRoutine.weekRoutine.rootines().count == 0 {
                tableView.setEmptyView(message: "상단에 추가버튼을 눌러\n새로운 루틴을 생성해보세요!", image: "dropdown")
            } else {
                tableView.restore()
            }
            return curWeekRoutine.weekRoutine.rootines().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekRootineTVCell.reuseIdentifier, for: indexPath) as? WeekRootineTVCell else {
                return .init()
            }
            cell.bind(model: curWeekRoutineModel?.routine[indexPath.row], index: indexPath.row)
            
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TabTVCell.reuseIdentifier) as? TabTVCell else {
                return .init()
            }
            cell.homeDelegate = self
            cell.expandBtn.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
            return cell
        } else {
            if cellType == .routine {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTVCell.reuseIdentifier, for: indexPath) as? RoutineTVCell else {
                    return .init()
                }
                cell.bind()
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RetrospectTVCell.reuseIdentifier, for: indexPath) as? RetrospectTVCell else {
                    return .init(style: .default, reuseIdentifier: "")
                }
                cell.bind()
                return cell
            }
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
            return 54
        } else {
            return 75
        }
    }
}

extension HomeVC: HomeTabCellTypeDelegate {
    func clickRoutine() {
        self.cellType = .routine
    }
    
    func clickRetrospect() {
        self.cellType = .retrospect
    }
}
