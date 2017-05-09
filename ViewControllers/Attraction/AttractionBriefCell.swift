//
//  AttractionBriefCell.swift
//  disney
//
//  Created by ebuser on 2017/4/28.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Kingfisher
import UIKit

class AttractionBriefCell: UITableViewCell {

    var data: AttractionListSpot? {
        didSet {
            if let data = data {
                let url = URL(string: data.thum)
                print(myImageView)
                myImageView.kf.setImage(with: url)
            }
        }
    }

    private let myImageView: UIImageView

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        myImageView = UIImageView(frame: CGRect.zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        myImageView.contentMode = .scaleAspectFill
        addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        myImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        myImageView.heightAnchor.constraint(equalTo: heightAnchor, constant: -16).isActive = true
        myImageView.widthAnchor.constraint(equalTo: myImageView.heightAnchor, multiplier: 1.5).isActive = true
        myImageView.layoutIfNeeded()

        myImageView.backgroundColor = UIColor.lightGray

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class AttractionBriefHeader: UIView {

    var text: String? {
        didSet {
            label.text = text
        }
    }

    private let label: UILabel

    override init(frame: CGRect) {
        label = UILabel(frame: CGRect.zero)
        super.init(frame: frame)

        addSubview(label)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(hex: "3F51B5")
        label.sizeToFit()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
