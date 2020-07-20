//
//  WeekTVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/20.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class WeekTVCell: UITableViewCell {
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var weekCV: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        weekLabel.viewRounded(cornerRadius: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
