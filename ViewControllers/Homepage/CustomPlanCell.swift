//
//  CustomPlanCell.swift
//  disney
//
//  Created by ebuser on 2017/6/5.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CustomPlanCell: UICollectionViewCell {

    var data: CustomPlanAttraction? {
        didSet {
            if let data = data {
                title.text = data.name

                switch data.category {
                case .attraction:
                    typeIndicator.backgroundColor = UIColor(hex: "2196F3")
                    typeIndicator.image = #imageLiteral(resourceName: "ListAttraction")
                case .show:
                    typeIndicator.backgroundColor = UIColor(hex: "F44336")
                    typeIndicator.image = #imageLiteral(resourceName: "ListParade")
                case .greeting:
                    typeIndicator.backgroundColor = UIColor(hex: "673AB7")
                    typeIndicator.image = #imageLiteral(resourceName: "ListGreeting")
                }

                if data.selected {
                    button.image = #imageLiteral(resourceName: "icy_cross_in_circle")
                } else {
                    button.image = #imageLiteral(resourceName: "icy_plus_in_circle")
                    typeIndicator.backgroundColor = UIColor(hex: "9E9E9E")
                }
            }
        }
    }

    let card: UIImageView
    let typeIndicator: LeftRoundedCornerImageView
    let title: UILabel
    let button: UIImageView

    override init(frame: CGRect) {
        card = UIImageView(frame: .zero)
        typeIndicator = LeftRoundedCornerImageView(frame: .zero)
        title = UILabel(frame: .zero)
        button = UIImageView(frame: .zero)
        super.init(frame: frame)
        backgroundColor = UIColor.clear

        addSubCard()
        addSubIndicator()
        addSubTitle()
        addSubButton()
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
        typeIndicator.tintColor = UIColor.white
        typeIndicator.contentMode = .center
        addSubview(typeIndicator)
        typeIndicator.translatesAutoresizingMaskIntoConstraints = false
        typeIndicator.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 2).isActive = true
        typeIndicator.topAnchor.constraint(equalTo: card.topAnchor, constant: 2).isActive = true
        typeIndicator.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -4).isActive = true
        typeIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }

    private func addSubTitle() {
        title.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: typeIndicator.rightAnchor, constant: 8).isActive = true
        title.centerYAnchor.constraint(equalTo: typeIndicator.centerYAnchor).isActive = true
    }

    private func addSubButton() {
        button.tintColor = UIColor(hex: "9E9E9E")
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -8).isActive = true
        button.centerYAnchor.constraint(equalTo: typeIndicator.centerYAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 4).isActive = true
        button.setContentHuggingPriority(.required, for: .horizontal)
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

    struct RotatableButtonEvent {
        let selected: Bool
        let indexPath: IndexPath
    }
}
