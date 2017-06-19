//
//  CustomPlanAttractionsOfAreaModel.swift
//  disney
//
//  Created by ebuser on 2017/6/14.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation

struct CustomPlanAttractionsOfAreaList {
    var areas: [CustomPlanAttractionsOfAreaArea]
    init(spots: [AttractionListSpot]) {
        var areas = [String: CustomPlanAttractionsOfAreaArea]()
        spots.forEach { spot in
            let element = CustomPlanAttractionsOfAreaElement(id: spot.id,
                                                             name: spot.name,
                                                             category: spot.category,
                                                             introduction: spot.introductions,
                                                             images: spot.thums)
            if areas[spot.area] == nil {
                var area = CustomPlanAttractionsOfAreaArea(name: spot.area)
                area.elements.append(element)
                areas[spot.area] = area
            } else {
                areas[spot.area]?.elements.append(element)
            }
        }
        self.areas = Array(areas.values)
        if !self.areas.isEmpty {
            self.areas[self.areas.count - 1].selected = true
        }
    }

    struct CustomPlanAttractionsOfAreaArea {
        let name: String
        var selected = false
        var elements = [CustomPlanAttractionsOfAreaElement]()
        init(name: String) {
            self.name = name
        }
    }

    struct CustomPlanAttractionsOfAreaElement: PlanAttractionConvertible {
        let id: String
        let name: String
        let introduction: String
        let images: [String]
        let category: SpotCategory
        var selected = false

        init(id: String,
             name: String,
             category: SpotCategory,
             introduction: String,
             images: [String]) {
            self.id = id
            self.name = name
            self.category = category
            self.introduction = introduction
            self.images = images
        }
    }
}
