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
    }

    let localizeFileName = "Map"

    let card: UIImageView
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

    private func addSubCard() {
        card.image = #imageLiteral(resourceName: "SpecifiedPlanCard")
        addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.leftAnchor.constraint(equalTo: leftAnchor, constant: 82).isActive = true
        card.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        card.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        card.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        let heightConstraint = card.heightAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.49)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.isActive = true
    }

    private func addSubThumb() {
        thumb.contentMode = .scaleAspectFill
        card.addSubview(thumb)
        thumb.translatesAutoresizingMaskIntoConstraints = false
        thumb.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 1).isActive = true
        thumb.topAnchor.constraint(equalTo: card.topAnchor, constant: 1).isActive = true
        thumb.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -2).isActive = true
        thumb.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.346).isActive = true
    }

    private func addSubMenu() {
        menu.setImage(#imageLiteral(resourceName: "ic_more_vert_black_24px"), for: .normal)
        menu.tintColor = UIColor.white
        menu.setContentCompressionResistancePriority(.required, for: .horizontal)
        card.addSubview(menu)
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -9).isActive = true
        menu.topAnchor.constraint(equalTo: card.topAnchor, constant: 8).isActive = true
    }

    private func addSubNameLabel() {
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.numberOfLines = 0
        card.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: menu.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: thumb.rightAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: menu.leftAnchor, constant: -8).isActive = true
    }

    private func addSubCostTimeLabel() {
        costTimeLabel.textColor = UIColor.white
        costTimeLabel.font = UIFont.systemFont(ofSize: 14)
        card.addSubview(costTimeLabel)
        costTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        costTimeLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10).isActive = true
        costTimeLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
    }

    private func addSubWaitTimeLabel() {
        waitTimeLabel.textColor = UIColor.white
        waitTimeLabel.font = UIFont.systemFont(ofSize: 14)
        card.addSubview(waitTimeLabel)
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

class MapLineCell: UITableViewCell {

}
