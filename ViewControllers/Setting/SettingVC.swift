//
//  SettingVC.swift
//  disney
//
//  Created by ebuser on 2017/4/25.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    private var tableView: UITableView
    private let cellIdentifier = "cellIdentifier"

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .grouped)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        addSubTableView()
    }

    private func addSubTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = DefaultStyle.viewBackgroundColor
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 4
        default:
            return 0
        }
    }

    //swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SettingCell!
        if let _cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SettingCell {
            cell = _cell
        } else {
            cell = SettingCell(style: .value1, reuseIdentifier: cellIdentifier)
        }

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.category = .tag
        case (1, 0):
            cell.category = .park
        case (1, 1):
            cell.category = .date
        case (1, 2):
            cell.category = .timeIn
        case (1, 3):
            cell.category = .timeOut
        case (2, 0):
            cell.category = .feedback
        case (2, 1):
            cell.category = .aboutUs
        case (2, 2):
            cell.category = .privacyPolicy
        case (2, 3):
            cell.category = .termsOfService
        default:
            break
        }

        return cell
    }
}
