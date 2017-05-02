//
//  TableTypeCommuteTableViewController.swift
//  ExpressBusTimetable
//
//  Created by akira on 4/30/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import UIKit

class TableTypeCommuteTableViewController: UITableViewController {
    
    var sct = SectionizedCommuteTimetable([])
    var timetableStatus: TimetableStatus = UserDefaults.timetableStatus.today()
    
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sct.array.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sct.sectionNames[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "tableCell")
        var minuteList = [String]()
        for ct in sct.array[indexPath.section] {
            minuteList.append(ct.onBusStopMinute)
        }
        cell.textLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 17, weight: UIFontWeightRegular)
        cell.textLabel?.text = minuteList.joined(separator: "　")
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sct.sectionIndexes
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
