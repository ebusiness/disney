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
    var data: AttractionOfHotGrade? {
        didSet {
            if let data = data {
                thumbnail.contentMode = .center
                thumbnail
                    .kf
                    .setImage(with: URL(string: data.images[0]),
                              placeholder: #imageLiteral(resourceName: "placeHolder"),
                              options: nil,
                              progressBlock: nil,
                              completionHandler: ({ [weak self] image, _, _, _ in
                                if image != nil {
                                    self?.thumbnail.contentMode = .scaleAspectFill
                                }
                              }))
                title.text = data.name
                hotGradeView.grade = data.rank

                if data.selected {
                    thumbnail.selected = true
                    checkbox.isHidden = false
                } else {
                    thumbnail.selected = false
                    checkbox.isHidden = true
                }
            }
        }
    }

    let card: UIImageView
    let thumbnail: RoundedCornerImageView
    let title: UILabel
    let hotGradeView: HotGradeView
    let checkbox: UIImageView

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        card = UIImageView(frame: .zero)
        thumbnail = RoundedCornerImageView(frame: .zero)
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
        contentView.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        card.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        card.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
    }

    private func addSubThumbnail() {
        thumbnail.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        thumbnail.contentMode = .scaleAspectFill
        card.addSubview(thumbnail)
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        thumbnail.topAnchor.constraint(equalTo: card.topAnchor, constant: 2).isActive = true
        thumbnail.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 2).isActive = true
        thumbnail.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -2).isActive = true
        thumbnail.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -4).isActive = true
    }

    private func addSubTitle() {
        title.numberOfLines = 0
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 16)
        thumbnail.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: thumbnail.leftAnchor, constant: 12).isActive = true
        title.bottomAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: -7).isActive = true
    }

    private func addSubHotGradeView() {
        thumbnail.addSubview(hotGradeView)
        hotGradeView.translatesAutoresizingMaskIntoConstraints = false
        hotGradeView.leftAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: -100).isActive = true
        hotGradeView.bottomAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: -7).isActive = true
    }

    private func addSubCheckbox() {
        checkbox.image = #imageLiteral(resourceName: "ic_image_checked_24px")
        card.addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -3).isActive = true
        checkbox.topAnchor.constraint(equalTo: card.topAnchor, constant: 3).isActive = true
    }

    class RoundedCornerImageView: UIImageView {

        let darkmask: CAGradientLayer
        var selected = false {
            didSet {
                if selected {
                    layer.mask = minorboundsMask
                } else {
                    layer.mask = outboundsMask
                }
            }
        }

        var outboundsMask: CALayer {
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: 2, height: 2))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            return maskLayer
        }

        var minorboundsMask: CALayer {
            let border = CGFloat(8)
            let maskX = border
            let maskY = border
            let maskWidth = bounds.width - 2 * border
            let maskHeight = bounds.height - 2 * border
            let maskRect = CGRect(x: maskX, y: maskY, width: maskWidth, height: maskHeight)
            let path = UIBezierPath(roundedRect: maskRect,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: 2, height: 2))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            return maskLayer
        }

        override init(frame: CGRect) {
            darkmask = CAGradientLayer()

            darkmask.colors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
                               #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor]
            super.init(frame: frame)

            layer.addSublayer(darkmask)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            updateOutboundsLayer()
            updateDarkmaskLayer()
        }

        private func updateOutboundsLayer() {
            if selected {
                layer.mask = minorboundsMask
            } else {
                layer.mask = outboundsMask
            }
        }

        private func updateDarkmaskLayer() {
            darkmask.frame = CGRect(x: 0, y: bounds.height - 44, width: bounds.width, height: 44)
        }
    }
}
