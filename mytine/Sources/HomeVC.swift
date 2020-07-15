//
//  HomeVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/10.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    let routineList = ["혜연 케어", "애리 케어", "재환 케어", "승희 케어", "유진 케어", "수빈 케어", "남수 케어"]
    @IBOutlet var routineCV: UICollectionView!
    @IBOutlet var routineTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routineCV.dataSource = self
        routineTV.dataSource = self
    }
}
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7 * routineList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let checkCell = routineCV.dequeueReusableCell(withReuseIdentifier: "CheckCell", for: indexPath)
        return checkCell
    }
}
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if routineList.count == 0{
            routineTV.setEmptyView(message: "등록한 루틴이 없습니다.", image: "")
        }else {
            routineTV.restore()
        }
        return routineList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if routineList.count == 0{
            routineTV.setEmptyView(message: "등록한 루틴이 없습니다.", image: "")
        }else {
            routineTV.restore()
        }
        return routineList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = routineTV.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        return listCell
    }
}
