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
    let settingTimeCell: SettingTimeCell
    let settingPanelCell: SettingPanelCell

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .plain)
        settingDateCell = SettingDateCell(style: .default, reuseIdentifier: nil)
        settingTimeCell = SettingTimeCell(style: .default, reuseIdentifier: nil)
        settingPanelCell = SettingPanelCell(style: .default, reuseIdentifier: nil)
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
        // 保存日期
        if Preferences.shared.visitStart.value != settingDateCell.date.value {
            Preferences.shared.visitStart.value = settingDateCell.date.value
        }
        navigationController?.popViewController(animated: true)
    }

    fileprivate func presentDatePicker() {
        guard let visitDate = settingDateCell.date.value else { return }
        let datepicker = VisitdatePickVC(date: visitDate)
        datepicker
            .subject
            .subscribe { [weak self] dateEvent in
                switch dateEvent {
                case .completed:
                    // 更新园区营业时间
                    self?.requestOpenTimeAndUpdatePanel()
                case .next(let date):
                    // 更新cell显示
                    self?.settingDateCell.date.value = date
                case .error:
                    break
                }
            }
            .disposed(by: disposeBag)
        present(datepicker, animated: false, completion: nil)
    }

    fileprivate func requestOpenTimeAndUpdatePanel() {
        guard let dateTime = settingDateCell.date.value else { return }
        let openTimeRequest = API.Schedule.openTime(date: dateTime)
        openTimeRequest.request { [weak self] data in
            guard let openTime = OpenTime(data) else { return }
            let openHour = openTime.open.hour
            let openMinute = openTime.open.minute
            let closeHour = openTime.close.hour
            let closeMinute = openTime.close.minute
            let open = Float(openHour) + Float(openMinute) / 60
            let close = Float(closeHour) + Float(closeMinute) / 60

            self?.settingPanelCell.panel.openCloseTime.value = (open, close)
        }
    }
}

extension SettingDateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return settingDateCell
        } else if indexPath.row == 1 {
            return settingTimeCell
        } else {
            return settingPanelCell
        }
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
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            presentDatePicker()
        }
    }
}
