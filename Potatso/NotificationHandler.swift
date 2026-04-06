//
//  NotificationHandler.swift
//  Potatso
//
//  Created by LEI on 7/23/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import ICSMainFramework
import CloudKit
import UserNotifications

class NotificationHandler: NSObject, AppLifeCycleProtocol {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configPush()
        return true
    }

    func configPush() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        DDLogInfo("didRegisterForRemoteNotificationsWithDeviceToken: \(deviceToken.hexString())")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let dict = userInfo as? [String: NSObject] {
            let ckNotification = CKNotification(fromRemoteNotificationDictionary: dict)
            if ckNotification.subscriptionID == potatsoSubscriptionId {
                DDLogInfo("received a CKNotification")
                SyncManager.shared.sync()
            }
        }
        completionHandler(.noData)
    }
}

extension Data {
    func hexString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
