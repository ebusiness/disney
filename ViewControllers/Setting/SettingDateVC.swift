//
//  SettingDateVC.swift
//  disney
//
//  Created by ebuser on 2017/6/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class SettingDateVC: UIViewController, FileLocalizable {

    let localizeFileName = "Setting"

    let tableView: UITableView
    let settingDateCell: SettingDateCell

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .plain)
        settingDateCell = SettingDateCell(style: .default, reuseIdentifier: nil)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        hidesBottomBarWhenPushed = true
        view.backgroundColor = DefaultStyle.viewBackgroundColor

        addSubTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationItems()
    }

    private func addSubTableView() {
        tableView.backgroundColor = DefaultStyle.viewBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
    }

    private func configNavigationItems() {
        title = localize(for: "setting tags")
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveHandler(_:)))
        navigationItem.rightBarButtonItem = saveButton
    }

    @objc
    private func saveHandler(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

}

extension SettingDateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return settingDateCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
