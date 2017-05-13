//
//  AttractionBriefCell.swift
//  disney
//
//  Created by ebuser on 2017/4/28.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Kingfisher
import UIKit

// swiftlint:disable line_length
class AttractionBriefCell: UITableViewCell, FileLocalizable {

    let localizeFileName = "Attraction"

    var data: AttractionListSpot? {
        didSet {
            if let data = data {

                // 清空所有文字
                resetText()

                // 景点图片
                let url = URL(string: data.thum)
                mainImageView.kf.setImage(with: url)

                // 景点名称
                if let htmlStringData = data.name.data(using: .unicode) {
                    if let attributedName = try? NSMutableAttributedString(data: htmlStringData,
                                                                           options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                                           documentAttributes: nil) {
                        attributedName.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
                                                      NSForegroundColorAttributeName: Color.white],
                                                     range: NSRange(location: 0, length: attributedName.string.characters.count))
                        title.attributedText = attributedName
                    }
                }

                // 景点分类（游乐设施，明星照相，游行演出）
                switch data.category {
                case .attraction:
                    categoryImageView.image = #imageLiteral(resourceName: "ListAttraction")
                    categoryImageView.backgroundColor = UIColor(hex: "2196F3")
                case .greeting:
                    categoryImageView.image = #imageLiteral(resourceName: "ListGreeting")
                    categoryImageView.backgroundColor = UIColor(hex: "673AB7")
                case .show:
                    categoryImageView.image = #imageLiteral(resourceName: "ListParade")
                    categoryImageView.backgroundColor = UIColor(hex: "F44336")
                }

                // 景点事实信息
                if let realtime = data.realtime {
                    let fullText = NSMutableAttributedString()

                    // 等待时间
                    if realtime.available,
                        let waitTime = realtime.waitTime {
                        let waitTimePrompt = NSAttributedString(string: localize(for: "waitTime") + ":",
                                                                attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15),
                                                                             NSForegroundColorAttributeName: #colorLiteral(red: 0.4717842937, green: 0.4717842937, blue: 0.4717842937, alpha: 1)])
                        let waitTimeColor = WaitTimeColor(waitTime: waitTime)
                        let waitTimeText = NSAttributedString(string: " \(waitTime)",
                            attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 35),
                                         NSForegroundColorAttributeName: waitTimeColor.value])
                        let waitTimeUnit = NSAttributedString(string: localize(for: "waitTimeUnit"),
                                                              attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15),
                                                                           NSForegroundColorAttributeName: waitTimeColor.value])

                        fullText.append(waitTimePrompt)
                        fullText.append(waitTimeText)
                        fullText.append(waitTimeUnit)
                    }

                    // 运营状态
                    if realtime.available,
                        let startTime = realtime.operationStart,
                        let endTime = realtime.operationEnd {
                        let statusText = NSAttributedString(string: realtime.statusInfo,
                                                                   attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15),
                                                                                NSForegroundColorAttributeName: #colorLiteral(red: 0.4757834077, green: 0.4757834077, blue: 0.4757834077, alpha: 1)])
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm"
                        let startText = formatter.string(from: startTime)
                        let endText = formatter.string(from: endTime)
                        let periodText = NSAttributedString(string: ": \(startText) - \(endText)",
                            attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15),
                                         NSForegroundColorAttributeName: #colorLiteral(red: 0.4757834077, green: 0.4757834077, blue: 0.4757834077, alpha: 1)])

                        fullText.appendLineBreakIfNotEmpty()
                        fullText.append(statusText)
                        fullText.append(periodText)
                    } else {
                        let statusText = NSAttributedString(string: realtime.statusInfo,
                                                                   attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15),
                                                                                NSForegroundColorAttributeName: #colorLiteral(red: 0.4757834077, green: 0.4757834077, blue: 0.4757834077, alpha: 1)])
                        fullText.appendLineBreakIfNotEmpty()
                        fullText.append(statusText)
                    }

                    // 快速通道
                    if realtime.available, realtime.fastpassAvailable,
                        let fastpassInfo = realtime.fastpassInfo {
                        let icon = NSTextAttachment()
                        icon.image = #imageLiteral(resourceName: "FastPass")
                        icon.bounds = CGRect(x: 0, y: -3, width: #imageLiteral(resourceName: "FastPass").size.width, height: #imageLiteral(resourceName: "FastPass").size.height)
                        let iconText = NSAttributedString(attachment: icon)
                        let statusText = NSAttributedString(string: " " + fastpassInfo + " ",
                                                            attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15),
                                                                         NSForegroundColorAttributeName: UIColor(hex: "F44336")])

                        fullText.appendLineBreakIfNotEmpty()
                        fullText.append(iconText)
                        fullText.append(statusText)

                        if realtime.fastpassRunning ,
                            let startTime = realtime.fastpassStart,
                            let endTime = realtime.fastpassEnd {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "HH:mm"
                            let startText = formatter.string(from: startTime)
                            let endText = formatter.string(from: endTime)
                            let periodText = NSAttributedString(string: "(\(startText) - \(endText))",
                                attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15),
                                             NSForegroundColorAttributeName: UIColor(hex: "F44336")])
                            fullText.append(periodText)
                        }

                    }
                    realtimeMessage.attributedText = fullText
                } else {
                    if let htmlStringData = data.introductions.data(using: .unicode) {
                        if let attributedName = try? NSMutableAttributedString(data: htmlStringData,
                                                                               options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                                               documentAttributes: nil) {
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.lineBreakMode = .byTruncatingTail
                            let range = (attributedName.string as NSString).range(of: attributedName.string)
                            attributedName.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15),
                                                          NSForegroundColorAttributeName: #colorLiteral(red: 0.4717842937, green: 0.4717842937, blue: 0.4717842937, alpha: 1),
                                                          NSParagraphStyleAttributeName: paragraphStyle],
                                                         range: range)
                            introduction.attributedText = attributedName
                        }
                    }
                }

            }
        }
    }

    private let backgroundImage: UIImageView
    private let mainImageView: MainImageView
    private let title: UILabel
    private let categoryImageView: CategoryImageView

    /// 实时讯息
    private let realtimeMessage: UILabel

    /// 没有实时讯息时显示简介
    private let introduction: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        backgroundImage = UIImageView(frame: CGRect.zero)
        title = UILabel(frame: CGRect.zero)
        mainImageView = MainImageView(frame: CGRect.zero)
        categoryImageView = CategoryImageView(frame: CGRect.zero)
        introduction = UILabel(frame: CGRect.zero)
        realtimeMessage = UILabel(frame: CGRect.zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(hex: "E1E2E1")
        selectionStyle = .none

        addBackgroundImage()
        addMainImage()
        addTitle()
        addCategoryImage()
        addIntroduction()
        addOperationMessage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func resetText() {
        title.attributedText = nil
        introduction.attributedText = nil
        realtimeMessage.attributedText = nil
    }

    private func addBackgroundImage() {
        addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        backgroundImage.image = #imageLiteral(resourceName: "card")
        backgroundImage.layoutIfNeeded()
    }

    private func addMainImage() {
        mainImageView.contentMode = .scaleAspectFill
        addSubview(mainImageView)
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.topAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: 2).isActive = true
        mainImageView.leftAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: 2).isActive = true
        mainImageView.rightAnchor.constraint(equalTo:  backgroundImage.rightAnchor, constant: -2).isActive = true
        let mainImageHeight = mainImageView.heightAnchor.constraint(equalToConstant: 200)
        mainImageHeight.priority = 999
        mainImageHeight.isActive = true
        mainImageView.layoutIfNeeded()
    }

    private func addTitle() {
        addSubview(title)
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 12).isActive = true
        title.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -12).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: mainImageView.rightAnchor, constant: -12).isActive = true
    }

    private func addCategoryImage() {
        categoryImageView.contentMode = .center
        categoryImageView.tintColor = Color.white
        addSubview(categoryImageView)
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        categoryImageView.leftAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: 2).isActive = true
        categoryImageView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
        categoryImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        let categoryImageHeight = categoryImageView.heightAnchor.constraint(equalToConstant: 100)
        categoryImageHeight.priority = 999
        categoryImageHeight.isActive = true
        categoryImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
        categoryImageView.layoutIfNeeded()
    }

    private func addIntroduction() {
        introduction.numberOfLines = 0
        addSubview(introduction)
        introduction.translatesAutoresizingMaskIntoConstraints = false
        introduction.leftAnchor.constraint(equalTo: categoryImageView.rightAnchor, constant: 8).isActive = true
        introduction.rightAnchor.constraint(equalTo: backgroundImage.rightAnchor, constant: -10).isActive = true
        introduction.centerYAnchor.constraint(equalTo: categoryImageView.centerYAnchor).isActive = true
        introduction.heightAnchor.constraint(lessThanOrEqualTo: categoryImageView.heightAnchor).isActive = true
    }

    private func addOperationMessage() {
        realtimeMessage.numberOfLines = 0
        addSubview(realtimeMessage)
        realtimeMessage.translatesAutoresizingMaskIntoConstraints = false
        realtimeMessage.leftAnchor.constraint(equalTo: categoryImageView.rightAnchor, constant: 8).isActive = true
        realtimeMessage.centerYAnchor.constraint(equalTo: categoryImageView.centerYAnchor).isActive = true
    }

}

