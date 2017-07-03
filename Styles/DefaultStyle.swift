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
        static let viewBackgroundColor = UIColor(hex: "EEEEEE")
        static let textLightGray = MaterialDesignColor.Grey.g400
        static let attraction = MaterialDesignColor.Blue.g500
        static let show = MaterialDesignColor.Red.g500
        static let greeting = MaterialDesignColor.Purple.g500
    }

    // Common background light grey
    class var viewBackgroundColor: UIColor { return Cache.viewBackgroundColor }

    /// Common primary blue
    class var primaryColor: UIColor { return Cache.primary }

    /// Common text light grey
    class var textLightGray: UIColor { return Cache.textLightGray }

    // Common category
    class var attraction: UIColor { return Cache.attraction }
    class var show: UIColor { return Cache.show }
    class var greeting: UIColor { return Cache.greeting }

    // Setting
    class var settingImageTint0: UIColor { return UIColor(hex: "E91E63") }
    class var settingImageTint1: UIColor { return UIColor(hex: "3F51B5") }
    class var settingImageTint2: UIColor { return UIColor(hex: "FF5722") }

    // Setting check mark
    class var settingCheckMark: UIColor { return UIColor(hex: "8BC34A") }

    // Setting
    class var settingCalendarMarkBackground: UIColor { return MaterialDesignColor.Blue.g600 }

}

struct MaterialDesignColor {

    static let Blue = BlueClass()
    static let Purple = PurpleClass()
    static let Grey = GreyClass()
    static let Red = RedClass()
    static let LightGreen = LightGreenClass()

    struct BlueClass: MaterialDesignColorPalette {
        let gColors = [
            "E3F2FD",
            "BBDEFB",
            "90CAF9",
            "64B5F6",
            "42A5F5",
            "2196F3",
            "1E88E5",
            "1976D2",
            "1565C0",
            "0D47A1"
        ]
        let aColors = [
            "82B1FF",
            "448AFF",
            "2979FF",
            "2962FF"
            ]
    }

    struct PurpleClass: MaterialDesignColorPalette {
        let gColors = [
            "F3E5F5",
            "E1BEE7",
            "CE93D8",
            "BA68C8",
            "AB47BC",
            "9C27B0",
            "8E24AA",
            "7B1FA2",
            "6A1B9A",
            "4A148C"
        ]
        let aColors = [
            "EA80FC",
            "E040FB",
            "D500F9",
            "AA00FF"
        ]
    }

    struct GreyClass: MaterialDesignColorPalette {
        let gColors = [
            "FAFAFA",
            "F5F5F5",
            "EEEEEE",
            "E0E0E0",
            "BDBDBD",
            "9E9E9E",
            "757575",
            "616161",
            "424242",
            "212121"
        ]
        let aColors = [String]()
    }

    struct RedClass: MaterialDesignColorPalette {
        let gColors = [
            "FFEBEE",
            "FFCDD2",
            "EF9A9A",
            "E57373",
            "EF5350",
            "F44336",
            "E53935",
            "D32F2F",
            "C62828",
            "B71C1C"
        ]
        let aColors = [
            "FF8A80",
            "FF5252",
            "FF1744",
            "D50000"
        ]
    }

    struct LightGreenClass: MaterialDesignColorPalette {
        let gColors = [
            "8BC34A",
            "F1F8E9",
            "DCEDC8",
            "C5E1A5",
            "AED581",
            "9CCC65",
            "8BC34A",
            "7CB342",
            "689F38",
            "558B2F",
            "33691E"
        ]
        let aColors = [
            "CCFF90",
            "B2FF59",
            "76FF03",
            "64DD17"
        ]
    }
}

protocol MaterialDesignColorPalette {
    var gColors: [String] { get }
    var aColors: [String] { get }
}

extension MaterialDesignColorPalette {
    var g50: UIColor { return UIColor(hex: gColors[0]) }
    var g100: UIColor { return UIColor(hex: gColors[1]) }
    var g200: UIColor { return UIColor(hex: gColors[2]) }
    var g300: UIColor { return UIColor(hex: gColors[3]) }
    var g400: UIColor { return UIColor(hex: gColors[4]) }
    var g500: UIColor { return UIColor(hex: gColors[5]) }
    var g600: UIColor { return UIColor(hex: gColors[6]) }
    var g700: UIColor { return UIColor(hex: gColors[7]) }
    var g800: UIColor { return UIColor(hex: gColors[8]) }
    var g900: UIColor { return UIColor(hex: gColors[9]) }
    var a100: UIColor { return UIColor(hex: aColors[0]) }
    var a200: UIColor { return UIColor(hex: aColors[1]) }
    var a300: UIColor { return UIColor(hex: aColors[2]) }
    var a400: UIColor { return UIColor(hex: aColors[3]) }
}
