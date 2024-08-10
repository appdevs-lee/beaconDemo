//
//  ViewController.swift
//  beaconDemo
//
//  Created by 이주성 on 7/10/24.
//

import UIKit
import CoreLocation
import CoreMotion
import DGCharts

final class ViewController: UIViewController {
    
    lazy var positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var testLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let locationManager = CLLocationManager()
    let motionManager = CMMotionActivityManager()
    let beaconRegion = CLBeaconRegion(uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059939")!, identifier: "awesomepia")
    
    var measurements: [Double] = []
    var appTestMeasurements: [Double] = []
    var mBeaconMeasurements: [Double] = []
    var awesomeMeasurements: [Double] = []
    var filter = KalmanFilter(stateEstimatePrior: 0.0, errorCovariancePrior: 1)
    var prediction: KalmanFilter<Double>?
    
    let AP1 = AP(x: 5, y: 10, distance: 0) // mBeacon
    let AP2 = AP(x: 10, y: 0, distance: 0) // appTest
    let AP3 = AP(x: 0, y: 0, distance: 0) // awesome
    
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
        self.setMotion()
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
        self.beaconRegion.notifyEntryStateOnDisplay = true
        self.beaconRegion.notifyOnEntry = true
        self.beaconRegion.notifyOnExit = true
        
        self.locationManager.startMonitoring(for: self.beaconRegion)
        self.locationManager.startRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
        
        self.prediction = self.filter.predict(stateTransitionModel: 1, controlInputModel: 0, controlVector: 0, covarianceOfProcessNoise: 0.0001)
    }
    
    func setMotion() {
        self.motionManager.startActivityUpdates(to: .main) { activity in
            guard let activity = activity else { return }
            
            print("sationary: \(activity.stationary)\nwalking: \(activity.walking)")
            
        }
    }
}

// MARK: - Extension for methods added
extension ViewController {
    func kalmanFilterTest(measurements: [Double]) -> Double {
        for measurement in measurements {
            let update = self.prediction!.update(measurement: measurement, observationModel: 1, covarienceOfObservationNoise: 0.1)
            
            self.filter = update
        }
        
//        print(self.filter.stateEstimatePrior)
        return self.filter.stateEstimatePrior
        
    }
    
    func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Welcome to Rantmedia!"
        content.body = "Enjoy your stay!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "EntryNotification", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                
            }
            
        }
    }
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
            print("inside")
            self.locationManager.startRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
//            self.postNotification()
            break
            
        case .outside:
            print("outside")
            self.locationManager.stopRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
//            self.postNotification()
            break
            
        case .unknown:
            print("Now unknown of Region")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("inside")
        if region is CLBeaconRegion {
            if CLLocationManager.isRangingAvailable() {
                self.testLabel.text = "inside"

            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLBeaconRegion {
            if CLLocationManager.isRangingAvailable() {
                print("outside")
                self.testLabel.text = "outside"
                
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if beacons.count > 0 {
//            print(beacons)
            
            for beacon in beacons {
                if beacon.rssi != 0 {
                    if beacon.minor == 2 {
                        self.mBeaconMeasurements.append(Double(beacon.rssi))
                        self.AP1.distance = round(pow(10, (-59.0-self.kalmanFilterTest(measurements: self.mBeaconMeasurements)) / (10.0 * 2.0)))
                        
                    } else if beacon.minor == 1 {
                        self.appTestMeasurements.append(Double(beacon.rssi))
                        self.AP2.distance = round(pow(10, (-59.0-self.kalmanFilterTest(measurements: self.appTestMeasurements)) / (10.0 * 2.0)))
                        
                    } else if beacon.minor == 3 {
                        self.awesomeMeasurements.append(Double(beacon.rssi))
                        self.AP3.distance = round(pow(10, (-59.0-self.kalmanFilterTest(measurements: self.awesomeMeasurements)) / (10.0 * 2.0)))
                        
                    } else {
                        print("unknown")
                        
                    }
                    
                }
                
            }
            
            let tril = Trilateration(AP1: self.AP3, AP2: self.AP2, AP3: self.AP1)
            
            self.testLabel.text =
            """
                AP1:\(self.AP3.x) \(self.AP3.y) \(self.AP3.distance)\n
                AP2:\(self.AP2.x) \(self.AP2.y) \(self.AP2.distance)\n
                AP3:\(self.AP1.x) \(self.AP1.y) \(self.AP1.distance)\n
                x: \(Int(tril.calcUserLocation().x)), y: \(Int(tril.calcUserLocation().y))\n
                """
            
            }
        
    }
    
}

protocol EssentialViewMethods {
    
}
