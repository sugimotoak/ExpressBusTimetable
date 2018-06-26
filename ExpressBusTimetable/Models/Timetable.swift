//
//  Timetable.swift
//  ExpressBusTimetable
//
//  Created by akira on 2/5/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import Foundation
import CSV
import SwiftDate

class Timetable {
    
    enum BusStopStatus {
        case ON
        case OFF
    }
    
    let noneList = ["─", "―"]
    let through = "↓"
    
    func isNone(_ string: String) -> Bool {
        for none in noneList {
            if string == none {
                return true
            }
        }
        return false
    }
    
    var busStopList = [String]()
    var onBusStopList = [String]()
    var offBusStopList = [String]()
    var busComList = [String]()
    var timetable = [[String]]()
    var countField = 0
    
    init(fileName: String) {
        loadTimetable(fileName)
    }
    
    func changeTimetable(fileName: String) {
        busStopList = [String]()
        onBusStopList = [String]()
        offBusStopList = [String]()
        busComList = [String]()
        timetable = [[String]]()
        countField = 0
        loadTimetable(fileName)
    }
    
    func loadTimetable(_ fileName: String) {
        let filePath = Bundle.main.path(forResource: fileName, ofType: "csv")!
        let stream = InputStream(fileAtPath: filePath)!
        log.debug("file : \(fileName)")
        
        do {
            
            var status: BusStopStatus = .ON
            for row in try CSV(stream: stream) {
                
                countField = row.count
                log.debug("\(row[0])")
                
                if row[0].isEmpty && onBusStopList.count != 0 {
                    status = .OFF
                }
                
                if !row[0].isEmpty {
                    switch status {
                    case .ON:
                        onBusStopList.append(row[0])
                        break
                    case .OFF:
                        offBusStopList.append(row[0])
                        break
                    }
                }
                
                if onBusStopList.count == 0 {
                    for field in row {
                        busComList.append(field)
                    }
                    busComList.remove(at: 0)
                    
                    for _ in 1..<countField {
                        timetable.append([String]())
                    }
                } else {
                    for i in 1..<countField {
                        timetable[i - 1].append(row[i])
                    }
                }
                
            }
        } catch {
            log.debug("error")
        }
        log.debug("\(onBusStopList)")
        log.debug("\(offBusStopList)")
        busStopList = onBusStopList + [""] + offBusStopList
        log.debug("\(busStopList)")
        log.debug(countField)
        log.debug("\(busComList)")
        log.debug("\(timetable)")
        
    }
    
    func getCommuteTimetable(_ onBusStop: String, _ offBusStop: String) -> SectionizedCommuteTimetable {
        var onBusStopIndex: Int = 0
        var offBusStopIndex: Int = 0
        for (index, busStop) in busStopList.enumerated() {
            if onBusStop == busStop {
                onBusStopIndex = index
            }
            if offBusStop == busStop {
                offBusStopIndex = index
            }
        }
        log.debug("\(onBusStopIndex):\(onBusStop)")
        log.debug("\(offBusStopIndex):\(offBusStop)")
        
        var ctList = [CommuteTimetable]()
        for row in timetable {
            if !isNone(row[onBusStopIndex]) && !isNone(row[offBusStopIndex])
                && row[onBusStopIndex] != through && row[offBusStopIndex] != through {
                var destinationBusStop: String = ""
                for i in (0..<busStopList.count).reversed() {
                    if !isNone(row[i]) {
                        destinationBusStop = busStopList[i]
                        break
                    }
                }
                let ct = CommuteTimetable(row[onBusStopIndex], row[offBusStopIndex], destinationBusStop)
                ctList.append(ct)
            }
        }
        
        return SectionizedCommuteTimetable(ctList)
    }
    
    func checkUpDown(_ onBusStop: String, _ offBusStop: String) -> TimetableStatus.UpDown? {
        let onBusStopIndex = busStopList.index(of: onBusStop)
        let offBusStopIndex = busStopList.index(of: offBusStop)
        if onBusStopIndex == nil || offBusStopIndex == nil {
            return nil
        } else if onBusStopIndex! < offBusStopIndex! {
            return TimetableStatus.UpDown.Up
        } else if offBusStopIndex! < onBusStopIndex! {
            return TimetableStatus.UpDown.Down
        }
        return nil
    }
}

public enum TimetableList: String {
    case KIMITSU_TOKYO
    case KIMITSU_HANEDA
    
    public static let list: [TimetableList] = [.KIMITSU_TOKYO, .KIMITSU_HANEDA]
    public static let nameList = ["青掘駅・君津駅〜東京駅・浜松町駅", "君津駅〜羽田空港"]
    
    func getCsvList() -> [String] {
        switch self {
        case .KIMITSU_TOKYO:
            return ["kimitsu_tokyo_weekday_up", "kimitsu_tokyo_weekday_down", "kimitsu_tokyo_weekend_up", "kimitsu_tokyo_weekend_down"]
        case .KIMITSU_HANEDA:
            return ["kimitsu_haneda_weekday_up", "kimitsu_haneda_weekday_down", "kimitsu_haneda_weekend_up", "kimitsu_haneda_weekend_down"]
        }
    }
    
    func getName() -> String {
        return TimetableList.nameList[TimetableList.list.index(of: self)!]
    }
    
    func getWeekdayUpTimetableCSVName() -> String {
        return getCsvList()[0]
    }
    
    func getWeekdayDownTimetableCSVName() -> String {
        return getCsvList()[1]
    }
    
    func getWeekendUpTimetableCSVName() -> String {
        return getCsvList()[2]
    }
    
