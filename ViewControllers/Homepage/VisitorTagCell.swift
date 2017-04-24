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

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
