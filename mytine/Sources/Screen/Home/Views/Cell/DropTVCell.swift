//
//  DropTVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/08/22.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class DropTVCell: UITableViewCell {
    static let reuseIdentifier = "DropTVCell"
    @IBOutlet var backView: UIView!
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

    func bind(weekString: String) {
        label.text = weekString
    }
}
