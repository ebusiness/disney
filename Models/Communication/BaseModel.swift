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
    init(_ json: JSON)
    init(_ json: DataResponse<JSON>)
}

extension SwiftJSONSerializable {

    init(_ json: DataResponse<JSON>) {
        self.init(json.result.value!)
    }

    static func array<T: SwiftJSONSerializable>(_ json: DataResponse<JSON>) -> [T] {
        return json.result.value?.array?.map { T($0) } ?? [T]()
    }
}
