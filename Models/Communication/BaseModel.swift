//
//  BaseModel.swift
//  disney
//
//  Created by ebuser on 2017/4/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol SwiftJSONSerializable {
    init?(_ json: JSON)
    init?(_ json: DataResponse<JSON>)
}

extension SwiftJSONSerializable {

    init?(_ json: DataResponse<JSON>) {
        if let value = json.result.value {
            self.init(value)
        } else {
            return nil
        }
    }

    static func array<T: SwiftJSONSerializable>(_ json: DataResponse<JSON>) -> [T?]? {
        return json.result.value?.array?.map { T($0) }
    }
}
