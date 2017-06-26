//
//  Main.swift
//  disney
//
//  Created by ebuser on 2017/4/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxSwift
import UIKit

class NavigationVC: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barStyle = .black
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = UIColor(hex: "0091EA")
        navigationBar.tintColor = UIColor.white
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class TabVC: UITabBarController, FileLocalizable {
    let localizeFileName = "Main"

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let homepageVC = HomepageVC()
        homepageVC.tabBarItem.image = #imageLiteral(resourceName: "TabbarPlan")
        homepageVC.tabBarItem.title = localize(for: "TabbarPlan")
        let homepageNavi = NavigationVC(rootViewController: homepageVC)

        let attractionVC = AttractionVC()
        attractionVC.tabBarItem.image = #imageLiteral(resourceName: "TabbarAttraction")
        attractionVC.tabBarItem.title = localize(for: "TabbarAttraction")
        let attractionNavi = NavigationVC(rootViewController: attractionVC)

        let mapVC = MapVC()
        mapVC.tabBarItem.image = #imageLiteral(resourceName: "TabbarMap")
        mapVC.tabBarItem.title = localize(for: "TabbarMap")
        let mapNavi = NavigationVC(rootViewController: mapVC)

        let settingVC = SettingVC()
        settingVC.tabBarItem.image = #imageLiteral(resourceName: "TabbarSetting")
        settingVC.tabBarItem.title = localize(for: "TabbarSetting")
        let settingNavi = NavigationVC(rootViewController: settingVC)

        let vcs = [homepageNavi, attractionNavi, mapNavi, settingNavi]
        setViewControllers(vcs, animated: false)

        // setting change action
        Preferences
            .shared
            .visitPark
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.reloadPlanVC()
                self?.reloadAttractionVC()
            })
            .disposed(by: disposeBag)
    }

    func reloadPlanVC() {
        guard selectedIndex != 0 else { return }
        let homepageVC = HomepageVC()
        homepageVC.tabBarItem.image = #imageLiteral(resourceName: "TabbarPlan")
        homepageVC.tabBarItem.title = localize(for: "TabbarPlan")
        let homepageNavi = NavigationVC(rootViewController: homepageVC)
        guard let vcs = viewControllers else { return }
        let newVCs = [homepageNavi] + vcs.suffix(from: 1)
        setViewControllers(newVCs, animated: false)
    }

    func reloadAttractionVC() {
        guard selectedIndex != 1 else { return }
        let attractionVC = AttractionVC()
        attractionVC.tabBarItem.image = #imageLiteral(resourceName: "TabbarAttraction")
        attractionVC.tabBarItem.title = localize(for: "TabbarAttraction")
        let attractionNavi = NavigationVC(rootViewController: attractionVC)
        guard let vcs = viewControllers else { return }
        var newVCs = [UIViewController]()
        newVCs.append(vcs[0])
        newVCs.append(attractionNavi)
        newVCs.append(contentsOf: vcs.suffix(from: 2))
        setViewControllers(newVCs, animated: false)
    }

}
