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
    func setEmptyView(message: String, image: String){
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let picImage: UIImageView = {
            let imageView = UIImageView()
            let image = UIImage(named: image)
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
            label.textAlignment = NSTextAlignment.center
            label.numberOfLines = 0
            label.textColor = .dusk
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        picImage.addSubview(messageLabel)
        messageLabel.bottomAnchor.constraint(equalTo: picImage.bottomAnchor, constant: 50).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: picImage.leftAnchor, constant: -40).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: picImage.rightAnchor, constant: 60).isActive = true
        
        emptyView.addSubview(picImage)
        picImage.translatesAutoresizingMaskIntoConstraints = false
        picImage.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 100).isActive = true
        picImage.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -120).isActive = true
        picImage.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 150).isActive = true
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func setEmptyView() {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        emptyView.backgroundColor = .subBlue
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
