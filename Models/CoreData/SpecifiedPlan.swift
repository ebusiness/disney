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
        route
            .images
            .map { SpecifiedPlanRouteImage.from(url: $0) }
            .forEach { $0.route = myRoute }
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
