//
//  VisitorTagCell.swift
//  disney
//
//  Created by ebuser on 2017/4/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class VisitorEssentialInfoCell: UICollectionViewCell, FileLocalizable {

    let localizeFileName = "VisitorTag"

    var spec: Spec? {
        didSet {
            guard let spec = spec else {
                imageView.image = nil
                title.text = nil
                content.text = nil
                seperator.isHidden = true
                return
            }
            switch spec {
            case .date:
                imageView.tintColor = UIColor(hex: "FF9100")
                imageView.image = #imageLiteral(resourceName: "EssentialInfoDate")
                title.text = localize(for: "chooseDate")
                content.text = "2017年12月11日"
                seperator.isHidden = true
            case .park:
                imageView.tintColor = UIColor(hex: "2979FF")
                imageView.image = #imageLiteral(resourceName: "EssentialInfoPark")
                title.text = localize(for: "choosePark")
                content.text = "东京迪士尼乐园"
                seperator.isHidden = false
            }
        }
    }

    private let imageView: UIImageView
    private let title: UILabel
    private let content: UILabel
    private let seperator: UIView

    override init(frame: CGRect) {

        imageView = UIImageView()
        title = UILabel()
        content = UILabel()
        seperator = UIView()
        super.init(frame: frame)

        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        imageView.layoutIfNeeded()

        title.textColor = UIColor.lightGray
        title.font = UIFont.systemFont(ofSize: 12)
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 72).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12).isActive = true
        title.layoutIfNeeded()

        title.font = UIFont.systemFont(ofSize: 14)
        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: leftAnchor, constant: 72).isActive = true
        content.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 8).isActive = true
        content.layoutIfNeeded()

        seperator.backgroundColor = UIColor.lightGray
        addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        seperator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        seperator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    enum Spec {
        case date
        case park
    }

}

class VisitorTagCell: UICollectionViewCell {

    var visitorTag: VisitorTagModel? {
        didSet {
            if let tag = visitorTag {
                contentLabel.text = tag.localize()
                layer.borderColor = UIColor(hex: tag.color).cgColor
            } else {
                contentLabel.text = ""
                layer.borderColor = UIColor.gray.cgColor
            }
        }
    }

    private var contentLabel: UILabel
    override init(frame: CGRect) {

        contentLabel = UILabel()
        super.init(frame: frame)

        layer.borderWidth = 1
        layer.cornerRadius = 3

        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -12.0).isActive = true
        contentLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        contentLabel.layoutIfNeeded()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VisitorTagHeaderCell: UICollectionReusableView {

    var title = "" {
        didSet {
            textLabel.text = title
        }
    }

    private let textLabel: UILabel

    override init(frame: CGRect) {

        textLabel = UILabel()

        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9364776858, green: 0.9635409852, blue: 1, alpha: 1)

        textLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        textLabel.layoutIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
