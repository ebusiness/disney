//
//  API.swift
//  disney
//
//  Created by ebuser on 2017/4/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation

struct API {}

// MARK: - Visitor Tag
extension API {
    enum Visitor: Requestable {
        case tags

        var path: String {
            switch self {
            case .tags:
                return "/visitor/tags"
            }
        }

        var method: RouteMethod {
            switch self {
            case .tags:
                return .GET
            }
        }

        var parameters: [String : Any]? {
            switch self {
            case .tags:
                return nil
            }
        }
    }
}
