//
//  BaseModel.swift
//  disney
//
//  Created by ebuser on 2017/4/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import SwiftyJSON

protocol SwiftJSONSerializable {
    init(_ json: JSON)
    static func arraySerialize<T: SwiftJSONSerializable>(_ json: JSON) -> [T]?
}

extension SwiftJSONSerializable {
    static func arraySerialize<T: SwiftJSONSerializable>(_ json: JSON) -> [T]? {
        return json.array?.map { T($0) }
    }
}
