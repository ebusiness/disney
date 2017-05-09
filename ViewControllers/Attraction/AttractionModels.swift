//
//  AttractionModels.swift
//  disney
//
//  Created by ebuser on 2017/5/9.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AttractionListSpot: SwiftJSONSerializable {
    let id: String
    let category: SpotCategory
    let name: String
    let area: String
    let thum: String

    init?(_ json: JSON) {
        guard let id = json["str_id"].string else {
            return nil
        }
        self.id = id

        guard let category = SpotCategory(rawValue: json["category"].stringValue) else {
            return nil
        }
        self.category = category

        guard let name = json["name"].string else {
            return nil
        }
        self.name = name

        guard let area = json["area"].string else {
            return nil
        }
        self.area = area

        guard let thum = json["thum_url_pc"].string else {
            return nil
        }
        self.thum = thum
    }
}
