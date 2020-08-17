//
//  EditVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/22.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit
import SnapKit

enum EditMode {
    case add, edit
}

class EditVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var backView: [UIView]!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emojiTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var goalTextfield: UITextField!
    @IBOutlet weak var emojiMessage: UILabel!
    @IBOutlet weak var nameMessage: UILabel!
    @IBOutlet weak var weekMessage: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    private let weekList = ["월", "화", "수", "목", "금", "토", "일"]
    private var selectWeek = [0,0,0,0,0,0,0]
    private let notiGenerator = UINotificationFeedbackGenerator()
    var rootine: Rootine?
    var editMode: EditMode = .add
    var curWeekRoutine: WeekRootineModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchRoutine()
    }
    
    func fetchRoutine() {
        if let rootine = rootine {
            emojiTextfield.text = rootine.emoji
            nameTextfield.text = rootine.title
            goalTextfield.text = rootine.goal
            rootine.repeatDays.enumerated().forEach {
                if $1 == 1 {
                    let indexPath = IndexPath(row: $0, section: 0)
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
                }
            }
        }
    }

    func setUI() {
        editMode = rootine == nil ? .add : .edit
        
        if editMode == .edit {
            deleteButton.isHidden = false
        }
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold",
                                                   size: 17)!]
        self.navigationItem.leftBarButtonItem?.action = #selector(self.backClick(_:))
        
        backView.forEach{ $0.viewRounded(cornerRadius: 10) }
        saveButton.viewRounded(cornerRadius: 12)
        deleteButton.viewRounded(cornerRadius: 12)
        
        emojiMessage.isHidden = true
        nameMessage.isHidden = true
        weekMessage.isHidden = true
        emojiTextfield.delegate = self
        goalTextfield.delegate = self
        nameTextfield.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide))
        tapGesture.cancelsTouchesInView = false
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
    
    func createRootine() {
        guard emojiTextfield.hasText,
            nameTextfield.hasText else {
                return
        }
        
        guard let emoji = emojiTextfield.text,
            let title = nameTextfield.text,
            let goal = goalTextfield.text else {
                return
        }
        
        let rootine = Rootine(id: -1,
                              emoji: emoji,
                              title: title,
                              goal: goal,
                              repeatDays: selectWeek)
        
        // 루틴생성, 주차루틴 수정
        if FMDBManager.shared.createRootine(rootine: rootine) {
            guard let curWeekRoutine = curWeekRoutine else {
                return
            }
            let count = FMDBManager.shared.searchRoutineCount()
            var newArr = curWeekRoutine.weekRoutine.rootines()
            newArr.append(count)
            _ = FMDBManager.shared.updateWeekRootine(rootinesList: newArr, week: curWeekRoutine.weekRoutine.week)
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    func modifyRootine() {
        guard var rootine = rootine,
            let emoji = emojiTextfield.text,
            let title = nameTextfield.text,
            let goal = goalTextfield.text else {
            return
        }
        
        rootine.emoji = emoji
        rootine.title = title
        rootine.goal = goal
        rootine.repeatDays = selectWeek
        // 루틴업데이트
        if FMDBManager.shared.updateRootine(rootine: rootine) {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func warningBackAlert() {
        let alert = CustomAlertView(text: "이전 화면으로 돌아가시겠습니까?\n미 저장시, 작성중인 루틴은 저장되지 않습니다.") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        navigationController?.view.addSubview(alert)
        alert.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func deleteRootine() {
        guard let rootine = rootine else {
            return
        }
        if FMDBManager.shared.deleteRootine(id: rootine.id) {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    func backClick(_ sender: UIBarButtonItem) {
        warningBackAlert()
    }
    
    func waringGeneratorAnimation(view: UILabel) {
        view.transform = .init(translationX: 4, y: 0)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: [.allowUserInteraction],
                       animations: {
                        view.transform = .identity
                        
        })
    }
    
    @IBAction func deleteRootine(_ sender: UIButton) {
        let alert = UIAlertController(title: "확인",
                                      message: "정말로 삭제하시겠습니까?",
                                      preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "삭제하기", style: .destructive) { (action) in
            //code
        }
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveClick(_ sender: Any) {
        if selectWeek.filter({$0==1}).count == 0 {
            weekMessage.isHidden = false
            notiGenerator.notificationOccurred(.error)
            waringGeneratorAnimation(view: weekMessage)
            return
        }
        
        editMode == .edit ? modifyRootine() : createRootine()
    }
    
}

extension EditVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditWeekCVCell", for: indexPath) as? EditWeekCVCell else { return .init()}
        cell.weekLabel.text = weekList[indexPath.row]
        
        return cell
    }
}

extension EditVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectWeek[indexPath.item] = 1
        weekMessage.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectWeek[indexPath.item] = 0
    }
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
                    backView[0].viewBorder(borderColor: .macaroniAndCheese, borderWidth: 1)
                    notiGenerator.notificationOccurred(.error)
                    waringGeneratorAnimation(view: emojiMessage)
                }
            } else {
                emojiMessage.text = "루틴의 이모지가 등록되지 않았습니다."
                emojiMessage.isHidden = false
                backView[0].viewBorder(borderColor: .macaroniAndCheese, borderWidth: 1)
                notiGenerator.notificationOccurred(.error)
                waringGeneratorAnimation(view: emojiMessage)
            }
        } else if textField === nameTextfield {
            if textField.hasText {
                nameMessage.isHidden = true
                backView[1].viewBorder(borderColor: .clear, borderWidth: 1)
                goalTextfield.becomeFirstResponder()
            } else {
                nameMessage.isHidden = false
                backView[1].viewBorder(borderColor: .macaroniAndCheese, borderWidth: 1)
                notiGenerator.notificationOccurred(.error)
                waringGeneratorAnimation(view: nameMessage)
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
