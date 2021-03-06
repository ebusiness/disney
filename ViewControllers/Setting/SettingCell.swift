//
//  SettingCell.swift
//  disney
//
//  Created by ebuser on 2017/5/16.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SettingCell: UITableViewCell, FileLocalizable {

    let localizeFileName = "Setting"

    private var detailTextDisposable: Disposable?
    private var disposeBag = DisposeBag()

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

                if let visitPark = Preferences.shared.visitPark.value {
                    detailTextLabel?.text = visitPark.localize()
                } else {
                    detailTextLabel?.text = nil
                }
            case .date:
                imageView?.tintColor = DefaultStyle.settingImageTint1
                imageView?.image = #imageLiteral(resourceName: "ic_date_range_black_24px")
                textLabel?.text = localize(for: "setting date")
                guard let detailTextLabel = detailTextLabel else { break }
                detailTextDisposable?.dispose()
                detailTextDisposable = Preferences
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
                    .bind(to: detailTextLabel.rx.text)
                detailTextDisposable?.disposed(by: disposeBag)
            case .timeIn:
                imageView?.tintColor = DefaultStyle.settingImageTint1
                imageView?.image = #imageLiteral(resourceName: "ic_timer_black_24px")
                textLabel?.text = localize(for: "setting time in")
                guard let detailTextLabel = detailTextLabel else { break }
                detailTextDisposable?.dispose()
                detailTextDisposable = Preferences
                    .shared
                    .visitStart
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
                    .bind(to: detailTextLabel.rx.text)
                detailTextDisposable?.disposed(by: disposeBag)
            case .timeOut:
                imageView?.tintColor = DefaultStyle.settingImageTint1
                imageView?.image = #imageLiteral(resourceName: "ic_timer_off_black_24px")
                textLabel?.text = localize(for: "setting time out")
                guard let detailTextLabel = detailTextLabel else { break }
                detailTextDisposable?.dispose()
                detailTextDisposable = Preferences
                    .shared
                    .visitEnd
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
                    .bind(to: detailTextLabel.rx.text)
                detailTextDisposable?.disposed(by: disposeBag)
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
