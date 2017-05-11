//
//  AttractionModels.swift
//  disney
//
//  Created by ebuser on 2017/5/9.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AttractionListSpot: SwiftJSONSerializable {
    let id: String
    let category: SpotCategory
    let name: String
    let area: String
    let thum: String
    let realtime: Realtime?
    let introductions: String

    init?(_ json: JSON) {
        guard let id = json["str_id"].string else {
            return nil
        }
        self.id = id

        guard let category = SpotCategory(rawValue: json["category"].stringValue) else {
            return nil
        }
        self.category = category

        guard let name = json["name"].string else {
            return nil
        }
        self.name = name

        guard let area = json["area"].string else {
            return nil
        }
        self.area = area

        guard let thum = json["thum_url_pc"].string else {
            return nil
        }
        self.thum = thum

        realtime = Realtime(json["realtime"])

        guard let introductions = json["introductions"].string else {
            return nil
        }
        self.introductions = introductions
    }

    struct Realtime: SwiftJSONSerializable {
        let statusInfo: String
        let available: Bool
        let fastpassAvailable: Bool

        let operationStart: Date?
        let operationEnd: Date?
        let fastpassStart: Date?
        let fastpassEnd: Date?
        let fastpassInfo: String?
        let fastpassRunning: Bool

        let waitTime: Int?

        init?(_ json: JSON) {
            guard let statusInfo = json["statusInfo"].string else {
                return nil
            }
            self.statusInfo = statusInfo

            guard let available = json["available"].bool else {
                return nil
            }
            self.available = available

            guard let fastpassAvailable = json["fastpassAvailable"].bool else {
                return nil
            }
            self.fastpassAvailable = fastpassAvailable

            operationStart = Date(iso8601str: json["operation_start"].string)
            operationEnd = Date(iso8601str: json["operation_end"].string)
            fastpassStart = Date(iso8601str: json["fastpass_start"].string)
            fastpassEnd = Date(iso8601str: json["fastpass_end"].string)

            fastpassInfo = json["fastpassInfo"].string
            fastpassRunning = fastpassInfo == "発券中"

            if let waitTimeStr = json["waitTime"].string {
                waitTime = Int(waitTimeStr)
            } else {
                waitTime = nil
            }

        }
    }
}
