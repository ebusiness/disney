//
//  HomepageModels.swift
//  disney
//
//  Created by ebuser on 2017/5/16.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PlanListElement: SwiftJSONSerializable {
    let name: String
    let introduction: String
    let routes: [Route]

    init?(_ json: JSON) {
        guard let name = json["name"].string else { return nil }
        self.name = name

        guard let introduction = json["introduction"].string else { return nil }
        self.introduction = introduction

        guard let routes: [Route] = Route.array(json["route"]) else { return nil }
        guard !routes.isEmpty else { return nil }
        self.routes = routes
    }

    struct Route: SwiftJSONSerializable {
        let name: String
        let images: [String]

        init?(_ json: JSON) {
            guard let name = json["attraction"]["name"].string else {
                return nil
            }
            self.name = name

            guard let array = json["attraction"]["images"].array else {
                return nil
            }
            let images = array.map { $0.string } .filter { $0 != nil } .map { $0! }
            guard !images.isEmpty else {
                return nil
            }
            self.images = images
        }
    }

}
