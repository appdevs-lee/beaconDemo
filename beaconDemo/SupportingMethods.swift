//
//  File.swift
//  beaconDemo
//
//  Created by Awesomepia on 7/24/24.
//

import Foundation
import UserNotifications
import CoreLocation

class SupportingMethods {
    static let shared = SupportingMethods()
    
    let constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059939")!)
    let region = CLBeaconRegion(beaconIdentityConstraint: CLBeaconIdentityConstraint(uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059939")!), identifier: "beaconTest")
    
    func pushNotification(title: String, body: String, seconds: Double, identifier: String) {
        // 1️⃣ 알림 내용, 설정
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body

        // 2️⃣ 조건(시간, 반복)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

        // 3️⃣ 요청
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)

        // 4️⃣ 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func pushLocalNotification(title: String, body: String, region: CLBeaconRegion, identifier: String) {
        // 1️⃣ 알림 내용, 설정
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body

        // 2️⃣ 조건(위치)
        let trigger = UNLocationNotificationTrigger(region: self.region, repeats: true)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        // 3️⃣ 요청
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)

        // 4️⃣ 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
