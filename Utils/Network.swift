//
//  Network.swift
//  disney
//
//  Created by ebuser on 2017/4/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON

struct NetworkConstants {
    static let host = URL(string: "https://api.dev.genbatomo.com/")
    static let version = "v1/"

    static var language: String = {

        guard let syslang = NSLocale.preferredLanguages.first else {
            return "en/"
        }
        switch syslang {
        case "en/":
            return "en/"
        case "zh-Hant":
            return "tw/"
        case "ja":
            return "ja/"
        case "zh-Hans":
            return "cn/"
        default:
            return "en/"
        }

    }()

    static var park: String = {
        if let visitPark = UserDefaults.standard[.visitPark] as? String {

            switch visitPark {
            case "land":
                return "land/"
            case "sea":
                return "sea/"
            default:
                return "land/"
            }
        } else {
            return "land/"
        }

    }()
}

/**
 HTTP method definitions.

 See https://tools.ietf.org/html/rfc7231#section-4.3
 */
public enum RouteMethod: String {
    case OPTIONS
    case GET
    case HEAD
    case POST
    case PUT
    case PATCH
    case DELETE
    case TRACE
    case CONNECT
}

protocol Requestable: URLRequestConvertible {
    /// url path
    var path: String { get }
    /// Method
    var method: RouteMethod { get }
    /// Parameters
    var parameters: [String: Any]? { get }
}

extension Requestable {
    func asURLRequest() throws -> URLRequest {
        let urlString = NetworkConstants.version + NetworkConstants.language + NetworkConstants.park + path
        guard let url = URL(string: urlString, relativeTo: NetworkConstants.host) else {
            throw URLError(URLError.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 30
        return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
    }

    @discardableResult
    func request(completionHandler: @escaping (DataResponse<JSON>) -> Void) -> Request {
        return Alamofire.SessionManager.default
            .request(self)
            .validate()
            .responseSwiftyJSON(completionHandler: completionHandler)
    }
}
