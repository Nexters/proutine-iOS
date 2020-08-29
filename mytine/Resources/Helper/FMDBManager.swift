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
        case week, day, rootine, record
        
        var tableName: String {
            switch self {
            case .week:
                return "WeekRootine"
            case .day:
                return "DayRootine"
            case .rootine:
                return "Rootine"
            case .record:
                return "Record"
            }
        }
    }
    static let shared = FMDBManager()
    private let database: FMDatabase
    private let dbName = "routine.sqlite"
    private let weekTableName = "WeekRootine"
    private let dayTableName = "DayRootine"
    private let rootineTableName = "Rootine"
    private let monthRecordTableName = "Record"
    
    init() {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(dbName)
        database = FMDatabase(url: fileURL)
    }
    
    // MARK: DB Manager
    
    func createTable() -> Bool {
        
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        do {
            try database.executeUpdate("create table if not exists \(weekTableName)(week Integer Primary key AutoIncrement, rootinesIdx Text, weekString Text)", values: nil)
            
            try database.executeUpdate("create table if not exists \(dayTableName)(id Integer Primary key, retrospect Text, week Integer, completes Text)", values: nil)
            
            try database.executeUpdate("create table if not exists \(rootineTableName)(id Integer Primary key AutoIncrement, emoji Text, title Text, goal Text, repeatDays Text)", values: nil)
            
            try database.executeUpdate("create table if not exists \(monthRecordTableName)(id Integer Primary key AutoIncrement, month Text, routineId Integer, count Integer)", values: nil)
        } catch {
            print("create fail")
            database.close()
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
            database.close()
            return false
        }
        database.close()
        return true
    }
    
    // MARK: - WeekRootine Manager
    func addWeek(rootineIdx: String?, weekString: String) -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        do {
            if let rootineIdx = rootineIdx {
                try database.executeUpdate("insert into \(weekTableName) (rootinesIdx, weekString) values (?, ?)", values: [rootineIdx, weekString])
            } else {
                try database.executeUpdate("insert into \(weekTableName) (rootinesIdx, weekString) values (?, ?)", values: ["", weekString])
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            database.close()
            return false
        }
        
        database.close()
        return true
    }
    
    // 0일때 모든 주차 조회
    func selectWeekRootine(week: Int) -> [WeekRootine] {
        guard database.open() else {
            print("Unable to open database")
            return []
        }
        var list: [WeekRootine] = []
        var queryString: String
        if week == 0 {
            queryString = "select * from \(weekTableName)"
        } else {
            queryString = "select * from \(weekTableName) where week = \(week)"
        }
        
        do {
            
            let rs = try database.executeQuery(queryString, values: nil)
            
            while rs.next() {
                let week: Int32 = rs.int(forColumn: "week")
                let rootinesIdx: String = rs.string(forColumn: "rootinesIdx") ?? ""
                let weekString: String = rs.string(forColumn: "weekString") ?? ""
                print("week \(week) ::::: rootinesIdx \(rootinesIdx) ::::: weekString \(weekString)")
                
                let weekRootine = WeekRootine(week: Int(week), rootinesIdx: rootinesIdx, weekString: weekString)
                list.append(weekRootine)
            }
           
        } catch {
            print("Unable to open database")
            database.close()
            return []
        }
        
        database.close()
        return list
    }
    
    func updateWeekRootine(rootinesList: [Int], week: Int) -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        let rootines = rootinesList.map {String($0)}
        let rootineString = rootines.joined(separator: " ")
        do {
            try database.executeUpdate("update \(weekTableName) set rootinesIdx = ? where week = ?", values: [rootineString, week])
        } catch {
            print("failed: \(error.localizedDescription)")
            database.close()
            return false
        }
        database.close()
        return true
    }
    
    // MARK: - DayRootine Manager
    func createDayRootine(rootine: DayRootine) -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        do {
            try database.executeUpdate("insert into \(dayTableName) (id, retrospect, week, completes) values (?,?,?,?)",
                values: [rootine.id, rootine.retrospect, rootine.week, rootine.completeString()])
        } catch {
            print("failed: \(error.localizedDescription)")
            database.close()
            return false
        }
        
        database.close()
        return true
    }
    
    // 0이면 모두 조회
    func selectDayRootine(week: Int) -> [DayRootine] {
        guard database.open() else {
            print("Unable to open database")
            return []
        }
        var dayRootines: [DayRootine] = []
        do {
            var queryString: String
            if week == 0 {
                queryString = "select * from \(dayTableName)"
            } else {
                queryString = "select * from \(dayTableName) where week = \(week)"
            }
            let rs = try database.executeQuery(queryString, values: nil)
            
            
            while rs.next() {
                let id: Int32 = rs.int(forColumn: "id")
                let retrospect: String = rs.string(forColumn: "retrospect") ?? ""
                let week: Int32 = rs.int(forColumn: "week")
                let completes: String = rs.string(forColumn: "completes") ?? ""
                print("count - id \(id) :::: week \(week) ::::: completes \(completes)")
                let completeList: [Int]
                if completes.isEmpty {
                    completeList = []
                } else {
                    completeList = completes.components(separatedBy: .whitespacesAndNewlines).map{Int($0)!}
                }
                dayRootines.append(DayRootine(id: Int(id),
                                              retrospect: retrospect,
                                              week: Int(week),
                                              complete: completeList
                                              ))
            }
           
        } catch {
            print("Unable to open database")
            database.close()
            return []
        }
        
        database.close()
        return dayRootines
    }
    
    func selectDayRootineWithId(id: Int) -> DayRootine? {
        guard database.open() else {
            print("Unable to open database")
            return nil
        }
        var dayRoutine = DayRootine(id: -1, retrospect: "", week: -1, complete: [])
        do {
            let queryString = "select * from \(dayTableName) where id = \(id)"
            
            let rs = try database.executeQuery(queryString, values: nil)
            
            while rs.next() {
                let id: Int32 = rs.int(forColumn: "id")
                let retrospect: String = rs.string(forColumn: "retrospect") ?? ""
                let week: Int32 = rs.int(forColumn: "week")
                let completes: String = rs.string(forColumn: "completes") ?? ""
                print("withid - id \(id) :::: week \(week) ::::: completes \(completes)")
                let completeList: [Int]
                if completes.isEmpty {
                    completeList = []
                } else {
                    completeList = completes.components(separatedBy: .whitespacesAndNewlines).map{Int($0)!}
                }
                dayRoutine = DayRootine(id: Int(id),
                                        retrospect: retrospect,
                                        week: Int(week),
                                        complete: completeList)
            }
            
        } catch {
            print("Unable to open database")
            database.close()
            return nil
        }
        
        database.close()
        return dayRoutine
    }
    
    func isDayRoutine(id: Int) -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        var totalCount = 0
        do {
            let queryString = "select count(*) from \(dayTableName) where id = \(id)"
            let rs = try database.executeQuery(queryString, values: nil)
            
            while rs.next() {
                totalCount = Int(rs.int(forColumn: "count(*)"))
            }
        } catch {
            print("Unable to open database")
            database.close()
            return false
        }
        
        return totalCount == 0 ? false: true
    }
    
    func updateDayRootine(rootine: DayRootine) -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        do {
            try database.executeUpdate("update \(dayTableName) set retrospect = ?, completes = ? where id = ?",
                values: [rootine.retrospect, rootine.completeString(), rootine.id])
        } catch {
            print("failed: \(error.localizedDescription)")
            database.close()
            return false
        }
        database.close()
        return true
    }
    
    // MARK: - Rootine Manager
    func createRootine(rootine: Rootine) -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        do {
            try database.executeUpdate("insert into \(rootineTableName) (emoji, title, goal, repeatDays) values (?,?,?,?)",
                values: [rootine.emoji, rootine.title, rootine.goal, rootine.getRepeatDay()])
        } catch {
            print("failed: \(error.localizedDescription)")
            database.close()
            return false
        }
        
        database.close()
        return true
    }
    
    // 0이면 모두 조회
    func selectRootine(id: Int) -> [Rootine] {
        guard database.open() else {
            print("Unable to open database")
            return []
        }
        var routineList: [Rootine] = []
        do {
            var queryString: String
            if id == 0 {
                queryString = "select * from \(rootineTableName)"
            } else {
                queryString = "select * from \(rootineTableName) where id = \(id)"
            }
            let rs = try database.executeQuery(queryString, values: nil)
            while rs.next() {
                let id: Int32 = rs.int(forColumn: "id")
                let emoji: String = rs.string(forColumn: "emoji") ?? ""
                let title: String = rs.string(forColumn: "title") ?? ""
                let goal: String = rs.string(forColumn: "goal") ?? ""
                let repeatDays: String = rs.string(forColumn: "repeatDays") ?? ""
                let intRepeatDays = repeatDays.components(separatedBy: .whitespacesAndNewlines).map{Int($0)!}
                let routine = Rootine(id: Int(id), emoji: emoji, title: title, goal: goal, repeatDays: intRepeatDays)
                
                routineList.append(routine)
                print("all - id \(id) :::: emoji \(emoji) ::::: repeatDays \(repeatDays)")
            }
           
        } catch {
            print("Unable to open database")
            database.close()
            return []
        }
        
        database.close()
        return routineList
    }
    
    func searchRoutineCount() -> Int {
        guard database.open() else {
            print("Unable to open database")
            return 0
        }
        var totalCount = 0
        do {
            let queryString = "select count(*) from \(rootineTableName)"
            let rs = try database.executeQuery(queryString, values: nil)
            
            while rs.next() {
                totalCount = Int(rs.int(forColumn: "count(*)"))
                
                print("count \(totalCount)")
            }
           
        } catch {
            print("Unable to open database")
            database.close()
            return 0
        }
        
        database.close()
        return totalCount
    }
    
    func updateRootine(rootine: Rootine) -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        do {
            try database.executeUpdate("update \(rootineTableName) set emoji = ?, title = ?, goal = ?, repeatDays = ? where id = ?",
                values: [rootine.emoji, rootine.title, rootine.goal, rootine.getRepeatDay(), rootine.id])
        } catch {
            print("failed: \(error.localizedDescription)")
            database.close()
            return false
        }
        database.close()
        return true
    }
    
    func deleteRootine(id: Int) -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        do {
            try database.executeUpdate("delete from \(rootineTableName) where id = ?", values: [id])
        } catch {
            print("failed: \(error.localizedDescription)")
            database.close()
            return false
        }
        database.close()
        return true
    }
    
    // MARK: - MonthRecord Manager
    // 카운트 추가
    func addRoutineCount(month: String, routineId: String) {
        guard database.open() else {
            print("Unable to open database")
            return
        }
        
        let count = searchRecordCount(month: month, routineId: routineId)
        do {
            if count > 0 {
                try database.executeUpdate("update \(monthRecordTableName) set count = ? where routineId = ?",
                    values: [count+1, routineId])
            } else {
                try database.executeUpdate("insert into \(monthRecordTableName) (month, routineId, count) values (?,?,?)",
                    values: [month, routineId, 1])
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
            database.close()
            return
        }
        
        database.close()
    }
    
    // 루틴 현재기록 조회
    func searchRecordCount(month: String, routineId: String) -> Int {
        
        var count = 0
        do {
            let queryString = "select count from \(monthRecordTableName) where routineId = \(routineId)"
            let rs = try database.executeQuery(queryString, values: nil)
            
            while rs.next() {
                count = Int(rs.int(forColumn: "count"))
                
                print("month routine count \(count)")
            }
           
        } catch {
            print("Unable to open database")
            database.close()
            return 0
        }
        
        database.close()
        return count
    }
    
    // 월간기록 조회
    func selectRecordWithMonth(month: String) {
        
    }
    
}
//id Integer Primary key AutoIncrement, month Text, routineId Integer, count Integer
