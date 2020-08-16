//
//  DayRootineCVCell.swift
//  mytine
//
//  Created by 남수김 on 2020/07/25.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit
// 하루루틴 보여주는 Cell
class DayRootineCVCell: UICollectionViewCell {
    static let nibName = "DayRootineCVCell"
    static let reuseIdentifier = "DayRootineCVCell"
    @IBOutlet weak var emojiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.viewRounded(cornerRadius: 4)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .white
    }
    
    func bind(dayId : Int?, routineId rId: Int?, emoji: String, isActive: Bool) {
        if !isActive {
            contentView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.968627451, alpha: 1)
        } else {
            guard let dayId = dayId,
                let rId = rId,
                let dayRoutine = FMDBManager.shared.selectDayRootineWithId(id: dayId) else {
                    return
            }
            if dayRoutine.complete.contains(rId) {
                emojiLabel.text = emoji
            }
        }
    }
}
