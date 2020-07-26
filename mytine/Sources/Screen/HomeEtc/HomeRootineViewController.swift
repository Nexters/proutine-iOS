//
//  HomeRootineViewController.swift
//  mytine
//
//  Created by 남수김 on 2020/07/25.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class HomeRootineViewController: UIViewController {

    @IBOutlet weak var rootineCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        
       
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: HomeRootineCVCell.nibName, bundle: nil)
        rootineCollectionView.register(nib, forCellWithReuseIdentifier: HomeRootineCVCell.reuseIdentifier)
        rootineCollectionView.dataSource = self
        rootineCollectionView.delegate = self
    }
}

extension HomeRootineViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRootineCVCell.reuseIdentifier, for: indexPath) as? HomeRootineCVCell else {
            return .init()
        }
        cell.bind()
        return cell
    }
    
}

extension HomeRootineViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //TODO: 요일넓이 + 루틴갯수 * 루틴한칸넓이
        return CGSize(width: 600, height: 400)
    }
}
