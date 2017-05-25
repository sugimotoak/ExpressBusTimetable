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
    @IBOutlet weak var segmentedControlBaseView: UIView!
    @IBOutlet weak var displayFormatSegmentedControl: UISegmentedControl!
    @IBOutlet weak var weekFormatSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeight: NSLayoutConstraint!
    
    var listTypeVC: ListTypeCommuteTableViewController?
    var tableTypeVC: TableTypeCommuteTableViewController?
    
    var isSearch = false
    var timetableStatus: TimetableStatus {
        get {
            return isSearch ? UserDefaults.searchTimetableStatus : UserDefaults.timetableStatus
        }
        set(value) {
            if isSearch {
                UserDefaults.searchTimetableStatus = value
            } else {
                UserDefaults.timetableStatus = value
            }
        }
    }
    var displayType: TimetableStatus.DisplayType {
        get {
            return isSearch ? UserDefaults.searchTableViewDisplayType : UserDefaults.tableViewDisplayType
        }
        set(value) {
            if isSearch {
                UserDefaults.searchTableViewDisplayType = value
            } else {
                UserDefaults.tableViewDisplayType = value
            }
        }
    }
    var onBusStop: String {
        get {
            return isSearch ? UserDefaults.searchOnBusStop : UserDefaults.onBusStop
        }
        set(value) {
            if isSearch {
                UserDefaults.searchOnBusStop = value
            } else {
                UserDefaults.onBusStop = value
            }
            
        }
    }
    var offBusStop: String {
        get {
            return isSearch ? UserDefaults.searchOffBusStop : UserDefaults.offBusStop
        }
        set(value) {
            if isSearch {
                UserDefaults.searchOffBusStop = value
            } else {
                UserDefaults.offBusStop = value
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControlBaseView.backgroundColor = EBTColor.sharedInstance.primaryColor
        bannerView.backgroundColor = EBTColor.sharedInstance.secondaryColor
        
        if displayType == .LIST {
            listContainerView.isHidden = false
            tableContainerView.isHidden = true
            displayFormatSegmentedControl.selectedSegmentIndex = 0
        } else {
            listContainerView.isHidden = true
            tableContainerView.isHidden = false
            displayFormatSegmentedControl.selectedSegmentIndex = 1
        }
        timetableStatus = timetableStatus.today()
        weekFormatSegmentedControl.selectedSegmentIndex = timetableStatus.isWeekend() ? 1 : 0
        
        if isSearch {
            bannerView.adUnitID = "ca-app-pub-4629563331084064/5144514436"
            bannerView.rootViewController = self
            bannerView.delegate = self
            bannerViewHeight.constant = 50
            bannerView.load(AdMobManager.getRequest())
        } else {
            bannerView.adUnitID = "ca-app-pub-4629563331084064/4076897235"
            bannerView.rootViewController = self
            bannerView.delegate = self
            bannerViewHeight.constant = 50
            bannerView.load(AdMobManager.getRequest())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let sct = timetableStatus.getTimetable().getCommuteTimetable(onBusStop, offBusStop)
        setSCT(sct)
        listTypeVC?.tableView.reloadData()
        tableTypeVC?.tableView.reloadData()
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
    
    @IBAction func selectChangeButton(_ sender: Any) {
        timetableStatus = timetableStatus.switchUpDown()
        
        swap(&onBusStop, &offBusStop)
        
        let sct = timetableStatus.getTimetable().getCommuteTimetable(onBusStop, offBusStop)
        setSCT(sct)
        listTypeVC?.tableView.reloadData()
        tableTypeVC?.tableView.reloadData()
        
        navigationItem.title = onBusStop + "->" + offBusStop
    }
    
    @IBAction func displayTypeSegmentedControlChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            listContainerView.isHidden = false
            tableContainerView.isHidden = true
            displayType = .LIST
            break
        case 1:
            tableContainerView.isHidden = false
            listContainerView.isHidden = true
            displayType = .TABLE
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
        let sct = timetableStatus.getTimetable().getCommuteTimetable(UserDefaults.onBusStop, UserDefaults.offBusStop)
        setSCT(sct)
        listTypeVC?.tableView.reloadData()
        tableTypeVC?.tableView.reloadData()
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
