//
//  AdMobManager.swift
//  ExpressBusTimetable
//
//  Created by akira on 5/10/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import Foundation
import GoogleMobileAds

class AdMobManager {

    static func getRequest() -> GADRequest {
        let request = GADRequest()
        if TARGET_OS_SIMULATOR == 1 {
            request.testDevices = [kGADSimulatorID]
        }
        return request
    }
}
