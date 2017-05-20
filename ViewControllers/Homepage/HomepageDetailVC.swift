//
//  HomepageDetailVC.swift
//  disney
//
//  Created by ebuser on 2017/5/16.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class HomepageDetailVC: UIViewController {

    private let planId: String

    private let tableView: UITableView
    fileprivate let cellIdentifierTop = "cellIdentifierTop"
    fileprivate let cellIdentifierMid = "cellIdentifierMid"
    fileprivate let cellIdentifierBottom = "cellIdentifierBottom"

    fileprivate var planDetail: PlanDetail? {
        didSet {
            tableView.reloadData()
            navigationItem.title = planDetail?.name
        }
    }

    init(plan id: String) {
        planId = id
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
        guard let date = UserDefaults.standard[.visitDate] as? Date else {
            return
        }
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(in: TimeZone(secondsFromGMT: 9 * 3600)!, from: date)

        if let baseTime = calendar.date(from: dateComponents) {
            let planDetailRequest = API.Plan.detail(planId, baseTime.format())
            planDetailRequest.request { [weak self] data in
                guard let planDetail = PlanDetail(data) else {
                    return
                }
                self?.planDetail = planDetail
            }
        }

    }
}

extension HomepageDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planDetail?.routes.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // top
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTop, for: indexPath) as? HomepageDetailCellTop else {
                fatalError("Unknown cell type")
            }
            cell.data = planDetail?.routes[indexPath.row]
            return cell
        } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let planDetail = planDetail {
            let data = planDetail.routes[indexPath.row]
            let parameter = AttractionDetailVC.PreviousPage.planList(id: data.id, date: planDetail.start)
            let destination = AttractionDetailVC(parameter)
            navigationController?.pushViewController(destination, animated: true)
        }
    }
}
