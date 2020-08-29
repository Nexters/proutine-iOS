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
    
    private var dayId = -1
    private var emoji = ""
    private var routineId = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.viewRounded(cornerRadius: 4)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(complete),
                                               name: .routineComplete,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(uncomplete),
                                               name: .routineUnComplete,
                                               object: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .white
        emoji = ""
        dayId = -1
        routineId = -1
    }
    
    @objc
    func complete(notification: Notification) {
        guard let dayId = notification.userInfo?["dayId"] as? Int,
            let rId = notification.userInfo?["routineIndex"] as? Int else {
            return
        }
        
        if dayId == self.dayId && rId == self.routineId {
            emojiLabel.text = emoji
        }
    }
    
    @objc
    func uncomplete(notification: Notification) {
        guard let dayId = notification.userInfo?["dayId"] as? Int,
        let rId = notification.userInfo?["shouldRemoveIndex"] as? Int else {
            return
        }
        
        if dayId == self.dayId && rId == self.routineId {
            emojiLabel.text = ""
        }
    }
    
    func bind(dayId: Int?, routineId rId: Int?, emoji: String, isActive: Bool) {
        if !isActive {
            contentView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.968627451, alpha: 1)
            self.emoji = ""
            self.emojiLabel.text = ""
        } else {
            guard let dayId = dayId,
                let rId = rId,
                let dayRoutine = FMDBManager.shared.selectDayRootineWithId(id: dayId) else {
                    return
            }
            self.routineId = rId
            self.dayId = dayId
            self.emoji = emoji
            if dayRoutine.complete.contains(rId) {
                emojiLabel.text = emoji
            }
        }
    }
}
