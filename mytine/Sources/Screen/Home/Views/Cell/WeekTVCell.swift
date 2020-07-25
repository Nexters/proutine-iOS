//
//  WeekTVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/20.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class WeekTVCell: UITableViewCell {
//    @IBOutlet var weekLabel: UILabel!
//    @IBOutlet var weekCV: UICollectionView!
    
    @IBOutlet var homeCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        weekLabel.viewRounded(cornerRadius: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: HomeRootineCVCell.nibName, bundle: nil)
        homeCollectionView.register(nib, forCellWithReuseIdentifier: HomeRootineCVCell.reuseIdentifier)
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
    }

}

extension WeekTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRootineCVCell.reuseIdentifier, for: indexPath) as? HomeRootineCVCell else {
            return .init()
        }
        cell.bind()
        return cell
    }
    
}

extension WeekTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //TODO: 요일넓이 + 루틴갯수 * 루틴한칸넓이
        return CGSize(width: 600, height: 400)
    }
}
