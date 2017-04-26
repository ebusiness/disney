//
//  VisitorTagModel.swift
//  disney
//
//  Created by ebuser on 2017/4/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation
import SwiftyJSON

struct VisitorTagModel: SwiftJSONSerializable {

    let id: String
    let JA: String
    let CN: String
    let EN: String
    let TW: String

    init(_ json: JSON) {

        id = json["ID"].stringValue
        JA = json["Ja"].stringValue
        CN = json["Cn"].stringValue
        EN = json["En"].stringValue
        TW = json["Tw"].stringValue

    }
}
