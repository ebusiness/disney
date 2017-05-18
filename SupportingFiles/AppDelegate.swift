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

    private func isVisitorTagAssigned() -> Bool {
        guard let date = UserDefaults.standard[.visitDate] as? Date else {
            return false
        }
        guard UserDefaults.standard[.visitPark] as? String != nil else {
            return false
        }
        let now = Date()
        if date < now {
            return false
        }
        return true
    }

    func switchToHomepage() {

        let tabVC = TabVC()
        guard let window = window else { return }
        UIView.transition(with: window,
                          duration: 0.3,
                          options: [.curveEaseInOut, .transitionFlipFromRight],
                          animations: { [unowned self] in
                            self.window?.rootViewController = tabVC
                          },
                          completion: nil)

    }

}
