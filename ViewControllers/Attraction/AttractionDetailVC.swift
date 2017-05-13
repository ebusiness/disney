//
//  AttractionDetailVC.swift
//  disney
//
//  Created by ebuser on 2017/5/11.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

// swiftlint:disable line_length
class AttractionDetailVC: UIViewController {

    let attractionId: String
    let thum: String
    let tableView: UITableView

    fileprivate var timeInfo: AttractionDetailWaitTime?
    fileprivate var detailInfo: AttractionDetail?

    fileprivate let chartCellIdentifier = "chartCellIdentifier"

    init(attractionId: String, thum: String) {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.attractionId = attractionId
        self.thum = thum

        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true

        addSubTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        requestAttractionDetail()
        requestWaitTime()
    }

    private func addSubTableView() {
        tableView.register(AttractionDetailChartCell.self, forCellReuseIdentifier: chartCellIdentifier)
        tableView.backgroundColor = UIColor(hex: "E1E2E1")

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        view.addSubview(tableView)

        // Manage Autolayout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func requestAttractionDetail() {
        let detailInfoRequest = API.Attraction.detail(attractionId)

        detailInfoRequest.request { [weak self] data in
            if let retrieved = AttractionDetail(data) {
                self?.detailInfo = retrieved
                self?.updateInfo()
            }
        }
    }

    private func requestWaitTime() {
        let timeInfoRequest = API.Attraction.waitTime(attractionId)

        timeInfoRequest.request { [weak self] data in
            if let retrieved = AttractionDetailWaitTime(data) {
                self?.timeInfo = retrieved
                self?.updateTime()
            }
        }
    }

    private func updateInfo() {
        navigationItem.title = detailInfo?.name
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }

    private func updateTime() {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

extension AttractionDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return timeInfo == nil ? 0 : 1
        } else if section == 1 {
            return 0
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: chartCellIdentifier, for: indexPath) as? AttractionDetailChartCell else {
                fatalError("Unknown cell type")
            }
            cell.thum = thum
            cell.data = timeInfo
            return cell
        }
        return UITableViewCell()
    }
}
