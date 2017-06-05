//
//  Homepage.swift
//  disney
//
//  Created by ebuser on 2017/4/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class HomepageVC: UIViewController, FileLocalizable {

    let localizeFileName = "Homepage"

    let tableView: UITableView
    let cellIdentifier = "cellIdentifier"

    var suggestedPlans = [PlanListElement]() {
        didSet {
            tableView.reloadData()
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        navigationItem.title = localize(for: "Day plans")

        addNavigationItems()

        addSubTableView()

        requestPlanList()

    }

    private func addNavigationItems() {
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newPlanButtonHandler(_:)))
        navigationItem.rightBarButtonItem = rightItem
    }

    private func addSubTableView() {
        tableView.register(HomepageCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(hex: "E1E2E1")
        view.addSubview(tableView)

        // Manage Autolayout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        tableView.layoutIfNeeded()

        // Add delegates
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func requestPlanList() {
        let planListRequest = API.Plans.list

        planListRequest.request { [weak self] data in
            guard let plans: [PlanListElement] = PlanListElement.array(dataResponse: data) else {
                return
            }
            self?.suggestedPlans = plans
        }
    }

    fileprivate func pushToNext(plan: String) {
        let destination = HomepageDetailVC(plan: plan)
        navigationController?.pushViewController(destination, animated: true)
    }

    func newPlanButtonHandler(_ sender: UIBarButtonItem) {
        let destination = CustomPlanViewController()
        navigationController?.pushViewController(destination, animated: true)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomepageVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedPlans.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HomepageCell else {
            fatalError("Unknown cell type")
        }
        cell.data = suggestedPlans[indexPath.row]
        cell.itemSelectedHandler = { [weak self] id in
            if self?.navigationController?.topViewController == self {
                self?.pushToNext(plan: id)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        pushToNext(plan: suggestedPlans[indexPath.row].id)
    }
}
