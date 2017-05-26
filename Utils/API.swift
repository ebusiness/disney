//
//  API.swift
//  disney
//
//  Created by ebuser on 2017/4/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Alamofire
import Foundation

struct API {
}

// MARK: - Version Check
extension API {
    struct VersionCheck: Requestable {
        let path = "versions/"
        let method: RouteMethod = .GET
        let parameters: [String : Any]? = nil

        func asURLRequest() throws -> URLRequest {
            guard let url = URL(string: path, relativeTo: NetworkConstants.host) else {
                throw URLError(URLError.badURL)
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.timeoutInterval = 30
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}

// MARK: - Visitor Tag
extension API {
    enum Visitor: Requestable {
        case tags

        var path: String {
            switch self {
            case .tags:
                return "visitor/tags/"
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

// MARK: - Attraction
extension API {
    enum Attractions: Requestable {
        case list
        case detail(id: String)
        case waitTime(id: String, date: String?)

        var path: String {
            switch self {
            case .list:
                return "attractions/"
            case .detail(let id):
                return "attractions/\(id)/"
            case .waitTime(let id, let date):
                if let date = date {
                    return "attractions/\(id)/waittimes/\(date)/"
                } else {
                    return "attractions/\(id)/waittimes/"
                }
            }
        }

        var method: RouteMethod {
            return .GET
        }

        var parameters: [String: Any]? {
            return nil
        }
    }
}

// MARK: - Plan
extension API {
    enum Plan: Requestable {
        case list
        case detail(String, String)

        var path: String {
            switch self {
            case .list:
                return "plans/"
            case .detail(let id, let time):
                return "plans/\(id)/\(time)/"
            }
        }

        var method: RouteMethod {
            return .GET
        }

        var parameters: [String : Any]? {
            return nil
        }
    }
}
