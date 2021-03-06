//
//  SearchViewController.swift
//  ExpressBusTimetable
//
//  Created by akira on 5/14/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SearchViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = EBTColor.sharedInstance.primaryColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            let title = (tableView.cellForRow(at: indexPath)?.viewWithTag(2) as? UILabel)?.text
            let label = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as? UILabel
            let list = TimetableList.nameList
            log.debug("\(list)")
            let selection = TimetableList.list.index(of: UserDefaults.searchTimetableList) ?? 0
            log.debug("\(selection),\(UserDefaults.searchTimetableList)")
            let picker = ActionSheetStringPicker(title: title,
                                                 rows: list,
                                                 initialSelection: selection,
                                                 doneBlock: {
                                                     _, selectedIndex, selectedValue in
                                                     if selectedIndex != selection {
                                                         let value: String = selectedValue as! String
                                                         label?.text = value
                                                         UserDefaults.searchTimetableList = TimetableList.list[selectedIndex]
                                                         DispatchQueue.main.async { () -> Void in
                                                             tableView.reloadData()
                                                         }
                                                     }
                                                     tableView.deselectRow(at: indexPath, animated: true)
                                                     return },
                                                 cancel: { _ in
                                                     tableView.deselectRow(at: indexPath, animated: true)
                                                     return },
                                                 origin: view)
            picker?.show()
            break
        case IndexPath(row: 1, section: 0):
            let title = (tableView.cellForRow(at: indexPath)?.viewWithTag(2) as? UILabel)?.text
            let label = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as? UILabel
            let timetableWeekDayUp = TimetableStatus.WeekdayUp.getSearchTimetable()
            let list = timetableWeekDayUp.busStopList
            log.debug("\(list)")
            let selection = list.index(of: UserDefaults.searchOnBusStop) ?? 0
            log.debug("\(selection),\(UserDefaults.searchOnBusStop)")
            let picker = ActionSheetStringPicker(title: title,
                                                 rows: list,
                                                 initialSelection: selection,
                                                 doneBlock: {
                                                     _, _, selectedValue in
                                                     let value: String = selectedValue as! String
                                                     if !value.isEmpty {
                                                         label?.text = value
                                                         UserDefaults.searchOnBusStop = value
                                                         if let upDown = timetableWeekDayUp.checkUpDown(value, UserDefaults.searchOffBusStop) {
                                                             UserDefaults.searchTimetableStatus = UserDefaults.searchTimetableStatus.changeUpDown(upDown: upDown)
                                                         }
                                                     }
                                                     tableView.deselectRow(at: indexPath, animated: true)
                                                     return },
                                                 cancel: { _ in
                                                     tableView.deselectRow(at: indexPath, animated: true)
                                                     return },
                                                 origin: view)
            picker?.show()
            break
        case IndexPath(row: 2, section: 0):
            let title = (tableView.cellForRow(at: indexPath)?.viewWithTag(2) as? UILabel)?.text
            let label = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as? UILabel
            let timetableWeekDayUp = TimetableStatus.WeekdayUp.getSearchTimetable()
            let list = timetableWeekDayUp.busStopList
            log.debug("\(list)")
            let selection = list.index(of: UserDefaults.searchOffBusStop) ?? 0
            log.debug("\(selection),\(UserDefaults.searchOffBusStop)")
            let picker = ActionSheetStringPicker(title: title,
                                                 rows: list,
                                                 initialSelection: selection,
                                                 doneBlock: {
                                                     _, _, selectedValue in
                                                     let value: String = selectedValue as! String
                                                     if !value.isEmpty {
                                                         label?.text = value
                                                         UserDefaults.searchOffBusStop = value
                                                         if let upDown = timetableWeekDayUp.checkUpDown(UserDefaults.searchOnBusStop, value) {
                                                             UserDefaults.searchTimetableStatus = UserDefaults.searchTimetableStatus.changeUpDown(upDown: upDown)
                                                         }
                                                     }
                                                     tableView.deselectRow(at: indexPath, animated: true)
                                                     return },
                                                 cancel: { _ in
                                                     tableView.deselectRow(at: indexPath, animated: true)
                                                     return },
                                                 origin: view)
            picker?.show()
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            let timetableName = UserDefaults.searchTimetableList.getName()
            let timetableLabel = cell.viewWithTag(1) as? UILabel
            timetableLabel?.text = timetableName
            break
        case IndexPath(item: 1, section: 0):
            let onBusStop = UserDefaults.searchOnBusStop
            let onBusStopLabel = cell.viewWithTag(1) as? UILabel
            onBusStopLabel?.text = onBusStop
            break
        case IndexPath(item: 2, section: 0):
            let offBusStop = UserDefaults.searchOffBusStop
            let offBusStopLabel = cell.viewWithTag(1) as? UILabel
            offBusStopLabel?.text = offBusStop
            break
        default:
            break
        }
        
        cell.backgroundColor = EBTColor.sharedInstance.secondaryColor
        (cell.viewWithTag(1) as? UILabel)?.textColor = EBTColor.sharedInstance.secondaryTextColor
        (cell.viewWithTag(2) as? UILabel)?.textColor = EBTColor.sharedInstance.secondaryTextColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let v = view as! UITableViewHeaderFooterView
        v.tintColor = EBTColor.sharedInstance.primaryColor
        v.textLabel?.textColor = EBTColor.sharedInstance.primaryTextColor
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Search" {
            
            let vc = segue.destination as! CommuteViewController
            
            vc.isSearch = true
        }
    }
}
