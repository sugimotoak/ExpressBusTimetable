//
//  CommuteViewController.swift
//  ExpressBusTimetable
//
//  Created by akira on 2/4/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import XCGLogger

class CommuteViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var changeButton: UIBarButtonItem!
    @IBOutlet weak var displayFormatSegmentedControl: UISegmentedControl!
    @IBOutlet weak var weekFormatSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeight: NSLayoutConstraint!
    
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
        
        bannerView.adUnitID = "ca-app-pub-4629563331084064/4076897235"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerViewHeight.constant = 50
        bannerView.load(AdMobManager.getRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timetableStatus = UserDefaults.timetableStatus
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
    
    // MARK: - GADBannerViewDelegate
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        log.error(error)
        bannerViewHeight.constant = 0
    }
    
}
