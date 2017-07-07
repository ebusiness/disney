//
//  VisitdatePickVC.swift
//  disney
//
//  Created by ebuser on 2017/4/27.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxSwift
import UIKit

class VisitdatePickVC: UIViewController {

    let disposeBag = DisposeBag()
    let subject = PublishSubject<Date>()

    fileprivate let pickerView = UIDatePicker()
    fileprivate let touchGesture: UILongPressGestureRecognizer

    init(date: Date) {

        touchGesture = UILongPressGestureRecognizer()

        super.init(nibName: nil, bundle: nil)

        touchGesture.minimumPressDuration = 0
        touchGesture.addTarget(self, action: #selector(handleLongGesture(gesture:)))
        touchGesture.cancelsTouchesInView = false
        touchGesture.delegate = self
        view.addGestureRecognizer(touchGesture)

        modalPresentationStyle = .overCurrentContext

        pickerView.datePickerMode = .date
        pickerView.minimumDate = Date()
        pickerView.timeZone = TimeZone(secondsFromGMT: 3600 * 9)
        pickerView.setDate(date, animated: false)

        pickerView.addTarget(self, action: #selector(handleValueChanged(picker:)), for: .valueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3313356164)

        pickerView.backgroundColor = UIColor.white
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)
        pickerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true

    }

    @objc
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            if !pickerView.frame.contains(gesture.location(in: view)) {
                subject.onCompleted()
                dismiss(animated: false, completion: nil)
            }
        }
    }

    @objc
    func handleValueChanged(picker: UIDatePicker) {
        subject.onNext(picker.date)
    }

}

extension VisitdatePickVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if pickerView.frame.contains(gestureRecognizer.location(in: view)) {
            return false
        } else {
            return true
        }
    }
}
