//
//  CreatePlanAttractionsOfGradeCell.swift
//  disney
//
//  Created by ebuser on 2017/7/11.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Kingfisher
import UIKit

class CreatePlanAttractionsOfGradeCell: UITableViewCell {

    let card: UIImageView
    let thumbnail: TopRoundedCornerImageView
    let title: UILabel
    let hotGradeView: HotGradeView
    let checkbox: UIImageView

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        card = UIImageView(frame: .zero)
        thumbnail = TopRoundedCornerImageView(frame: .zero)
        title = UILabel(frame: .zero)
        hotGradeView = HotGradeView(frame: .zero)
        checkbox = UIImageView(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = DefaultStyle.viewBackgroundColor

        addSubCard()
        addSubThumbnail()
        addSubTitle()
        addSubHotGradeView()
        addSubCheckbox()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubCard() {
        card.image = #imageLiteral(resourceName: "card")
        addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        card.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
        card.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        card.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }

    private func addSubThumbnail() {
        thumbnail.contentMode = .scaleAspectFill
        addSubview(thumbnail)
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        thumbnail.topAnchor.constraint(equalTo: card.topAnchor, constant: 2).isActive = true
        thumbnail.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 2).isActive = true
        thumbnail.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -2).isActive = true
        thumbnail.heightAnchor.constraint(equalTo: thumbnail.widthAnchor, multiplier: 9.0 / 16.0, constant: 0).isActive = true

        // mask
        let mask = UIView(frame: .zero)
        mask.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1466449058)
        thumbnail.addSubview(mask)
        mask.translatesAutoresizingMaskIntoConstraints = false
        mask.addAllConstraints(equalTo: thumbnail)
    }

    private func addSubTitle() {
        title.numberOfLines = 0
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: thumbnail.leftAnchor, constant: 12).isActive = true
        title.bottomAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: -12).isActive = true
    }

    private func addSubHotGradeView() {
        addSubview(hotGradeView)
        hotGradeView.translatesAutoresizingMaskIntoConstraints = false
        hotGradeView.leftAnchor.constraint(equalTo: thumbnail.leftAnchor, constant: 12).isActive = true
        hotGradeView.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 4).isActive = true
        hotGradeView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8).isActive = true
    }

    private func addSubCheckbox() {
        checkbox.tintColor = UIColor(hex: "797979")
        checkbox.image = #imageLiteral(resourceName: "ic_check_box_outline_blank_black_24px")
        addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -14).isActive = true
        checkbox.centerYAnchor.constraint(equalTo: hotGradeView.centerYAnchor).isActive = true
    }

    class TopRoundedCornerImageView: UIImageView {
        override func layoutSubviews() {
            super.layoutSubviews()
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 2, height: 2))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            layer.mask = maskLayer
        }
    }
}
