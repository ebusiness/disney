//
//  MapCells.swift
//  disney
//
//  Created by ebuser on 2017/6/30.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Kingfisher
import UIKit

class MapPointCell: UITableViewCell, FileLocalizable {

    var data: SpecifiedPlanRoute? {
        didSet {
            dataDidSet()
        }
    }

    let localizeFileName = "Map"

    var menuPressedHandler: (() -> Void)?

    let card: UIImageView
    let cardContainer: UIView
    let thumb: LeftRoundedCornerImageView
    let nameLabel: UILabel
    let waitTimeLabel: UILabel
    let costTimeLabel: UILabel
    let menu: UIButton
    let startTimeLabel: UILabel
    let endTimeLabel: UILabel
    let categoryIcon: UIImageView
    let guidewire: UIView

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        card = UIImageView(frame: .zero)
        cardContainer = UIView(frame: .zero)
        thumb = LeftRoundedCornerImageView(frame: .zero)
        nameLabel = UILabel(frame: .zero)
        waitTimeLabel = UILabel(frame: .zero)
        costTimeLabel = UILabel(frame: .zero)
        menu = UIButton(type: .custom)
        startTimeLabel = UILabel(frame: .zero)
        endTimeLabel = UILabel(frame: .zero)
        categoryIcon = UIImageView(frame: .zero)
        guidewire = UIView(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        addSubCardContainer()
        addSubCard()
        addSubThumb()
        addSubMenu()
        addSubNameLabel()
        addSubCostTimeLabel()
        addSubWaitTimeLabel()
        addSubStartTimeLabel()
        addSubCategoryIcon()
        addSubEndTimeLabel()
        addSubGuidewire()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubCardContainer() {
        addSubview(cardContainer)
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 82).isActive = true
        cardContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        cardContainer.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        cardContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        let heightConstraint = cardContainer.heightAnchor.constraint(equalTo: cardContainer.widthAnchor, multiplier: 0.49)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.isActive = true
    }

    private func addSubCard() {
        cardContainer.addSubview(card)
        card.addAllConstraints(equalTo: cardContainer)
    }

    private func addSubThumb() {
        thumb.contentMode = .scaleAspectFill
        cardContainer.addSubview(thumb)
        thumb.translatesAutoresizingMaskIntoConstraints = false
        thumb.leftAnchor.constraint(equalTo: cardContainer.leftAnchor, constant: 1).isActive = true
        thumb.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 1).isActive = true
        thumb.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -2).isActive = true
        thumb.widthAnchor.constraint(equalTo: cardContainer.widthAnchor, multiplier: 0.346).isActive = true
    }

    private func addSubMenu() {
        menu.setImage(#imageLiteral(resourceName: "ic_more_vert_black_24px"), for: .normal)
        menu.tintColor = UIColor.white
        menu.addTarget(self, action: #selector(menuPressed(_:)), for: .touchUpInside)
        menu.setContentCompressionResistancePriority(.required, for: .horizontal)
        cardContainer.addSubview(menu)
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.rightAnchor.constraint(equalTo: cardContainer.rightAnchor, constant: -9).isActive = true
        menu.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 8).isActive = true
    }

    private func addSubNameLabel() {
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.numberOfLines = 0
        cardContainer.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: menu.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: thumb.rightAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: menu.leftAnchor, constant: -8).isActive = true
    }

    private func addSubCostTimeLabel() {
        costTimeLabel.textColor = UIColor.white
        costTimeLabel.font = UIFont.systemFont(ofSize: 14)
        cardContainer.addSubview(costTimeLabel)
        costTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        costTimeLabel.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -10).isActive = true
        costTimeLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
    }

    private func addSubWaitTimeLabel() {
        waitTimeLabel.textColor = UIColor.white
        waitTimeLabel.font = UIFont.systemFont(ofSize: 14)
        cardContainer.addSubview(waitTimeLabel)
        waitTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        waitTimeLabel.bottomAnchor.constraint(equalTo: costTimeLabel.topAnchor, constant: -4).isActive = true
        waitTimeLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
    }

    private func addSubStartTimeLabel() {
        startTimeLabel.textColor = DefaultStyle.textLightGray
        addSubview(startTimeLabel)
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        startTimeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        startTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }

    private func addSubCategoryIcon() {
        addSubview(categoryIcon)
        categoryIcon.translatesAutoresizingMaskIntoConstraints = false
        categoryIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        categoryIcon.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor, constant: 4).isActive = true
    }

    private func addSubEndTimeLabel() {
        endTimeLabel.textColor = DefaultStyle.textLightGray
        addSubview(endTimeLabel)
        endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        endTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        endTimeLabel.leftAnchor.constraint(equalTo: startTimeLabel.leftAnchor).isActive = true
    }

    private func addSubGuidewire() {
        guidewire.backgroundColor = DefaultStyle.textLightGray
        addSubview(guidewire)
        guidewire.translatesAutoresizingMaskIntoConstraints = false
        guidewire.topAnchor.constraint(equalTo: categoryIcon.bottomAnchor, constant: 4).isActive = true
        guidewire.bottomAnchor.constraint(equalTo: endTimeLabel.topAnchor, constant: -4).isActive = true
        guidewire.widthAnchor.constraint(equalToConstant: 1).isActive = true
        guidewire.centerXAnchor.constraint(equalTo: categoryIcon.centerXAnchor).isActive = true
    }

    @objc
    private func menuPressed(_ sender: UIButton) {
        menuPressedHandler?()
    }

    func dataDidSet() {
        if let data = data {
            // 背景颜色
            switch data.eCategory {
            case .attraction:
                card.image = #imageLiteral(resourceName: "SpecifiedPlanCardAttraction")
                categoryIcon.tintColor = DefaultStyle.attraction
                categoryIcon.image = #imageLiteral(resourceName: "ic_toys_black_24px")
            case .show:
                card.image = #imageLiteral(resourceName: "SpecifiedPlanCardShow")
                categoryIcon.tintColor = DefaultStyle.show
                categoryIcon.image = #imageLiteral(resourceName: "ic_parade_black_24px")
            case .greeting:
                card.image = #imageLiteral(resourceName: "SpecifiedPlanCardGreeting")
                categoryIcon.tintColor = DefaultStyle.greeting
                categoryIcon.image = #imageLiteral(resourceName: "ic_local_see_black_24px")
            }
            // 缩略图
            if let image = data.images?.firstObject as? SpecifiedPlanRouteImage {
                thumb.kf.setImage(with: URL(string: image.url!))
            }
            // 项目名
            nameLabel.text = data.name
            // 排队时间和项目时间
            waitTimeLabel.text = localize(for: "Predicted queue time: %d minute(s)", arguments: data.waitTime)
            costTimeLabel.text = localize(for: "Predicted cost time: %d minute(s)", arguments: data.timeCost)
            // 开始时间
            startTimeLabel.text = data.startTimeText
            endTimeLabel.text = data.endTimeText
        }
    }

    class LeftRoundedCornerImageView: UIImageView {
        override func layoutSubviews() {
            super.layoutSubviews()
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.bottomLeft, .topLeft],
                                    cornerRadii: CGSize(width: 2, height: 2))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            layer.mask = maskLayer
        }
    }
}

