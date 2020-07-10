//
//  HomeVC.swift
//  mytine
//
//  Created by 황수빈 on 2020/07/10.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    let routineList = [""]
    let count = 4 // 사용자가 등록한 루틴의 갯수
    @IBOutlet var routineSetCV: UICollectionView!
    @IBOutlet var routineCV: UICollectionView!
    @IBOutlet var routineTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routineSetCV.dataSource = self
        routineCV.dataSource = self
        routineTV.dataSource = self
    }
}
extension HomeVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == routineCV {
            return 2    // 요일, 체크칸
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == routineCV {
            switch section {
            case 0: // 요일
                return 7
            default: // 체크칸
                return 7 * count
            }
        } else {
            // 전체 몇 개를 return 해야할까
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == routineCV {
            switch indexPath.section {
            case 0: // 요일
                let weekCell = routineCV.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath)
                return weekCell
            default: // 체크칸
                let checkCell = routineCV.dequeueReusableCell(withReuseIdentifier: "CheckCell", for: indexPath)
                return checkCell
            }
        } else {
            let setCell = routineSetCV.dequeueReusableCell(withReuseIdentifier: "SetCell", for: indexPath)
            return setCell
        }
    }
}
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if routineList.count == 0{
            routineTV.setEmptyView(message: "생성된 채팅방이 없습니다.\n요청을 수락하거나 채팅 요청을 해보세요.", image: "imgChatEmpty")
        }else {
            routineTV.restore()
        }
        return routineList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
