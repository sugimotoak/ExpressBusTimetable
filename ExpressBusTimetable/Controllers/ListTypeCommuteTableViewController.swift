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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
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
        timeLabel.textColor = EBTColor.sharedInstance.secondaryTextColor
        destinationLabel.text = timetable.destinationBusStop

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
