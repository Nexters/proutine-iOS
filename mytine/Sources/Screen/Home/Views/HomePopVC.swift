//
//  HomePopVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/20.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class HomePopVC: UIViewController {
    @IBOutlet var backView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var editBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.viewRounded(cornerRadius: 10)
        imageView.viewRounded(cornerRadius: 10)
        editBtn.viewRounded(cornerRadius: 14)
    }
    
    @IBAction func clickClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
