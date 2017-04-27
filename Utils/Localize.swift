//
//  Localize.swift
//  disney
//
//  Created by ebuser on 2017/4/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation

protocol Localizable {
    var EN: String { get }
    var CN: String { get }
    var JA: String { get }
    var TW: String { get }
}

extension Localizable {

    func localize() -> String {
        if let syslang = NSLocale.preferredLanguages.first {
            switch syslang {
            case "en":
                return EN
            case "zh-Hant":
                return TW
            case "ja":
                return JA
            case "zh-Hans":
                return CN
            default:
                return EN
            }
        }
        return EN
    }
}

protocol FileLocalizable {
    var localizeFileName: String { get }
}

extension FileLocalizable {
    func localize(for key: String) -> String {
        return NSLocalizedString(key,
                                 tableName: localizeFileName,
                                 comment: "")
    }
}
