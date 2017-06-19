//
//  CustomPlanAttractionsOfGradeModel.swift
//  disney
//
//  Created by ebuser on 2017/6/16.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AttractionOfHotGrade: SwiftJSONDecodable, PlanAttractionConvertible {

    let id: String
    let category: SpotCategory
    let name: String
    let images: [String]
    let rank: Double

    var selected: Bool

    init?(_ json: JSON) {
        guard let id = json["str_id"].string else { return nil }
        self.id = id

        guard let category = SpotCategory(rawValue: json["category"].stringValue) else { return nil }
        self.category = category

        guard let name = json["name"].string else { return nil }
        self.name = name

        guard let images = json["images"].array?.flatMap ({ $0.string }) else { return nil }
        guard !images.isEmpty else { return nil }
        self.images = images

        guard let score = json["index_hot"].int, score > 0 else { return nil }
        let c = 13.0
        let rank = log(Double(score)) / log(c)
        self.rank = rank
        selected = false
    }
}
