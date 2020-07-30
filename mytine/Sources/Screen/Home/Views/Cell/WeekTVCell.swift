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
    
    @IBOutlet var weekView: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        weekView[0].viewRounded(cornerRadius: 8)
        weekView[1].viewRounded(cornerRadius: 8)
        weekView[2].viewRounded(cornerRadius: 8)
        weekView[3].viewRounded(cornerRadius: 8)
        weekView[4].viewRounded(cornerRadius: 8)
        weekView[5].viewRounded(cornerRadius: 8)
        weekView[6].viewRounded(cornerRadius: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
