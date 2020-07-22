//
//  EditVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/22.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class EditVC: UIViewController {

    var weekList = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    @IBOutlet var backView: [UIView]!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 17)!]
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 17.0)!], for: .normal)
    }
    
    func setUI() {
        backView[0].viewBorder(borderColor: .lightGray, borderWidth: 1)
        backView[1].viewBorder(borderColor: .lightGray, borderWidth: 1)
        backView[0].viewRounded(cornerRadius: 10)
        backView[1].viewRounded(cornerRadius: 10)
        backView[2].viewRounded(cornerRadius: 10)
    }
    
    @IBAction func backHome(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension EditVC: UICollectionViewDelegate {
    
}
extension EditVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditWeekCVCell", for: indexPath) as! EditWeekCVCell
        cell.weekLabel.text = weekList[indexPath.row]
        
        return cell
    }
}
