//
//  CloudSetManager.swift
//  Potatso
//
//  Created by LEI on 8/13/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import Async
import RealmSwift

class CloudSetManager {

    static let shared = CloudSetManager()

    private init() {

    }

    func update() {
        Async.background(after: 1.5) {
            let realm = try! Realm()
            let uuids = realm.objects(RuleSet.self).filter("isSubscribe = true").map({ $0.uuid })
            API.updateRuleSetListDetail(uuids: Array(uuids)) { result in
                switch result {
                case .success(let sets):
                    do {
                        try RuleSet.addRemoteArray(rulesets: sets)
                    } catch {
                        error.log(message: "Unable to save updated rulesets")
                        return
                    }
                case .failure(let error):
                    error.log(message: "Fail to update ruleset details")
                }
            }
        }
    }
}
