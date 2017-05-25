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
    
    // commute
    static let KEY_ONBUSSTOP = "KEY_ONBUSSTOP"
    static let DEFAULT_ONBUSSTOP = "杢師４丁目"
    
    static let KEY_OFFBUSSTOP = "KEY_OFFBUSSTOP"
    static let DEFAULT_OFFBUSSTOP = "東京駅八重洲口前"
    
    static let KEY_TIMETABLE_STATUS = "KEY_TIMETABLE_STATUS"
    static let DEFAULT_TIMETABLE_STATUS = TimetableStatus.WeekdayUp.rawValue
    
    static let KEY_TABLEVIEW_TYPE = "KEY_TABLEVIEW_TYPE"
    static let DEFAULT_TABLEVIEW_TYPE = "LIST"
    
    // search
    static let KEY_SEARCH_ONBUSSTOP = "KEY_SEARCH_ONBUSSTOP"
    static let DEFAULT_SEARCH_ONBUSSTOP = "杢師４丁目"
    
    static let KEY_SEARCH_OFFBUSSTOP = "KEY_SEARCH_OFFBUSSTOP"
    static let DEFAULT_SEARCH_OFFBUSSTOP = "東京駅八重洲口前"
    
    static let KEY_SEARCH_TIMETABLE_STATUS = "KEY_TIMETABLE_STATUS"
    static let DEFAULT_SEARCH_TIMETABLE_STATUS = TimetableStatus.WeekdayUp.rawValue
    
    static let KEY_SEARCH_TABLEVIEW_TYPE = "KEY_SEARCH_TABLEVIEW_TYPE"
    static let DEFAULT_SEARCH_TABLEVIEW_TYPE = "LIST"
    
    static let KEY_COLOR_THEME = "KEY_COLOR_THEME"
    static let DEFAULT_COLOR_THEME = "Black"
    
    static func getValue(key: String, defaultValue: String) -> String {
        if let value = standard.string(forKey: key) {
            return value
        } else {
            return defaultValue
        }
    }
    
    // commute
    static var onBusStop: String {
        get {
            return getValue(key: KEY_ONBUSSTOP, defaultValue: DEFAULT_ONBUSSTOP)
        }
        set(value) {
            standard.set(value, forKey: KEY_ONBUSSTOP)
            standard.synchronize()
        }
    }
    
    static var offBusStop: String {
        get {
            return getValue(key: KEY_OFFBUSSTOP, defaultValue: DEFAULT_OFFBUSSTOP)
        }
        set(value) {
            standard.set(value, forKey: KEY_OFFBUSSTOP)
            standard.synchronize()
        }
    }
    
    static var timetableStatus: TimetableStatus {
        get {
            return TimetableStatus(rawValue: getValue(key: KEY_TIMETABLE_STATUS, defaultValue: DEFAULT_TIMETABLE_STATUS))!
        }
        set(value) {
            standard.set(value.rawValue, forKey: KEY_TIMETABLE_STATUS)
            standard.synchronize()
        }
    }
    
    static var tableViewDisplayType: TimetableStatus.DisplayType {
        get {
            return TimetableStatus.DisplayType(rawValue: getValue(key: KEY_TABLEVIEW_TYPE, defaultValue: DEFAULT_TABLEVIEW_TYPE))!
        }
        set(value) {
            standard.set(value.rawValue, forKey: KEY_TABLEVIEW_TYPE)
            standard.synchronize()
        }
    }
    
    // search
    static var searchOnBusStop: String {
        get {
            return getValue(key: KEY_SEARCH_ONBUSSTOP, defaultValue: DEFAULT_SEARCH_ONBUSSTOP)
        }
        set(value) {
            standard.set(value, forKey: KEY_SEARCH_ONBUSSTOP)
            standard.synchronize()
        }
    }
    
    static var searchOffBusStop: String {
        get {
            return getValue(key: KEY_SEARCH_OFFBUSSTOP, defaultValue: DEFAULT_SEARCH_OFFBUSSTOP)
        }
        set(value) {
            standard.set(value, forKey: KEY_SEARCH_OFFBUSSTOP)
            standard.synchronize()
        }
    }
    
    static var searchTimetableStatus: TimetableStatus {
        get {
            return TimetableStatus(rawValue: getValue(key: KEY_SEARCH_TIMETABLE_STATUS, defaultValue: DEFAULT_SEARCH_TIMETABLE_STATUS))!
        }
        set(value) {
            standard.set(value.rawValue, forKey: KEY_SEARCH_TIMETABLE_STATUS)
            standard.synchronize()
        }
    }
    
    static var searchTableViewDisplayType: TimetableStatus.DisplayType {
        get {
            return TimetableStatus.DisplayType(rawValue: getValue(key: KEY_SEARCH_TABLEVIEW_TYPE, defaultValue: DEFAULT_SEARCH_TABLEVIEW_TYPE))!
        }
        set(value) {
            standard.set(value.rawValue, forKey: KEY_SEARCH_TABLEVIEW_TYPE)
            standard.synchronize()
        }
    }
    
    static var colorTheme: EBTColor.Theme {
        get {
            return EBTColor.Theme(rawValue: getValue(key: KEY_COLOR_THEME, defaultValue: DEFAULT_COLOR_THEME))!
        }
        set(value) {
            standard.set(value.rawValue, forKey: KEY_COLOR_THEME)
            standard.synchronize()
        }
    }
    
    static func reset() {
        standard.removeObject(forKey: KEY_ONBUSSTOP)
        standard.removeObject(forKey: KEY_OFFBUSSTOP)
        standard.removeObject(forKey: KEY_TIMETABLE_STATUS)
        standard.removeObject(forKey: KEY_TABLEVIEW_TYPE)
    }
}
