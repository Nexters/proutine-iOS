//
//  Date+Extension.swift
//  mytine
//
//  Created by 남수김 on 2020/07/27.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation

extension Date {
    private func simpleDateFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.timeZone = .current
        formatter.dateFormat = format
        return formatter
    }
    
    func makeRootineId() -> String {
        let formatter = simpleDateFormatter(format: "yyyyMMdd")
        let dateString = formatter.string(from: self)
        
        return dateString
    }
}
