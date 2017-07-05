//
//  SettingFastpass.swift
//  disney
//
//  Created by ebuser on 2017/7/4.
//  Copyright © 2017年 e-business. All rights reserved.
//

import CoreData
import RxCocoa
import RxSwift
import UIKit

class SettingFastpass: UIViewController, FileLocalizable {

    let localizeFileName = "Setting"

    fileprivate let route: SpecifiedPlanRoute
    fileprivate let disposeBag = DisposeBag()

    fileprivate let tableView: UITableView
    fileprivate let beginCell: UITableViewCell
    fileprivate let endCell: UITableViewCell
    fileprivate let beginPickerCell: UITableViewCell
    fileprivate let endPickerCell: UITableViewCell
    fileprivate let beginDatePicker: UIDatePicker
    fileprivate let endDatePicker: UIDatePicker

    fileprivate var begin: Variable<Date?> = Variable(nil)
    fileprivate var end: Variable<Date?> = Variable(nil)

    fileprivate var state = State.allCollapsed

    init(route: SpecifiedPlanRoute) {
        self.route = route
        tableView = UITableView(frame: .zero, style: .grouped)
        beginCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        endCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        beginPickerCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        endPickerCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        beginDatePicker = UIDatePicker(frame: .zero)
        endDatePicker = UIDatePicker(frame: .zero)
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = DefaultStyle.viewBackgroundColor

        setupNavigationBar()
        addSubTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNavigationBar() {
        title = localize(for: "Fastpass settings")

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(cancelHandler(_:)))
        navigationItem.leftBarButtonItem = cancelButton

        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveHandler(_:)))
        navigationItem.rightBarButtonItem = saveButton
    }

    private func addSubTableView() {
        configBeginCell()
        configEndCell()
        configDatePickerCells()
        addDatePickerListeners()

        tableView.backgroundColor = DefaultStyle.viewBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addAllConstraints(equalTo: view)
    }

    private func configBeginCell() {
        beginCell.accessoryType = .disclosureIndicator
        beginCell.imageView?.tintColor = DefaultStyle.settingImageTint1
        beginCell.imageView?.image = #imageLiteral(resourceName: "ic_timer_black_24px")
        beginCell.textLabel?.text = localize(for: "setting fastpass begin")
        beginCell.selectionStyle = .none
        beginCell.detailTextLabel?.text = localize(for: "setting fastpass none")
    }

    private func configEndCell() {
        endCell.accessoryType = .disclosureIndicator
        endCell.imageView?.tintColor = DefaultStyle.settingImageTint1
        endCell.imageView?.image = #imageLiteral(resourceName: "ic_timer_off_black_24px")
        endCell.textLabel?.text = localize(for: "setting fastpass end")
        endCell.selectionStyle = .none
        endCell.detailTextLabel?.text = localize(for: "setting fastpass none")
    }

    private func configDatePickerCells() {
        beginDatePicker.datePickerMode = .time
        beginPickerCell.addSubview(beginDatePicker)
        beginDatePicker.addAllConstraints(equalTo: beginPickerCell)

        endDatePicker.datePickerMode = .time
        endPickerCell.addSubview(endDatePicker)
        endDatePicker.addAllConstraints(equalTo: endPickerCell)

        if let fastpass = route.fastpass,
            let oldBegin = fastpass.begin,
            let oldEnd = fastpass.end {
            beginDatePicker.date = oldBegin
            endDatePicker.date = oldEnd
        } else if let visitStart = Preferences.shared.visitStart.value {
            beginDatePicker.date = visitStart
            endDatePicker.date = visitStart
        }
    }

    private func addDatePickerListeners() {
        beginDatePicker
            .rx
            .date
            .bind(to: begin)
            .disposed(by: disposeBag)
        begin
            .asObservable()
            .subscribe({ event in
                if let element = event.element,
                    let date = element {
                    self.beginCell.detailTextLabel?.text = date.format(pattern: "H:mm")
                }
            })
            .disposed(by: disposeBag)

        endDatePicker
            .rx
            .date
            .bind(to: end)
            .disposed(by: disposeBag)
        end
            .asObservable()
            .subscribe({ event in
                if let element = event.element,
                    let date = element {
                    self.endCell.detailTextLabel?.text = date.format(pattern: "H:mm")
                }
            })
            .disposed(by: disposeBag)
    }

    @objc
    private func saveHandler(_ sender: UIBarButtonItem) {
        guard let beginTime = begin.value else { return }
        guard let endTime = end.value else { return }
        guard beginTime <= endTime else { return }
        // 重新获取计划时间表并更新数据库
        SpecifyPlanManager
            .shared
            .updateFastpass(route: route,
                            begin: beginTime,
                            end: endTime,
                            completionHandler: {
                                self.dismiss(animated: true)
            })

    }

    @objc
    private func cancelHandler(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    enum State {
        case allCollapsed
        case beginExpanded
        case endExpanded
    }
}

extension SettingFastpass: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .allCollapsed:
            return 2
        case .beginExpanded:
            return 3
        case .endExpanded:
            return 3
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .allCollapsed:
            if indexPath.row == 0 {
                return beginCell
            } else {
                return endCell
            }
        case .beginExpanded:
            if indexPath.row == 0 {
                return beginCell
            } else if indexPath.row == 1 {
                return beginPickerCell
            } else {
                return endCell
            }
        case .endExpanded:
            if indexPath.row == 0 {
                return beginCell
            } else if indexPath.row == 1 {
                return endCell
            } else {
                return endPickerCell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.beginUpdates()
        if cell == beginCell {
            switch state {
            case .allCollapsed:
                state = .beginExpanded
                tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
            case .beginExpanded:
                state = .allCollapsed
                tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
            case .endExpanded:
                state = .beginExpanded
                tableView.deleteRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
                tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
            }
        } else if cell == endCell {
            switch state {
            case .allCollapsed:
                state = .endExpanded
                tableView.insertRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
            case .beginExpanded:
                state = .endExpanded
                tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                tableView.insertRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
            case .endExpanded:
                state = .allCollapsed
                tableView.deleteRows(at: [IndexPath(row: 2, section: 0)], with: .fade)

            }
        }
        tableView.endUpdates()
    }
}
