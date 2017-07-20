//
//  ListTypeCommuteTableViewController.swift
//  ExpressBusTimetable
//
//  Created by akira on 4/30/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import UIKit

class ListTypeCommuteTableViewController: CommuteTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        for (section, item) in sct.array.enumerated() {
            for (row, ct) in item.enumerated() {
                if ct.isNext {
                    self.tableView.scrollToRow(at: IndexPath(row: row, section: section),
                                               at: UITableViewScrollPosition.middle,
                                               animated: false)
                    break
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sct.array[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell")!
        let timetable = sct.array[indexPath.section][indexPath.row]
        let timeLabel = cell.contentView.viewWithTag(1) as! UILabel
        let destinationLabel = cell.contentView.viewWithTag(2) as! UILabel
        cell.backgroundColor = EBTColor.sharedInstance.secondaryColor
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 17, weight: UIFontWeightLight)
        timeLabel.text = timetable.onOffBusStopTime
        destinationLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: UIFontWeightLight)
        destinationLabel.text = timetable.destinationBusStop

        if timetable.isNext {
            timeLabel.textColor = EBTColor.sharedInstance.nextTimeColor
            destinationLabel.textColor = EBTColor.sharedInstance.nextTimeColor
        } else {
            timeLabel.textColor = EBTColor.sharedInstance.secondaryTextColor
            destinationLabel.textColor = EBTColor.sharedInstance.secondaryTextColor
        }

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
