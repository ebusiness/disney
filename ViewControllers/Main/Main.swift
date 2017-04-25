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
        navigationBar.tintColor = UIColor.white
    }
}

class TabVC: UITabBarController {
    let localizeFileName = "Main"
    override func viewDidLoad() {
        super.viewDidLoad()

        let homepageVC = HomepageVC()
        homepageVC.tabBarItem.image = #imageLiteral(resourceName: "TabbarPlan")
        homepageVC.tabBarItem.title = NSLocalizedString("TabbarPlan", tableName: localizeFileName, comment: "")
        let homepageNavi = NavigationVC(rootViewController: homepageVC)

        let attractionVC = AttractionVC()
        attractionVC.tabBarItem.image = #imageLiteral(resourceName: "TabbarAttraction")
        attractionVC.tabBarItem.title = NSLocalizedString("TabbarAttraction", tableName: localizeFileName, comment: "")
        let attractionNavi = NavigationVC(rootViewController: attractionVC)

        let mapVC = MapVC()
        mapVC.tabBarItem.image = #imageLiteral(resourceName: "TabbarMap")
        mapVC.tabBarItem.title = NSLocalizedString("TabbarMap", tableName: localizeFileName, comment: "")
        let mapNavi = NavigationVC(rootViewController: mapVC)

        let settingVC = SettingVC()
        settingVC.tabBarItem.image = #imageLiteral(resourceName: "TabbarSetting")
        settingVC.tabBarItem.title = NSLocalizedString("TabbarSetting", tableName: localizeFileName, comment: "")
        let settingNavi = NavigationVC(rootViewController: settingVC)

        let vcs = [homepageNavi, attractionNavi, mapNavi, settingNavi]
        setViewControllers(vcs, animated: false)
    }
}
