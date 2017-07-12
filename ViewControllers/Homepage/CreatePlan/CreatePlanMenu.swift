//
//  CreatePlanMenuVC.swift
//  disney
//
//  Created by ebuser on 2017/7/11.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class CreatePlanMenu: UIView {

    let leftButton: UIButton

    override init(frame: CGRect) {
        leftButton = UIButton(type: .custom)
        super.init(frame: frame)

        backgroundColor = DefaultStyle.primaryColor
        addSubLeftButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 44)
    }

    private func addSubLeftButton() {
        leftButton.tintColor = UIColor.white
        leftButton.setImage(#imageLiteral(resourceName: "ic_tune_black_24px"), for: .normal)
        addSubview(leftButton)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        leftButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
    }
}
