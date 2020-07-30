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
    
    var item: Routine? {
        didSet {
            guard let item = item else {
                return
            }
            iconLabel?.text = item.emoji
            timeLabel?.text = item.goal
            listLabel?.text = item.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.viewRounded(cornerRadius: 10)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
