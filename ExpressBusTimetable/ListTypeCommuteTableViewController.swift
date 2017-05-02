//
//  ListTypeCommuteTableViewController.swift
//  ExpressBusTimetable
//
//  Created by akira on 4/30/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import UIKit

class ListTypeCommuteTableViewController: UITableViewController {

    var sct = SectionizedCommuteTimetable([])

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
        return sct.array[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "listCell")
        cell.textLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 17, weight: UIFontWeightRegular)
        cell.textLabel?.text = "\(sct.array[indexPath.section][indexPath.row])"
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
