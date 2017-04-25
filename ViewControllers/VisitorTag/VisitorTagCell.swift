//
//  VisitorTagCell.swift
//  disney
//
//  Created by ebuser on 2017/4/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class VisitorTagCell: UICollectionViewCell {
    var content: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 3

        content = UILabel()
        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        content.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        content.layoutIfNeeded()
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
