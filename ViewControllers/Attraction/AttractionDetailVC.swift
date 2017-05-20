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

    let previousPage: PreviousPage
    let tableView: UITableView

    lazy var attractionId: String = {
        switch self.previousPage {
        case .attractionList(let spot):
            return spot.id
        case .planList(let id, _):
            return id
        }
    }()

    lazy var date: Date? = {
        switch self.previousPage {
        case .attractionList(let spot):
            return nil
        case .planList(_, let date):
            return date
        }
    }()

    fileprivate var timeInfo: AttractionDetailWaitTime?
    fileprivate var detailInfo: AttractionDetail?

    fileprivate let chartCellIdentifier = "chartCellIdentifier"
    fileprivate let infoCellIdentifer = "infoCellIdentifier"
    fileprivate let thumsCellIdentifier = "thumsCellIdentifier"

    init(_ parameter: PreviousPage) {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.previousPage = parameter

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
            }
            self?.updateTime()
        }
    }

    private func updateInfo() {
        guard let detailInfo = detailInfo else { return }

        navigationItem.title = detailInfo.name

        if detailInfo.isAvailable {
            requestWaitTime()
        } else {
            tableView.reloadData()
        }
    }

    private func updateTime() {
        tableView.reloadData()
    }

    enum PreviousPage {
        case attractionList(data: AttractionListSpot)
        case planList(id: String, date: Date)
    }
}

extension AttractionDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return detailInfo != nil ? 1 : 0
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
            guard let detailInfo = detailInfo else { fatalError("need detail info to show thumbs") }
            if let timeInfo = timeInfo {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: chartCellIdentifier, for: indexPath) as? AttractionDetailChartCell else {
                    fatalError("Unknown cell type")
                }
                cell.thum = detailInfo.thums[0]
                cell.data = timeInfo
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: thumsCellIdentifier, for: indexPath) as? AttractionDetailThumsCell else {
                    fatalError("Unknown cell type")
                }
                cell.thums = detailInfo.thums
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
