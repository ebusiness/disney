//
//  VisitparkPickVC.swift
//  disney
//
//  Created by ebuser on 2017/4/27.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxSwift
import UIKit

class VisitparkPickVC: UIViewController {

    let disposeBag = DisposeBag()
    let subject = PublishSubject<TokyoDisneyPark>()

    fileprivate let pickerView = UIPickerView()
    fileprivate let data = [TokyoDisneyPark.land,
                            TokyoDisneyPark.sea]

    fileprivate let touchGesture: UILongPressGestureRecognizer

    init(park: TokyoDisneyPark) {

        touchGesture = UILongPressGestureRecognizer()

        super.init(nibName: nil, bundle: nil)

        touchGesture.minimumPressDuration = 0
        touchGesture.addTarget(self, action: #selector(handleLongGesture(gesture:)))
        touchGesture.cancelsTouchesInView = false
        touchGesture.delegate = self
        view.addGestureRecognizer(touchGesture)

        modalPresentationStyle = .overCurrentContext

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(data.index(of: park)!, inComponent: 0, animated: false)
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
    private func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            if !pickerView.frame.contains(gesture.location(in: view)) {
                dismiss(animated: false, completion: nil)
            }
        }
    }

}

extension VisitparkPickVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].localize()
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subject.onNext(data[row])
    }
}

extension VisitparkPickVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if pickerView.frame.contains(gestureRecognizer.location(in: view)) {
            return false
        } else {
            return true
        }
    }
}
