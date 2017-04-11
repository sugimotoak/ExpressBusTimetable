//
//  Timetable.swift
//  ExpressBusTimetable
//
//  Created by akira on 2/5/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import Foundation
import CSV

enum BusStopStatus {
    case ON
    case OFF
}

enum TimetableStatus {
    case WeekdayUp
    case WeekdayDown
    case WeekendUp
    case WeekendDown;
    
    func switchUpDown() -> TimetableStatus {
        switch self {
        case .WeekdayUp:
            return .WeekdayDown
        case .WeekdayDown:
            return .WeekdayUp
        case .WeekendUp:
            return .WeekendDown
        case .WeekendDown:
            return .WeekendUp
        }
    }
    
    func getTimetable() -> Timetable {
        switch self {
        case .WeekdayUp:
            return WeekdayUpTimetable.sharedInstance
        case .WeekdayDown:
            return WeekdayDownTimetable.sharedInstance
        case .WeekendUp:
            return WeekendUpTimetable.sharedInstance
        case .WeekendDown:
            return WeekendDownTimetable.sharedInstance
        }
    }
    
    func isUp() -> Bool {
        switch self {
        case .WeekdayUp, .WeekendUp:
            return true
        case .WeekdayDown, .WeekendDown:
            return false
        }
    }
}

let none = "─"
let through = "↓"

class Timetable {
    
    var busStopList = [String]()
    var onBusStopList = [String]()
    var offBusStopList = [String]()
    var busComList = [String]()
    var timetable = [[String]]()
    var countField = 0
    
    init(fileName:String) {
        loadTimetable(fileName)
    }
    
    func loadTimetable(_ fileName: String) {
        let filePath = Bundle.main.path(forResource: fileName, ofType: "csv")!
        let stream = InputStream(fileAtPath: filePath)!
        print("file : kimitsu_tokyo_weekday_up.csv");
        
        
        do{
            
            var status : BusStopStatus = .ON
            for row in try CSV(stream: stream) {
                
                countField = row.count
                print("\(row[0])")
                
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
            print("error")
        }
        print("\(onBusStopList)")
        print("\(offBusStopList)")
        busStopList = onBusStopList + [""] + offBusStopList
        print("\(busStopList)")
        print(countField)
        print("\(busComList)")
        print("\(timetable)")
        
        
        
        
    }

    func getCommutingTimetable(_ onBusStop: String, _ offBusStop: String) -> [CommutingTimetable] {
        var onBusStopIndex:Int = 0
        var offBusStopIndex:Int = 0
        for (index,busStop) in busStopList.enumerated() {
            if onBusStop == busStop {
                onBusStopIndex = index
            }
            if offBusStop == busStop {
                offBusStopIndex = index
            }
        }
        print("\(onBusStopIndex):\(onBusStop)")
        print("\(offBusStopIndex):\(offBusStop)")
        
        
        var ctList = [CommutingTimetable]()
        for row in timetable {
            if row[onBusStopIndex] != none && row[offBusStopIndex] != none
            && row[onBusStopIndex] != through && row[offBusStopIndex] != through {
                var destinationBusStop:String = ""
                for i in (0..<busStopList.count).reversed() {
                    if row[i] != none {
                        destinationBusStop = busStopList[i]
                        break
                    }
                }
                let ct = CommutingTimetable(row[onBusStopIndex], row[offBusStopIndex],destinationBusStop)
                ctList.append(ct)
            }
        }
        return ctList
    }
}

class WeekdayUpTimetable :Timetable{
    static let sharedInstance = WeekdayUpTimetable()
    private init() {
        super.init(fileName: "kimitsu_tokyo_weekday_up")
    }
}

class WeekdayDownTimetable :Timetable{
    static let sharedInstance = WeekdayDownTimetable()
    private init() {
        super.init(fileName: "kimitsu_tokyo_weekday_down")
    }
}

class WeekendUpTimetable :Timetable{
    static let sharedInstance = WeekendUpTimetable()
    private init() {
        super.init(fileName: "kimitsu_tokyo_weekend_up")
    }
}

class WeekendDownTimetable :Timetable{
    static let sharedInstance = WeekendDownTimetable()
    private init() {
        super.init(fileName: "kimitsu_tokyo_weekend_down")
    }
}

class CommutingTimetable: CustomStringConvertible {
    let onBusStopTime: String
    let offBusStopTime: String
    let destinationBusStop: String
    
    init(_ onBusStopTime: String, _ offBusStopTime: String, _ destinationBusStop: String) {
        self.onBusStopTime = onBusStopTime
        self.offBusStopTime = offBusStopTime
        self.destinationBusStop = destinationBusStop
    }
    
    var description: String { return "\(onBusStopTime) - \(offBusStopTime) \(destinationBusStop)行き" }
}