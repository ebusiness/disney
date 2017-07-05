//
//  DefaultStyle.swift
//  disney
//
//  Created by ebuser on 2017/6/21.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class DefaultStyle {
    private struct Cache {
        static let primary = MaterialDesignColor.Blue.g500
        static let viewBackgroundColor = MaterialDesignColor.Grey.g200
        static let textLightGray = MaterialDesignColor.Grey.g400
        static let attraction = MaterialDesignColor.Blue.g500
        static let show = MaterialDesignColor.Red.g500
        static let greeting = MaterialDesignColor.Purple.g500
    }

    // Common background light grey
    class var viewBackgroundColor: UIColor { return Cache.viewBackgroundColor }

    /// Common primary blue
    class var primaryColor: UIColor { return Cache.primary }
    class var darkPrimaryColor: UIColor { return MaterialDesignColor.Indigo.g500 }

    /// Common text light grey
    class var textLightGray: UIColor { return Cache.textLightGray }

    // Common category
    class var attraction: UIColor { return Cache.attraction }
    class var show: UIColor { return Cache.show }
    class var greeting: UIColor { return Cache.greeting }

    // Setting
    class var settingImageTint0: UIColor { return UIColor(hex: "E91E63") }
    class var settingImageTint1: UIColor { return MaterialDesignColor.Indigo.g500 }
    class var settingImageTint2: UIColor { return UIColor(hex: "FF5722") }

    // Setting check mark
    class var settingCheckMark: UIColor { return UIColor(hex: "8BC34A") }

    // Setting
    class var settingCalendarMarkBackground: UIColor { return MaterialDesignColor.Blue.g600 }

}
