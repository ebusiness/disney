//
//  CustomPlanMenu.swift
//  disney
//
//  Created by ebuser on 2017/5/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxSwift
import UIKit

class CustomPlanMenu: UIView {

    var state = State.collapsed

    let disposeBag = DisposeBag()

    let mainButton: UIButton
    let dehazeShape: UIImageView
    let clearShape: UIImageView

    let addButton: UIButton
    let fixedAdd: UIImageView

    let backButton: UIButton
    let fixedBack: UIImageView

    let randomButton: UIButton
    let fixedRandom: UIImageView

    let subject = PublishSubject<SubjectType>()

    override init(frame: CGRect) {
        mainButton = UIButton(type: .custom)
        addButton = UIButton(type: .custom)
        backButton = UIButton(type: .custom)
        randomButton = UIButton(type: .custom)
        dehazeShape = UIImageView(image: #imageLiteral(resourceName: "ic_dehaze_black_24px"))
        clearShape = UIImageView(image: #imageLiteral(resourceName: "ic_clear_black_24px"))
        fixedAdd = UIImageView(image: #imageLiteral(resourceName: "CustomPlanMenuSmall"))
        fixedBack = UIImageView(image: #imageLiteral(resourceName: "CustomPlanMenuSmall"))
        fixedRandom = UIImageView(image: #imageLiteral(resourceName: "CustomPlanMenuSmall"))
        super.init(frame: frame)

        addSubMainButton()
        addSubPopedButtons()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 70, height: 300)
    }

    private func addSubMainButton() {
        let mainButtonSize = CGSize(width: 70, height: 74)
        mainButton.addTarget(self, action: #selector(mainButtonPressed(_:)), for: .touchUpInside)
        addSubview(mainButton)
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        mainButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mainButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainButton.widthAnchor.constraint(equalToConstant: mainButtonSize.width).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: mainButtonSize.height).isActive = true

        let fixedImageView = UIImageView(image: #imageLiteral(resourceName: "CustomPlanMenuBig"))
        addSubview(fixedImageView)
        fixedImageView.translatesAutoresizingMaskIntoConstraints = false
        fixedImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        fixedImageView.bottomAnchor.constraint(equalTo: mainButton.bottomAnchor).isActive = true

        dehazeShape.tintColor = UIColor.white
        dehazeShape.alpha = 1
        fixedImageView.addSubview(dehazeShape)
        dehazeShape.frame.origin = CGPoint(x: 22, y: 23)

        clearShape.tintColor = UIColor.white
        fixedImageView.addSubview(clearShape)
        clearShape.frame.origin = CGPoint(x: 22, y: 23)
        clearShape.alpha = 0
        clearShape.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi * 0.25))
    }

    //swiftlint:disable:next function_body_length
    private func addSubPopedButtons() {
        let popedButtonSize = CGSize(width: 52, height: 52)

        addButton
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] in
                self?.subject.onNext(.addPressed)
            })
            .disposed(by: disposeBag)
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -12).isActive = true
        addButton.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: popedButtonSize.width).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: popedButtonSize.height).isActive = true

        addSubview(fixedAdd)
        fixedAdd.frame.origin = CGPoint(x: 9, y: 162)

        let addShape = UIImageView(image: #imageLiteral(resourceName: "ic_add_black_24px"))
        addShape.tintColor = UIColor(hex: "9E9E9E")
        fixedAdd.addSubview(addShape)
        addShape.frame.origin = CGPoint(x: 12, y: 13)

        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: 0, y: 12)
        transform = transform.scaledBy(x: 0.75, y: 0.75)
        fixedAdd.transform = transform
        fixedAdd.alpha = 0

        backButton
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] in
                self?.subject.onNext(.backPressed)
            })
            .disposed(by: disposeBag)
        addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.bottomAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        backButton.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: popedButtonSize.width).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: popedButtonSize.height).isActive = true

        addSubview(fixedBack)
        fixedBack.frame.origin = CGPoint(x: 9, y: 110)

        let backShape = UIImageView(image: #imageLiteral(resourceName: "ic_keyboard_arrow_left_black_24px"))
        backShape.tintColor = UIColor(hex: "9E9E9E")
        fixedBack.addSubview(backShape)
        backShape.frame.origin = CGPoint(x: 12, y: 13)

        fixedBack.transform = transform
        fixedBack.alpha = 0

        randomButton
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] in
                self?.subject.onNext(.randomPressed)
            })
            .disposed(by: disposeBag)
        addSubview(randomButton)
        randomButton.translatesAutoresizingMaskIntoConstraints = false
        randomButton.bottomAnchor.constraint(equalTo: backButton.topAnchor).isActive = true
        randomButton.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor).isActive = true
        randomButton.widthAnchor.constraint(equalToConstant: popedButtonSize.width).isActive = true
        randomButton.heightAnchor.constraint(equalToConstant: popedButtonSize.height).isActive = true

        addSubview(fixedRandom)
        fixedRandom.frame.origin = CGPoint(x: 9, y: 58)

        let randomShape = UIImageView(image: #imageLiteral(resourceName: "ic_shuffle_black_24px"))
        randomShape.tintColor = UIColor(hex: "9E9E9E")
        fixedRandom.addSubview(randomShape)
        randomShape.frame.origin = CGPoint(x: 12, y: 13)

        fixedRandom.transform = transform
        fixedRandom.alpha = 0
    }

    @objc
    private func mainButtonPressed(_ sender: UIButton) {
        if state == .collapsed {
            changeState(to: .expanded)
        } else {
            changeState(to: .collapsed)
        }
    }

    func expand() {
        changeState(to: .expanded)
    }

    func collapse() {
        changeState(to: .collapsed)
    }

    //swiftlint:disable:next function_body_length
    private func changeState(to newState: State) {
        mainButton.isUserInteractionEnabled = false
        if newState == .expanded {
            UIView.animateKeyframes(withDuration: 0.5,
                                    delay: 0,
                                    options: [.calculationModeLinear],
                                    animations: {
                                        // 大按钮（三）
                                        UIView.addKeyframe(withRelativeStartTime: 0,
                                                           relativeDuration: 0.3,
                                                           animations: { [weak self] in
                                                            self?.dehazeShape.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.25)
                                                            self?.dehazeShape.alpha = 0
                                        })
                                        // 大按钮（X）
                                        UIView.addKeyframe(withRelativeStartTime: 0.2,
                                                           relativeDuration: 0.4,
                                                           animations: { [weak self] in
                                                            self?.clearShape.transform = CGAffineTransform(rotationAngle: 0)
                                                            self?.clearShape.alpha = 1
                                        })
                                        // 小按钮(+)
                                        UIView.addKeyframe(withRelativeStartTime: 0.3,
                                                           relativeDuration: 0.5,
                                                           animations: { [weak self] in
                                                            self?.fixedAdd.alpha = 1
                                                            self?.fixedAdd.transform = CGAffineTransform.identity
                                        })
                                        // 小按钮(<)
                                        UIView.addKeyframe(withRelativeStartTime: 0.475,
                                                           relativeDuration: 0.325,
                                                           animations: { [weak self] in
                                                            self?.fixedBack.alpha = 1
                                                            self?.fixedBack.transform = CGAffineTransform.identity
                                        })
                                        // 小按钮(x)
                                        UIView.addKeyframe(withRelativeStartTime: 0.65,
                                                           relativeDuration: 0.15,
                                                           animations: { [weak self] in
                                                            self?.fixedRandom.alpha = 1
                                                            self?.fixedRandom.transform = CGAffineTransform.identity
                                        })
            }, completion: { [weak self] _ in
                self?.mainButton.isUserInteractionEnabled = true
            })
        } else {
            UIView.animateKeyframes(withDuration: 0.3,
                                    delay: 0,
                                    options: [.calculationModeLinear],
                                    animations: {
                                        // 大按钮（X）
                                        UIView.addKeyframe(withRelativeStartTime: 0,
                                                           relativeDuration: 0.5,
                                                           animations: { [weak self] in
                                                            self?.clearShape.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi * 0.25))
                                                            self?.clearShape.alpha = 0
                                        })
                                        // 小按钮
                                        UIView.addKeyframe(withRelativeStartTime: 0,
                                                           relativeDuration: 0.5,
                                                           animations: { [weak self] in
                                                            self?.fixedAdd.alpha = 0
                                                            self?.fixedBack.alpha = 0
                                                            self?.fixedRandom.alpha = 0
                                        })
                                        // 大按钮（三）
                                        UIView.addKeyframe(withRelativeStartTime: 0.4,
                                                           relativeDuration: 0.6,
                                                           animations: { [weak self] in
                                                            self?.dehazeShape.transform = CGAffineTransform(rotationAngle: 0)
                                                            self?.dehazeShape.alpha = 1

                                        })
            }, completion: { [weak self] _ in
                self?.mainButton.isUserInteractionEnabled = true
                var transform = CGAffineTransform.identity
                transform = transform.translatedBy(x: 0, y: 12)
                transform = transform.scaledBy(x: 0.75, y: 0.75)
                self?.fixedAdd.transform = transform
                self?.fixedBack.transform = transform
                self?.fixedRandom.transform = transform
            })
        }

        state = newState
    }

    enum State {
        case collapsed
        case expanded
    }

    enum SubjectType {
        case addPressed
        case backPressed
        case randomPressed
    }
}
