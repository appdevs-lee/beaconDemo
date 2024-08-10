//
//  BeaconManager.swift
//  beaconDemo
//
//  Created by Awesomepia on 8/2/24.
//

import Foundation
import CoreLocation

class BeaconManager: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    var detectedBeacons: [CLBeacon] = []
    
    override init() {
        self.locationManager = CLLocationManager()
        
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func startScanning() {
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: CLBeaconIdentityConstraint(uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059939")!), identifier: "awesomepia")
                                          
        
        self.locationManager.startMonitoring(for: beaconRegion)
        self.locationManager.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
    }
}
