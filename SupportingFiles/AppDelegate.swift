//
//  AppDelegate.swift
//  disney
//
//  Created by starboychina on 2017/04/21.
//  Copyright © 2017 e-business. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // swiftlint:disable:next line_length
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)

        if !isVisitorTagAssigned() {
            // 用户选择标签
            let visitorTagVC = VisitorTagVC()
            let navigationVC = NavigationVC(rootViewController: visitorTagVC)

            window?.rootViewController = navigationVC
            window?.makeKeyAndVisible()
        } else {
            // 主功能
            let tabVC = TabVC()

            window?.rootViewController = tabVC
            window?.makeKeyAndVisible()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func isVisitorTagAssigned() -> Bool {
        return false
    }

}
