//
//  TabTVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/20.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class TabTVCell: UITableViewCell {
    static let nibName = "TabTVCell"
    static let reuseIdentifier = "TabTVCell"
    
    var routine : (() -> ()) = {}
    var retrospect : (() -> ()) = {}
    
    @IBOutlet var routineBtn: UIButton!
    @IBOutlet var reviewBtn: UIButton!
    @IBOutlet var barView: UIView!
    @IBOutlet var barwidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func clickRoutine(_ sender: UIButton) {
        routine()
        self.barwidth.constant = self.routineBtn.frame.width
//        self.barView.frame.size.width = self.routineBtn.frame.width
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.routineBtn.isSelected = true
            self.reviewBtn.isSelected = false
            self.barView.frame.size.width = self.routineBtn.frame.width
            self.barView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        self.layoutIfNeeded()
    }
    
    @IBAction func clickReview(_ sender: UIButton) {
        retrospect()
        self.barwidth.constant = self.reviewBtn.frame.width
//        self.barView.frame.size.width = self.reviewBtn.frame.width
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.routineBtn.isSelected = false
            self.reviewBtn.isSelected = true
            self.barView.frame.size.width = self.reviewBtn.frame.width
            self.barView.transform = CGAffineTransform(translationX: sender.frame.width, y: 0)
        })
        
        self.layoutIfNeeded()
    }
}
