//
//  HomepageDetailCells.swift
//  disney
//
//  Created by ebuser on 2017/5/16.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Kingfisher
import UIKit

// swiftlint:disable line_length
class HomepageDetailCellTop: HomepageDetailCellBase {
    override var data: PlanDetail.Route? {
        didSet {
            super.data = data
            if let data = data {
                // 行走时间段落
                if let startTimeWalk = data.timeWalkStart?.format(pattern: "H:mm"),
                    let endTimeWalk = data.timeWalkEnd?.format(pattern: "H:mm") {
                    toNextDurationLabel.text = startTimeWalk + " ~ " + endTimeWalk
                }

                // 行走花费时间
                toNextDescriptionLabel.text = localize(for: "Walk cost time:") + " \(data.timeToNext)" + localize(for: "minute(s)")
            }
        }
    }

    fileprivate let bottomConnector: UIImageView
    fileprivate let toNextDurationLabel: UILabel
    fileprivate let toNextDescriptionLabel: UILabel
    fileprivate let promptImageView: UIImageView

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        toNextDurationLabel = UILabel(frame: .zero)
        toNextDescriptionLabel = UILabel(frame: .zero)
        bottomConnector = UIImageView(frame: .zero)
        promptImageView = UIImageView(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubBottomConnector()
        addSubToNextDurationLabel()
        addSubToNextDescriptionLabel()
        addSubPromptImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func addSubBottomConnector() {
        bottomConnector.image = #imageLiteral(resourceName: "JoinerLong")
        addSubview(bottomConnector)
        bottomConnector.translatesAutoresizingMaskIntoConstraints = false
        bottomConnector.leftAnchor.constraint(equalTo: sideColorView.rightAnchor, constant: 24).isActive = true
        bottomConnector.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -12).isActive = true
        let lowPriorityConstraint = bottomConnector.bottomAnchor.constraint(equalTo: bottomAnchor)
        lowPriorityConstraint.priority = 999
        lowPriorityConstraint.isActive = true
        bottomConnector.layoutIfNeeded()
    }

    fileprivate func addSubToNextDurationLabel() {
        toNextDurationLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(toNextDurationLabel)
        toNextDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        toNextDurationLabel.leftAnchor.constraint(equalTo: bottomConnector.rightAnchor, constant: 12).isActive = true
        toNextDurationLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 12).isActive = true
    }
    fileprivate func addSubToNextDescriptionLabel() {
        toNextDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        toNextDescriptionLabel.textColor = #colorLiteral(red: 0.4756369591, green: 0.4756369591, blue: 0.4756369591, alpha: 1)
        addSubview(toNextDescriptionLabel)
        toNextDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        toNextDescriptionLabel.leftAnchor.constraint(equalTo: toNextDurationLabel.leftAnchor).isActive = true
        toNextDescriptionLabel.topAnchor.constraint(equalTo: toNextDurationLabel.bottomAnchor, constant: 12).isActive = true
    }

    fileprivate func addSubPromptImageView() {
        promptImageView.tintColor = UIColor(hex: "2196F3")
        promptImageView.image = #imageLiteral(resourceName: "directions_walk")
        addSubview(promptImageView)
        promptImageView.translatesAutoresizingMaskIntoConstraints = false
        promptImageView.rightAnchor.constraint(equalTo: bottomConnector.leftAnchor).isActive = true
        promptImageView.centerYAnchor.constraint(equalTo: bottomConnector.centerYAnchor, constant: 8).isActive = true
    }

}

class HomepageDetailCellMid: HomepageDetailCellBase {
    override var data: PlanDetail.Route? {
        didSet {
            super.data = data
            if let data = data {
                // 行走时间段落
                if let startTimeWalk = data.timeWalkStart?.format(pattern: "H:mm"),
                    let endTimeWalk = data.timeWalkEnd?.format(pattern: "H:mm") {
                    toNextDurationLabel.text = startTimeWalk + " ~ " + endTimeWalk
                }

                // 行走花费时间
                toNextDescriptionLabel.text = localize(for: "Walk cost time:") + " \(data.timeToNext)" + localize(for: "minute(s)")
            }
        }
    }

    fileprivate let bottomConnector: UIImageView
    fileprivate let toNextDurationLabel: UILabel
    fileprivate let toNextDescriptionLabel: UILabel
    fileprivate let topConnector: UIImageView
    fileprivate let promptImageView: UIImageView

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        toNextDurationLabel = UILabel(frame: .zero)
        toNextDescriptionLabel = UILabel(frame: .zero)
        topConnector = UIImageView(frame: .zero)
        bottomConnector = UIImageView(frame: .zero)
        promptImageView = UIImageView(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubBottomConnector()
        addSubToNextDurationLabel()
        addSubToNextDescriptionLabel()
        addSubTopConnector()
        addSubPromptImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func addSubBottomConnector() {
        bottomConnector.image = #imageLiteral(resourceName: "JoinerLong")
        addSubview(bottomConnector)
        bottomConnector.translatesAutoresizingMaskIntoConstraints = false
        bottomConnector.leftAnchor.constraint(equalTo: sideColorView.rightAnchor, constant: 24).isActive = true
        bottomConnector.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -12).isActive = true
        let lowPriorityConstraint = bottomConnector.bottomAnchor.constraint(equalTo: bottomAnchor)
        lowPriorityConstraint.priority = 999
        lowPriorityConstraint.isActive = true
        bottomConnector.layoutIfNeeded()
    }

