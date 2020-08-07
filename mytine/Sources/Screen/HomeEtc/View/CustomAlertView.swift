//
//  CustomAlertView.swift
//  mytine
//
//  Created by 남수김 on 2020/08/04.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class CustomAlertView: UIView {
    private var labelText: String?
    private var okCallback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(text: String, okCallback: (() -> Void)?) {
        self.init()
        self.labelText = text
        self.okCallback = okCallback
        
        alertBulider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func alertBulider() {
        
        let effect = UIBlurEffect(style: .dark)
        let containView = UIVisualEffectView(effect: effect)
        containView.alpha = 0.85
        containView.frame = UIScreen.main.bounds
        containView.isUserInteractionEnabled = false
        self.addSubview(containView)
        containView.snp.makeConstraints {
            $0.top.bottom.right.left.equalTo(self)
        }
        
        let alert: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.viewRounded(cornerRadius: 12)
            self.addSubview(view)
            view.snp.makeConstraints {
                $0.width.equalTo(312)
                $0.height.equalTo(128)
                $0.center.equalTo(self.snp.center)
            }
            return view
        }()
        
        let _: UILabel = {
            let label = UILabel()
            label.text = labelText
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.textColor = .mainFont
            alert.addSubview(label)
            
            label.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview().offset(20)
            }
            return label
        }()
        
        let okButton: UIButton = {
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(self.alertOkAction), for: .touchUpInside)
            button.setTitle("확인", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .mainBlue
            button.viewRounded(cornerRadius: 12)
            alert.addSubview(button)
            
            button.snp.makeConstraints {
                $0.width.equalTo(55)
                $0.height.equalTo(30)
                $0.right.equalToSuperview().offset(-20)
                $0.bottom.equalToSuperview().offset(-20)
            }
            return button
        }()
        
        let _: UIButton = {
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(self.alertCancelAction), for: .touchUpInside)
            button.setTitle("취소", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
            button.setTitleColor(.subFont, for: .normal)
            alert.addSubview(button)
            
            button.snp.makeConstraints {
                $0.width.equalTo(55)
                $0.height.equalTo(30)
                $0.right.equalTo(okButton.snp.left).offset(-20)
                $0.bottom.equalToSuperview().offset(-20)
            }
            return button
        }()
     
    }
    
    @objc
    func alertCancelAction() {
        self.removeFromSuperview()
    }
    
    @objc
    func alertOkAction() {
        okCallback?()
        self.removeFromSuperview()
    }
}
