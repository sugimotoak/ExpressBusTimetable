//
//  TimetableStatus.swift
//  ExpressBusTimetable
//
//  Created by akira on 4/21/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import Foundation

public enum TimetableStatus: String {
    case WeekdayUp
    case WeekdayDown
    case WeekendUp
    case WeekendDown
    
    enum UpDown {
        case Up
        case Down
    }
    
    enum Week {
        case Day
        case End
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
    
    func today() -> TimetableStatus {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        if calendar.isDateInWeekend(Date()) {
            return self.changeWeek(week: .End)
        } else {
            return self.changeWeek(week: .Day)
        }
    }
    
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
    
    func switchWeek() -> TimetableStatus {
        switch self {
        case .WeekdayUp:
            return .WeekendUp
        case .WeekdayDown:
            return .WeekendDown
        case .WeekendUp:
            return .WeekdayUp
        case .WeekendDown:
            return .WeekdayDown
        }
    }
    
    func changeUpDown(upDown: UpDown) -> TimetableStatus {
        if upDown == .Up {
            if !self.isUp() {
                return self.switchUpDown()
            }
        } else {
            if self.isUp() {
                return self.switchUpDown()
            }
        }
        return self
    }
    
    func changeWeek(week: Week) -> TimetableStatus {
        if week == .Day {
            if self.isWeekend() {
                return self.switchWeek()
            }
        } else {
            if !self.isWeekend() {
                return self.switchWeek()
            }
        }
        return self
    }
    
    func changeWeekDayUp() -> TimetableStatus {
        return self.changeWeek(week: TimetableStatus.Week.Day).changeUpDown(upDown: TimetableStatus.UpDown.Up)
    }
    
    func isUp() -> Bool {
        switch self {
        case .WeekdayUp, .WeekendUp:
            return true
        case .WeekdayDown, .WeekendDown:
            return false
        }
    }
    
    func upDownRiverseValue() -> String {
        if !self.isUp() {
            return "上り"
        } else {
            return "下り"
        }
    }
    
    func isWeekend() -> Bool {
        switch self {
        case .WeekendUp, .WeekendDown:
            return true
        case .WeekdayUp, .WeekdayDown:
            return false
        }
    }
}
