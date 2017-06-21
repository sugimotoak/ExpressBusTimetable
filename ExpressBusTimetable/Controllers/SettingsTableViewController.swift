//
//  SettingsTableViewController.swift
//  ExpressBusTimetable
//
//  Created by akira on 4/22/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import XCGLogger
import AAMFeedback

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = EBTColor.sharedInstance.primaryColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    */

    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 3
        default:
            return 0
        }
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(row: 1, section: 0):
            let title = (tableView.cellForRow(at: indexPath)?.viewWithTag(2) as? UILabel)?.text
            let label = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as? UILabel
            let timetableWeekDayUp = TimetableStatus.WeekdayUp.getTimetable()
            let list = timetableWeekDayUp.busStopList
            log.debug("\(list)")
            let selection = list.index(of: UserDefaults.onBusStop) ?? 0
            log.debug("\(selection),\(UserDefaults.onBusStop)")
            let picker = ActionSheetStringPicker(title: title,
                                                 rows: list,
                                                 initialSelection: selection,
                                                 doneBlock: {
                                                     _, _, selectedValue in
                                                     let value: String = selectedValue as! String
                                                     if !value.isEmpty {
                                                         label?.text = value
                                                         UserDefaults.onBusStop = value
                                                         if let upDown = timetableWeekDayUp.checkUpDown(value, UserDefaults.offBusStop) {
                                                             UserDefaults.timetableStatus = UserDefaults.timetableStatus.changeUpDown(upDown: upDown)
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
            let timetableWeekDayUp = TimetableStatus.WeekdayUp.getTimetable()
            let list = timetableWeekDayUp.busStopList
            log.debug("\(list)")
            let selection = list.index(of: UserDefaults.offBusStop) ?? 0
            log.debug("\(selection),\(UserDefaults.offBusStop)")
            let picker = ActionSheetStringPicker(title: title,
                                                 rows: list,
                                                 initialSelection: selection,
                                                 doneBlock: {
                                                     _, _, selectedValue in
                                                     let value: String = selectedValue as! String
                                                     if !value.isEmpty {
                                                         label?.text = value
                                                         UserDefaults.offBusStop = value
                                                         if let upDown = timetableWeekDayUp.checkUpDown(UserDefaults.onBusStop, value) {
                                                             UserDefaults.timetableStatus = UserDefaults.timetableStatus.changeUpDown(upDown: upDown)
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
        case IndexPath(row: 0, section: 1):
            let label = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as? UILabel
            label?.text = UserDefaults.colorTheme.rawValue

            let list = [EBTColor.Theme.Default.rawValue, EBTColor.Theme.White.rawValue]
            let selection = list.index(of: UserDefaults.colorTheme.rawValue) ?? 0
            let picker = ActionSheetStringPicker(title: title,
                                                 rows: list,
                                                 initialSelection: selection,
                                                 doneBlock: {
                                                     _, _, selectedValue in
                                                     let value: String = selectedValue as! String
                                                     if !value.isEmpty {
                                                         label?.text = value
                                                         let theme = EBTColor.Theme(rawValue: value) ?? .Default
                                                         UserDefaults.colorTheme = theme
                                                     }
                                                     tableView.deselectRow(at: indexPath, animated: true)
                                                     return },
                                                 cancel: { _ in
                                                     tableView.deselectRow(at: indexPath, animated: true)
                                                     return },
                                                 origin: view)
            picker?.show()
            break
        case IndexPath(row: 0, section: 2):
            let alert: UIAlertController = UIAlertController(title: "リセットしますか？", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let defaultAction: UIAlertAction = UIAlertAction(title: "リセットする", style: UIAlertActionStyle.destructive, handler: {
                (_: UIAlertAction!) -> Void in
                UserDefaults.reset()
                tableView.reloadData()
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            break
        case IndexPath(row: 0, section: 3):
            let avc = AAMFeedbackViewController()
            avc.toRecipients = ["sugimotoak@gmail.com"]
            avc.ccRecipients = nil
            let nav = UINavigationController(rootViewController: avc)
            present(nav, animated: true, completion: nil)
            break
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        switch indexPath {
        case IndexPath(row: 1, section: 0):
            let onBusStop = UserDefaults.onBusStop
            let onBusStopLabel = cell.viewWithTag(1) as? UILabel
            onBusStopLabel?.text = onBusStop
            break
        case IndexPath(row: 2, section: 0):
            let offBusStop = UserDefaults.offBusStop
            let offBusStopLabel = cell.viewWithTag(1) as? UILabel
            offBusStopLabel?.text = offBusStop
            break
        case IndexPath(row: 0, section: 1):
            let label = cell.viewWithTag(1) as? UILabel
            label?.text = UserDefaults.colorTheme.rawValue
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
