//
//  Localize.swift
//  disney
//
//  Created by ebuser on 2017/4/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation

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
