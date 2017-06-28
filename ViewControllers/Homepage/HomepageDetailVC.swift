//
//  HomepageDetailVC.swift
//  disney
//
//  Created by ebuser on 2017/5/16.
//  Copyright © 2017年 e-business. All rights reserved.
//

import CoreData
import UIKit

class HomepageDetailVC: UIViewController {

    private let planId: String
    private let planType: PlanType

    var fetchedResultsController: NSFetchedResultsController<CustomPlan>?

    private let tableView: UITableView
    fileprivate let cellIdentifierTop = "cellIdentifierTop"
    fileprivate let cellIdentifierMid = "cellIdentifierMid"
    fileprivate let cellIdentifierBottom = "cellIdentifierBottom"
    fileprivate let pathCellIdentifier = "pathCellIdentifier"
    fileprivate var pathCell: HomepageDetailPathCell!

    fileprivate var planDetail: PlanDetail?

    init(plan id: String, type: PlanType) {
        planId = id
        planType = type
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubTableView()

        requestPlanDetail()
    }

    private func addSubTableView() {
        tableView.register(HomepageDetailCellTop.self, forCellReuseIdentifier: cellIdentifierTop)
        tableView.register(HomepageDetailCellMid.self, forCellReuseIdentifier: cellIdentifierMid)
        tableView.register(HomepageDetailCellBottom.self, forCellReuseIdentifier: cellIdentifierBottom)
        pathCell = HomepageDetailPathCell(style: .default, reuseIdentifier: nil)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func requestPlanDetail() {
        if planType == .custom {
            let fetchRequest = NSFetchRequest<CustomPlan>(entityName: "CustomPlan")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "create", ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "id == %@", planId)
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
                requester.request { [weak self] data in
                    guard let planDetail = PlanDetail(data) else { return }
                    guard let strongSelf = self else { return }
                    strongSelf.planDetail = planDetail
                    strongSelf.title = result.cName
                    strongSelf.tableView.reloadData()
                }
            } catch {
                // 取得不到数据

                return
            }
        } else {
            guard let date = Preferences.shared.visitStart.value else { return }
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents(in: TimeZone(secondsFromGMT: 9 * 3600)!, from: date)

            if let baseTime = calendar.date(from: dateComponents) {
                let planDetailRequest = API.Plans.detail(planId, baseTime.format())
                planDetailRequest.request { [weak self] data in
                    guard let planDetail = PlanDetail(data) else {
                        return
                    }
                    self?.planDetail = planDetail
                    self?.title = planDetail.name
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension HomepageDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return planDetail?.pathImageURL != nil ? 1 : 0
        } else {
            return planDetail?.routes.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Path image
            pathCell.imageURL = planDetail?.pathImageURL
            return pathCell
        } else {
            if indexPath.row == 0 {
                // top
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTop, for: indexPath) as? HomepageDetailCellTop else {
                    fatalError("Unknown cell type")
                }
                cell.data = planDetail?.routes[indexPath.row]
                return cell
            } else if indexPath.row == tableView.numberOfRows(inSection: 1) - 1 {
                // bottom
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierBottom, for: indexPath) as? HomepageDetailCellBottom else {
                    fatalError("Unknown cell type")
                }
                cell.data = planDetail?.routes[indexPath.row]
                return cell
            } else {
                // mid
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierMid, for: indexPath) as? HomepageDetailCellMid else {
                    fatalError("Unknown cell type")
                }
                cell.data = planDetail?.routes[indexPath.row]
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {

            let rectInWindow = pathCell.pathImageView.rectInWindow
            let desination = ImageBrowserController(contentFrame: rectInWindow,
                                                    imageURL: planDetail?.pathImageURL)
            present(desination, animated: false, completion: nil)
        } else {
            if let planDetail = planDetail {
                let data = planDetail.routes[indexPath.row]
                let parameter = AttractionDetailVC.PreviousPage.planList(id: data.id, date: planDetail.start)
                let destination = AttractionDetailVC(parameter)
                navigationController?.pushViewController(destination, animated: true)
            }
        }
    }
}
