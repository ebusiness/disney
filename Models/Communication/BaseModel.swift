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

enum TokyoDisneyPark: String, FileLocalizable {
    case land
    case sea

    var localizeFileName: String {
        return "Main"
    }

    func localize() -> String {
        switch self {
        case .land:
            return localize(for: "TokyoDisneyPark.land")
        case.sea:
            return localize(for: "TokyoDisneyPark.sea")
        }
    }
}

enum SpotCategory: String {
    case show
    case greeting
    case attraction
}
