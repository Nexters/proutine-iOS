//
//  DropdownCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/08/11.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class DropdownCell: UITableViewCell {
    @IBOutlet var backView: UIView!
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        backView.viewRounded(cornerRadius: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            backView.backgroundColor = .subBlue
        } else {
            backView.backgroundColor = .white
        }
    }
}
