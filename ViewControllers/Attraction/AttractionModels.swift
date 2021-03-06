//
//  AttractionModels.swift
//  disney
//
//  Created by ebuser on 2017/5/9.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation
import SwiftyJSON

// swiftlint:disable file_length
struct AttractionListSpot: SwiftJSONDecodable {
    let id: String
    let category: SpotCategory
    let name: String
    let area: String
    let thums: [String]
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

        guard let thums = json["images"].array else {
            return nil
        }
        self.thums = thums.map { $0.string } .filter { $0 != nil } .map { $0! }
        if thums.isEmpty { return nil }

        realtime = Realtime(json["realtime"])

        guard let introductions = json["introductions"].string else {
            return nil
        }
        self.introductions = introductions
    }

    struct Realtime: SwiftJSONDecodable {
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

            waitTime = json["waitTime"].int

        }
    }
}

struct AttractionDetail: SwiftJSONDecodable, FileLocalizable {

    let localizeFileName = "Attraction"

    let id: String
    let name: String
    let area: String
    let introductions: String
    let isAvailable: Bool
    let thums: [String]

    let summaries: [Summary]?
    let summaryTags: [SummaryTag]?

    let restrictions: [String]?
    let mapImages: [String]?

    private(set) var analysis = [CardInfo]()

    //swiftlint:disable:next cyclomatic_complexity
    init?(_ json: JSON) {
        guard let id = json["str_id"].string else {
            return nil
        }
        self.id = id

        guard let name = json["name"].string else {
            return nil
        }
        self.name = name

        guard let area = json["area"].string else { return nil }
        self.area = area

        guard let introductions = json["introductions"].string else {
            return nil
        }
        self.introductions = introductions

        guard let isAvailable = json["is_available"].bool else { return nil }
        self.isAvailable = isAvailable

        guard let thums = json["images"].array else {
            return nil
        }
        self.thums = thums.map { $0.string } .filter { $0 != nil } .map { $0! }
        if thums.isEmpty { return nil }

        summaries = Summary.array(json["summaries"])
        summaryTags = SummaryTag.array(json["summary_tags"])

        if let limitArray = json["limited"].array {
            let limits = limitArray.map { $0.string } .filter { $0 != nil } .map { $0! }
            if !limits.isEmpty {
                self.restrictions = limits
            } else {
                self.restrictions = nil
            }
        } else {
            self.restrictions = nil
        }

        if let mapArray = json["maps"].array {
            let maps = mapArray.map { $0.string } .filter { $0 != nil } .map { $0! }
            if !maps.isEmpty {
                mapImages = maps
            } else {
                mapImages = nil
            }
        } else {
            mapImages = nil
        }

        analyse()
    }

    // swiftlint:disable:next function_body_length
    private mutating func analyse() {
        // 分区

        // 项目简介
        let cardIntroduction = CardInfo(cardType: .introduction,
                                        title: localize(for: "AttractionDetailCellInfo"),
                                        content: introductions)
        analysis.append(cardIntroduction)

        // 所需时间
        let cardTitleDuration = localize(for: "AttractionDetailCellDuration")
        if let duration = summaries?.first(where: { summary -> Bool in
            return summary.title == cardTitleDuration
        }) {
            let cardDuration = CardInfo(cardType: .duration,
                                        title: duration.title,
                                        content: duration.body)
            analysis.append(cardDuration)
        }

        // 演出时间
        let cardTitleShowDuration = localize(for: "AttractionDetailCellShowDuration")
        if let duration = summaries?.first(where: { summary -> Bool in
            return summary.title == cardTitleShowDuration
        }) {
            let cardDuration = CardInfo(cardType: .duration,
                                        title: duration.title,
                                        content: duration.body)
            analysis.append(cardDuration)
        }

        // 定员
        let cardTitleCapacity = localize(for: "AttractionDetailCellCapacity")
        if let capacity = summaries?.first(where: { summary -> Bool in
            return summary.title == cardTitleCapacity
        }) {
            let cardCapacity = CardInfo(cardType: .capacity,
                                        title: capacity.title,
                                        content: capacity.body)
            analysis.append(cardCapacity)
        }

        // 搭乘限制（预留）
        if let restrictions = restrictions {
            let content = restrictions.joined(separator: "<br />")
            let cardRestrictions = CardInfo(cardType: .restriction,
                                            title: localize(for: "AttractionDetailCellBoardingRestrictions"),
                                            content: content)
            analysis.append(cardRestrictions)
        }

        // 对象
        let cardTitleAppropriateFor = localize(for: "AttractionDetailCellAppropriateFor")
        if let appropriateFor = summaryTags?.first(where: { summaryTag -> Bool in
            return summaryTag.type == cardTitleAppropriateFor
        }) {
            let content = appropriateFor.tags.joined(separator: "<br />")
            let cardAppropriateFor = CardInfo(cardType: .appropriateFor,
                                        title: appropriateFor.type,
                                        content: content)
            analysis.append(cardAppropriateFor)
        }

        // 游乐设施分类
        let cardTitleAttractionType = localize(for: "AttractionDetailCellAttractionType")
        if let attractionType = summaryTags?.first(where: { summaryTag -> Bool in
            return summaryTag.type == cardTitleAttractionType
        }) {
            let content = attractionType.tags.joined(separator: "<br />")
            let cardAppropriateFor = CardInfo(cardType: .attractionType,
                                              title: attractionType.type,
                                              content: content)
            analysis.append(cardAppropriateFor)
        }

    }

