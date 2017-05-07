//
//  CommuteViewController.swift
//  ExpressBusTimetable
//
//  Created by akira on 2/4/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import Foundation
import UIKit

class CommuteViewController: UIViewController {
    
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var changeButton: UIBarButtonItem!
    @IBOutlet weak var displayFormatSegmentedControl: UISegmentedControl!
    @IBOutlet weak var weekFormatSegmentedControl: UISegmentedControl!
    
    var listTypeVC: ListTypeCommuteTableViewController?
    var tableTypeVC: TableTypeCommuteTableViewController?
    
    var timetableStatus: TimetableStatus = UserDefaults.timetableStatus.today()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let displayType = UserDefaults.tableViewDisplayType
        if displayType == .LIST {
            listContainerView.isHidden = false
            tableContainerView.isHidden = true
            displayFormatSegmentedControl.selectedSegmentIndex = 0
        } else {
            listContainerView.isHidden = true
            tableContainerView.isHidden = false
            displayFormatSegmentedControl.selectedSegmentIndex = 1
        }
        weekFormatSegmentedControl.selectedSegmentIndex = timetableStatus.isWeekend() ? 1 : 0
        changeButton.title = timetableStatus.upDownRiverseValue()
        UserDefaults.timetableStatus = timetableStatus
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let onBusStop = UserDefaults.onBusStop
        let offBusStop = UserDefaults.offBusStop
        changeButton.title = timetableStatus.upDownRiverseValue()
        let sct = timetableStatus.getTimetable().getCommuteTimetable(onBusStop, offBusStop)
        setSCT(sct)
        getShowingVC()?.tableView.reloadData()
        
        navigationItem.title = onBusStop + "->" + offBusStop
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListType" {
            listTypeVC = segue.destination as? ListTypeCommuteTableViewController
        } else if segue.identifier == "TableType" {
            tableTypeVC = segue.destination as? TableTypeCommuteTableViewController
        }
    }
    
    func setSCT(_ sct: SectionizedCommuteTimetable) {
        listTypeVC?.sct = sct
        tableTypeVC?.sct = sct
    }
    
    func getShowingVC() -> CommuteTableViewController? {
        if !listContainerView.isHidden {
            return listTypeVC
        } else if !tableContainerView.isHidden {
            return tableTypeVC
        } else {
            return nil
        }
    }
    
    @IBAction func selectChangeButton(_ sender: Any) {
        timetableStatus = timetableStatus.switchUpDown()
        UserDefaults.timetableStatus = timetableStatus
        
        swap(&UserDefaults.onBusStop, &UserDefaults.offBusStop)
        let onBusStop = UserDefaults.onBusStop
        let offBusStop = UserDefaults.offBusStop
        
        changeButton.title = timetableStatus.upDownRiverseValue()
        let sct = timetableStatus.getTimetable().getCommuteTimetable(onBusStop, offBusStop)
        setSCT(sct)
        getShowingVC()?.tableView.reloadData()
        
        navigationItem.title = onBusStop + "->" + offBusStop
    }
    
    @IBAction func displayTypeSegmentedControlChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            listContainerView.isHidden = false
            tableContainerView.isHidden = true
            UserDefaults.tableViewDisplayType = .LIST
            break
        case 1:
            tableContainerView.isHidden = false
            listContainerView.isHidden = true
            UserDefaults.tableViewDisplayType = .TABLE
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
        UserDefaults.timetableStatus = timetableStatus
        let sct = timetableStatus.getTimetable().getCommuteTimetable(UserDefaults.onBusStop, UserDefaults.offBusStop)
        setSCT(sct)
        getShowingVC()?.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
