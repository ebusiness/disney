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
        let path = "versions"
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
                return "visitor/tags"
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

// MARK: - Attractions
extension API {
    enum Attractions: Requestable {
        case list
        case detail(id: String)
        case waitTime(id: String, date: String?)
        case hotGrade

        var path: String {
            switch self {
            case .list:
                return "attractions"
            case .detail(let id):
                return "attractions/\(id)"
            case .waitTime(let id, let date):
                if let date = date {
                    return "attractions/\(id)/waittimes/\(date)"
                } else {
                    return "attractions/\(id)/waittimes"
                }
            case .hotGrade:
                return "attractions"
            }
        }

        var method: RouteMethod {
            return .GET
        }

        var parameters: [String: Any]? {
            switch self {
            case .hotGrade:
                return ["sort": "hot"]
            default:
                return nil
            }
        }
    }
}

// MARK: - Plans
extension API {
    enum Plans: Requestable {
        case list
        case detail(String, String)
        case customize(CustomizeParameter)
        case map(id: String)

        var path: String {
            switch self {
            case .list:
                return "plans"
            case .detail(let id, let time):
                return "plans/\(id)/\(time)"
            case .customize:
                return "plans/customize"
            case .map(let id):
                return "files/plans/\(id)"
            }
        }

        var method: RouteMethod {
            switch self {
            case .list:
                return .GET
            case .detail:
                return .GET
            case .customize:
                return .POST
            case .map:
                return .GET
            }
        }

        var parameters: [String : Any]? {
            switch self {
            case .customize(let customizeParameter):
                return customizeParameter.asParameter()
            case .map:
                return ["withbg": 1]
            default:
                return nil
            }
        }

        //swiftlint:disable:next nesting
        struct CustomizeParameter {
            let start: Date
            let route: [[String: Any]]
            func asParameter() -> [String: Any] {
                var params = [String: Any]()
                params["start"] = start.zFormat()
                params["route"] = route
                return params
            }
        }
    }
}

// MARK: - AttractionTags
extension API {
    enum AttractionTags: Requestable {
        case list
        case detail(id: String)

        var path: String {
            switch self {
            case .list:
                return "attraction/tags"
            case .detail(let id):
                return "attraction/tags/\(id)"
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

// MARK: - Schedule
extension API {
    enum Schedule: Requestable {
        case openTime(date: Date)

        var path: String {
            switch self {
            case .openTime(let date):
                let dateString = date.format(pattern: "yyyy-MM-dd")
                return "schedule/\(dateString)"
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