    struct Summary: SwiftJSONDecodable {
        let title: String
        let body: String
        init?(_ json: JSON) {
            guard let title = json["title"].string else {
                return nil
            }
            self.title = title

            guard let body = json["body"].string else {
                return nil
            }
            self.body = body
        }
    }

    struct SummaryTag: SwiftJSONDecodable {
        let type: String
        let tags: [String]
        init?(_ json: JSON) {
            guard let type = json["type"].string else {
                return nil
            }
            self.type = type

            guard let tags = json["tags"].array?.map({ $0.stringValue }) else {
                return nil
            }
            self.tags = tags
        }
    }

    struct CardInfo {
        let title: String
        let content: String
        let cardType: CardType

        init(cardType: CardType, title: String, content: String) {
            self.cardType = cardType
            self.title = title
            self.content = content
        }
    }

    enum CardType {
        case introduction
        case duration
        case capacity
        case restriction
        case appropriateFor
        case attractionType
//        case
    }
}

struct AttractionDetailWaitTime: SwiftJSONDecodable {

    let date: Date

    // 预测时间与实际时间至少存在一个
    // 从8:00开始至22:00结束，每15分钟一个数据，依次对应数组下标的0...56
    let prediction: [WaitTimeSim?]?
    let realtime: [WaitTimeReal?]?

    let type: AttractionDetailWaitTimeType
    // 第一个实时数据的位置
    private(set) var firstRealtimeIndex: Int?
    // 最后一个实时数据的位置
    private(set) var lastRealtimeIndex: Int?
    // 运营结束时的位置
    private(set) var maxIndex: Int?

    // 最大值的档位：30, 60, 90...
    private(set) var scale: Int = 30

    init?(_ json: JSON) {
        guard let date = Date(iso8601str: json["datetime"].string) else { return nil }
        self.date = date

        var emptyPrediction = true
        var emptyRealtime = true

        if let ps = WaitTimeSim.array(json["prediction"]), !ps.isEmpty {
            var tps: [WaitTimeSim?] = Array(repeating: nil, count: 57)
            ps.forEach { tps[$0.index] = $0 }
            prediction = tps
            emptyPrediction = false
        } else {
            prediction = nil
            emptyPrediction = true
        }

        if let rs = WaitTimeReal.array(json["realtime"]), !rs.isEmpty {
            var trs: [WaitTimeReal?] = Array(repeating: nil, count: 57)
            rs.forEach { trs[$0.index] = $0 }
            realtime = trs
            emptyRealtime = false
        } else {
            realtime = nil
            emptyRealtime = true
        }

        switch (emptyPrediction, emptyRealtime) {
        case (true, true):
            return nil
        case (true, false):
            type = .realtimeOnly
        case (false, true):
            type = .simOnly
        case (false, false):
            type = .mix
        }

        let analysis = analyseRealtime()
        firstRealtimeIndex = analysis[0]
        lastRealtimeIndex = analysis[1]
        maxIndex = analysis[2]

        scale = analyseScale()

    }

