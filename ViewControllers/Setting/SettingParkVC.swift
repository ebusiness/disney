//
//  SettingParkVC.swift
//  disney
//
//  Created by ebuser on 2017/6/23.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class SettingParkVC: UIViewController, FileLocalizable {

    let localizeFileName = "Setting"

    let tableView: UITableView
    let identifier = "identifier"

    fileprivate let data = [TokyoDisneyPark.land,
                            TokyoDisneyPark.sea]
    fileprivate var selectedIndex: Int?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .grouped)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        view.backgroundColor = DefaultStyle.viewBackgroundColor
        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configNavigationItems()
        addSubTableView()
        loadSelectedPark()
    }

    private func configNavigationItems() {
        title = localize(for: "setting park")
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveHandler(_:)))
        navigationItem.rightBarButtonItem = saveButton
    }

    private func addSubTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.backgroundColor = DefaultStyle.viewBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.tintColor = DefaultStyle.settingCheckMark
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func loadSelectedPark() {
        guard let park = Preferences.shared.visitPark.value else { return }
        guard let index = data.index(of: park) else { return }
        selectedIndex = index
        tableView.reloadData()
    }

    @objc
    private func saveHandler(_ sender: UIBarButtonItem) {
        if let index = selectedIndex {
            Preferences.shared.visitPark.value = data[index]
        }
        navigationController?.popViewController(animated: true)
    }
}

extension SettingParkVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.selectionStyle = .none
        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = data[indexPath.row].localize()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}
