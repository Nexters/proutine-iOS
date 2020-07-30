//
//  CheckCVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/17.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class CheckCVCell: UICollectionViewCell {
    static let reuseIdentifier = " WeekCellViewModel"
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var checkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.viewRounded(cornerRadius: 10)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = UIColor.lightGray
            } else {
                self.contentView.backgroundColor = UIColor.clear
            }
        }
    }
}
