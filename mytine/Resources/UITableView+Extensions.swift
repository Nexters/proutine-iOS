//
//  UITableView+Extensions.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/10.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func setEmptyView(message: String, label: String){
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))

        let addBtn: UIButton = {
            let button = UIButton()
            button.setTitle(label, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.darkGray
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.font = UIFont(name:"AppleSDGothicNeo-Bold", size: 16.0)
            label.textAlignment = NSTextAlignment.center
            label.numberOfLines = 0
            label.textColor = .gray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        addBtn.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: addBtn.topAnchor, constant: -62).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: addBtn.leftAnchor, constant: 72).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: addBtn.rightAnchor, constant: -72).isActive = true

        emptyView.addSubview(addBtn)
        addBtn.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 48).isActive = true
        addBtn.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -48).isActive = true
        addBtn.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 220).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emptyView.backgroundColor = .backColor
        self.backgroundColor = .backColor
        self.backgroundView?.backgroundColor = .backColor
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
