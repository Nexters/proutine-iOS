//
//  HomeVC.swift
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
    @IBOutlet var downButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dropView: UIView!
    @IBOutlet var dropTableView: UITableView!
    var isExpanded = true
    var dropdownIdx: Int?
    var keyboardHeight: CGFloat = .zero
    private var messageLabel: UILabel!
    private var selectedIdx: Int = 0
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
        setUI()
        setupRoutine(week: 0)
        setupTableView()
        setupCollectionView()
        setDropView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let curWeekRoutine = self.curWeekRoutineModel else {
            return
        }
        setupRoutine(week: curWeekRoutine.weekRoutine.week)
        setNavigationBar()
        tableView.reloadData()
        collectionView.reloadData()
        registerRoutinesNotifications()
        
        var todayIndex = Date().getWeekday() - 2
        if todayIndex == -1 {
            todayIndex = 6
        }
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
    }
    
    func setUI() {
        messageLabel = {
            let label = UILabel()
            label.tag = 100
            label.text = "회고가 저장되었습니다."
            label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10)
            label.textAlignment = NSTextAlignment.center
            label.textColor = .mainBlue
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    }
    
    func setDropView() {
        dropView.isHidden = true
        dropTableView.viewRounded(cornerRadius: 12)
        dropView.layer.cornerRadius = 12
        dropView.layer.shadowColor = UIColor.darkGray.cgColor
        dropView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        dropView.layer.shadowRadius = 4.0
        dropView.layer.shadowOpacity = 0.5
    }
    
    func setupRoutine(week: Int) {
        allWeekRoutine = FMDBManager.shared.selectWeekRootine(week: 0)
        
        guard let weekRoutine = allWeekRoutine.last else {
            return
        }
        
        // week : 0 가장 처음, 최신 꺼 로드
        if week == weekRoutine.week || week == 0 {
            loadRoutineDB(week: weekRoutine.week)
            dropdownIdx = weekRoutine.week
        } else {
            loadRoutineDB(week: week)
            dropdownIdx = week
        }
    }
    
    func loadRoutineDB(week: Int) {
        let weekRoutine = allWeekRoutine[week-1]
        let dayRoutine = FMDBManager.shared.selectDayRootine(week: week)
        let routines = weekRoutine.rootines().map{ FMDBManager.shared.selectRootine(id: $0)[0] }
        
        curWeekRoutineModel = WeekRootineModel(weekRoutine: weekRoutine,
                                               dayRoutine: dayRoutine,
                                               routine: routines)
        
        self.navigationTitle.text = weekRoutine.weekString
    }
    
    func presentPopup() {
        guard let popup = self.storyboard?.instantiateViewController(identifier: "HomePopVC") as? HomePopVC else { return }
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true, completion: nil)
    }
    
    func setupTableView() {
        let nib = UINib(nibName: WeekRootineTVCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: WeekRootineTVCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        dropTableView.delegate = self
        dropTableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func registerRoutinesNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(routineComplete(_:)), name: .routineComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(routineUnComplete(_:)), name: .routineUnComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unregisterRoutinesNotifications() {
        NotificationCenter.default.removeObserver(self, name: .routineComplete, object: nil)
        NotificationCenter.default.removeObserver(self, name: .routineUnComplete, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc
    func keyboardHide() {
        view.endEditing(true)
    }
    
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
    }
    
    @objc
    func handleExpandClose(button: UIButton) {
        isExpanded = !isExpanded
        tableView.reloadSections(.init(integer: 0), with: .none)
    }
    
    @objc
    func routineComplete(_ notification: NSNotification) {
        guard var curWeekRoutine = self.curWeekRoutineModel else {
            return
        }
        let userInfo = notification.userInfo as! [String: Int]
        let routineId = userInfo["routineIndex"]
        let indexPath = userInfo["indexPath"]
        
        if !curWeekRoutine.dayRoutine[self.selectedIdx].complete.contains(routineId!) {
            selectRoutine[indexPath!].1 = true
            curWeekRoutine.dayRoutine[self.selectedIdx].complete.append(routineId!)
            _ = FMDBManager.shared.updateDayRootine(rootine: curWeekRoutine.dayRoutine[self.selectedIdx])
            setupRoutine(week: curWeekRoutine.weekRoutine.week)
        }
    }
    
    @objc
    func routineUnComplete(_ notification: NSNotification) {
        guard var curWeekRoutine = self.curWeekRoutineModel else {
            return
        }
        let userInfo = notification.userInfo as! [String: Int]
        let routineId = userInfo["shouldRemoveIndex"]
        let indexPath = userInfo["indexPath"]
        
        if let index = curWeekRoutine.dayRoutine[self.selectedIdx].complete.firstIndex(of: routineId!) {
            selectRoutine[indexPath!].1 = false
            curWeekRoutine.dayRoutine[self.selectedIdx].complete.remove(at: index)
            _ = FMDBManager.shared.updateDayRootine(rootine: curWeekRoutine.dayRoutine[self.selectedIdx])
            setupRoutine(week: curWeekRoutine.weekRoutine.week)
        }
    }
    
    @IBAction func clickDownButton(_ sender: UIButton) {
        downButton.isSelected = true
        if downButton.isSelected == true {
            UIView.animate(withDuration: 0.3) {
                self.downButton.transform = CGAffineTransform(rotationAngle: .pi)
            }
            dropView.isHidden = false
        }
    }
    
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
        let cell = collectionView.cellForItem(at: .init(item: selectedIdx, section: 0))
        cell?.isSelected = false
        
        selectRoutine.removeAll()
        selectedIdx = indexPath.row
        guard let curWeekRoutine = curWeekRoutineModel else {
            return
        }
        
        var tempList: [(Rootine, Bool)] = []
        
        for index in curWeekRoutine.routine.indices where curWeekRoutine.routine[index].repeatDays[indexPath.row] == 1 {
            if (!curWeekRoutine.dayRoutine[indexPath.row].complete.isEmpty) && (curWeekRoutine.dayRoutine[indexPath.row].complete.contains(curWeekRoutine.routine[index].id)) {
                tempList.append((curWeekRoutine.routine[index], true))
            } else {
                selectRoutine.append((curWeekRoutine.routine[index], false))
            }
        }
        selectRoutine += tempList
        tableView.reloadData()
        messageLabel.isHidden = true
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
        cell.bind(model: curWeekRoutine.dayRoutine[indexPath.item],
                  dayRoutineCount: Float(dayCount),
                  index: indexPath.item)
        if selectedIdx == indexPath.item {
            cell.isSelected = true
        }
        return cell
    }
}

//MARK:- 일별 루틴 체크 table view
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dropTableView {
            UIView.animate(withDuration: 0.3) {
                self.downButton.transform = .identity
            }
            dropView.isHidden = true
            downButton.isSelected = false
            dropdownIdx = indexPath.row+1
            setupRoutine(week: dropdownIdx!)
            // print("dropdown", dropdownIdx)
            collectionView.reloadData()
            let selectIndexPath = IndexPath(item: selectedIdx, section: 0)
            collectionView.selectItem(at: selectIndexPath, animated: false, scrollPosition: .left)
            collectionView(collectionView, didSelectItemAt: selectIndexPath)
        } else {
            if indexPath.section == 2 && cellType == .routine {
                let storyboard = UIStoryboard.init(name: "HomeRootine", bundle: nil)
                guard let dvc = storyboard.instantiateViewController(withIdentifier: "EditVC") as? EditVC else { return }
                dvc.rootine = selectRoutine[indexPath.row].0
                dvc.curWeekRoutine = curWeekRoutineModel
                self.navigationController?.pushViewController(dvc, animated: true)
            }
        }
    }
}
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == dropTableView {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dropTableView {
            return allWeekRoutine.count
        } else {
            guard let curWeekRoutine = curWeekRoutineModel else {
                return 0
            }
            
            if section == 0 {
                return (isExpanded) ? curWeekRoutine.weekRoutine.rootines().count : 0
            } else if section == 1 {
                return 1
            } else if cellType == .routine {
                if curWeekRoutine.weekRoutine.rootines().count == 0 {
                    tableView.setEmptyView(message: "상단에 추가버튼을 눌러\n새로운 루틴을 생성해보세요!", image: "homeNullImage")
                } else {
                    tableView.restore()
                }
                return selectRoutine.count
            } else {
                tableView.setEmptyView()
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dropTableView {
            
            guard let cell = dropTableView.dequeueReusableCell(withIdentifier: DropTVCell.reuseIdentifier, for: indexPath) as? DropTVCell else {
                return .init()
            }
            cell.bind(weekString: allWeekRoutine[indexPath.row].weekString)
            return cell
        } else {
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekRootineTVCell.reuseIdentifier, for: indexPath) as? WeekRootineTVCell else {
                    return .init()
                }
                cell.bind(model: curWeekRoutineModel?.routine[indexPath.row], dayId: curWeekRoutineModel?.dayRoutine[0].id)
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
                    if model.0.goal == "" {
                        cell.centerConstraint.constant = 0
                    }
                    cell.bind(routine: model.0, isCompleted: model.1)
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: RetrospectTVCell.reuseIdentifier, for: indexPath) as? RetrospectTVCell else {
                        return .init(style: .default, reuseIdentifier: "")
                    }
                    guard let retrospect = curWeekRoutineModel?.dayRoutine[selectedIdx].retrospect else {
                        return .init()
                    }
                    cell.textView.delegate = self
                    cell.bind(content: retrospect)
                    if isExpanded {
                        cell.textView.isScrollEnabled = false
                    }
                    textViewDidChange(cell.textView)
                    return cell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == dropTableView {
            return nil
        } else {
            if indexPath.section == 2 && cellType == .routine {
                let doneAction = UIContextualAction(style: .normal, title: "") { (action, view, bool) in
                    guard let curWeekRoutine = self.curWeekRoutineModel else {
                        return
                    }
                    
                    let dayRoutine = curWeekRoutine.dayRoutine[self.selectedIdx]
                    let month = String(dayRoutine.id).monthWithDayRoutineId()
                    let routineId = self.selectRoutine[indexPath.row].0.id
                    if !dayRoutine.complete.contains(routineId) {
                        FMDBManager.shared.addRoutineCount(month: month, routineId: routineId)
                    }
                    NotificationCenter.default.post(name: .routineComplete, object: nil, userInfo: ["routineIndex": routineId, "indexPath": indexPath.row, "dayId": dayRoutine.id])
                    self.collectionView.reloadData()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                doneAction.image = UIImage(named: "complete")
                doneAction.backgroundColor = UIColor.subBlue
                return UISwipeActionsConfiguration(actions: [doneAction])
            } else {
                return nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == dropTableView {
            return nil
        } else {
            if indexPath.section == 2 && cellType == .routine {
                let cancelAction = UIContextualAction(style: .normal, title: "") { (action, view, bool) in
                    guard let curWeekRoutine = self.curWeekRoutineModel else {
                        return
                    }
                    
                    let dayRoutine = curWeekRoutine.dayRoutine[self.selectedIdx]
                    let month = String(dayRoutine.id).monthWithDayRoutineId()
                    let routineId = self.selectRoutine[indexPath.row].0.id
                    if dayRoutine.complete.contains(routineId) {
                        FMDBManager.shared.removeRoutineCount(month: month, routineId: routineId)
                    }
                    NotificationCenter.default.post(name: .routineUnComplete, object: nil, userInfo: ["shouldRemoveIndex": routineId, "indexPath": indexPath.row, "dayId": dayRoutine.id])
                    self.collectionView.reloadData()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                cancelAction.image = UIImage(named: "undo")
                cancelAction.backgroundColor = UIColor.subBlue
                return UISwipeActionsConfiguration(actions: [cancelAction])
            } else {
                return nil
            }
        }
    }
}

extension HomeVC: HomeTabCellTypeDelegate {
    func clickRoutine() {
        self.cellType = .routine
        messageLabel.isHidden = true
    }
    
    func clickRetrospect() {
        self.cellType = .retrospect
    }
}

extension HomeVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageLabel.tag == 100 {
            messageLabel.removeFromSuperview()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let curWeekRoutine = curWeekRoutineModel else {
            return
        }
        if var dayRoutine = curWeekRoutineModel?.dayRoutine[selectedIdx] {
            dayRoutine.retrospect = textView.text
            FMDBManager.shared.updateDayRootine(rootine: dayRoutine)
            setupRoutine(week: curWeekRoutine.weekRoutine.week)
            collectionView.reloadData()
            collectionView(collectionView, didSelectItemAt: IndexPath(item: selectedIdx, section: 0))
            
            view.addSubview(messageLabel)
            messageLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor).isActive = true
            messageLabel.isHidden = false
        }
        textView.resignFirstResponder()
        // textView.contentInset.bottom = 0
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let caret = textView.caretRect(for: textView.selectedTextRange!.start)
        let estimatedSize = textView.sizeThatFits(size)
        textView.scrollRectToVisible(caret, animated: true)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
                if !isExpanded {
                    textView.isScrollEnabled = true
                    constraint.constant = 185
                }
            }
        }
//        let caret = textView.caretRect(for: textView.selectedTextRange!.start)
//        textView.scrollRectToVisible(caret, animated: true)
//        textView.contentInset.bottom = keyboardHeight - 155
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}
