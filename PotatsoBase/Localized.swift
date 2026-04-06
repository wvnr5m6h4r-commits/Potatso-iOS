//
//  Strings.swift
//  Potatso
//
//  Created by LEI on 1/23/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import UIKit

/// Internal current language key
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
let LCLDefaultLanguage = "en"

/// Name for language change notification
public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"

public extension String {
    func localized() -> String {
        if let path = Bundle.main.path(forResource: Localize.currentLanguage(), ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        } else if let path = Bundle.main.path(forResource: "Base", ofType: "lproj"),
                  let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return self
    }

    func localizedFormat(arguments: CVarArg...) -> String {
        return String(format: localized(), arguments: arguments)
    }

    func localizedPlural(argument: CVarArg) -> String {
        return String.localizedStringWithFormat(localized(), argument)
    }

    /// Hex color e.g. `"FF0000"` or `"#FF0000"` — replaces legacy SwiftColor pod.
    var color: UIColor {
        return UIColor(potatsoHex: self) ?? .black
    }
}

public extension UIColor {
    func alpha(_ value: CGFloat) -> UIColor {
        return withAlphaComponent(value)
    }

    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        setFill()
        UIRectFill(rect)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }

    convenience init?(potatsoHex: String) {
        var hex = potatsoHex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hex.hasPrefix("#") {
            hex.removeFirst()
        }
        guard hex.count == 6 || hex.count == 8 else {
            return nil
        }
        var value: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&value) else {
            return nil
        }
        let r, g, b, a: CGFloat
        if hex.count == 6 {
            r = CGFloat((value & 0xFF0000) >> 16) / 255.0
            g = CGFloat((value & 0x00FF00) >> 8) / 255.0
            b = CGFloat(value & 0x0000FF) / 255.0
            a = 1.0
        } else {
            r = CGFloat((value & 0xFF000000) >> 24) / 255.0
            g = CGFloat((value & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((value & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(value & 0x000000FF) / 255.0
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

// MARK: Language Setting Functions

public class Localize: NSObject {
    public class func availableLanguages() -> [String] {
        return Bundle.main.localizations
    }

    public class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }

    public class func setCurrentLanguage(language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if selectedLanguage != currentLanguage() {
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        }
    }

    public class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if availableLanguages.contains(preferredLanguage) {
            defaultLanguage = preferredLanguage
        } else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }

    public class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(language: self.defaultLanguage())
    }

    public class func displayNameForLanguage(language: String) -> String {
        let locale = NSLocale(localeIdentifier: currentLanguage()) as NSLocale
        return locale.displayName(forKey: .languageCode, value: language) ?? language
    }
}
