//
//  VisitorTagModels.swift
//  disney
//
//  Created by ebuser on 2017/5/9.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation
import SwiftyJSON

struct VisitorTagModel: SwiftJSONDecodable {
    let id: String
    let name: String
    let color: String

    init?(_ json: JSON) {

        guard let id = json["_id"].string else {
            return nil
        }
        self.id = id

        guard let name = json["name"].string else {
            return nil
        }
        self.name = name

        guard let color = json["color"].string else {
            return nil
        }
        self.color = color

    }
}
