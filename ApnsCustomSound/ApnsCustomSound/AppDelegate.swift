//
//  AppDelegate.swift
//  ApnsCustomSound
//
//  Created by SungPyo on 2018. 10. 30..
//  Copyright © 2018년 SungPyo. All rights reserved.
//

//{
//    "aps" : {
//        "alert" : {
//            "title" : "Title",
//            "body" : "Body"
//        },
//        "sound" : "popcorn.wav",
//        "badge" : 1
//    }
//}

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NSLog("launchOptions = \(launchOptions)"); //앱 종료 상태에서 푸시를 선택하여 실행한 경우 launchOption에 페이로드가 담긴다.
        self.regsterAPNS(application)
        return true
    }
   
    func regsterAPNS(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            let currentNotification = UNUserNotificationCenter.current()
            currentNotification.delegate = self
            currentNotification.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if (error != nil) {
                    //에러
                } else {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        } else {
                let userNotificationSet = UIUserNotificationSettings(types: [
                    UIUserNotificationType.sound,
                    UIUserNotificationType.badge,
                    UIUserNotificationType.alert
                    ],categories: nil)
                application.registerUserNotificationSettings(userNotificationSet)
                application.registerForRemoteNotifications()
        }
    }
    
    //등록 성공
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        NSLog("deviceToken.description = \(token)")
        
    }
    
    //등록 실패
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("error.localizedDescription \(error.localizedDescription)")
    }
    
    //앱 실행중 10.0 이상.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NSLog("notification.request.content.userInfo = \(notification.request.content.userInfo)")
        
        completionHandler([.alert,.sound])
    }
    
    //앱 백그라운드에서 10이하
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("userInfo = \(userInfo)")
    }
    
    //앱 백그라운드에서 또는 종료상태에서 실행시 10이상 (didfinish가 더 먼저 호출된다.)
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NSLog("response.notification.request.content.userInfo = \(response.notification.request.content.userInfo)")
        
        completionHandler();
    }
    
//    //로컬노티 수신
//    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//        NSLog("notification.userInfo = \(notification.userInfo)")
//    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        NSLog("userInfo = \(userInfo)")
//        completionHandler(.newData)
//    }
//
//    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
//        NSLog("identifier = \(identifier)")
//    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

