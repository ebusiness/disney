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
                return
            }
            switch spec {
            case let .date(date):
                imageView.backgroundColor = UIColor(hex: "2979FF")
                backgroundColor = UIColor(hex: "448AFF")
                imageView.image = #imageLiteral(resourceName: "EssentialInfoDate")
                title.text = localize(for: "chooseDate")
                content.text = DateFormatter.localizedString(from: date,
                                                             dateStyle: .medium,
                                                             timeStyle: .none)
            case let .park(park):
                imageView.backgroundColor = UIColor(hex: "651FFF")
                backgroundColor = UIColor(hex: "7C4DFF")
                imageView.image = #imageLiteral(resourceName: "EssentialInfoPark")
                title.text = localize(for: "choosePark")
                content.text = park.localize()
            }
        }
    }

    private let imageView: UIImageView
    private let title: UILabel
    private let content: UILabel

    override init(frame: CGRect) {

        imageView = UIImageView()
        title = UILabel()
        content = UILabel()
        super.init(frame: frame)

        imageView.tintColor = UIColor.white
        imageView.contentMode = .center
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.layoutIfNeeded()

        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 13)
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 80).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16).isActive = true
        title.layoutIfNeeded()

        content.textColor = UIColor.white
        content.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: leftAnchor, constant: 80).isActive = true
        content.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 12).isActive = true
        content.layoutIfNeeded()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    enum Spec {

        case date(_: Date)
        case park(_: TokyoDisneyPark)

    }

}

class VisitorTagCell: UICollectionViewCell {

    var visitorTag: VisitorTagModel? {
        didSet {
            if let tag = visitorTag {
                contentLabel.text = tag.name
                backgroundColor = UIColor(hex: tag.color)
            } else {
                contentLabel.text = ""
                backgroundColor = UIColor.gray
            }
        }
    }

    private var contentLabel: UILabel
    override init(frame: CGRect) {

        contentLabel = UILabel()
        super.init(frame: frame)

        layer.cornerRadius = frame.size.height / 2

        contentLabel.textColor = UIColor.white
        contentLabel.font = UIFont.boldSystemFont(ofSize: 13)
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

        textLabel.font = UIFont.boldSystemFont(ofSize: 14)
        textLabel.textColor = #colorLiteral(red: 0.4729186296, green: 0.4729186296, blue: 0.4729186296, alpha: 1)
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        textLabel.layoutIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
