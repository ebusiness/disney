//
//  AttractionVC.swift
//  disney
//
//  Created by ebuser on 2017/4/25.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class AttractionVC: UIViewController, FileLocalizable {

    let localizeFileName = "Attraction"

    fileprivate var tableView: UITableView!
    fileprivate let cellIdentifer = "cellIdentifier"

    var listData = [String: [AttractionListSpot]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLogo()
        addSubTableView()

        addRefreshTimer()

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
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true

        // Add delegates
        tableView.delegate = self
        tableView.dataSource = self

    }

    private func addRefreshTimer() {
        Timer.scheduledTimer(timeInterval: 1 * 4,
                             target: self,
                             selector: #selector(handleRefreshTimer(_:)),
                             userInfo: nil,
                             repeats: true)
    }

    fileprivate func requestAttractionList(completionHandler: ((Bool) -> Void)? = nil) {
        let attractionListRequest = API.Attractions.list

        attractionListRequest.request { [weak self] data in
            guard let list = data.result.value?.array else {
                completionHandler?(false)
                return
            }
            self?.listData = [String: [AttractionListSpot]]()
            list.forEach { json in
                guard let spot = AttractionListSpot(json) else {
                    completionHandler?(false)
                    return
                }
                if let strongSelf = self {
                    var area = strongSelf.listData[spot.area]
                    if area == nil {
                        area = [spot]
                    } else {
                        area!.append(spot)
                    }
                    strongSelf.listData[spot.area] = area
                } else {
                    completionHandler?(false)
                    return
                }
            }
            self?.tableView.reloadData()
            completionHandler?(true)
        }
    }

    fileprivate func pushToDetail(spot: AttractionListSpot) {
        let parameter = AttractionDetailVC.PreviousPage.attractionList(data: spot)
        let destination = AttractionDetailVC(parameter)
        navigationController?.pushViewController(destination, animated: true)
    }

    @objc
    func handleRefreshTimer(_ timer: Timer) {
        requestAttractionList()
        let now = Date()
        print("\(now): timer fired!")
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
        let data = listData[Array(listData.keys)[indexPath.section]]![indexPath.row]
        pushToDetail(spot: data)
    }
}
