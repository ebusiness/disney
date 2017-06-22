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
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
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
            return 3
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if let _cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = _cell
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.imageView?.image = #imageLiteral(resourceName: "AttractionDetailCapcity")
            cell.textLabel?.text = "text"
            cell.detailTextLabel?.text = "detail text"
        }

        switch indexPath.section {
        case 0:
            cell.imageView?.tintColor = DefaultStyle.settingImageTint0
        case 1:
            cell.imageView?.tintColor = DefaultStyle.settingImageTint1
        case 2:
            cell.imageView?.tintColor = DefaultStyle.settingImageTint2
        default:
            break
        }

        return cell
    }
}
