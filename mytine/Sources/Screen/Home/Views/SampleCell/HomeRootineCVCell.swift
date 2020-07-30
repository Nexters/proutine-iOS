//
//  HomeRootineCVCell.swift
//  mytine
//
//  Created by 남수김 on 2020/07/25.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class HomeRootineCVCell: UICollectionViewCell {
    static let nibName = "HomeRootineCVCell"
    static let reuseIdentifier = "HomeRootineCVCell"
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
