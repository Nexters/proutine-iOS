//
//  FMDBManager.swift
//  mytine
//
//  Created by 남수김 on 2020/07/26.
//  Copyright © 2020 황수빈. All rights reserved.
//

import Foundation
import FMDB

class FMDBManager {
    
    enum TableType {
        case week, day, rootine
        
        var tableName: String {
            switch self {
            case .week:
                return "WeekRootine"
            case .day:
                return "DayRootine"
            case .rootine:
                return "Rootine"
            default:
                return ""
            }
        }
    }
    static let shared = FMDBManager()
    private let database: FMDatabase
    private let dbName = "Rootine.sqlite"
    private let weekTableName = "WeekRootine"
    private let dayTableName = "DayRootine"
    private let rootineTableName = "Rootine"
    
    init() {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(dbName)
        database = FMDatabase(url: fileURL)
    }
    
    func createTable() -> Bool {
        
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        do {
            try database.executeUpdate("create table if not exists \(weekTableName)(week Integer Primary key AutoIncrement, rootinesIdx Text)", values: nil)
            
            try database.executeUpdate("create table if not exists \(dayTableName)(id Integer Primary key, retrospect Text, week Integer, completes = Text, rootineRate Text)", values: nil)
            
            try database.executeUpdate("create table if not exists \(rootineTableName)(id Integer Primary key AutoIncrement, emoji Text, title, Text, goal Text, repeatDays Text, count Integer)", values: nil)
        } catch {
            print("create fail")
            return false
        }
        database.close()
        return true
    }
    
    // MARK: WeekRootine Manager
    func addWeek() -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        do {
            try database.executeUpdate("insert into \(weekTableName)", values: nil)
        } catch {
            print("failed: \(error.localizedDescription)")
            return false
        }
        
        database.close()
        return true
    }
    
    func selectWeekRootine(week: Int) -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        do {
            var weekNum: String
            if week == 0 {
                weekNum = "*"
            } else {
                weekNum = "\(week)"
            }
            let rs = try database.executeQuery("select \(weekNum) from \(weekTableName)", values: nil)
            
            while rs.next() {
                let id: Int32 = rs.int(forColumn: "id")
                let title: String = rs.string(forColumn: "title") ?? ""
                
                print("id \(id)")
                print("title \(title)")
            }
           
        } catch {
            print("Unable to open database")
            return false
        }
        
        database.close()
        return true
    }
    
    func updateWeekRootine(rootinesList: [Int], week: Int) -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        let rootines = rootinesList.reduce(into: "") {"\($0) \($1)"}
        print("update \(rootines)")
        do {
            try database.executeUpdate("update \(weekTableName) set rootinesIdx = ? where week = ?", values: [rootines, week])
        } catch {
            print("failed: \(error.localizedDescription)")
            return false
        }
        database.close()
        return true
    }
    
    
    
    func dropDB(type: TableType) -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        do {
            try database.executeUpdate("drop table \(type.tableName)", values: nil)
        } catch {
            print("failed: \(error.localizedDescription)")
            return false
        }
        database.close()
        return true
    }
}

/*
 class WeekRootine {
   let rootinesIdx: [Int] = [1,3,4,9] //해당 루틴
   let week = 1 //주차, PK
   let rootineRate = [0.3, 1, 1, .... 7개] // 달성률
 }

 class DayRootine {
   let id = 20200720 //idx를위한구분, PK
   let retrospect: String = "회고를 적어따" //회고
   let week = 1 // 주차구분을위한
   let complete = [true, false, true, false] //완료여부 - WeekRootine과 매칭 1완료
 }

 //////////
 class Rootine {
   let idx = 1 //id, PK
   let iconImg: String //이모지
   let title: String
   let goal: String
   let repeatDays = [.mon, .fri] //반복요일
   let count = 1 // 0일때 디비에서 삭제
 }
 */

