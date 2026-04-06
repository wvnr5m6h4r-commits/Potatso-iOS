//
//  AppInitilizer.swift
//  Potatso
//
//  Created by LEI on 12/27/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import Foundation
import ICSMainFramework
import Appirater
import CocoaLumberjack

let appID = "1070901416"

class AppInitializer: NSObject, AppLifeCycleProtocol {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configLogging()
        configAppirater()
        return true
    }

    func configAppirater() {
        Appirater.setAppId(appID)
    }

    func configLogging() {
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24 * 3
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)

        #if DEBUG
        DDLog.add(DDOSLogger.sharedInstance)
        #endif
    }
}
