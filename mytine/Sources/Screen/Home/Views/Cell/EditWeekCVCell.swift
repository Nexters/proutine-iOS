//
//  EditWeekCVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/22.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class EditWeekCVCell: UICollectionViewCell {
    
    @IBOutlet var weekLabel: UILabel!
    
    override func awakeFromNib() {
        self.viewRounded(cornerRadius: 4)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = UIColor.weekSelectColor
                self.weekLabel.textColor = UIColor.white
            } else {
                self.contentView.backgroundColor = UIColor.editBackColor
                self.weekLabel.textColor = UIColor.lightGray
            }
        }
    }
}
