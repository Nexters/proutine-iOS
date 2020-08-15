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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind() {
        backgroundColor = .lightGray
    }
}
