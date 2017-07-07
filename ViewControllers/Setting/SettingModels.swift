//
//  SettingModels.swift
//  disney
//
//  Created by ebuser on 2017/7/6.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation
import SwiftyJSON

struct OpenTime: SwiftJSONDecodable {
    let open: Date
    let close: Date

    init?(_ json: JSON) {
        guard let openString = json["open"].string else { return nil }
        guard let open = Date(iso8601str: openString) else { return nil }
        self.open = open

        guard let closeString = json["close"].string else { return nil }
        guard let close = Date(iso8601str: closeString) else { return nil }
        self.close = close
    }
}
