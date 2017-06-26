//
//  Preferences.swift
//  disney
//
//  Created by ebuser on 2017/6/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Foundation
import RxSwift

class Preferences {

    private let disposeBag = DisposeBag()

    //swiftlint:disable:next function_body_length
    private init() {
        // 园区：初始化
        if let parkString = UserDefaults.standard[.visitPark] as? String,
            let park = TokyoDisneyPark(rawValue: parkString) {
            visitPark = Variable(park)
        } else {
            visitPark = Variable(nil)
        }
        // 园区：写
        visitPark
            .asObservable()
            .skip(1)
            .subscribe(onNext: { park in
                guard let park = park else { return }
                UserDefaults.standard[.visitPark] = park.rawValue
            })
            .addDisposableTo(disposeBag)

        // 出入时间：初始化
        if let year = UserDefaults.standard[.visitYear] as? Int,
            let month = UserDefaults.standard[.visitMonth] as? Int,
            let day = UserDefaults.standard[.visitDay] as? Int {

            if let startHour = UserDefaults.standard[.visitHour] as? Int,
                let startMinute = UserDefaults.standard[.visitMinute] as? Int {
                var dateComponents = DateComponents()
                dateComponents.timeZone = TimeZone(secondsFromGMT: 3600 * 9)
                dateComponents.year = year
                dateComponents.month = month
                dateComponents.day = day
                dateComponents.hour = startHour
                dateComponents.minute = startMinute
                dateComponents.second = 0

                let calendar = Calendar.current
                let date = calendar.date(from: dateComponents)
                visitStart = Variable(date)
            } else {
                visitStart = Variable(nil)
            }

            if let endHour = UserDefaults.standard[.exitHour] as? Int,
                let endMinute = UserDefaults.standard[.exitMinute] as? Int {
                var dateComponents = DateComponents()
                dateComponents.timeZone = TimeZone(secondsFromGMT: 3600 * 9)
                dateComponents.year = year
                dateComponents.month = month
                dateComponents.day = day
                dateComponents.hour = endHour
                dateComponents.minute = endMinute
                dateComponents.second = 0

                let calendar = Calendar.current
                let date = calendar.date(from: dateComponents)
                visitEnd = Variable(date)
            } else {
                visitEnd = Variable(nil)
            }

        } else {
            visitStart = Variable(nil)
            visitEnd = Variable(nil)
        }
        // 出入时间：写
        visitStart
            .asObservable()
            .skip(1)
            .subscribe(onNext: { start in
                guard let start = start else { return }
                let calendar = Calendar.current
                let timeZone = TimeZone(secondsFromGMT: 3600 * 9)!
                let dateComponents = calendar.dateComponents(in: timeZone, from: start)
                let year = dateComponents.year
                let month = dateComponents.month
                let day = dateComponents.day
                let hour = dateComponents.hour
                let minute = dateComponents.minute
                UserDefaults.standard[.visitYear] = year
                UserDefaults.standard[.visitMonth] = month
                UserDefaults.standard[.visitDay] = day
                UserDefaults.standard[.visitHour] = hour
                UserDefaults.standard[.visitMinute] = minute
            })
            .addDisposableTo(disposeBag)
        visitEnd
            .asObservable()
            .skip(1)
            .subscribe(onNext: { end in
                guard let end = end else { return }
                let calendar = Calendar.current
                let timeZone = TimeZone(secondsFromGMT: 3600 * 9)!
                let dateComponents = calendar.dateComponents(in: timeZone, from: end)
                let year = dateComponents.year
                let month = dateComponents.month
                let day = dateComponents.day
                let hour = dateComponents.hour
                let minute = dateComponents.minute
                UserDefaults.standard[.visitYear] = year
                UserDefaults.standard[.visitMonth] = month
                UserDefaults.standard[.visitDay] = day
                UserDefaults.standard[.exitHour] = hour
                UserDefaults.standard[.exitMinute] = minute
            })
            .addDisposableTo(disposeBag)
    }

    static let shared = Preferences()

    // MARK: - 园区
    let visitPark: Variable<TokyoDisneyPark?>

    // MARK: - 入园时间
    let visitStart: Variable<Date?>

    // MARK: - 退园时间
    let visitEnd: Variable<Date?>

}
