//
//  RxExtension.swift
//  disney
//
//  Created by ebuser on 2017/5/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UITextField {
    var isEditing: ControlProperty<Bool> {
        return UITextField.rx.vIsEditing(
            base,
            getter: { textField in
                textField.isEditing
        }, setter: { textField, value in
            if value {
                textField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        )
    }

    private static func vIsEditing<C: UITextField, T>(_ textField: C, getter: @escaping (C) -> T, setter: @escaping (C, T) -> Void) -> ControlProperty<T> {
        let values: Observable<T> = Observable.deferred { [weak textField] in
            guard let existingSelf = textField else {
                return Observable.empty()
            }

            return (existingSelf as UITextField).rx.controlEvent([.editingDidBegin, .editingDidEnd])
                .flatMap { _ in
                    return textField.map { Observable.just(getter($0)) } ?? Observable.empty()
                }
                .startWith(getter(existingSelf))
        }
        return ControlProperty(values: values, valueSink: UIBindingObserver(UIElement: textField) { textField, value in
            setter(textField, value)
        })
    }
}
