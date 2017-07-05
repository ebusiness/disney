//
//  SettingDateCells.swift
//  disney
//
//  Created by ebuser on 2017/6/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SettingDateCell: UITableViewCell, FileLocalizable {

    let localizeFileName = "Setting"

    let container: UIView
    let calendarImageView: UIImageView
    let titleLabel: UILabel
    let dateLabel: UILabel

    let disposeBag = DisposeBag()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        container = UIView(frame: .zero)
        calendarImageView = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        dateLabel = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = DefaultStyle.viewBackgroundColor
        selectionStyle = .none

        addSubContainer()
        addSubCalendarImageView()
        addSubTitleLabel()
        addSubDateLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubContainer() {
        container.backgroundColor = DefaultStyle.primaryColor
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        container.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
        container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6).isActive = true
        let containerHeightConstraint = container.heightAnchor.constraint(equalToConstant: 80)
        containerHeightConstraint.priority = UILayoutPriority(rawValue: 999)
        containerHeightConstraint.isActive = true
    }

    private func addSubCalendarImageView() {
        calendarImageView.tintColor = UIColor.white
        calendarImageView.contentMode = .center
        calendarImageView.backgroundColor = DefaultStyle.settingCalendarMarkBackground
        calendarImageView.image = #imageLiteral(resourceName: "EssentialInfoDate")
        container.addSubview(calendarImageView)
        calendarImageView.translatesAutoresizingMaskIntoConstraints = false
        calendarImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        calendarImageView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        calendarImageView.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        calendarImageView.widthAnchor.constraint(equalTo: calendarImageView.heightAnchor).isActive = true
    }

    private func addSubTitleLabel() {
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.text = localize(for: "chooseDate")
        container.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 88).isActive = true
        titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
    }

    private func addSubDateLabel() {
        dateLabel.textColor = UIColor.white
        dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        Preferences
            .shared
            .visitStart
            .asObservable()
            .map { (date: Date?) -> String? in
                if let date = date {
                    return DateFormatter.localizedString(from: date,
                                                         dateStyle: .medium,
                                                         timeStyle: .none)
                } else {
                    return nil
                }
            }
            .asObservable()
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        container.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 88).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8).isActive = true
    }
}

class SettingTimeCell: UITableViewCell {

}

class SettingPanelCell: UITableViewCell {

}
