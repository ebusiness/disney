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
}

extension SwiftJSONSerializable {

    init?(_ json: DataResponse<JSON>) {
        if let value = json.result.value {
            self.init(value)
        } else {
            return nil
        }
    }

    static func array<T: SwiftJSONSerializable>(dataResponse: DataResponse<JSON>) -> [T]? {
        return dataResponse.result.value?.array?.map { T($0) } .filter { $0 != nil } .map { $0! }
    }

    static func array<T: SwiftJSONSerializable>(_ json: JSON) -> [T]? {
        return json.array?.map { T($0) } .filter { $0 != nil } .map { $0! }
    }
}
