//
//  RetrospectTVCell.swift
//  mytine
//
//  Created by 황수빈 on 2020/08/08.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class RetrospectTVCell: UITableViewCell {
    static let reuseIdentifier = "RetrospectTVCell"
    @IBOutlet var textView: UITextView!
    @IBOutlet var saveBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        saveBtn.viewRounded(cornerRadius: 8)
        textView.viewRounded(cornerRadius: 10)
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func bind(content: String) {
        self.backgroundColor = .mainBlue
        textView.text = content
    }
}
