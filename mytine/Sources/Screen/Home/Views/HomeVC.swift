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
    @IBOutlet var navigationView: UIView!
    @IBOutlet var navigationTitle: UILabel!
    @IBOutlet var dropView: UIView!
    @IBOutlet var downButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    var isExpanded = true
    var dropdownIdx: Int = 0
    private var selectedIdx: Int = 0
    private var dayRoutineCellIndex: Int = 0  {
        didSet {
            if oldValue == 6 {
                self.dayRoutineCellIndex = 0
            }
        }
    }  // cell reload시 cellIndex 0으로 다시 초기화해주기
    private var allWeekRoutine: [WeekRootine] = []
    private var selectRoutine: [(Rootine, Bool)] = []
    private var curWeekRoutineModel: WeekRootineModel?
    private var cellType: CellType = .routine {
        didSet {
            tableView.reloadSections(.init(integer: 2), with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDropView()
        setupTableView()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        setupRoutine()
        tableView.reloadData()
        registerRoutinesNotifications()
        
        let todayIndex = Date().getWeekday() - 2
        let selectIndexPath = IndexPath(item: todayIndex, section: 0)
        collectionView.selectItem(at: selectIndexPath, animated: false, scrollPosition: .left)
        collectionView(collectionView, didSelectItemAt: selectIndexPath)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        unregisterRoutinesNotifications()
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        dropView.isHidden = true
    }
    
    func setDropView() {
        dropView.layer.cornerRadius = 12
        dropView.layer.shadowColor = UIColor.darkGray.cgColor
        dropView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        dropView.layer.shadowRadius = 4.0
        dropView.layer.shadowOpacity = 0.5
    }
    
    func setupRoutine() {
        allWeekRoutine = FMDBManager.shared.selectWeekRootine(week: 0)
        guard let weekRoutine = allWeekRoutine.last else {
            return
        }
        self.navigationTitle.text = allWeekRoutine.last?.weekString
        dropdownIdx = weekRoutine.week
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
    
    func registerRoutinesNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(routineComplete(_:)), name: .routineComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(routineUnComplete(_:)), name: .routineUnComplete, object: nil)
    }
    
    func unregisterRoutinesNotifications() {
        NotificationCenter.default.removeObserver(self, name: .routineComplete, object: nil)
        NotificationCenter.default.removeObserver(self, name: .routineUnComplete, object: nil)
    }
    
    @objc
    func handleExpandClose(button: UIButton) {
        isExpanded = !isExpanded
        tableView.reloadSections(.init(integer: 0), with: .bottom)
    }
    
    @objc
    func routineComplete(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: {
            let cell = notification.object as! RoutineTVCell
            cell.dimEffect()
        })
        
        guard var curWeekRoutine = self.curWeekRoutineModel else {
            return
        }
        let userInfo = notification.userInfo as! [String: Int]
        let index = userInfo["routineIndex"]
        curWeekRoutine.dayRoutine[self.selectedIdx].complete.append(self.selectRoutine[index!].0.id)
        _ = FMDBManager.shared.updateDayRootine(rootine: curWeekRoutine.dayRoutine[self.selectedIdx])
        self.loadRoutineDB(week: curWeekRoutine.weekRoutine.week)
    }
    
    @objc
    func routineUnComplete(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: {
            let cell = notification.object as! RoutineTVCell
            cell.reset()
        })
        
        guard var curWeekRoutine = self.curWeekRoutineModel else {
            return
        }
        let userInfo = notification.userInfo as! [String: Int]
        let index = userInfo["shouldRemoveIndex"]
        curWeekRoutine.dayRoutine[self.selectedIdx].complete.remove(at: index!)
        _ = FMDBManager.shared.updateDayRootine(rootine: curWeekRoutine.dayRoutine[self.selectedIdx])
        self.loadRoutineDB(week: curWeekRoutine.weekRoutine.week)
    }
    
    @IBAction func clickDownButton(_ sender: UIButton) {
        downButton.isSelected = !downButton.isSelected
        if downButton.isSelected == true {
            UIView.animate(withDuration: 0.3) {
                self.downButton.transform = CGAffineTransform(rotationAngle: .pi)
            }
            dropView.isHidden = false
        } else {
            UIView.animate(withDuration: 0.3) {
                self.downButton.transform = .identity
            }
            dropView.isHidden = true
            loadRoutineDB(week: dropdownIdx)
            dayRoutineCellIndex = 0
            tableView.reloadData()
        }
    }
    
    /// Right bar button Item
    @IBAction func addRoutine(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "HomeRootine", bundle: nil)
        guard let dvc = storyboard.instantiateViewController(identifier: "EditVC") as? EditVC else { return }
        dvc.curWeekRoutine = curWeekRoutineModel
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}
//MARK:- 월 화 수 목 금 토 일 collection view
extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectRoutine.removeAll()
        selectedIdx = indexPath.row
        guard let curWeekRoutine = curWeekRoutineModel else {
            return
        }
        
        // 1이면 반복, 0이면 반복 X
        for index in curWeekRoutine.routine.indices {
            if curWeekRoutine.routine[index].repeatDays[indexPath.row] == 1 {
                selectRoutine.append((curWeekRoutine.routine[index], false))
            }
            let completeList = curWeekRoutine.dayRoutine[indexPath.row].complete
            if !completeList.isEmpty {
                var tempList: [(Rootine, Bool)] = []
                
                for index in completeList.indices {
                    if completeList.contains(selectRoutine[index].0.id) {
                        tempList.append((selectRoutine[index].0, true))  // 완료한 루틴들
                        selectRoutine.remove(at: index)        // 완료하지 않은 루틴들만 남음
                    }
                }
                selectRoutine += tempList
            }
        }
        print("selectRoutine", selectRoutine)
        tableView.reloadData()
    }
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
        var dayCount = 0
        curWeekRoutine.routine.forEach {
            if $0.repeatDays[indexPath.item] == 1 {
                dayCount += 1
            }
        }
        
        let startDay = curWeekRoutine.weekRoutine.weekString.components(separatedBy: " - ")[0]
        if !curWeekRoutine.dayRoutine.isEmpty {
            let curDayRoutine = curWeekRoutine.dayRoutine[dayRoutineCellIndex]
            if String(curDayRoutine.id) == startDay.weekConvertToDayRoutineId().afterDayString(addDay: indexPath.item) {
                cell.bind(model: curDayRoutine,
                          dayRoutineCount: Float(dayCount),
                          index: indexPath.item)
            } else {
                let dayId = Int(startDay
                    .weekConvertToDayRoutineId()
                    .afterDayString(addDay: indexPath.item))
                cell.bind(model: DayRootine(id: dayId!,
                                            retrospect: "",
                                            week: curWeekRoutine.weekRoutine.week,
                                            complete: []),
                          dayRoutineCount: Float(dayCount),
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
                      dayRoutineCount: Float(dayCount),
                      index: indexPath.item)
        }
        dayRoutineCellIndex += 1
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
            if selectRoutine.count == 0 {
                tableView.setEmptyView(message: "상단에 추가버튼을 눌러\n새로운 루틴을 생성해보세요!", image: "")
            } else {
                tableView.restore()
            }
            return selectRoutine.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekRootineTVCell.reuseIdentifier, for: indexPath) as? WeekRootineTVCell else {
                return .init()
            }
            cell.bind(model: curWeekRoutineModel?.routine[indexPath.row], index: indexPath.row, dayId: curWeekRoutineModel?.dayRoutine[0].id)
            
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
                let model = selectRoutine[indexPath.row]
                cell.bind(routine: model.0, isCompleted: model.1)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RetrospectTVCell.reuseIdentifier, for: indexPath) as? RetrospectTVCell else {
                    return .init(style: .default, reuseIdentifier: "")
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 2 && cellType == .routine {
            let doneAction = UIContextualAction(style: .normal, title: "") { (action, view, bool) in
                guard let curWeekRoutine = self.curWeekRoutineModel else {
                    return
                }
                guard let cell = tableView.cellForRow(at: indexPath) as? RoutineTVCell else {
                    return
                }
                let dayRoutine = curWeekRoutine.dayRoutine[self.selectedIdx]
                if !dayRoutine.complete.contains(self.selectRoutine[indexPath.row].0.id) {
                    NotificationCenter.default.post(name: .routineComplete, object: cell, userInfo: ["routineIndex": indexPath.row, "dayId": dayRoutine.id])
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
                self.collectionView.reloadData()
            }
            doneAction.image = UIImage(named: "complete")
            doneAction.backgroundColor = UIColor.subBlue
            return UISwipeActionsConfiguration(actions: [doneAction])
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 2 {
            let cancelAction = UIContextualAction(style: .normal, title: "") { (action, view, bool) in
                guard let curWeekRoutine = self.curWeekRoutineModel else {
                    return
                }
                guard let cell = tableView.cellForRow(at: indexPath) as? RoutineTVCell else {
                    return
                }
                let dayRoutine = curWeekRoutine.dayRoutine[self.selectedIdx]
                if let index = dayRoutine.complete.firstIndex(of: self.selectRoutine[indexPath.row].0.id) {
                    NotificationCenter.default.post(name: .routineUnComplete, object: cell, userInfo: ["shouldRemoveIndex": index, "dayId": dayRoutine.id])
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
                self.collectionView.reloadData()
            }
            cancelAction.image = UIImage(named: "undo")
            cancelAction.backgroundColor = UIColor.subBlue
            return UISwipeActionsConfiguration(actions: [cancelAction])
        } else {
            return nil
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