    /// 分析实时数据：获取实时信息开始点，实时信息结束点，停运时间点
    ///
    /// - Returns: (实时信息开始点，实时信息结束点，停运时间点)
    func analyseRealtime() -> [Int?] {
        if let rt = realtime {
            // 实时信息存在
            let numberOfValues = rt.count
            // first index
            var iFirstIndex: Int?
            var lastAvailableOperationEnd: Date?
            for index in 0..<numberOfValues {
                if let data = rt[index] {
                    iFirstIndex = index
                    lastAvailableOperationEnd = data.operationEnd
                    break
                }
            }
            guard let firstIndex = iFirstIndex else {
                return [nil, nil, nil]
            }

            // last index
            var lastIndex = firstIndex
            var lastRunning = true
            if firstIndex + 1 < numberOfValues {
                for index in (firstIndex + 1)..<numberOfValues {
                    if let data = rt[index] {
                        lastIndex = index
                        lastRunning = data.running
                        lastAvailableOperationEnd = data.operationEnd
                    }
                }
            }

            // 如果最后一条可用信息时，项目处于停运状态
            if !lastRunning {
                return [firstIndex, lastIndex, lastIndex]
            }

            // stop index
            if let laoe = lastAvailableOperationEnd, let laoeIndex = laoe.waitTimeIndex {
                return [firstIndex, lastIndex, laoeIndex]
            } else {
                return [firstIndex, lastIndex, 56]
            }
        } else {
            return [nil, nil, nil]
        }
    }

    private func analyseScale() -> Int {
        var scale = 30
        if let simData = prediction {
            let skip = lastRealtimeIndex ?? -1
            let simScale = simData.reduce(30) { (res, data) -> Int in
                if let data = data, data.index > skip, data.waitTime > res {
                    return ((data.waitTime - 1) / 30 + 1) * 30
                } else {
                    return res
                }
            }
            scale = max(scale, simScale)
        }
        if let realData = realtime {
            let realScale = realData.reduce(30) { (res, data) -> Int in
                if let data = data, data.waitTime > res {
                    return ((data.waitTime - 1) / 30 + 1) * 30
                } else {
                    return res
                }
            }
            scale = max(scale, realScale)
        }
        return scale
    }

    struct WaitTimeReal: SwiftJSONDecodable {
        let waitTime: Int
        let at: Date
        let running: Bool
        let operationEnd: Date?

        // 从8:00至22:00每15分钟分割
        let index: Int

        init?(_ json: JSON) {

            guard let createTime = Date(iso8601str: json["createTime"].string) else {
                return nil
            }
            self.at = createTime

            guard let running = json["available"].bool else {
                return nil
            }
            self.running = running

            if running {
                guard let waitTimeInt = json["waitTime"].int else {
                    return nil
                }
                self.waitTime = waitTimeInt
            } else {
                waitTime = 0
            }

            operationEnd = Date(iso8601str: json["operation_end"].string)

            guard let index = createTime.waitTimeIndex else {
                return nil
            }
            self.index = index
        }
    }

    struct WaitTimeSim: SwiftJSONDecodable {
        let waitTime: Int
        let at: Date

        // 从8:00至22:00每15分钟分割
        let index: Int
        init?(_ json: JSON) {
            guard let waitTimeInt = json["waitTime"].int else {
                return nil
            }
            self.waitTime = waitTimeInt

            guard let createTime = Date(iso8601str: json["createTime"].string) else {
                return nil
            }
            self.at = createTime

            guard let index = createTime.waitTimeIndex else {
                return nil
            }
            self.index = index
        }
    }
}

enum AttractionDetailWaitTimeType {
    case realtimeOnly
    case simOnly
    case mix
}

fileprivate extension Date {
    var waitTimeIndex: Int? {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: self)
        guard let hour = comp.hour, let minute = comp.minute else {
            return nil
        }
        let secondsSinceOpen = hour * 3600 + minute * 60 - 8 * 3600
        if secondsSinceOpen < 0 {
            return nil
        }
        let index = Int(floor( Double(secondsSinceOpen) / Double(60 * 15) ))
        if index > 56 {
            return nil
        } else {
            return index
        }
    }
}
