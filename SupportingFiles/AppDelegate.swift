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

        let launchScreenVC = LaunchScreenViewController()
        window?.rootViewController = launchScreenVC
        window?.makeKeyAndVisible()

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

    func switchToHomepage() {

        let tabVC = TabVC()
        guard let window = UIApplication.shared.keyWindow else { return }
        UIView.transition(with: window,
                          duration: 0.3,
                          options: [.curveEaseInOut, .transitionFlipFromRight],
                          animations: { _ in
                            window.rootViewController = tabVC
        },
                          completion: nil)

    }

}
