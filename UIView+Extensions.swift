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
            // cornerRadius 가 nil 일 경우의 default
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        self.layer.masksToBounds = true
    }
    
    func viewBorder(borderColor : UIColor?, borderWidth : CGFloat?) {
        if let borderColor_ = borderColor {
            self.layer.borderColor = borderColor_.cgColor
        } else {
            self.layer.borderColor = UIColor(red: 205/255, green: 209/255, blue: 208/255, alpha: 1.0).cgColor
        }
        
        // UIView 의 테두리 두께 설정
        if let borderWidth_ = borderWidth {
            self.layer.borderWidth = borderWidth_
        } else {
            // borderWidth 변수가 nil 일 경우의 default
            self.layer.borderWidth = 1.0
        }
    }
}
