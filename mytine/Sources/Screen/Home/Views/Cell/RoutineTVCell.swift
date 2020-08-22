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
    @IBOutlet var centerConstraint: NSLayoutConstraint!
    
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
        isCompleted ? dimEffect() : reset()
    }
    
    func dimEffect() {
        backView.alpha = 0.5
        timeLabel.alpha = 0.32
        iconLabel.alpha = 0.5
        listLabel.alpha = 0.5
    }
    
    func reset() {
        backView.alpha = 1.0
        timeLabel.alpha = 1.0
        iconLabel.alpha = 1.0
        listLabel.alpha = 1.0
    }
}
