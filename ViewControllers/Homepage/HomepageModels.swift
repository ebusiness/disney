//
//  HomepageModels.swift
//  disney
//
//  Created by ebuser on 2017/5/16.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PlanType {
    case suggestion
    case custom
}

protocol PlanConvertible {
    var cId: String { get }
    var cPathImageURL: URL? { get }
    var cName: String { get }
    var cIntroduction: String { get }
    var cRoutes: [RouteConvertible] { get }
}

protocol RouteConvertible {
    var cName: String { get }
    var cImages: [String] { get }
}

struct PlanListElement: SwiftJSONDecodable, PlanConvertible {

    let id: String
    let pathImageURL: URL?
    let name: String
    let introduction: String
    let routes: [Route]

    // PlanConvertible
    var cId: String {
        return id
    }
    var cPathImageURL: URL? {
        return pathImageURL
    }
    var cName: String {
        return name
    }
    var cIntroduction: String {
        return introduction
    }
    var cRoutes: [RouteConvertible] {
        return routes
    }

    init?(_ json: JSON) {
        guard let id = json["_id"].string else { return nil }
        self.id = id

        let mapRequest = API.Plans.map(id: id)
        if let mapUrl = try? mapRequest.asURLRequest().url,
            let uMapUrl = mapUrl {
            self.pathImageURL = uMapUrl
        } else {
            self.pathImageURL = nil
        }

        guard let name = json["name"].string else { return nil }
        self.name = name

        guard let introduction = json["introduction"].string else { return nil }
        self.introduction = introduction

        guard let routes: [Route] = Route.array(json["route"]) else { return nil }
        guard !routes.isEmpty else { return nil }
        self.routes = routes
    }

    struct Route: SwiftJSONDecodable, RouteConvertible {
        let name: String
        let images: [String]

        // RouteConvertible
        var cName: String {
            return name
        }
        var cImages: [String] {
            return images
        }

        init?(_ json: JSON) {
            guard let name = json["attraction"]["name"].string else {
                return nil
            }
            self.name = name

            guard let array = json["attraction"]["images"].array else {
                return nil
            }
            let images = array.flatMap { $0.string }
            guard !images.isEmpty else {
                return nil
            }
            self.images = images
        }
    }
}

struct PlanDetail: SwiftJSONDecodable {
    /* 取得属性 */
    let id: String
    let pathImageURL: URL?
    let name: String
    private(set) var routes: [Route]
    let start: Date

    // 有时需要在获取之后指定Plan所在的园区
    // API没有返回相应信息，需要手动保存
    let park = Preferences.shared.visitPark.value ?? .land

    init?(_ json: JSON) {
        guard let id = json["_id"].string else { return nil }
        self.id = id

        let mapRequest = API.Plans.map(id: id)
        if let mapUrl = try? mapRequest.asURLRequest().url,
            let uMapUrl = mapUrl {
            self.pathImageURL = uMapUrl
        } else {
            self.pathImageURL = nil
        }

        guard let name = json["name"].string else {
            return nil
        }
        self.name = name

        guard let routes: [Route] = Route.array(json["route"]) else { return nil }
        guard !routes.isEmpty else { return nil }
        self.routes = routes

        guard let start = Date(iso8601str: json["start"].string) else { return nil }
        self.start = start

        analyse()
    }

    private mutating func analyse() {
        for (index, var value) in routes.enumerated() {

            var baseTime = value.start
            // 分析各个时间点
            value.timeStart = baseTime
            let timeForPlay = 60 * value.waitTime + 60 * value.timeCost
            baseTime = baseTime.addingTimeInterval(Double(timeForPlay))
            value.timeEnd = baseTime
            value.timeWalkStart = baseTime
            let timeForWalk = 60 * value.timeToNext
            baseTime = baseTime.addingTimeInterval(Double(timeForWalk))
            value.timeWalkEnd = baseTime

            routes[index] = value
        }
    }

    struct Route: SwiftJSONDecodable {
        /* 取得属性 */
        let name: String
        let images: [String]
        let timeCost: Int
        let timeToNext: Int
        let waitTime: Int
        let id: String
        let category: SpotCategory
        let start: Date
        let fastpass: Fastpass?

        /* 计算属性 */
        fileprivate(set) var timeStart: Date?
        fileprivate(set) var timeEnd: Date?
        fileprivate(set) var timeWalkStart: Date?
        fileprivate(set) var timeWalkEnd: Date?

        init?(_ json: JSON) {
            guard let name = json["attraction"]["name"].string else {
                return nil
            }
            self.name = name

            guard let array = json["attraction"]["images"].array else {
                return nil
            }
            let images = array.map { $0.string } .filter { $0 != nil } .map { $0! }
            guard !images.isEmpty else {
                return nil
            }
            self.images = images

            guard let timeCost = json["timeCost"].int else {
                return nil
            }
            self.timeCost = timeCost

            self.timeToNext = json["walktimeToNext"].int ?? 0

            self.waitTime = json["waitTime"].int ?? 0

            guard let id = json["str_id"].string else { return nil }
            self.id = id

            guard let categoryString = json["attraction"]["category"].string else { return nil }
            guard let category = SpotCategory(rawValue: categoryString) else { return nil }
            self.category = category

            guard let start = Date(iso8601str: json["schedule"]["startTime"].string) else { return nil }
            self.start = start

            self.fastpass = Fastpass(json["fastpass"])
        }
    }

    struct Fastpass: SwiftJSONDecodable {
        let begin: Date
        let end: Date

        init?(_ json: JSON) {
            guard let begin = Date(iso8601str: json["begin"].string) else { return nil }
            self.begin = begin

            guard let end = Date(iso8601str: json["end"].string) else { return nil }
            self.end = end
        }
    }

}

extension CustomPlan: PlanConvertible {
    var cId: String {
        return id ?? ""
    }
    var cPathImageURL: URL? {
        if let pathImageString = pathImage,
            let pathImageURL = URL(string: pathImageString) {
            return pathImageURL
        } else {
            return nil
        }
    }
    var cName: String {
        return name ?? ""
    }
    var cIntroduction: String {
        return introduction ?? ""
    }
    var cRoutes: [RouteConvertible] {
        guard let routes = routes else { return [] }
        return routes
            .array
            .map { $0 as? CustomPlanRoute }
            .flatMap { $0 }
    }
}

extension CustomPlanRoute: RouteConvertible {
    var cName: String {
        return name ?? ""
    }
    var cImages: [String] {
        guard let images = images else { return [] }
        return images
            .array
            .map { $0 as? CustomPlanRouteImage }
            .flatMap { $0?.url }
    }
}
