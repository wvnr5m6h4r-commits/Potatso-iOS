//
//  API.swift
//  Potatso
//
//  Created by LEI on 6/4/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import PotatsoModel
import Alamofire
import ObjectMapper

struct API {

    static let URL = "https://api.potatso.com/"

    enum Path {
        case ruleSets
        case ruleSet(String)
        case ruleSetListDetail

        var url: String {
            let path: String
            switch self {
            case .ruleSets:
                path = "rulesets"
            case .ruleSet(let uuid):
                path = "ruleset/\(uuid)"
            case .ruleSetListDetail:
                path = "rulesets/detail"
            }
            return API.URL + path
        }
    }

    static func getRuleSets(page: Int = 1, count: Int = 20, callback: @escaping (Result<[RuleSet], Error>) -> Void) {
        DDLogVerbose("API.getRuleSets ===> page: \(page), count: \(count)")
        AF.request(Path.ruleSets.url, method: .get, parameters: ["page": page, "count": count])
            .validate()
            .responseJSON { response in
                callback(parseArrayResponse(response))
            }
    }

    static func getRuleSetDetail(uuid: String, callback: @escaping (Result<RuleSet, Error>) -> Void) {
        DDLogVerbose("API.getRuleSetDetail ===> uuid: \(uuid)")
        AF.request(Path.ruleSet(uuid).url, method: .get)
            .validate()
            .responseJSON { response in
                callback(parseObjectResponse(response))
            }
    }

    static func updateRuleSetListDetail(uuids: [String], callback: @escaping (Result<[RuleSet], Error>) -> Void) {
        DDLogVerbose("API.updateRuleSetListDetail ===> uuids: \(uuids)")
        AF.request(Path.ruleSetListDetail.url, method: .post, parameters: ["uuids": uuids], encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                callback(parseArrayResponse(response))
            }
    }

    private static func parseArrayResponse(_ response: AFDataResponse<Any>) -> Result<[RuleSet], Error> {
        switch response.result {
        case .failure(let err):
            return .failure(err)
        case .success(let value):
            if let dict = value as? [String: Any], let msg = dict["error_message"] as? String {
                return .failure(NSError(domain: "Potatso", code: -1, userInfo: [NSLocalizedDescriptionKey: msg]))
            }
            if let parsed = Mapper<RuleSet>().mapArray(JSONObject: value) {
                return .success(parsed)
            }
            return .failure(NSError(domain: "Potatso", code: -2, userInfo: [NSLocalizedDescriptionKey: "ObjectMapper failed"]))
        }
    }

    private static func parseObjectResponse(_ response: AFDataResponse<Any>) -> Result<RuleSet, Error> {
        switch response.result {
        case .failure(let err):
            return .failure(err)
        case .success(let value):
            if let dict = value as? [String: Any], let msg = dict["error_message"] as? String {
                return .failure(NSError(domain: "Potatso", code: -1, userInfo: [NSLocalizedDescriptionKey: msg]))
            }
            if let parsed = Mapper<RuleSet>().map(JSONObject: value) {
                return .success(parsed)
            }
            return .failure(NSError(domain: "Potatso", code: -2, userInfo: [NSLocalizedDescriptionKey: "ObjectMapper failed"]))
        }
    }
}

extension RuleSet: Mappable {

    public convenience init?(map: Map) {
        self.init()
        guard let rulesJSON = map.JSON["rules"] as? [[String: Any]] else {
            return nil
        }
        var rules: [Rule] = []
        if let parsedObject = Mapper<Rule>().mapArray(JSONArray: rulesJSON) {
            rules.append(contentsOf: parsedObject)
        }
        self.rules = rules
    }

    public func mapping(map: Map) {
        uuid <- map["id"]
        name <- map["name"]
        createAt <- (map["created_at"], DateTransform())
        remoteUpdatedAt <- (map["updated_at"], DateTransform())
        desc <- map["description"]
        ruleCount <- map["rule_count"]
        isOfficial <- map["is_official"]
    }
}

extension RuleSet {

    static func addRemoteObject(ruleset: RuleSet, update: Bool = true) throws {
        ruleset.isSubscribe = true
        ruleset.deleted = false
        ruleset.editable = false
        let id = ruleset.uuid
        guard let local = DBUtils.get(id, type: RuleSet.self) else {
            try DBUtils.add(ruleset)
            return
        }
        if local.remoteUpdatedAt == ruleset.remoteUpdatedAt && local.deleted == ruleset.deleted {
            return
        }
        try DBUtils.add(ruleset)
    }

    static func addRemoteArray(rulesets: [RuleSet], update: Bool = true) throws {
        for ruleset in rulesets {
            try addRemoteObject(ruleset, update: update)
        }
    }

}

extension Rule: Mappable {

    public convenience init?(map: Map) {
        guard let pattern = map.JSON["pattern"] as? String else {
            return nil
        }
        guard let actionStr = map.JSON["action"] as? String, let action = RuleAction(rawValue: actionStr) else {
            return nil
        }
        guard let typeStr = map.JSON["type"] as? String, let type = RuleType(rawValue: typeStr) else {
            return nil
        }
        self.init(type: type, action: action, value: pattern)
    }

    public func mapping(map: Map) {
    }
}

struct DateTransform: TransformType {

    func transformFromJSON(_ value: Any?) -> Double? {
        guard let dateStr = value as? String else {
            return Date().timeIntervalSince1970
        }
        let fmt = ISO8601DateFormatter()
        fmt.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = fmt.date(from: dateStr) {
            return d.timeIntervalSince1970
        }
        let fmt2 = ISO8601DateFormatter()
        return fmt2.date(from: dateStr)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
    }

    func transformToJSON(_ value: Double?) -> Any? {
        guard let v = value else {
            return nil
        }
        let date = Date(timeIntervalSince1970: v)
        return ISO8601DateFormatter().string(from: date)
    }
}
