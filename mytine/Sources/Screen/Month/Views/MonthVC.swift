//
//  MonthVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/08/29.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class MonthVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigationBar()
        findTopRoutine()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
               NSAttributedString.Key.foregroundColor: UIColor.mainFont
        ]
    }
    
    func findTopRoutine() {
        // FMDBManager.shared.searchRecordCount(month: 7, routineId: Int)
    }
    
    @IBAction func goBackHome(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension MonthVC: UITableViewDelegate {
    
}

extension MonthVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setEmptyView(message: "이번달 말 10개 이상의 루틴 수행 시,\n루틴 순위를 확인할 수 있어요!", image: "group_2")
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
}
