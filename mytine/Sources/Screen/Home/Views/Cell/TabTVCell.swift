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
    
    @IBOutlet var expandBtn: UIButton!
    @IBOutlet var routineBtn: UIButton!
    @IBOutlet var reviewBtn: UIButton!
    @IBOutlet var barView: UIView!
    @IBOutlet var barwidth: NSLayoutConstraint!
    var homeDelegate: HomeTabCellTypeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        routineBtn.isSelected = true
    }
    
    @IBAction func clickRoutine(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.routineBtn.isSelected = true
            self.reviewBtn.isSelected = false
            self.barView.frame.size.width = self.routineBtn.frame.width
            self.barView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        homeDelegate?.clickRoutine()
        self.layoutIfNeeded()
    }
    
    @IBAction func clickReview(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.routineBtn.isSelected = false
            self.reviewBtn.isSelected = true
            self.barView.frame.size.width = self.reviewBtn.frame.width
            self.barView.transform = CGAffineTransform(translationX: sender.frame.width+16
                , y: 0)
        })
        homeDelegate?.clickRetrospect()
        self.layoutIfNeeded()
    }
}

protocol HomeTabCellTypeDelegate {
    func clickRoutine()
    func clickRetrospect()
}
