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
        #if targetEnvironment(simulator)
            request.testDevices = [kGADSimulatorID]
        #endif
        return request
    }
}
