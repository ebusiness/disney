//
//  AttractionVC.swift
//  disney
//
//  Created by ebuser on 2017/4/25.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

// swiftlint:disable line_length
class AttractionVC: UIViewController {

    fileprivate var tableView: UITableView!
    fileprivate let cellIdentifer = "cellIdentifier"

    var listData = [String: [AttractionListSpot]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLogo()
        addSubTableView()

        requestAttractionList()
    }

    private func setupLogo() {

        let imageView = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        let logo = UIBarButtonItem(customView: imageView)
        navigationItem.leftBarButtonItem = logo

    }

    private func addSubTableView() {
        // Init collection view
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.register(AttractionBriefCell.self, forCellReuseIdentifier: cellIdentifer)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(hex: "E1E2E1")

        view.addSubview(tableView)

        // Manage Autolayout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true

        // Add delegates
        tableView.delegate = self
        tableView.dataSource = self

    }

    private func requestAttractionList() {
        let attractionListRequest = API.Attraction.list

        attractionListRequest.request { [weak self] data in
            guard let list = data.result.value?.array else {
                return
            }
            list.forEach { json in
                guard let spot = AttractionListSpot(json) else {
                    return
                }
                if self?.listData == nil {
                    return
                }
                var area = self!.listData[spot.area]
                if area == nil {
                    area = [spot]
                } else {
                    area!.append(spot)
                }
                self!.listData[spot.area] = area
            }
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AttractionVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return listData.keys.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData[Array(listData.keys)[section]]!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? AttractionBriefCell else {
            fatalError("Unknown cell type")
        }
        let data = listData[Array(listData.keys)[indexPath.section]]![indexPath.row]
        cell.data = data
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSize = CGSize(width: tableView.frame.size.width, height: 30)
        let headerFrame = CGRect(origin: CGPoint.zero, size: headerSize)
        let header = AttractionBriefHeader(frame: headerFrame)

        header.text = Array(listData.keys)[section]

        return header
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
