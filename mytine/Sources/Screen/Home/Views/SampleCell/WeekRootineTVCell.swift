//
//  WeekRootineTVCell.swift
//  mytine
//
//  Created by 남수김 on 2020/07/25.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class WeekRootineTVCell: UITableViewCell {
    static let nibName = "WeekRootineTVCell"
    static let reuseIdentifier = "WeekRootineTVCell"
    
    @IBOutlet weak var dayCollectionView: UICollectionView!
    
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
        let nib = UINib(nibName: DayRootineCVCell.nibName, bundle: nil)
        dayCollectionView.register(nib, forCellWithReuseIdentifier: DayRootineCVCell.reuseIdentifier)
        dayCollectionView.dataSource = self
        dayCollectionView.delegate = self
    }
}

extension WeekRootineTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayRootineCVCell.reuseIdentifier, for: indexPath) as? DayRootineCVCell else {
            return .init()
        }
        //TODO: 해당루틴에 대한 정보 0,1,0,1,0,1,1...
        cell.bind()
        return cell
    }
}

extension WeekRootineTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //TODO: 루틴 한칸사이즈
        return CGSize(width: 44, height: 44)
    }
}
