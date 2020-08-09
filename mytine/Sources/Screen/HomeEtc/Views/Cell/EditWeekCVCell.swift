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
        self.contentView.viewRounded(cornerRadius: 4)
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.repeatDayUnselectColor.cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = .white
                self.contentView.layer.borderColor = UIColor.mainBlue.cgColor
                self.weekLabel.textColor = .mainBlue
            } else {
                self.contentView.backgroundColor = .clear
                self.contentView.layer.borderColor = UIColor.repeatDayUnselectColor.cgColor
                self.weekLabel.textColor = .repeatDayUnselectColor
                
            }
        }
    }
}
