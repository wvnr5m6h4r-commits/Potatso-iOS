//
//  AppDelegate.swift
//  ICDSMainFramework
//
//  Created by LEI on 2/26/15.
//  Copyright (c) 2015 TouchingApp. All rights reserved.
//

import UIKit

public class AppDelegate: UIResponder, UIApplicationDelegate {

    public var bootstrapViewController: UIViewController {
        return UIViewController()
    }
    public var window: UIWindow?

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        appConfig.loadConfig("config.plist")
        if let lifeCycleItems = appConfig.lifeCycleConfig[LifeCycleKey.didFinishLaunchingWithOptions] {
            for item in lifeCycleItems {
                _ = item.object?.application?(application, didFinishLaunchingWithOptions: launchOptions)
            }
        }
        return true
    }

    public func applicationWillResignActive(_ application: UIApplication) {
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        if let lifeCycleItems = appConfig.lifeCycleConfig[LifeCycleKey.didEnterBackground] {
            for item in lifeCycleItems {
                item.object?.applicationDidEnterBackground?(application)
            }
        }
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        if let lifeCycleItems = appConfig.lifeCycleConfig[LifeCycleKey.willEnterForeground] {
            for item in lifeCycleItems {
                item.object?.applicationWillEnterForeground?(application)
            }
        }
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        if let lifeCycleItems = appConfig.lifeCycleConfig[LifeCycleKey.didBecomeActive] {
            for item in lifeCycleItems {
                item.object?.applicationDidBecomeActive?(application)
            }
        }
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        if let lifeCycleItems = appConfig.lifeCycleConfig[LifeCycleKey.willTerminate] {
            for item in lifeCycleItems {
                item.object?.applicationWillTerminate?(application)
            }
        }
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let lifeCycleItems = appConfig.lifeCycleConfig[LifeCycleKey.remoteNotification] {
            for item in lifeCycleItems {
                item.object?.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
            }
        }
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if let lifeCycleItems = appConfig.lifeCycleConfig[LifeCycleKey.remoteNotification] {
            for item in lifeCycleItems {
                item.object?.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
            }
        }
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let lifeCycleItems = appConfig.lifeCycleConfig[LifeCycleKey.remoteNotification] {
            for item in lifeCycleItems {
                item.object?.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
            }
        }
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        var handled = false
        if let lifeCycleItems = appConfig.lifeCycleConfig[LifeCycleKey.openURL] {
            for item in lifeCycleItems {
                if let res = item.object?.application?(app, open: url, options: options), res {
                    handled = res
                }
            }
        }
        return handled
    }
}
