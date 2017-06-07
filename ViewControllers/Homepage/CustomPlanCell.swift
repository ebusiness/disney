//
//  CustomPlanCell.swift
//  disney
//
//  Created by ebuser on 2017/6/5.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class CustomPlanCell: UITableViewCell {

    var data: CustomPlanAttraction? {
        didSet {
            if let data = data {
                title.text = data.name

                switch data.category {
                case .attraction:
                    indicator.backgroundColor = UIColor(hex: "2196F3")
                    indicator.image = #imageLiteral(resourceName: "ListAttraction")
                case .show:
                    indicator.backgroundColor = UIColor(hex: "F44336")
                    indicator.image = #imageLiteral(resourceName: "ListParade")
                case .greeting:
                    indicator.backgroundColor = UIColor(hex: "673AB7")
                    indicator.image = #imageLiteral(resourceName: "ListGreeting")
                }
            }
        }
    }

    let card: UIImageView
    let indicator: LeftRoundedCornerImageView
    let title: UILabel
    let button: RotatableButton

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        card = UIImageView(frame: .zero)
        indicator = LeftRoundedCornerImageView(frame: .zero)
        title = UILabel(frame: .zero)
        button = RotatableButton(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none

        addSubCard()
        addSubIndicator()
        addSubTitle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubCard() {
        card.image = #imageLiteral(resourceName: "card")
        addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        card.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        card.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        card.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
    }

    private func addSubIndicator() {
        indicator.tintColor = UIColor.white
        indicator.contentMode = .center
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 2).isActive = true
        indicator.topAnchor.constraint(equalTo: card.topAnchor, constant: 2).isActive = true
        indicator.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -4).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }

    private func addSubTitle() {
        title.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: indicator.rightAnchor, constant: 8).isActive = true
        title.centerYAnchor.constraint(equalTo: indicator.centerYAnchor).isActive = true
    }

    class RotatableButton: UIButton {

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
