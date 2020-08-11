//
//  UIColor+Additions.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/16.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit
extension UIColor {
    
    @nonobjc class var mainBlue: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 118.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var mainFont: UIColor {
      return UIColor(red: 89.0 / 255.0, green: 116.0 / 255.0, blue: 138.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var subFont: UIColor {
      return UIColor(red: 147.0 / 255.0, green: 176.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var subBlue: UIColor {
      return UIColor(red: 244.0 / 255.0, green: 244.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
    }
    
    /// 이제 필요 없는 컬러들
    @nonobjc class var backColor: UIColor {
           return UIColor(red: 251 / 255.0, green: 252 / 255.0, blue: 253 / 255.0, alpha: 1.0)
       }
    
    @nonobjc class var editBackColor: UIColor {
           return UIColor(red: 236 / 255.0, green: 237 / 255.0, blue: 237 / 255.0, alpha: 1.0)
       }
    
    @nonobjc class var weekSelectColor: UIColor {
        return UIColor(red: 96 / 255.0, green: 96 / 255.0, blue: 96 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var repeatDayUnselectColor: UIColor {
        return UIColor(red: 196 / 255.0, green: 208 / 255.0, blue: 232 / 255.0, alpha: 1.0)
    }
}
