//
//  SettingVC.swift
//  disney
//
//  Created by ebuser on 2017/4/25.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class SettingVC: UIViewController, FileLocalizable {

    let localizeFileName = "Setting"

    private var tableView: UITableView
    private let cellIdentifier = "cellIdentifier"

    let cells = [
        [SettingCell.Category.tag],
        [SettingCell.Category.park, SettingCell.Category.date, SettingCell.Category.timeIn, SettingCell.Category.timeOut],
        [SettingCell.Category.feedback, SettingCell.Category.aboutUs, SettingCell.Category.privacyPolicy, SettingCell.Category.termsOfService]
    ]

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

        addNavigationItems()
        addSubTableView()
    }

    private func addNavigationItems() {
        navigationItem.title = localize(for: "Settings")
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

    fileprivate func pushToSettingTagVC() {
        let destination = SettingTagVC()
        navigationController?.pushViewController(destination, animated: true)
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SettingCell!
        if let _cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SettingCell {
            cell = _cell
        } else {
            cell = SettingCell(style: .value1, reuseIdentifier: cellIdentifier)
        }

        cell.category = cells[indexPath.section][indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            pushToSettingTagVC()
        default:
            break
        }
    }
}
