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
        static let viewBackgroundColor = UIColor(hex: "EEEEEE")
    }

    class var viewBackgroundColor: UIColor { return Cache.viewBackgroundColor }
}