class MapFastpassPointCell: MapPointCell {
    let fastpassContainer: UIView
    let fastpassIcon: UIImageView
    let fastpassLabel: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        fastpassContainer = UIView(frame: .zero)
        fastpassIcon = UIImageView(image: #imageLiteral(resourceName: "FastPass"))
        fastpassLabel = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubFastpassContainer()
        addSubFastpassIcon()
        addSubFastpassLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addSubCardContainer() {
        addSubview(cardContainer)
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 82).isActive = true
        cardContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        cardContainer.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        let heightConstraint = cardContainer.heightAnchor.constraint(equalTo: cardContainer.widthAnchor, multiplier: 0.49)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.isActive = true
    }

    private func addSubFastpassContainer() {
        addSubview(fastpassContainer)
        fastpassContainer.translatesAutoresizingMaskIntoConstraints = false
        fastpassContainer.leftAnchor.constraint(equalTo: cardContainer.leftAnchor, constant: 12).isActive = true
        fastpassContainer.topAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: 4).isActive = true
        let bottomConstraint = fastpassContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        bottomConstraint.isActive = true
    }

    private func addSubFastpassIcon() {
        fastpassContainer.addSubview(fastpassIcon)
        fastpassIcon.translatesAutoresizingMaskIntoConstraints = false
        fastpassIcon.leftAnchor.constraint(equalTo: fastpassContainer.leftAnchor).isActive = true
        fastpassIcon.topAnchor.constraint(equalTo: fastpassContainer.topAnchor).isActive = true
        fastpassIcon.bottomAnchor.constraint(equalTo: fastpassContainer.bottomAnchor).isActive = true
    }

    private func addSubFastpassLabel() {
        fastpassLabel.textColor = DefaultStyle.textLightGray
        fastpassContainer.addSubview(fastpassLabel)
        fastpassLabel.translatesAutoresizingMaskIntoConstraints = false
        fastpassLabel.leftAnchor.constraint(equalTo: fastpassIcon.rightAnchor, constant: 8).isActive = true
        fastpassLabel.centerYAnchor.constraint(equalTo: fastpassIcon.centerYAnchor).isActive = true
    }

    override func dataDidSet() {
        super.dataDidSet()
        if let data = data,
            let begin = data.fastpass?.begin,
            let end = data.fastpass?.end {
            fastpassLabel.text = begin.format(pattern: "H:mm") + " ~ " + end.format(pattern: "H:mm")
        }
    }
}

class MapLineCell: UITableViewCell, FileLocalizable {

    let localizeFileName = "Map"

    var data: SpecifiedPlanRoute? {
        didSet {
            if let data = data {
                pathLabel.text = localize(for: "Walk %d minute(s) to arrive", arguments: data.timeToNext)
            }
        }
    }

    let icon: UIImageView
    let pathLabel: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        icon = UIImageView(frame: .zero)
        pathLabel = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        addSubIcon()
        addSubPathLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubIcon() {
        icon.tintColor = MaterialDesignColor.LightGreen.g500
        icon.image = #imageLiteral(resourceName: "ic_directions_walk_black_24px")
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func addSubPathLabel() {
        pathLabel.font = UIFont.systemFont(ofSize: 15)
        addSubview(pathLabel)
        pathLabel.translatesAutoresizingMaskIntoConstraints = false
        pathLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 80).isActive = true
        pathLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

}
