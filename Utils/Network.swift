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
    static let version = "v1"
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
        guard let url = URL(string: NetworkConstants.version + path, relativeTo: NetworkConstants.host) else {
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
