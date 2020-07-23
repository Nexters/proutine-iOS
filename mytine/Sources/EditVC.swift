//
//  EditVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/22.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit
import AudioToolbox

class EditVC: UIViewController, UITextFieldDelegate {
    
    var weekList = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    @IBOutlet var backView: [UIView]!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var emojiTextfield: UITextField!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var goalTextfield: UITextField!
    @IBOutlet var emojiMessage: UILabel!
    @IBOutlet var nameMessage: UILabel!
    @IBOutlet var weekMessage: UILabel!
    
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
        backView[0].viewRounded(cornerRadius: 10)
        backView[1].viewRounded(cornerRadius: 10)
        backView[2].viewRounded(cornerRadius: 10)
        emojiMessage.isHidden = true
        nameMessage.isHidden = true
        weekMessage.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emojiTextfield {
            if textField.text == nil {
                emojiMessage.isHidden = false
                backView[0].viewBorder(borderColor: .lightGray, borderWidth: 1)
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            } else {
                emojiMessage.isHidden = true
                nameTextfield.becomeFirstResponder()
            }
        } else if textField == nameTextfield {
            if textField.text == nil {
                nameMessage.isHidden = false
                backView[1].viewBorder(borderColor: .lightGray, borderWidth: 1)
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            } else {
                nameMessage.isHidden = true
                goalTextfield.becomeFirstResponder()
            }
        } else if textField == goalTextfield {
            goalTextfield.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func backHome(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveRootine(_ sender: UIBarButtonItem) {
        if emojiTextfield.text?.isSingleEmoji == false {
            print("하나의 이모지만 등록이 가능합니다.")
        }else {
            self.navigationController?.popViewController(animated: true)
        }
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
extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    var containsEmoji: Bool { contains { $0.isEmoji } }

    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    var emojiString: String { emojis.map { String($0) }.reduce("", +) }

    var emojis: [Character] { filter { $0.isEmoji } }

    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}