    func getWeekendDownTimetableCSVName() -> String {
        return getCsvList()[3]
    }
}

class WeekdayUpCommuteTimetable: Timetable {
    static let sharedInstance = WeekdayUpCommuteTimetable()
    private init() {
        super.init(fileName: UserDefaults.timetableList.getWeekdayUpTimetableCSVName())
    }
    
    public func reload() {
        super.changeTimetable(fileName: UserDefaults.timetableList.getWeekdayUpTimetableCSVName())
    }
}

class WeekdayDownCommuteTimetable: Timetable {
    static let sharedInstance = WeekdayDownCommuteTimetable()
    private init() {
        super.init(fileName: UserDefaults.timetableList.getWeekdayDownTimetableCSVName())
    }
    
    public func reload() {
        super.changeTimetable(fileName: UserDefaults.timetableList.getWeekdayDownTimetableCSVName())
    }
}

class WeekendUpCommuteTimetable: Timetable {
    static let sharedInstance = WeekendUpCommuteTimetable()
    private init() {
        super.init(fileName: UserDefaults.timetableList.getWeekendUpTimetableCSVName())
    }
    
    public func reload() {
        super.changeTimetable(fileName: UserDefaults.timetableList.getWeekendUpTimetableCSVName())
    }
}

class WeekendDownCommuteTimetable: Timetable {
    static let sharedInstance = WeekendDownCommuteTimetable()
    private init() {
        super.init(fileName: UserDefaults.timetableList.getWeekendDownTimetableCSVName())
    }
    
    public func reload() {
        super.changeTimetable(fileName: UserDefaults.timetableList.getWeekendDownTimetableCSVName())
    }
}

class WeekdayUpSearchTimetable: Timetable {
    static let sharedInstance = WeekdayUpSearchTimetable()
    private init() {
        super.init(fileName: UserDefaults.searchTimetableList.getWeekdayUpTimetableCSVName())
    }
    
    public func reload() {
        super.changeTimetable(fileName: UserDefaults.searchTimetableList.getWeekdayUpTimetableCSVName())
    }
}

class WeekdayDownSearchTimetable: Timetable {
    static let sharedInstance = WeekdayDownSearchTimetable()
    private init() {
        super.init(fileName: UserDefaults.searchTimetableList.getWeekdayDownTimetableCSVName())
    }
    
    public func reload() {
        super.changeTimetable(fileName: UserDefaults.searchTimetableList.getWeekdayDownTimetableCSVName())
    }
}

class WeekendUpSearchTimetable: Timetable {
    static let sharedInstance = WeekendUpSearchTimetable()
    private init() {
        super.init(fileName: UserDefaults.searchTimetableList.getWeekendUpTimetableCSVName())
    }
    
    public func reload() {
        super.changeTimetable(fileName: UserDefaults.searchTimetableList.getWeekendUpTimetableCSVName())
    }
}

class WeekendDownSearchTimetable: Timetable {
    static let sharedInstance = WeekendDownSearchTimetable()
    private init() {
        super.init(fileName: UserDefaults.searchTimetableList.getWeekendDownTimetableCSVName())
    }
    
    public func reload() {
        super.changeTimetable(fileName: UserDefaults.searchTimetableList.getWeekendDownTimetableCSVName())
    }
}

class SectionizedCommuteTimetable {
    let commuteTimetableArray: [CommuteTimetable]
    var sectionNames = [String]()
    var sectionIndexes = [String]()
    var array = [[CommuteTimetable]]()
    
    init(_ commuteTimetableArray: [CommuteTimetable]) {
        self.commuteTimetableArray = commuteTimetableArray
        let now = Date().inRegion(region: Region.init(tz: TimeZoneName.asiaTokyo, cal: CalendarName.gregorian, loc: LocaleName.japaneseJapan))
        var isNextBusStopTime = false
        
        var preHour = ""
        for ct in commuteTimetableArray {
            let hour = ct.onBusStopHour
            let minute = ct.onBusStopMinute
            if !isNextBusStopTime {
                if let time = now.atTime(hour: Int(hour)!, minute: Int(minute)!, second: 0) {
                    if now < time {
                        isNextBusStopTime = true
                        ct.isNext = true
                    }
                }
            }
            
            if hour != preHour {
                sectionNames.append(hour + ":00")
                sectionIndexes.append(hour)
                array.append([ct])
            } else {
                array[array.endIndex - 1].append(ct)
            }
            preHour = hour
            
        }
        
    }
}

class CommuteTimetable {
    let onBusStopTime: String
    let offBusStopTime: String
    let destinationBusStop: String
    var isNext = false
    
    var onOffBusStopTime: String {
        return "\(onBusStopTime) - \(offBusStopTime)"
    }
    
    var onBusStopHour: String {
        return String(onBusStopTime.prefix(2))
    }
    
    var onBusStopMinute: String {
        return String(onBusStopTime.suffix(2))
    }
    
    init(_ onBusStopTime: String, _ offBusStopTime: String, _ destinationBusStop: String) {
        self.onBusStopTime = CommuteTimetable.formatTime(onBusStopTime)
        self.offBusStopTime = CommuteTimetable.formatTime(offBusStopTime)
        self.destinationBusStop = destinationBusStop
    }
    
    static func formatTime(_ time: String) -> String {
        let addZero = "0" + time
        if let range = addZero.range(of: "\\d{2}:\\d{2}", options: .regularExpression, range: nil, locale: .current) {
            return String(addZero[range])
        }
        return time
    }
}
