//
//  UserDefaults+AppSpec.swift
//  ExpressBusTimetable
//
//  Created by akira on 4/17/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import Foundation

/*
 * UserDefaults Class
 */
public extension UserDefaults {
    
    static let KEY_ONBUSSTOP = "KEY_ONBUSSTOP"
    static let DEFAULT_ONBUSSTOP = "杢師４丁目"
    static let KEY_OFFBUSSTOP = "KEY_OFFBUSSTOP"
    static let DEFAULT_OFFBUSSTOP = "東京駅八重洲口前"
    static let KEY_TIMETABLE_STATUS = "KEY_TIMETABLE_STATUS"
    static let DEFAULT_TIMETABLE_STATUS = TimetableStatus.WeekdayUp.rawValue
    
    static var onBusStop: String {
        get {
            return getValue(key: KEY_ONBUSSTOP, defaultValue: DEFAULT_ONBUSSTOP)
        }
        set(value) {
            standard.set(value, forKey: KEY_ONBUSSTOP)
        }
    }
    
    static var offBusStop: String {
        get {
            return getValue(key: KEY_OFFBUSSTOP, defaultValue: DEFAULT_OFFBUSSTOP)
        }
        set(value) {
            standard.set(value, forKey: KEY_OFFBUSSTOP)
        }
    }
    
    static var timetableStatus: TimetableStatus {
        get {
            return TimetableStatus(rawValue: getValue(key: KEY_TIMETABLE_STATUS, defaultValue: DEFAULT_TIMETABLE_STATUS))!
        }
        set(value) {
            standard.set(value.rawValue, forKey: KEY_TIMETABLE_STATUS)
        }
    }
    
    static func getValue(key: String, defaultValue: String) -> String {
        if let value = standard.string(forKey: key) {
            return value
        } else {
            return defaultValue
        }
    }
}
