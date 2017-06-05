//
//  CustomPlanCategoryCells.swift
//  disney
//
//  Created by ebuser on 2017/5/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class CustomPlanCategoryTopCell: UICollectionViewCell {

    var position: Position = .top {
        didSet {
            switch position {
            case .top:
                backgroundImageView.image = #imageLiteral(resourceName: "CardTop")
                seprator.isHidden = false
            case .mid:
                backgroundImageView.image = #imageLiteral(resourceName: "CardMid")
                seprator.isHidden = false
            case .bottom:
                backgroundImageView.image = #imageLiteral(resourceName: "CartBottom")
                seprator.isHidden = true
            }
        }
    }

    var iconImage: UIImage? {
        didSet {
            icon.image = iconImage
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    private let backgroundImageView: UIImageView
    private let seprator: UIView
    private let icon: UIImageView
    private let titleLabel: UILabel
    private let rightArrow: UIImageView

    override init(frame: CGRect) {
        backgroundImageView = UIImageView(frame: .zero)
        seprator = UIView(frame: .zero)
        icon = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        rightArrow = UIImageView(frame: .zero)
        super.init(frame: frame)

        backgroundColor = UIColor(hex: "E1E2E1")

        addSubBackgroundImageView()
        addSubSeprator()
        addSubIcon()
        addSubTitleLabel()
        addSubRightArrow()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubBackgroundImageView() {
        backgroundImageView.image = #imageLiteral(resourceName: "CardTop")
        addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.addAllConstraints(equalTo: self)
    }

    private func addSubSeprator() {
        seprator.backgroundColor = UIColor.lightGray
        addSubview(seprator)
        seprator.translatesAutoresizingMaskIntoConstraints = false
        seprator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seprator.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        seprator.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        seprator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
    }

    private func addSubIcon() {
        icon.tintColor = UIColor(hex: "797979")
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func addSubTitleLabel() {
        titleLabel.textColor = UIColor(hex: "797979")
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 12).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
    }

    private func addSubRightArrow() {
        rightArrow.tintColor = UIColor(hex: "797979")
        rightArrow.image = #imageLiteral(resourceName: "ic_chevron_right_black_24px")
        addSubview(rightArrow)
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        rightArrow.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
    }

    enum Position {
        case top
        case mid
        case bottom
    }
}

class CustomPlanCategoryTagCell: UICollectionViewCell {

    var data: PlanCategoryAttractionTag? {
        didSet {
            if let data = data {
                backgroundColor = UIColor(hex: data.color)
                iconView.image = data.icon.image
                titleLabel.text = data.name
            }
        }
    }

    private let iconView: UIImageView
    private let titleLabel: UILabel

    override init(frame: CGRect) {
        iconView = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        super.init(frame: frame)

        backgroundColor = UIColor.yellow
        layer.cornerRadius = 2
        layer.masksToBounds = true

        addSubIconView()
        addSubTitleLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubIconView() {
        iconView.tintColor = UIColor.white
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12).isActive = true
    }

    private func addSubTitleLabel() {
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -36).isActive = true
    }
}
