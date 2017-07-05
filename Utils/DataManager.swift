//
//  CoreData.swift
//  disney
//
//  Created by ebuser on 2017/6/12.
//  Copyright © 2017年 e-business. All rights reserved.
//

import CoreData
import UIKit

class DataManager {

    private init() { }

    static let shared = DataManager()

    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
    }

    lazy var context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return appDelegate.managedObjectContext
    }()

    func randomID() -> String {
        let uuid = UUID()
        return uuid.uuidString
    }
}

class SpecifyPlanManager {
    private init() { }

    static let shared = SpecifyPlanManager()

    private var type: PlanType!
    private var id: String!

    func save(type: PlanType, id: String) {
        self.type = type
        self.id = id
        requestPlanDetail()
    }

    func updateFastpass(route: SpecifiedPlanRoute, begin: Date, end: Date, completionHandler: (() -> Swift.Void)? = nil) {
        guard let sId = route.id else { return }
        guard let date = Preferences.shared.visitStart.value else { return }
        let sRouteParameter: [String: Any] = ["str_id": sId,
                                              "fastpass": [
                                                "begin": begin.zFormat(),
                                                "end": end.zFormat()]]
        guard let otherRoutes = route
            .plan?
            .routes?
            .map ({ $0 as? SpecifiedPlanRoute })
            .flatMap({ $0 })
            .filter({ ($0.id != nil) && ($0.id != sId) })
            else { return }
        let otherRouteParameter: [[String: Any]] = otherRoutes
            .map({
                if let fp = $0.fastpass,
                    let begin = fp.begin,
                    let end = fp.end {
                    return ["str_id": $0.id!,
                            "fastpass": ["begin": begin.zFormat(),
                                         "end": end.zFormat()]]
                } else {
                    return ["str_id": $0.id!]
                }
            })
        let routes = [sRouteParameter] + otherRouteParameter
        let parameter = API.Plans.CustomizeParameter(start: date, route: routes)
        let requester = API.Plans.customize(parameter)
        requester.request { data in
            guard let planDetail = PlanDetail(data) else { return }
            self.replaceInDB(plan: planDetail)
            completionHandler?()
        }
    }

    private func requestPlanDetail() {
        if type == .custom {
            let fetchRequest = NSFetchRequest<CustomPlan>(entityName: "CustomPlan")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "create", ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            do {
                let results = try DataManager.shared.context.fetch(fetchRequest)
                guard let date = Preferences.shared.visitStart.value else { return }
                guard let result = results[safe: 0] else { return }
                guard let routes = result
                    .routes?
                    .array
                    .map ({ $0 as? CustomPlanRoute })
                    .flatMap ({ $0?.str_id })
                    .map ({ ["str_id": $0] })
                    else { return }
                let parameter = API.Plans.CustomizeParameter(start: date, route: routes)
                let requester = API.Plans.customize(parameter)
                requester.request { data in
                    guard let planDetail = PlanDetail(data) else { return }
                    self.replaceInDB(plan: planDetail)
                }
            } catch {
                // 取得不到数据

                return
            }
        } else {
            guard let date = Preferences.shared.visitStart.value else { return }

            let planDetailRequest = API.Plans.detail(id, date.format())
            planDetailRequest.request { data in
                guard let planDetail = PlanDetail(data) else { return }
                self.replaceInDB(plan: planDetail)
            }
        }
    }

    private func replaceInDB(plan: PlanDetail) {
        // 删除已有数据
        let fetchRequest = NSFetchRequest<SpecifiedPlan>(entityName: "SpecifiedPlan")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "park", ascending: false)]
        fetchRequest.predicate = NSPredicate(value: true)
        do {
            let results = try DataManager.shared.context.fetch(fetchRequest)
            results.forEach { DataManager.shared.context.delete($0) }
        } catch {
        }
        // 添加新数据
        SpecifiedPlan.from(planDetail: plan)
        DataManager.shared.save()
    }
}