    fileprivate func addSubToNextDurationLabel() {
        toNextDurationLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(toNextDurationLabel)
        toNextDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        toNextDurationLabel.leftAnchor.constraint(equalTo: bottomConnector.rightAnchor, constant: 12).isActive = true
        toNextDurationLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 12).isActive = true
    }
    fileprivate func addSubToNextDescriptionLabel() {
        toNextDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        toNextDescriptionLabel.textColor = #colorLiteral(red: 0.4756369591, green: 0.4756369591, blue: 0.4756369591, alpha: 1)
        addSubview(toNextDescriptionLabel)
        toNextDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        toNextDescriptionLabel.leftAnchor.constraint(equalTo: toNextDurationLabel.leftAnchor).isActive = true
        toNextDescriptionLabel.topAnchor.constraint(equalTo: toNextDurationLabel.bottomAnchor, constant: 12).isActive = true
    }

    fileprivate func addSubTopConnector() {
        topConnector.image = #imageLiteral(resourceName: "JoinerShort")
        addSubview(topConnector)
        topConnector.translatesAutoresizingMaskIntoConstraints = false
        topConnector.leftAnchor.constraint(equalTo: sideColorView.rightAnchor, constant: 24).isActive = true
        topConnector.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topConnector.layoutIfNeeded()
    }

    fileprivate func addSubPromptImageView() {
        promptImageView.tintColor = UIColor(hex: "2196F3")
        promptImageView.image = #imageLiteral(resourceName: "directions_walk")
        addSubview(promptImageView)
        promptImageView.translatesAutoresizingMaskIntoConstraints = false
        promptImageView.rightAnchor.constraint(equalTo: bottomConnector.leftAnchor).isActive = true
        promptImageView.centerYAnchor.constraint(equalTo: bottomConnector.centerYAnchor, constant: 8).isActive = true
    }
}

class HomepageDetailCellBottom: HomepageDetailCellBase {
    fileprivate let topConnector: UIImageView

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        topConnector = UIImageView(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubTopConnector()
        addBottomConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func addSubTopConnector() {
        topConnector.image = #imageLiteral(resourceName: "JoinerShort")
        addSubview(topConnector)
        topConnector.translatesAutoresizingMaskIntoConstraints = false
        topConnector.leftAnchor.constraint(equalTo: sideColorView.rightAnchor, constant: 24).isActive = true
        topConnector.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topConnector.layoutIfNeeded()
    }
    fileprivate func addBottomConstraint() {
        let lowPriorityConstraint = mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        lowPriorityConstraint.priority = 999
        lowPriorityConstraint.isActive = true
    }
}

class HomepageDetailCellBase: UITableViewCell, FileLocalizable {

    var data: PlanDetail.Route? {
        didSet {
            if let data = data {
                // 图片
                mainImageView.kf.setImage(with: URL(string: data.images[0]))

                // 项目标题
                if let htmlStringData = data.name.data(using: .unicode) {
                    if let attributedName = try? NSMutableAttributedString(data: htmlStringData,
                                                                           options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                                           documentAttributes: nil) {
                        attributedName.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
                                                      NSForegroundColorAttributeName: UIColor.white],
                                                     range: NSRange(location: 0, length: attributedName.string.characters.count))
                        titleLabel.attributedText = attributedName
                    }
                }

                // 项目时间段
                if let startText = data.timeStart?.format(pattern: "H:mm"),
                    let endText = data.timeEnd?.format(pattern: "H:mm") {
                    durationLabel.text = startText + " ~ " + endText
                }

                // 排队时间
                queueLabel.text = localize(for: "Predicted queue time:")  + " " + "\(data.waitTime)" + localize(for: "minute(s)")

                // 花费时间
                costLabel.text = localize(for: "Predicted cost time:")  + " " + "\(data.timeCost)" + localize(for: "minute(s)")
            }
        }
    }

    let localizeFileName = "Homepage"

    fileprivate let mainImageView: MaskedImageView
    fileprivate let sideColorView: UIView
    fileprivate let titleLabel: UILabel
    fileprivate let durationLabel: UILabel
    fileprivate let queueLabel: UILabel
    fileprivate let costLabel: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        mainImageView = MaskedImageView(frame: .zero)
        sideColorView = UIView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        durationLabel = UILabel(frame: .zero)
        queueLabel = UILabel(frame: .zero)
        costLabel = UILabel(frame: .zero)

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        addSubMainImageView()
        addSubSideColorView()
        addSubTitleLabel()
        addSubDurationLabel()
        addSubQueueLabel()
        addSubCostLabel()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func addSubMainImageView() {
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        addSubview(mainImageView)
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        mainImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    fileprivate func addSubSideColorView() {
        sideColorView.backgroundColor = UIColor(hex: "2196F3")
        addSubview(sideColorView)
        sideColorView.translatesAutoresizingMaskIntoConstraints = false
        sideColorView.topAnchor.constraint(equalTo: mainImageView.topAnchor).isActive = true
        sideColorView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
        sideColorView.leftAnchor.constraint(equalTo: mainImageView.leftAnchor).isActive = true
        sideColorView.widthAnchor.constraint(equalToConstant: 8).isActive = true
    }
    fileprivate func addSubTitleLabel() {
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: sideColorView.rightAnchor, constant: 12).isActive = true
    }
    fileprivate func addSubDurationLabel() {
        durationLabel.textColor = UIColor.white
        durationLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(durationLabel)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        durationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
    }
    fileprivate func addSubQueueLabel() {
        queueLabel.textColor = UIColor.white
        queueLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(queueLabel)
        queueLabel.translatesAutoresizingMaskIntoConstraints = false
        queueLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        queueLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 8).isActive = true
    }
    fileprivate func addSubCostLabel() {
        costLabel.textColor = UIColor.white
        costLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(costLabel)
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        costLabel.topAnchor.constraint(equalTo: queueLabel.bottomAnchor, constant: 8).isActive = true
        costLabel.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -12).isActive = true
    }

}
