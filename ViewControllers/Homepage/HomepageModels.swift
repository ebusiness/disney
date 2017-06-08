//
//  HomepageModels.swift
//  disney
//
//  Created by ebuser on 2017/5/16.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PlanListElement: SwiftJSONDecodable {
    let id: String
    let name: String
    let introduction: String
    let routes: [Route]

    init?(_ json: JSON) {
        guard let id = json["_id"].string else { return nil }
        self.id = id

        guard let name = json["name"].string else { return nil }
        self.name = name

        guard let introduction = json["introduction"].string else { return nil }
        self.introduction = introduction

        guard let routes: [Route] = Route.array(json["route"]) else { return nil }
        guard !routes.isEmpty else { return nil }
        self.routes = routes
    }

    struct Route: SwiftJSONDecodable {
        let name: String
        let images: [String]

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
        }
    }
}

struct PlanDetail: SwiftJSONDecodable {
    /* 取得属性 */
    let name: String
    private(set) var routes: [Route]
    let start: Date

    init?(_ json: JSON) {
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
        let start: Date

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

            guard let start = Date(iso8601str: json["schedule"]["startTime"].string) else { return nil }
            self.start = start
        }
    }

}
