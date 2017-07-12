//
//  CreatePlanVC.swift
//  disney
//
//  Created by ebuser on 2017/7/11.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class CreatePlanVC: UIViewController {

    let planMenu: CreatePlanMenu
    let tableContainer: UIView

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        planMenu = CreatePlanMenu(frame: .zero)
        tableContainer = UIView(frame: .zero)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        view.backgroundColor = DefaultStyle.viewBackgroundColor
        hidesBottomBarWhenPushed = true
        automaticallyAdjustsScrollViewInsets = false

        addSubPlanMenu()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    private func addSubPlanMenu() {
        view.addSubview(planMenu)
        planMenu.translatesAutoresizingMaskIntoConstraints = false
        planMenu.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        planMenu.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        planMenu.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }

}
