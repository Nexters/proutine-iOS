//
//  HomeRootineCVCell.swift
//  mytine
//
//  Created by 남수김 on 2020/07/25.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class HomeRootineCVCell: UICollectionViewCell {
    let weekString = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    static let nibName = "HomeRootineCVCell"
    static let reuseIdentifier = "HomeRootineCVCell"
    
    @IBOutlet weak var weekTableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupTableView() {
        let nib = UINib(nibName: WeekRootineTVCell.nibName, bundle: nil)
        weekTableView.register(nib, forCellReuseIdentifier: WeekRootineTVCell.reuseIdentifier)
        weekTableView.dataSource = self
        weekTableView.delegate = self
    }
    
    func bind() {
        setupTableView()
        
    }
}

extension HomeRootineCVCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekRootineTVCell.reuseIdentifier, for: indexPath) as? WeekRootineTVCell else {
            return .init()
        }
        //TODO: 요일과 해당요일에 해당하는 데이터넣어주기
        // cell.weekLabel.text = weekString[indexPath.row]
        cell.bind()
        return cell
    }
}

extension HomeRootineCVCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //TODO: 한주당 높이
        return 44
    }
}
