//
//  CustomPlanAttractionsOfTagVC.swift
//  disney
//
//  Created by ebuser on 2017/5/29.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class CustomPlanAttractionsOfTagVC: UIViewController {

    let tag: PlanCategoryAttractionTag
    var tagDetail: PlanCategoryAttractionTagDetail?

    let tableView: UITableView
    let identifier = "identifier"

    init(tag: PlanCategoryAttractionTag) {
        self.tag = tag
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubTableView()

        requestAttractionList()
    }

    private func addSubTableView() {
        tableView.register(CustomPlanAttractionsOfTagCell.self, forCellReuseIdentifier: identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func requestAttractionList() {
        let requester = API.AttractionTags.detail(id: tag.id)

        requester.request { [weak self] data in
            if let retrieved = PlanCategoryAttractionTagDetail(data) {
                self?.tagDetail = retrieved
                self?.tableView.reloadData()
            }
        }
    }
}

extension CustomPlanAttractionsOfTagVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagDetail?.attractions.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CustomPlanAttractionsOfTagCell else {
            fatalError("Unknown cell type")
        }
        cell.data = tagDetail?.attractions[indexPath.row]
        return cell
    }
}
