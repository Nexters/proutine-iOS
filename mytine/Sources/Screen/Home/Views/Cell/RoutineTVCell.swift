//
//  RoutineTVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/15.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class RoutineTVCell: UITableViewCell {
    static let reuseIdentifier = "RoutineTVCell"
    @IBOutlet var backView: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var iconLabel: UILabel!
    @IBOutlet var listLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        iconLabel.viewRounded(cornerRadius: 10)
        backView.viewRounded(cornerRadius: 10)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(routine: Rootine, isCompleted: Bool) {
        self.backgroundColor = .mainFont
        timeLabel.text = routine.goal
        iconLabel.text = routine.emoji
        listLabel.text = routine.title
        self.contentView.layer.opacity = isCompleted ? 0.5 : 1.0
    }
}
