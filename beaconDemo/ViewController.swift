//
//  ViewController.swift
//  beaconDemo
//
//  Created by 이주성 on 7/10/24.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    
    lazy var testLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let locationManager = CLLocationManager()
//    var beaconRegion = CLBeaconRegion(uuid: UUID(uuidString: "")!, identifier: "beaconTest")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewFoundation()
        self.initializeObjects()
        self.setDelegates()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
        self.setBeacon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setViewAfterTransition()
    }
    
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //        return .portrait
    //    }
    
    deinit {
        print("----------------------------------- ViewController is disposed -----------------------------------")
    }
}

// MARK: Extension for essential methods
extension ViewController: EssentialViewMethods {
    func setViewFoundation() {
        
    }
    
    func initializeObjects() {
        self.locationManager.delegate = self                         // 델리게이트 넣어줌.
        self.locationManager.requestAlwaysAuthorization()            // 위치 권한 받아옴.

        self.locationManager.startUpdatingLocation()                 // 위치 업데이트 시작
        self.locationManager.allowsBackgroundLocationUpdates = true  // 백그라운드에서도 위치를 체크할 것인지에 대한 여부. 필요없으면 false로 처리하자.
        self.locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        self.view.addSubview(self.testLabel)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // testLabel
        NSLayoutConstraint.activate([
            self.testLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.testLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
        ])
    }
    
    func setViewAfterTransition() {
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        //self.tabBarController?.tabBar.isHidden = false
    }
    
    func setBeacon() {
//        self.beaconRegion.notifyEntryStateOnDisplay = true
//        self.beaconRegion.notifyOnEntry = true
//        self.beaconRegion.notifyOnExit = true
        
        
    }
}

// MARK: - Extension for methods added
extension ViewController {
    
}

// MARK: - Extension for selector methods
extension ViewController {
    
}

// MARK: - Extension for CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print(".notDetermined")
            self.locationManager.requestWhenInUseAuthorization()
        case .denied:
            print(".denied")
            self.dismiss(animated: true)
        case .authorizedWhenInUse, .authorizedAlways:
            print(".autohrizedWhenInUse")
            self.dismiss(animated: true)
        case .restricted:
            print(".restricted")
            self.dismiss(animated: true)
        @unknown default:
            self.dismiss(animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
//            self.locationManager.startRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
            break
        case .outside:
//            self.locationManager.stopRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
            break
        case .unknown:
            print("Now unknown of Region")
            
        }
    }
    
}

protocol EssentialViewMethods {
    
}
