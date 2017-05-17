//
//  MaskedImageView.swift
//  disney
//
//  Created by ebuser on 2017/5/17.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class MaskedImageView: UIImageView {
    private let translucentMask: UIView

    override init(frame: CGRect) {
        translucentMask = UIView(frame: .zero)
        super.init(frame: frame)

        addSubTranslucentMask()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubTranslucentMask() {
        translucentMask.backgroundColor = #colorLiteral(red: 0.1326085031, green: 0.1326085031, blue: 0.1326085031, alpha: 0.3280714897)
        addSubview(translucentMask)
        translucentMask.addAllConstraints(equalTo: self)
    }

}
