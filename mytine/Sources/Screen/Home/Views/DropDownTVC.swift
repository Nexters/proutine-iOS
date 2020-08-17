//
//  DropDownTVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/08/11.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class DropDownTVC: UITableViewController {
    var dropList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadWeekList()
    }
    
    func setupTableView() {
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
    }
    
    func loadWeekList() {
        let allWeekRoutine = FMDBManager.shared.selectWeekRootine(week: 0)

        for index in allWeekRoutine.indices {
            self.dropList.append(allWeekRoutine[index].weekString)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as? DropdownCell else { return .init() }

        cell.label.text = dropList[indexPath.row]
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dvc = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeVC else {
            return
        }
        dvc.dropdownIdx = indexPath.row+1
    }
}
