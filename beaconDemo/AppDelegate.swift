//
//  AppDelegate.swift
//  beaconDemo
//
//  Created by 이주성 on 7/10/24.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { bool, error in
                if bool {
                    let setting = UNMutableNotificationContent()

                    setting.title = "회사 도착"
                    setting.body = "출근을 눌러주세요!"
                    
//                    let region = CLBeaconRegion(uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!, major: 10001, minor: 19641, identifier: "beaconTest")
                    let constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059939")!)
                    let region = CLBeaconRegion(beaconIdentityConstraint: CLBeaconIdentityConstraint(uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059939")!), identifier: "beaconTest")
                    region.notifyEntryStateOnDisplay = true
                    region.notifyOnEntry = true
                    region.notifyOnEntry = true
                    
                    let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
                    let request = UNNotificationRequest(identifier: "beaconTest", content: setting, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request)
                    
                } else {
                    
                }
                
            }
        )

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Foreground(앱 켜진 상태)에서도 알림 오는 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Push >> willPresent")
        
        completionHandler([.badge, .banner, .list])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Push >> didReceive")
        
        completionHandler()
    }
}
