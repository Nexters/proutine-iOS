//
//  EditVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/22.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit
import AudioToolbox

class EditVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var backView: [UIView]!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var emojiTextfield: UITextField!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var goalTextfield: UITextField!
    @IBOutlet var emojiMessage: UILabel!
    @IBOutlet var nameMessage: UILabel!
    @IBOutlet var weekMessage: UILabel!
    
    private let weekList = ["월", "화", "수", "목", "금", "토", "일"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupCollectionView()
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setUI() {
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold",
                                                   size: 17)!]
        self.navigationItem.rightBarButtonItem?
            .setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 17.0)!],
                                    for: .normal)
        
        backView.forEach{ $0.viewRounded(cornerRadius: 10) }
        emojiMessage.isHidden = true
        nameMessage.isHidden = true
        weekMessage.isHidden = true
        emojiTextfield.delegate = self
        goalTextfield.delegate = self
        nameTextfield.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func keyboardHide() {
        view.endEditing(true)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
    }
    
    @IBAction func deleteRootine(_ sender: UIButton) {
        let alert = UIAlertController(title: "제목", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "삭제하기", style: .default) { (ok) in
            //code
        }
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backHome(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveRootine(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension EditVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditWeekCVCell", for: indexPath) as! EditWeekCVCell
        cell.weekLabel.text = weekList[indexPath.row]
        
        return cell
    }
}

extension EditVC: UICollectionViewDelegate {
    
}

extension EditVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === emojiTextfield {
            if textField.hasText,
                let emojiText = textField.text {
                if emojiText.isSingleEmoji {
                    emojiMessage.isHidden = true
                    backView[0].viewBorder(borderColor: .clear, borderWidth: 1)
                    nameTextfield.becomeFirstResponder()
                } else {
                    textField.text = ""
                    emojiMessage.text = "하나의 이모지만 등록이 가능합니다."
                    emojiMessage.isHidden = false
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            } else {
                emojiMessage.text = "루틴의 이모지가 등록되지 않았습니다."
                emojiMessage.isHidden = false
                backView[0].viewBorder(borderColor: .lightGray, borderWidth: 1)
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        } else if textField === nameTextfield {
            if textField.hasText {
                nameMessage.isHidden = true
                backView[1].viewBorder(borderColor: .clear, borderWidth: 1)
                goalTextfield.becomeFirstResponder()
            } else {
                nameMessage.isHidden = false
                backView[1].viewBorder(borderColor: .lightGray, borderWidth: 1)
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        } else if textField === goalTextfield {
            goalTextfield.resignFirstResponder()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emojiTextfield {
            nameTextfield.becomeFirstResponder()
        } else if textField === nameTextfield {
            goalTextfield.becomeFirstResponder()
        } else if textField === goalTextfield {
            goalTextfield.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let curString = textField.text else { return false }
        guard let stringRange = Range(range, in: curString) else { return false }
        
        let updateText = curString.replacingCharacters(in: stringRange, with: string)
        if textField === emojiTextfield {
            return updateText.count < 2
        } else {
            return updateText.count < 18
        }
    }
}
