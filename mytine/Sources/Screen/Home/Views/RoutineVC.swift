//
//  RoutineVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/29.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class RoutineVC: UIViewController, ViewModelBindableType {
    
    var viewModel: RoutineListViewModel!
    @IBOutlet var routineTableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.routineList
            .bind(to: routineTableView.rx.items(cellIdentifier: "cell")) { row, routine, cell in
                cell.textLabel?.text = routine.title
        }
        .disposed(by: rx.disposeBag)
    }
}
