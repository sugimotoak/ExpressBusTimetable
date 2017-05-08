//
//  SettingsTableViewController.swift
//  ExpressBusTimetable
//
//  Created by akira on 4/22/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
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
            NSLog("\(list)")
            let selection = list.index(of: UserDefaults.onBusStop) ?? 0
            NSLog("\(selection),\(UserDefaults.onBusStop)")
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
            NSLog("\(list)")
            let selection = list.index(of: UserDefaults.offBusStop) ?? 0
            NSLog("\(selection),\(UserDefaults.offBusStop)")
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
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        switch indexPath {
        case IndexPath(item: 1, section: 0):
            let onBusStop = UserDefaults.onBusStop
            let onBusStopLabel = cell.viewWithTag(1) as? UILabel
            onBusStopLabel?.text = onBusStop
            break
        case IndexPath(item: 2, section: 0):
            let offBusStop = UserDefaults.offBusStop
            let offBusStopLabel = cell.viewWithTag(1) as? UILabel
            offBusStopLabel?.text = offBusStop
            break
        default:
            break
        }

        return cell
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
