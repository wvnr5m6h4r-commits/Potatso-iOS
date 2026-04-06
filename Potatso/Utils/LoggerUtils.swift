//
//  LoggerUtils.swift
//  Potatso
//
//  Created by LEI on 6/21/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import CocoaLumberjack

extension Error {

    func log(message: String?) {
        if let message = message {
            DDLogError("\(message): \(self)")
        } else {
            DDLogError("\(self)")
        }
    }
}
