//
//  BaseModel.swift
//  disney
//
//  Created by ebuser on 2017/4/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol SwiftJSONDecodable {
    init?(_ json: JSON)
}

extension SwiftJSONDecodable {

    init?(_ json: DataResponse<JSON>) {
        if let value = json.result.value {
            self.init(value)
        } else {
            return nil
        }
    }

    static func array(dataResponse: DataResponse<JSON>) -> [Self]? {
        return dataResponse.result.value?.array?.flatMap { Self($0) }
    }

    static func array(_ json: JSON) -> [Self]? {
        return json.array?.flatMap { Self($0) }
    }
}
