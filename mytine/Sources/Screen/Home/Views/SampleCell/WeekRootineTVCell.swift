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
    
    private var model: Rootine?
    private var days: [Int] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupCollectionView()
    }
    
    override func prepareForReuse() {
        model = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(model: Rootine?, dayId: Int?) {
        self.model = model
        if let dayId = dayId {
            days = (0...6).map{ Int(String(dayId).afterDayString(addDay: $0)) ?? -1 }
        }
        dayCollectionView.reloadData()
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
        
        let isActive = model?.repeatDays[indexPath.item] == 1 ? true : false
        let emoji = model?.emoji
        
        cell.bind(dayId: days[indexPath.item], routineId: model?.id, emoji: emoji ?? "", isActive: isActive)
        return cell
    }
}

extension WeekRootineTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 루틴 한칸사이즈
        return CGSize(width: 42, height: 44)
    }
}
