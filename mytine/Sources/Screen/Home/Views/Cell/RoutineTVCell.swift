//
//  RoutineTVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/15.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class RoutineTVCell: UITableViewCell {
    static let nibName = "RoutineTVCell"
    static let reuseIdentifier = "RoutineTVCell"
    
    @IBOutlet var backView: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var iconLabel: UILabel!
    @IBOutlet var listLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.viewRounded(cornerRadius: 10)
        self.iconLabel.viewRounded(cornerRadius: 10)
        self.viewRounded(cornerRadius: 10)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(_ routine: Rootine) {
        self.timeLabel.text = routine.goal
        self.listLabel.text = routine.title
        self.iconLabel.text = routine.emoji
    }
}
