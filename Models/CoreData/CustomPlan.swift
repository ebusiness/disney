//
//  CustomPlan.swift
//  disney
//
//  Created by ebuser on 2017/6/12.
//  Copyright © 2017年 e-business. All rights reserved.
//

import CoreData

extension CustomPlan {
    static func from(planDetail: PlanDetail) -> CustomPlan? {
        let context = DataManager.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "CustomPlan",
                                                in: context)!
        let myPlan = CustomPlan(entity: entity,
                                insertInto: context)
        myPlan.id = planDetail.id
        myPlan.pathImage = planDetail.pathImageURL?.absoluteString
        planDetail
            .routes
            .map { CustomPlanRoute.from(route: $0) }
            .flatMap { $0 }
            .forEach { $0.plan = myPlan }
        return myPlan
    }
}

extension CustomPlanRoute {
    static func from(route: PlanDetail.Route) -> CustomPlanRoute? {
        let context = DataManager.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "CustomPlanRoute",
                                                in: context)!
        let myRoute = CustomPlanRoute(entity: entity,
                                      insertInto: context)
        myRoute.str_id = route.id
        myRoute.name = route.name
        myRoute.category = "nonono"
        route
            .images
            .map { CustomPlanRouteImage.from(url: $0) }
            .flatMap { $0 }
            .forEach { $0.route = myRoute }
        return myRoute
    }
}

extension CustomPlanRouteImage {
    static func from(url: String) -> CustomPlanRouteImage? {
        let context = DataManager.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "CustomPlanRouteImage",
                                                in: context)!
        let image = CustomPlanRouteImage(entity: entity,
                                         insertInto: context)
        image.url = url
        return image
    }
}
