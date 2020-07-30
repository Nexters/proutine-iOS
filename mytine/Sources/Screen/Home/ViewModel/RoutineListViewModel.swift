//
//  RoutineListViewModel.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/29.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RoutineListViewModel: CommonViewModel {
    var routineList: Observable<[Routine]> {
        return storage.routineList()
    }
}

//MARK:- tableView datasource
enum RoutineListViewModelItemType {
    case dashboard
    case checklist
}

protocol RoutineListViewModelItem {
    var type: RoutineListViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class RoutineViewModel: NSObject {
    var items = [RoutineListViewModelItem]()
    
    override init() {
        super.init()
        
//        guard let routine = Rootine() else {
//            return
//        }
//
//        if let dashboard = routine.dashboard {
//            let dashboardItem = RoutineViewModelDashboardItem
//            items.append(dashboardItem)
//        }
//
//        if let checklist = routine.checklist {
//            let checklistItem = RoutineViewModelCheckListItem(email: email)
//            items.append(checklistItem)
//        }
    }
}

extension RoutineViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .dashboard:
            if let cell = tableView.dequeueReusableCell(withIdentifier: WeekRootineTVCell.reuseIdentifier, for: indexPath) as? WeekRootineTVCell {
                return cell
            }
        case .checklist:
            if let item = item as? RoutineViewModelCheckListItem, let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTVCell.reuseIdentifier, for: indexPath) as? RoutineTVCell {
                let checklist = item.routines[indexPath.row]
                cell.item = checklist
                return cell
            }
        }
        return UITableViewCell()
    }
    
    private func tableView(_ tableView:UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = items[section]
        switch item.type {
        case .dashboard:
            if let cell = tableView.dequeueReusableCell(withIdentifier: WeekRootineTVCell.reuseIdentifier) as? WeekRootineTVCell {
                return cell
            }
        case .checklist:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TabTVCell.reuseIdentifier) as? TabTVCell {
                return cell
            }
        }
        return UIView()
    }
}

class RoutineViewModelDashboardItem: RoutineListViewModelItem {
    var type: RoutineListViewModelItemType {
        return .dashboard
    }
    
    var sectionTitle: String = "대시보드"
    
    var rowCount: Int {
        return routines.count
    }
    
    var routines: [Routine]
    
    init(routines: [Routine]) {
        self.routines = routines
    }
}

class RoutineViewModelCheckListItem: RoutineListViewModelItem {
    var type: RoutineListViewModelItemType {
        return .checklist
    }
    
    var sectionTitle: String {
        return "루틴/회고 탭 선택"
    }
    
    var rowCount: Int {
        return routines.count
    }
    
    var routines: [Routine]
    
    init(routines: [Routine]) {
        self.routines = routines
    }
}
