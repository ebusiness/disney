//
//  SettingCell.swift
//  disney
//
//  Created by ebuser on 2017/5/16.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell, FileLocalizable {

    let localizeFileName = "Setting"

    var category: Category? {
        didSet {
            guard let category = category else { return }
            switch category {
            case .tag:
                imageView?.tintColor = DefaultStyle.settingImageTint0
                imageView?.image = #imageLiteral(resourceName: "ic_class_black_24px")
                textLabel?.text = localize(for: "setting tags")
                detailTextLabel?.text = nil

            case .park:
                imageView?.tintColor = DefaultStyle.settingImageTint1
                imageView?.image = #imageLiteral(resourceName: "ic_flag_black_24px")
                textLabel?.text = localize(for: "setting park")
                detailTextLabel?.text = "detail"
            case .date:
                imageView?.tintColor = DefaultStyle.settingImageTint1
                imageView?.image = #imageLiteral(resourceName: "ic_date_range_black_24px")
                textLabel?.text = localize(for: "setting date")
                detailTextLabel?.text = "detail"
            case .timeIn:
                imageView?.tintColor = DefaultStyle.settingImageTint1
                imageView?.image = #imageLiteral(resourceName: "ic_timer_black_24px")
                textLabel?.text = localize(for: "setting time in")
                detailTextLabel?.text = "detail"
            case .timeOut:
                imageView?.tintColor = DefaultStyle.settingImageTint1
                imageView?.image = #imageLiteral(resourceName: "ic_timer_off_black_24px")
                textLabel?.text = localize(for: "setting time out")
                detailTextLabel?.text = "detail"

            case .feedback:
                imageView?.tintColor = DefaultStyle.settingImageTint2
                imageView?.image = #imageLiteral(resourceName: "ic_feedback_black_24px")
                textLabel?.text = localize(for: "setting feedback")
                detailTextLabel?.text = nil
            case .aboutUs:
                imageView?.tintColor = DefaultStyle.settingImageTint2
                imageView?.image = #imageLiteral(resourceName: "ic_supervisor_account_black_24px")
                textLabel?.text = localize(for: "setting about us")
                detailTextLabel?.text = nil
            case .privacyPolicy:
                imageView?.tintColor = DefaultStyle.settingImageTint2
                imageView?.image = #imageLiteral(resourceName: "ic_security_black_24px")
                textLabel?.text = localize(for: "setting privacy policy")
                detailTextLabel?.text = nil
            case .termsOfService:
                imageView?.tintColor = DefaultStyle.settingImageTint2
                imageView?.image = #imageLiteral(resourceName: "ic_extension_black_24px")
                textLabel?.text = localize(for: "setting terms of service")
                detailTextLabel?.text = nil
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        accessoryType = .disclosureIndicator
        textLabel?.text = "text"
        detailTextLabel?.text = "detail text"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    enum Category {
        case tag
        case park
        case date
        case timeIn
        case timeOut
        case feedback
        case aboutUs
        case privacyPolicy
        case termsOfService
    }
}
