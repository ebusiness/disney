//
//  AttractionDetailVC.swift
//  disney
//
//  Created by ebuser on 2017/5/11.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class AttractionDetailVC: UIViewController, FileLocalizable {

    let localizeFileName = "Attraction"

    let attractionId: String
    let thums: [String]
    let date: Date?
    let tableView: UITableView

    fileprivate var timeInfo: AttractionDetailWaitTime?
    fileprivate var detailInfo: AttractionDetail?

    fileprivate let chartCellIdentifier = "chartCellIdentifier"
    fileprivate let infoCellIdentifer = "infoCellIdentifier"
    fileprivate let thumsCellIdentifier = "thumsCellIdentifier"

    init(attractionId: String, thums: [String], date: Date? = nil) {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.attractionId = attractionId
        self.thums = thums
        self.date = date

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
        tableView.register(AttractionDetailInfoCell.self, forCellReuseIdentifier: infoCellIdentifer)
        tableView.register(AttractionDetailThumsCell.self, forCellReuseIdentifier: thumsCellIdentifier)
        tableView.backgroundColor = UIColor(hex: "E1E2E1")
        tableView.separatorStyle = .none

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
        let detailInfoRequest = API.Attraction.detail(id: attractionId)

        detailInfoRequest.request { [weak self] data in
            if let retrieved = AttractionDetail(data) {
                self?.detailInfo = retrieved
                self?.updateInfo()
            }
        }
    }

    private func requestWaitTime() {
        let dateString = date?.format(pattern: "yyyy-MM-dd")
        let timeInfoRequest = API.Attraction.waitTime(id: attractionId, date: dateString)

        timeInfoRequest.request { [weak self] data in
            if let retrieved = AttractionDetailWaitTime(data) {
                self?.timeInfo = retrieved
                self?.updateTime()
            }
        }
    }

    private func updateInfo() {
        navigationItem.title = detailInfo?.name
        tableView.reloadSections(IndexSet(integer: 1), with: .fade)
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
            return 1
        } else if section == 1 {
            if let detailInfo = detailInfo {
                return detailInfo.analysis.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let timeInfo = timeInfo {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: chartCellIdentifier, for: indexPath) as? AttractionDetailChartCell else {
                    fatalError("Unknown cell type")
                }
                cell.thum = thums[0]
                cell.data = timeInfo
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: thumsCellIdentifier, for: indexPath) as? AttractionDetailThumsCell else {
                    fatalError("Unknown cell type")
                }
                cell.thums = thums
                return cell
            }
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifer, for: indexPath) as? AttractionDetailInfoCell else {
                fatalError("Unknown cell type")
            }
            cell.data = detailInfo?.analysis[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
