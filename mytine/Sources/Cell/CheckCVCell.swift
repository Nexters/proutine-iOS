//
//  CheckCVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/17.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class CheckCVCell: UITableViewCell {

    @IBOutlet var checkBtn: [UIButton]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkBtn[0].viewBorder(borderColor: UIColor.gray, borderWidth: 1)
        checkBtn[1].viewBorder(borderColor: UIColor.gray, borderWidth: 1)
        checkBtn[2].viewBorder(borderColor: UIColor.gray, borderWidth: 1)
        checkBtn[3].viewBorder(borderColor: UIColor.gray, borderWidth: 1)
        checkBtn[4].viewBorder(borderColor: UIColor.gray, borderWidth: 1)
        checkBtn[5].viewBorder(borderColor: UIColor.gray, borderWidth: 1)
        checkBtn[6].viewBorder(borderColor: UIColor.gray, borderWidth: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