class AttractionBriefHeader: UIView {

    var text: String? {
        didSet {
            label.text = text
        }
    }

    private let label: UILabel

    override init(frame: CGRect) {
        label = UILabel(frame: CGRect.zero)
        super.init(frame: frame)

        addSubview(label)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(hex: "000000")
        label.sizeToFit()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class MainImageView: UIImageView {

    private let shade: UIView

    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 2, height: 2))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }

    override init(frame: CGRect) {
        shade = UIView(frame: CGRect.zero)
        super.init(frame: frame)

        addSubview(shade)
        shade.translatesAutoresizingMaskIntoConstraints = false
        shade.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        shade.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        shade.topAnchor.constraint(equalTo: topAnchor).isActive = true
        shade.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        shade.layoutIfNeeded()

        shade.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2012253853)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class CategoryImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: .bottomLeft,
                                cornerRadii: CGSize(width: 2, height: 2))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}

private extension NSMutableAttributedString {
    func appendLineBreakIfNotEmpty() {
        if !string.isEmpty {
            let lineBreak = NSAttributedString(string: "\n")
            self.append(lineBreak)
        }
    }
}

private enum WaitTimeColor {
    case nobody
    case prettyVacant
    case vacant
    case normal
    case littleCrowded
    case crowded
    case prettyCrowded
    case deadly
    init(waitTime: Int) {
        switch waitTime {
        case _ where waitTime < 15:
            self = .nobody
        case 15...24:
            self = .prettyVacant
        case 25...34:
            self = .vacant
        case 35...39:
            self = .normal
        case 40...49:
            self = .littleCrowded
        case 50...59:
            self = .crowded
        case 60...69:
            self = .prettyCrowded
        default:
            self = .deadly
        }
    }
    var value: Color {
        switch self {
        case .nobody:
            return UIColor(hex: "4CAF50")
        case .prettyVacant:
            return UIColor(hex: "8BC34A")
        case .vacant:
            return UIColor(hex: "CDDC39")
        case .normal:
            return UIColor(hex: "FFEB3B")
        case .littleCrowded:
            return UIColor(hex: "FFC107")
        case .crowded:
            return UIColor(hex: "FF9800")
        case .prettyCrowded:
            return UIColor(hex: "FF5722")
        case .deadly:
            return UIColor(hex: "F44336")
        }
    }
}
