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
    var timetableStatus = TimetableStatus.WeekdayUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        // ex 平日 上り 杢師４丁目→東京駅八重洲口前
        
        let onBusStop = "杢師４丁目"
        let offBusStop = "東京駅八重洲口前"
        let weekdayUp = WeekdayUpTimetable.sharedInstance
        ctList = weekdayUp.getCommutingTimetable(onBusStop, offBusStop)
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
        let timetable = timetableStatus.getTimetable()
        
        let onBusStop: String
        let offBusStop: String
        if timetableStatus.isUp() {
            changeButton.title = "下り"
            onBusStop = "杢師４丁目"
            offBusStop = "東京駅八重洲口前"
        } else {
            changeButton.title = "上り"
            onBusStop = "東京駅八重洲口前"
            offBusStop = "杢師４丁目"
        }
        
        ctList = timetable.getCommutingTimetable(onBusStop, offBusStop)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
