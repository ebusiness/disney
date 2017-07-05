//
//  SettingDateVC.swift
//  disney
//
//  Created by ebuser on 2017/6/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxSwift
import UIKit

class SettingDateVC: UIViewController, FileLocalizable {

    let localizeFileName = "Setting"

    let disposeBag = DisposeBag()
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
    }

    private func configNavigationItems() {
        title = localize(for: "setting date and time")
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveHandler(_:)))
        navigationItem.rightBarButtonItem = saveButton
    }

    @objc
    private func saveHandler(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    fileprivate func presentDatePicker() {
        guard let visitDate = Preferences.shared.visitStart.value else { return }
        let datepicker = VisitdatePickVC(date: visitDate)
        datepicker
            .subject
            .subscribe { dateEvent in
                guard let date = dateEvent.element else {
                    return
                }
                Preferences.shared.visitStart.value = date
            }
            .disposed(by: disposeBag)
        present(datepicker, animated: false, completion: nil)
    }
}

extension SettingDateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return settingDateCell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else if indexPath.row == 1 {
            return 80
        } else {
            return 400
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            presentDatePicker()
        }
    }
}
