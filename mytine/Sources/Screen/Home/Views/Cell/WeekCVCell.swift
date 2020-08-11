//
//  WeekCVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/08/09.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class WeekCVCell: UICollectionViewCell {
    static let reuseIdentifier = "WeekCVCell"
    static let weekList = ["월", "화", "수", "목", "금", "토", "일"]
    @IBOutlet var rateCheckView: UIView!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var routineCheckView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        routineCheckView.viewRounded(cornerRadius: 3)
    }
}
