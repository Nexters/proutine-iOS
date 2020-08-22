//
//  SplashViewController.swift
//  mytine
//
//  Created by 남수김 on 2020/08/22.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    @IBOutlet weak var onboardLottieView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    
    private var animationView: AnimationView = AnimationView(name: "data1")
    private var curPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.viewRounded(cornerRadius: 8)
    }
    
    override func viewDidLayoutSubviews() {
        
        setLottieView()
        onbaordPlay()
    }
    
    func setLottieView() {
        animationView.loopMode = .loop
        onboardLottieView.addSubview(animationView)
        
        animationView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
    }
  
    func onbaordPlay() {
        let page = curPage
        let animation: Animation?
        switch page {
        case 1:
            animation = AnimationView(name: "data1").animation
        case 2:
            animation = AnimationView(name: "data2").animation
        case 3:
             animation = AnimationView(name: "data3").animation
        default:
            return
        }
        
        animationView.animation = animation
        animationView.play()
    }
    
    func changeViewWithPage() {
        if curPage == 2 {
            mainLabel.text = "루틴 완료하기"
            subLabel.text = "좌우 스와이프로 루틴을\n완료, 취소해보세요!"
            pageController.currentPage = 1
        } else {
            mainLabel.text = "월간회고 확인하기"
            subLabel.text = "매달 나의 루틴 순위를 확인하며\n더 나은 다음 달을 계획해보세요!!"
            pageController.currentPage = 2
            nextButton.setTitle("프루틴 시작하기", for: .normal)
            skipButton.isHidden = true
        }
    }
    
    func goMainHomeVC() {
        UserDefaults.standard.set(true, forKey: UserDefaultKeyName.tutorial.getString)
        let storyboard = UIStoryboard(name: "Home", bundle: .main)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "HomeNav")
    }
    
    @IBAction func nextClick(_ sender: Any) {
        if curPage == 3 {
            goMainHomeVC()
        }
        curPage += 1
        onbaordPlay()
        changeViewWithPage()
    }
    
    @IBAction func skipClick(_ sender: Any) {
        goMainHomeVC()
    }
}
