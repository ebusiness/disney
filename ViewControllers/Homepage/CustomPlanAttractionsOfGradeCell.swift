//
//  CustomPlanAttractionsOfGradeCell.swift
//  disney
//
//  Created by ebuser on 2017/6/16.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Kingfisher
import UIKit

class CustomPlanAttractionsOfGradeCell: UITableViewCell {

    var data: AttractionOfHotGrade? {
        didSet {
            if let data = data {
                thumbnail.kf.setImage(with: URL(string: data.images[0]))
                title.text = data.name
                hotGradeView.grade = data.rank

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

class HotGradeView: UIView {

    private let label: UILabel
    private let stars: [UIImageView]

    var grade = 0.0 {
        didSet {
            if grade < 0 {
                grade = 0
            } else if grade > 5 {
                grade = 5
            }
            // 文字
            label.text = String(format: "%.1f", arguments: [grade])
            // 图
            switch grade {
            case 0..<0.5:
                // 0.0-0.4
                stars.forEach { $0.tintColor = UIColor(hex: "797979") }
            case 0.5..<1.5:
                // 0.5-1.4
                stars[0].tintColor = UIColor(hex: "F44336")
                stars[1..<5].forEach { $0.tintColor = UIColor(hex: "797979") }
            case 1.5..<2.5:
                // 1.5-2.4
                stars[0...1].forEach { $0.tintColor = UIColor(hex: "F44336") }
                stars[2..<5].forEach { $0.tintColor = UIColor(hex: "797979") }
            case 2.5..<3.5:
                // 2.5-3.4
                stars[0...2].forEach { $0.tintColor = UIColor(hex: "F44336") }
                stars[3..<5].forEach { $0.tintColor = UIColor(hex: "797979") }
            case 3.5..<4.5:
                // 3.5-4.4
                stars[0...3].forEach { $0.tintColor = UIColor(hex: "F44336") }
                stars[4].tintColor = UIColor(hex: "797979")
            default:
                // 4.5+
                stars.forEach { $0.tintColor = UIColor(hex: "F44336") }
            }
        }
    }

    override init(frame: CGRect) {
        label = UILabel(frame: .zero)
        var stars = [UIImageView]()
        for _ in 0..<5 {
            stars.append(UIImageView(frame: .zero))
        }
        self.stars = stars
        super.init(frame: frame)

        addSubLabel()
        addSubStars()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 24)
    }

    private func addSubLabel() {
        label.textColor = UIColor(hex: "F44336")
        label.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 33).isActive = true
    }

    private func addSubStars() {
        stars.forEach {
            $0.image = #imageLiteral(resourceName: "ic_whatshot_black_12px")
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        stars.forEach { $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true }
        stars[0].leftAnchor.constraint(equalTo: label.rightAnchor).isActive = true
        for index in 1..<5 {
            stars[index].leftAnchor.constraint(equalTo: stars[index - 1].rightAnchor).isActive = true
        }
    }

}
