//
//  FeedbackManager.swift
//  Potatso
//
//  Created by LEI on 8/4/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import ICSMainFramework
import UIKit

class FeedbackManager {
    static let shared = FeedbackManager()

    func showFeedback(inVC vc: UIViewController? = nil) {
        guard let currentVC = vc ?? UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        let alert = UIAlertController(
            title: "Feedback".localized(),
            message: "Support chat (Helpshift) has been removed in this open-source build. Please use GitHub issues or email the developer.".localized(),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default))
        currentVC.present(alert, animated: true)
    }
}
