//
//  CustomPlanModels.swift
//  disney
//
//  Created by ebuser on 2017/5/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

struct PlanCategoryAttractionTag: SwiftJSONDecodable {
    let id: String
    let name: String
    let color: String
    let icon: Icon

    init?(_ json: JSON) {
        guard let id = json["_id"].string else { return nil }
        self.id = id

        guard let name = json["name"].string else { return nil }
        self.name = name

        guard let color = json["plan_creation"]["color"].string else { return nil }
        self.color = color

        guard let iconString = json["plan_creation"]["icon"].string else { return nil }
        guard let icon = Icon(rawValue: iconString) else { return nil }
        self.icon = icon
    }

    enum Icon: String {
        case filmEffect = "3D_film_effects"
        case rainy = "OK_on_rainy_days"
        case fastpass = "FASTPASS_Attraction"
        case heightFree = "No_height_restrictions"
        case babies = "Babies"
        case speed = "Speed_/_Thrills"

        var image: UIImage {
            switch self {
            case .filmEffect:
                return #imageLiteral(resourceName: "3D_film_effects")
            case .rainy:
                return #imageLiteral(resourceName: "OK_on_rainy_days")
            case .fastpass:
                return #imageLiteral(resourceName: "FASTPASS_Attraction")
            case .heightFree:
                return #imageLiteral(resourceName: "No_height_restrictions")
            case .babies:
                return #imageLiteral(resourceName: "Babies")
            case .speed:
                return #imageLiteral(resourceName: "SpeedOrThrills")
            }
        }
    }
}

struct PlanCategoryAttractionTagDetail: SwiftJSONDecodable {
    let id: String
    var attractions: [Attraction]

    init?(_ json: JSON) {
        guard let id = json["_id"].string else { return nil }
        self.id = id

        guard let attractions = Attraction.array(json["attractions"]) else { return nil }
        self.attractions = attractions
    }

    struct Attraction: SwiftJSONDecodable, CustomPlanAttractionConvertible {
        let id: String
        let name: String
        let introduction: String
        let category: SpotCategory
        let images: [String]

        var selected = false

        init?(_ json: JSON) {
            guard let id = json["str_id"].string else { return nil }
            self.id = id

            guard let name = json["name"].string else { return nil }
            self.name = name

            guard let introduction = json["introductions"].string else { return nil }
            self.introduction = introduction

            guard let categoryString = json["category"].string else { return nil }
            guard let category = SpotCategory(rawValue: categoryString) else { return nil }
            self.category = category

            guard let array = json["images"].array else { return nil }
            let images = array.map { $0.string } .flatMap { $0 }
            guard !images.isEmpty else { return nil }
            self.images = images
        }

    }
}

struct CustomPlanAttraction: CustomPlanAttractionConvertible {
    let id: String
    let name: String
    let category: SpotCategory
    var selected: Bool

    init(id: String,
         name: String,
         category: SpotCategory) {
        self.id = id
        self.name = name
        self.category = category
        self.selected = true
    }
}

protocol CustomPlanAttractionConvertible: Equatable {
    var id: String { get }
    var name: String { get }
    var category: SpotCategory { get }
}

extension CustomPlanAttractionConvertible {
    static func ==<T> (lhs: Self, rhs: T) -> Bool where T: CustomPlanAttractionConvertible {
        return lhs.id == rhs.id
    }

    func convertToPlanAttraction() -> CustomPlanAttraction {
        return CustomPlanAttraction(id: id, name: name, category: category)
    }
}
