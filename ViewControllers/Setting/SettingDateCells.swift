//
//  SettingDateCells.swift
//  disney
//
//  Created by ebuser on 2017/6/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class SettingDateCell: UITableViewCell {

    let container: UIView
    let calendarImageView: UIImageView
    let titleLabel: UILabel
    let dateLabel: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        container = UIView(frame: .zero)
        calendarImageView = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        dateLabel = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

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
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        container.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
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

    }

    private func addSubDateLabel() {

    }
}

class SettingTimeCell: UITableViewCell {

}

class SettingPanelCell: UITableViewCell {

}
