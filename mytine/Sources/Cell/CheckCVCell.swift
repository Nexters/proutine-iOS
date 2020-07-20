//
//  CheckCVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/17.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class CheckCVCell: UICollectionViewCell {

    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var checkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.viewRounded(cornerRadius: 10)
    }
}
