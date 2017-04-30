//
//  CommuteViewController.swift
//  ExpressBusTimetable
//
//  Created by akira on 2/4/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import Foundation
import UIKit

class CommuteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var tableTableView: UITableView!
    @IBOutlet weak var changeButton: UIBarButtonItem!
    @IBOutlet weak var displayFormatSegmentedControl: UISegmentedControl!
    @IBOutlet weak var weekFormatSegmentedControl: UISegmentedControl!
    
    var sct = SectionizedCommuteTimetable([])
    var timetableStatus: TimetableStatus = UserDefaults.timetableStatus.today()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        listTableView.delegate = self
        listTableView.dataSource = self
        tableTableView.delegate = self
        tableTableView.dataSource = self
        listTableView.isHidden = false
        tableTableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let onBusStop = UserDefaults.onBusStop
        let offBusStop = UserDefaults.offBusStop
        changeButton.title = timetableStatus.upDownRiverseValue()
        sct = timetableStatus.getTimetable().getCommuteTimetable(onBusStop, offBusStop)
        navigationItem.title = onBusStop + "->" + offBusStop
        listTableView.reloadData()
        tableTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sct.array.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sct.sectionNames[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return sct.array[section].count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "listCell")
            cell.textLabel?.text = "\(sct.array[indexPath.section][indexPath.row])"
            return cell
        } else {
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "tableCell")
            var minuteList = [String]()
            for ct in sct.array[indexPath.section] {
                minuteList.append(ct.onBusStopMinute)
            }
            cell.textLabel?.text = minuteList.joined(separator: "  ")
            return cell
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sct.sectionIndexes
    }
    
    @IBAction func selectChangeButton(_ sender: Any) {
        timetableStatus = timetableStatus.switchUpDown()
        
        let onBusStop = UserDefaults.offBusStop
        let offBusStop = UserDefaults.onBusStop
        swap(&UserDefaults.onBusStop, &UserDefaults.offBusStop)
        
        changeButton.title = timetableStatus.upDownRiverseValue()
        sct = timetableStatus.getTimetable().getCommuteTimetable(onBusStop, offBusStop)
        listTableView.reloadData()
        tableTableView.reloadData()
        
        navigationItem.title = onBusStop + "->" + offBusStop
    }
    
    @IBAction func displayFormatSegmentedControlChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            listTableView.isHidden = false
            tableTableView.isHidden = true
            listTableView.reloadData()
            break
        case 1:
            tableTableView.isHidden = false
            listTableView.isHidden = true
            tableTableView.reloadData()
            break
        default:
            break
        }
    }
    
    @IBAction func weekFormatSegmentedControlChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            timetableStatus = timetableStatus.changeWeek(week: TimetableStatus.Week.Day)
            break
        case 1:
            timetableStatus = timetableStatus.changeWeek(week: TimetableStatus.Week.End)
            break
        default:
            break
        }
        sct = timetableStatus.getTimetable().getCommuteTimetable(UserDefaults.onBusStop, UserDefaults.offBusStop)
        listTableView.reloadData()
        tableTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
