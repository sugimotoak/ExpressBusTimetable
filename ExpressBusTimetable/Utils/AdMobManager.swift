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
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            request.testDevices = [kGADSimulatorID]
        #endif
        return request
    }
}
