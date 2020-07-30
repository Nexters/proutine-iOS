//
//  WeekTVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/20.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class WeekTVCell: UITableViewCell {
    static let reuseIdentifier = "WeekTVCell"
    let weekString = ["월", "화", "수", "목", "금", "토", "일"]
    
    @IBOutlet var homeCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: HomeRootineCVCell.nibName, bundle: nil)
        homeCollectionView.register(nib, forCellWithReuseIdentifier: HomeRootineCVCell.reuseIdentifier)
        homeCollectionView.dataSource = self
    }
}

extension WeekTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRootineCVCell.reuseIdentifier, for: indexPath) as? HomeRootineCVCell else {
            return .init()
        }
        cell.weekLabel.text = weekString[indexPath.row]
        return cell
    }
}
