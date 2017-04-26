//
//  VisitorTagCell.swift
//  disney
//
//  Created by ebuser on 2017/4/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

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

    private var contentLabel: UILabel!
    override init(frame: CGRect) {

        super.init(frame: frame)

        layer.borderWidth = 1
        layer.cornerRadius = 3

        contentLabel = UILabel()
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

    private let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9364776858, green: 0.9635409852, blue: 1, alpha: 1)

        textLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0).isActive = true
        textLabel.layoutIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
