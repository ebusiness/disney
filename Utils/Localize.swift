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
    func localize(for key: String, arguments: CVarArg...) -> String {
        if arguments.isEmpty {
            return NSLocalizedString(key,
                                     tableName: localizeFileName,
                                     comment: "")
        } else {
            let nonArgs = self.localize(for: key)
            return String(format: nonArgs, arguments: Array(arguments))
        }
    }
}
