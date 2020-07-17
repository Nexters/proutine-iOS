//
//  HomeVC2.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/17.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class HomeVC2: UIViewController {
    var routineList = ["혜연 케어", "애리 케어", "재환 케어", "승희 케어", "유진 케어", "수빈 케어", "남수 케어"]
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension HomeVC2: UITableViewDelegate {
    
}
extension HomeVC2: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCVCell", for: indexPath) as! CheckCVCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineTVCell", for: indexPath) as! RoutineTVCell
            cell.numLabel.text = "\(indexPath.row+1)"
            cell.listLabel.text = "\(routineList[indexPath.row])"
            return cell
        }
    }
}
