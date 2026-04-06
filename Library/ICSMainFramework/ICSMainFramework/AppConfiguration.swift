//
//  AppConfiguration.swift
//  ICSMainFramework
//
//  Created by LEI on 5/14/15.
//  Copyright (c) 2015 TouchingApp. All rights reserved.
//

import Foundation

private let sharedConfigInstance = AppConfig()

public struct ConfigKey {
    public static let lifeCycle = "lifecycle"
    public static let custom = "custom"
}

public struct LifeCycleKey {
    public static let didFinishLaunchingWithOptions = "didFinishLaunchingWithOptions"
    public static let didEnterBackground = "didEnterBackground"
    public static let willEnterForeground = "willEnterForeground"
    public static let didBecomeActive = "didBecomeActive"
    public static let remoteNotification = "remoteNotification"
    public static let willTerminate = "willTerminate"
    public static let openURL = "openURL"
}

let appConfig = AppConfig.sharedConfig

public class AppConfig {

    public var lifeCycleConfig = [String: [AppLifeCycleItem]]()
    public var customConfig = [String: Any]()

    public class var sharedConfig: AppConfig {
        return sharedConfigInstance
    }

    public func loadConfig(fileName: String) {
        var components = fileName.components(separatedBy: ".")
        let type = components.popLast()
        let name = components.joined(separator: ".")
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            if let configDict = NSDictionary(contentsOfFile: path) as? [String: Any] {
                loadConfig(dictionary: configDict)
            }
        }
    }

    public func loadConfig(dictionary: [String: Any]) {
        if let lifeCycleDict = dictionary[ConfigKey.lifeCycle] as? [String: Any] {
            loadLifeCycleConfig(lifeCycleDict)
        }
        if let lifeCycleDict = dictionary[ConfigKey.custom] as? [String: Any] {
            loadCustomConfig(lifeCycleDict)
        }
    }

    func loadLifeCycleConfig(dictionary: [String: Any]) {
        for (key, value) in dictionary {
            var items = [AppLifeCycleItem]()
            if let itemArray = value as? [Any] {
                items = itemArray.compactMap { elt in
                    guard let d = elt as? [String: Any] else { return nil }
                    return AppLifeCycleItem(dictionary: d)
                }
            }
            lifeCycleConfig[key] = items
        }
    }

    func loadCustomConfig(dictionary: [String: Any]) {
        customConfig = dictionary
    }

}
