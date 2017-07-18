//
//  CreatePlanAwesomeHeader.swift
//  disney
//
//  Created by ebuser on 2017/7/14.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

final class CreatePlanAwesomeHeader: UIView, FileLocalizable {

    var attractionNumber = 0 {
        didSet {
            textLabel.text = localize(for: "have chosen %d attractions", arguments: attractionNumber)
        }
    }

    let localizeFileName = "CustomPlan"

    let indicator: DragIndicator
    let textLabel: UILabel
    let button: UIButton
    let seperator: UIView

    override init(frame: CGRect) {
        indicator = DragIndicator(frame: .zero)
        textLabel = UILabel(frame: .zero)
        button = UIButton(type: .custom)
        seperator = UIView(frame: .zero)
        super.init(frame: frame)

        addSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 44)
    }

    private func addSubViews() {
        addSubIndicator()
        addSubSeperator()
        addSubTextLabel()
        addSubButton()
    }

    private func addSubIndicator() {
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }

    private func addSubSeperator() {
        seperator.backgroundColor = UIColor.lightGray
        addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        seperator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        seperator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
    }

    private func addSubTextLabel() {
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.text = localize(for: "have chosen %d attractions", arguments: attractionNumber)
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func addSubButton() {
        button.setTitleColor(DefaultStyle.primaryColor, for: .normal)
        button.setTitle(localize(for: "Edit"), for: .normal)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

final class DragIndicator: UIView {

    private let width = CGFloat(32)
    private let height = CGFloat(5)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!

        context.saveGState()

        let frame = CGRect(center: rect.center, size: CGSize(width: width, height: height))
        let rectanglePath = UIBezierPath(roundedRect: frame, cornerRadius: height / 2)
        UIColor.lightGray.setFill()
        rectanglePath.fill()

        context.restoreGState()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 14)
    }
}
