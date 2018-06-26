//
//  TableTypeCommuteTableViewController.swift
//  ExpressBusTimetable
//
//  Created by akira on 4/30/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import UIKit

class TableTypeCommuteTableViewController: CommuteTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        for (section, item) in sct.array.enumerated() {
            for (_, ct) in item.enumerated() {
                if ct.isNext {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: section),
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
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "tableCell")
        var minuteList = [String]()
        var nextBusStopMinuteIndex: Int?
        sct.array[indexPath.section].enumerated().forEach { index, ct in
            minuteList.append(ct.onBusStopMinute)
            if ct.isNext {
                nextBusStopMinuteIndex = index
            }
        }
        let text = minuteList.joined(separator: "　")
        cell.backgroundColor = EBTColor.sharedInstance.secondaryColor
        cell.textLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 17, weight: UIFont.Weight.light)
        cell.textLabel?.textColor = EBTColor.sharedInstance.secondaryTextColor

        if let index = nextBusStopMinuteIndex {
            let attrText = NSMutableAttributedString(string: text)
            let startIndex = index * 3
            attrText.addAttributes([NSAttributedStringKey.foregroundColor: EBTColor.sharedInstance.nextTimeColor],
                                   range: NSMakeRange(startIndex, 2))
            cell.textLabel?.attributedText = attrText
        } else {
            cell.textLabel?.text = text
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
