//
//  SpecifiedPlan.swift
//  disney
//
//  Created by ebuser on 2017/6/30.
//  Copyright © 2017年 e-business. All rights reserved.
//

import CoreData

extension SpecifiedPlan {
    @discardableResult
    static func from(planDetail: PlanDetail) -> SpecifiedPlan {
        let context = DataManager.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "SpecifiedPlan",
                                                in: context)!
        let myPlan = SpecifiedPlan(entity: entity,
                                   insertInto: context)
        myPlan.park = planDetail.park.rawValue
        myPlan.startTime = planDetail.start
        planDetail
            .routes
            .map { SpecifiedPlanRoute.from(route: $0) }
            .forEach { $0.plan = myPlan }
        return myPlan
    }
}

extension SpecifiedPlanRoute {
    var eCategory: SpotCategory {
        if category == "attraction" {
            return .attraction
        } else if category == "show" {
            return .show
        } else {
            return .greeting
        }
    }

    static func from(route: PlanDetail.Route) -> SpecifiedPlanRoute {
        let context = DataManager.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "SpecifiedPlanRoute",
                                                in: context)!
        let myRoute = SpecifiedPlanRoute(entity: entity,
                                         insertInto: context)
        myRoute.id = route.id
        myRoute.timeCost = Int32(route.timeCost)
        myRoute.timeToNext = Int32(route.timeToNext)
        myRoute.waitTime = Int32(route.waitTime)
        myRoute.name = route.name
        myRoute.start = route.start
        myRoute.category = route.category.rawValue

        // 计算开始时间和结束时间
        let timeForPlay = 60 * route.waitTime + 60 * route.timeCost
        let endTime = route.start.addingTimeInterval(Double(timeForPlay))
        myRoute.startTimeText = route.start.format(pattern: "H:mm")
        myRoute.endTimeText = endTime.format(pattern: "H:mm")

        // 缩略图
        route
            .images
            .map { SpecifiedPlanRouteImage.from(url: $0) }
            .forEach { $0.route = myRoute }

        // Fastpass
        if let fastpass = route.fastpass {
            myRoute.fastpass = SpecifiedPlanRouteFastpass.from(fastpass: fastpass)
        }
        return myRoute
    }
}

extension SpecifiedPlanRouteImage {
    static func from(url: String) -> SpecifiedPlanRouteImage {
        let context = DataManager.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "SpecifiedPlanRouteImage",
                                                in: context)!
        let image = SpecifiedPlanRouteImage(entity: entity,
                                            insertInto: context)
        image.url = url
        return image
    }
}

extension SpecifiedPlanRouteFastpass {
    static func make(begin: Date, end: Date) -> SpecifiedPlanRouteFastpass {
        let context = DataManager.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "SpecifiedPlanRouteFastpass",
                                                in: context)!
        let fastpass = SpecifiedPlanRouteFastpass(entity: entity,
                                                  insertInto: context)
        fastpass.begin = begin
        fastpass.end = end
        fastpass.beginString = begin.format(pattern: "H:mm")
        fastpass.endString = end.format(pattern: "H:mm")
        return fastpass
    }

    static func from(fastpass: PlanDetail.Fastpass) -> SpecifiedPlanRouteFastpass {
        return SpecifiedPlanRouteFastpass.make(begin: fastpass.begin, end: fastpass.end)
    }
}
