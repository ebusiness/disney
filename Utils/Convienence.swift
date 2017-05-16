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

    convenience init(baseColor: UIColor, alpha: CGFloat) {
        assert(alpha >= 0 && alpha <= 1, "Invalid alpha value")

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        baseColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
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
    case greeting
    case attraction
}

extension Date {
    init?(iso8601str: String?) {
        guard let iso8601str = iso8601str else {
            return nil
        }
        let formatterA = DateFormatter()
        formatterA.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let formatterB = DateFormatter()
        formatterB.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        if let date = formatterA.date(from: iso8601str) ?? formatterB.date(from: iso8601str) {
            self = date
        } else {
            return nil
        }
    }
}

extension UIView {
    func addAllConstraints(equalTo view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
