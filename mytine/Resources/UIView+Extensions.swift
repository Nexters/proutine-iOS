//
//  UIView+Extensions.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/15.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func viewRounded(cornerRadius : CGFloat?){
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        self.layer.masksToBounds = true
    }
    
    func viewRoundedCustom(cornerRadius : Double, borderColor : UIColor, firstCorner : UIRectCorner, secondCorner : UIRectCorner){
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [firstCorner, secondCorner], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
        
        let borderShape = CAShapeLayer()
        borderShape.frame = self.layer.bounds
        borderShape.path = path.cgPath
        borderShape.strokeColor = borderColor.cgColor
        borderShape.fillColor = nil
        borderShape.lineWidth = 0.5
        self.layer.addSublayer(borderShape)
    }
    
    func viewBorder(borderColor : UIColor, borderWidth : CGFloat?) {
        self.layer.borderColor = borderColor.cgColor
        if let borderWidth_ = borderWidth {
            self.layer.borderWidth = borderWidth_
        } else {
            self.layer.borderWidth = 1.0
        }
    }
}
