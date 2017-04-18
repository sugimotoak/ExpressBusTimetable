//
//  CommutingViewController.swift
//  ExpressBusTimetable
//
//  Created by akira on 2/4/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import Foundation
import UIKit

class CommutingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeButton: UIBarButtonItem!
    var ctList = [CommutingTimetable]()
    var timetableStatus = UserDefaults.timetableStatus
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        // default 平日 上り 杢師４丁目->東京駅八重洲口前
        let onBusStop = UserDefaults.onBusStop
        let offBusStop = UserDefaults.offBusStop
        changeButton.title = timetableStatus.upDownRiverseValue()
        ctList = timetableStatus.getTimetable().getCommutingTimetable(onBusStop, offBusStop)
        navigationItem.title = onBusStop + "->" + offBusStop
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ctList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = "\(ctList[indexPath.row])"
        return cell
    }
    
    @IBAction func selectChangeButton(_ sender: Any) {
        timetableStatus = timetableStatus.switchUpDown()
        
        let onBusStop = UserDefaults.offBusStop
        let offBusStop = UserDefaults.onBusStop
        swap(&UserDefaults.onBusStop, &UserDefaults.offBusStop)
        
        changeButton.title = timetableStatus.upDownRiverseValue()
        ctList = timetableStatus.getTimetable().getCommutingTimetable(onBusStop, offBusStop)
        tableView.reloadData()
        
        navigationItem.title = onBusStop + "->" + offBusStop
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
