//
//  Timetable.swift
//  ExpressBusTimetable
//
//  Created by akira on 2/5/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import Foundation
import CSV

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
        self.loadTimetable(fileName)
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

class WeekdayUpTimetable: Timetable {
    static let sharedInstance = WeekdayUpTimetable()
    private init() {
        super.init(fileName: "kimitsu_tokyo_weekday_up")
    }
}

class WeekdayDownTimetable: Timetable {
    static let sharedInstance = WeekdayDownTimetable()
    private init() {
        super.init(fileName: "kimitsu_tokyo_weekday_down")
    }
}

class WeekendUpTimetable: Timetable {
    static let sharedInstance = WeekendUpTimetable()
    private init() {
        super.init(fileName: "kimitsu_tokyo_weekend_up")
    }
}

class WeekendDownTimetable: Timetable {
    static let sharedInstance = WeekendDownTimetable()
    private init() {
        super.init(fileName: "kimitsu_tokyo_weekend_down")
    }
}

class SectionizedCommuteTimetable {
    let commuteTimetableArray: [CommuteTimetable]
    var sectionNames = [String]()
    var sectionIndexes = [String]()
    var array = [[CommuteTimetable]]()
    
    init(_ commuteTimetableArray: [CommuteTimetable]) {
        self.commuteTimetableArray = commuteTimetableArray
        
        var preIndex = ""
        for ct in commuteTimetableArray {
            if let range = ct.onBusStopTime.range(of: "\\d{2}", options: .regularExpression, range: nil, locale: .current) {
                let index = ct.onBusStopTime.substring(with: range)
                if index != preIndex {
                    sectionNames.append(index + ":00")
                    sectionIndexes.append(index)
                    array.append([ct])
                } else {
                    array[array.endIndex - 1].append(ct)
                }
                preIndex = index
            }
        }
        
    }
}

class CommuteTimetable {
    let onBusStopTime: String
    let offBusStopTime: String
    let destinationBusStop: String
    
    var onOffBusStopTime: String {
        return "\(onBusStopTime) - \(offBusStopTime)"
    }
    
    var onBusStopMinute: String {
        return offBusStopTime.substring(from: offBusStopTime.index(offBusStopTime.endIndex, offsetBy: -2))
    }
    
    init(_ onBusStopTime: String, _ offBusStopTime: String, _ destinationBusStop: String) {
        self.onBusStopTime = CommuteTimetable.formatTime(onBusStopTime)
        self.offBusStopTime = CommuteTimetable.formatTime(offBusStopTime)
        self.destinationBusStop = destinationBusStop
    }
    
    static func formatTime(_ time: String) -> String {
        let addZero = "0" + time
        if let range = addZero.range(of: "\\d{2}:\\d{2}", options: .regularExpression, range: nil, locale: .current) {
            return addZero.substring(with: range)
        }
        return time
    }
}
