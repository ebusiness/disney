//
//  Convienence.swift
//  disney
//
//  Created by ebuser on 2017/4/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

enum UserDefaultKeys: String {
    case visitDate = "visit_date"
    case visitPark = "visit_park"
    case visitorTags = "visitor_tags"
}

extension UserDefaults {
    subscript(key: UserDefaultKeys) -> Any? {
        get {
            return object(forKey: key.rawValue)
        }
        set(newValue) {
            set(newValue, forKey: key.rawValue)
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        guard let hexInt = Int(hex, radix: 16) else {
            fatalError("Invalid hex string")
        }
        self.init(rgb: hexInt)
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

enum TokyoDisneyPark: String, FileLocalizable {
    case land
    case sea

    var localizeFileName: String {
        return "Main"
    }

    func localize() -> String {
        switch self {
        case .land:
            return localize(for: "TokyoDisneyPark.land")
        case.sea:
            return localize(for: "TokyoDisneyPark.sea")
        }
    }
}

enum SpotCategory: String {
    case show
    case meeting
    case attraction
}
