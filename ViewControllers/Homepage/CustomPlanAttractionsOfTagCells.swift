//
//  CustomPlanAttractionsOfTagCells.swift
//  disney
//
//  Created by ebuser on 2017/5/29.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Kingfisher
import UIKit

class CustomPlanAttractionsOfTagCell: UITableViewCell {

    var data: PlanCategoryAttractionTagDetail.Attraction? {
        didSet {
            if let data = data {
                thumbnail.kf.setImage(with: URL(string: data.images[0]))
                title.text = data.name
                content.text = data.introduction

                if data.selected {
                    checkbox.tintColor = UIColor(hex: "8BC34A")
                    checkbox.image = #imageLiteral(resourceName: "ic_check_box_black_24px")
                } else {
                    checkbox.tintColor = UIColor(hex: "797979")
                    checkbox.image = #imageLiteral(resourceName: "ic_check_box_outline_blank_black_24px")
                }
            }
        }
    }

    let card: UIImageView
    let title: UILabel
    let content: UILabel
    let thumbnail: LeftRoundedCornerImageView
    let checkbox: UIImageView

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        card = UIImageView(frame: .zero)
        title = UILabel(frame: .zero)
        content = UILabel(frame: .zero)
        thumbnail = LeftRoundedCornerImageView(frame: .zero)
        checkbox = UIImageView(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        addSubCard()
        addSubThumbnail()
        addSubCheckbox()
        addSubTitle()
        addSubContent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubCard() {
        card.image = #imageLiteral(resourceName: "card")
        addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        card.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        card.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        card.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        card.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    private func addSubThumbnail() {
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        addSubview(thumbnail)
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        thumbnail.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 2).isActive = true
        thumbnail.topAnchor.constraint(equalTo: card.topAnchor, constant: 2).isActive = true
        thumbnail.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -4).isActive = true
        thumbnail.widthAnchor.constraint(equalToConstant: 110).isActive = true
    }

    private func addSubCheckbox() {
        checkbox.tintColor = UIColor(hex: "797979")
        checkbox.image = #imageLiteral(resourceName: "ic_check_box_outline_blank_black_24px")
        addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -14).isActive = true
        checkbox.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
        checkbox.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
    }

    private func addSubTitle() {
        title.textColor = UIColor.black
        title.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: card.topAnchor, constant: 14).isActive = true
        title.leftAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: 12).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: checkbox.leftAnchor, constant: -12).isActive = true
    }

    private func addSubContent() {
        content.numberOfLines = 0
        content.textColor = UIColor(hex: "797979")
        content.font = UIFont.boldSystemFont(ofSize: 15)
        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        content.leftAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: 12).isActive = true
        content.rightAnchor.constraint(equalTo: checkbox.leftAnchor, constant: -12).isActive = true
        content.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -16).isActive = true
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
