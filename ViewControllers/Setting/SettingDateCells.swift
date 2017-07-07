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
    let date: Variable<Date?> = Variable(Preferences.shared.visitStart.value)

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
        date
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
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        container.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 88).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8).isActive = true
    }
}

class SettingTimeCell: UITableViewCell, FileLocalizable {
    let localizeFileName = "Setting"

    let disposeBag = DisposeBag()
    let inTime: Variable<Date?> = Variable(Preferences.shared.visitStart.value)
    let outTime: Variable<Date?> = Variable(Preferences.shared.visitEnd.value)

    let stackView: UIStackView
    let inContainer: UIView
    let outContainer: UIView
    let inIcon: UIImageView
    let inTextLabel: UILabel
    let inTimeLabel: UILabel
    let outIcon: UIImageView
    let outTextLabel: UILabel
    let outTimeLabel: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        stackView = UIStackView(frame: .zero)
        inContainer = UIView(frame: .zero)
        outContainer = UIView(frame: .zero)
        inIcon = UIImageView(image: #imageLiteral(resourceName: "ic_timer_black_24px"))
        outIcon = UIImageView(image: #imageLiteral(resourceName: "ic_timer_off_black_24px"))
        inTextLabel = UILabel(frame: .zero)
        outTextLabel = UILabel(frame: .zero)
        inTimeLabel = UILabel(frame: .zero)
        outTimeLabel = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = DefaultStyle.viewBackgroundColor
        selectionStyle = .none
        addStackView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        let leftPlaceholder = UIView(frame: .zero)
        let rightPlaceholder = UIView(frame: .zero)
        leftPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        leftPlaceholder.widthAnchor.constraint(equalToConstant: 0).isActive = true
        rightPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        rightPlaceholder.widthAnchor.constraint(equalToConstant: 0).isActive = true

        setupInContainer()
        setupOutContainer()

        stackView.addArrangedSubview(leftPlaceholder)
        stackView.addArrangedSubview(inContainer)
        stackView.addArrangedSubview(outContainer)
        stackView.addArrangedSubview(rightPlaceholder)
    }

    private func setupInContainer() {
        inContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubInIconAndLabels()
    }

    private func addSubInIconAndLabels() {
        inIcon.tintColor = DefaultStyle.darkPrimaryColor
        inTextLabel.textColor = DefaultStyle.darkPrimaryColor
        inTextLabel.text = localize(for: "setting time in")
        inTimeLabel.textColor = DefaultStyle.darkPrimaryColor
        inTime
            .asObservable()
            .map { (date: Date?) -> String? in
                if let date = date {
                    return DateFormatter.localizedString(from: date,
                                                         dateStyle: .none,
                                                         timeStyle: .short)
                } else {
                    return nil
                }
            }
            .bind(to: inTimeLabel.rx.text)
            .disposed(by: disposeBag)
        inContainer.addSubview(inIcon)
        inContainer.addSubview(inTextLabel)
        inContainer.addSubview(inTimeLabel)
        inIcon.translatesAutoresizingMaskIntoConstraints = false
        inTextLabel.translatesAutoresizingMaskIntoConstraints = false
        inTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        inIcon.leftAnchor.constraint(equalTo: inContainer.leftAnchor).isActive = true
        inTextLabel.leftAnchor.constraint(equalTo: inIcon.rightAnchor, constant: 8).isActive = true
        inTextLabel.rightAnchor.constraint(equalTo: inContainer.rightAnchor).isActive = true
        inTimeLabel.centerXAnchor.constraint(equalTo: inContainer.centerXAnchor).isActive = true
        inIcon.topAnchor.constraint(equalTo: inContainer.topAnchor).isActive = true
        inTimeLabel.topAnchor.constraint(equalTo: inIcon.bottomAnchor, constant: 8).isActive = true
        inTimeLabel.bottomAnchor.constraint(equalTo: inContainer.bottomAnchor).isActive = true
        inIcon.centerYAnchor.constraint(equalTo: inTextLabel.centerYAnchor).isActive = true
    }

    private func setupOutContainer() {
        outContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubOutIconAndLabels()
    }

    private func addSubOutIconAndLabels() {
        outIcon.tintColor = DefaultStyle.darkPrimaryColor
        outTextLabel.textColor = DefaultStyle.darkPrimaryColor
        outTextLabel.text = localize(for: "setting time out")
        outTimeLabel.textColor = DefaultStyle.darkPrimaryColor
        outTime
            .asObservable()
            .map { (date: Date?) -> String? in
                if let date = date {
                    return DateFormatter.localizedString(from: date,
                                                         dateStyle: .none,
                                                         timeStyle: .short)
                } else {
                    return nil
                }
            }
            .bind(to: outTimeLabel.rx.text)
            .disposed(by: disposeBag)
        outContainer.addSubview(outIcon)
        outContainer.addSubview(outTextLabel)
        outContainer.addSubview(outTimeLabel)
        outIcon.translatesAutoresizingMaskIntoConstraints = false
        outTextLabel.translatesAutoresizingMaskIntoConstraints = false
        outTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        outIcon.leftAnchor.constraint(equalTo: outContainer.leftAnchor).isActive = true
        outTextLabel.leftAnchor.constraint(equalTo: outIcon.rightAnchor, constant: 8).isActive = true
        outTextLabel.rightAnchor.constraint(equalTo: outContainer.rightAnchor).isActive = true
        outTimeLabel.centerXAnchor.constraint(equalTo: outContainer.centerXAnchor).isActive = true
        outIcon.topAnchor.constraint(equalTo: outContainer.topAnchor).isActive = true
        outTimeLabel.topAnchor.constraint(equalTo: outIcon.bottomAnchor, constant: 8).isActive = true
        outTimeLabel.bottomAnchor.constraint(equalTo: outContainer.bottomAnchor).isActive = true
        outIcon.centerYAnchor.constraint(equalTo: outTextLabel.centerYAnchor).isActive = true
    }
}

class SettingPanelCell: UITableViewCell {

    let panel: SettingTimePanel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        panel = SettingTimePanel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = DefaultStyle.viewBackgroundColor
        addSubPanel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubPanel() {
        contentView.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        panel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        panel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
