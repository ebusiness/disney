//
//  Main.swift
//  disney
//
//  Created by ebuser on 2017/4/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barStyle = .black
        let background = NavigationBackground.image
        navigationBar.setBackgroundImage(background, for: .default)
    }
}

class TabVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let homepageVC = HomepageVC()
        let homepageNavi = NavigationVC(rootViewController: homepageVC)

        let vcs = [homepageNavi]
        setViewControllers(vcs, animated: false)
    }
}
