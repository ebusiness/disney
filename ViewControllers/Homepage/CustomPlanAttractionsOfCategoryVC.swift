//
//  CustomPlanAttractionsOfCategoryVC.swift
//  disney
//
//  Created by ebuser on 2017/6/19.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class CustomPlanAttractionsOfCategoryPageVC: UIViewController {

    let indicator: CustomPlanAttractionsOfCategoryIndicatorVC
    let pageViewController: UIPageViewController
    let attractionViewController: CustomPlanAttractionsOfCategoryVC
    let showViewController: CustomPlanAttractionsOfCategoryVC
    let greetingViewController: CustomPlanAttractionsOfCategoryVC

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        indicator = CustomPlanAttractionsOfCategoryIndicatorVC()
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: nil)
        attractionViewController = CustomPlanAttractionsOfCategoryVC(caterogy: .attraction)
        showViewController = CustomPlanAttractionsOfCategoryVC(caterogy: .show)
        greetingViewController = CustomPlanAttractionsOfCategoryVC(caterogy: .greeting)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor(hex: "E1E2E1")

        pageViewController.delegate = self
        pageViewController.dataSource = self

        addSubIndicator()
        addSubPageView()
    }

    private func addSubIndicator() {
        view.addSubview(indicator.view)
        indicator.view.translatesAutoresizingMaskIntoConstraints = false
        indicator.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        indicator.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        indicator.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        indicator.view.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    private func addSubPageView() {
        pageViewController.setViewControllers([attractionViewController],
                                              direction: .forward,
                                              animated: false,
                                              completion: nil)
        view.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: indicator.view.bottomAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
    }
}

extension CustomPlanAttractionsOfCategoryPageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == attractionViewController {
            return nil
        } else if viewController == showViewController {
            return attractionViewController
        } else if viewController == greetingViewController {
            return showViewController
        } else {
            fatalError()
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == attractionViewController {
            return showViewController
        } else if viewController == showViewController {
            return greetingViewController
        } else if viewController == greetingViewController {
            return nil
        } else {
            fatalError()
        }
    }
}

class CustomPlanAttractionsOfCategoryVC: UIViewController {

    let caterogy: SpotCategory
    let tableView: UITableView

    init(caterogy: SpotCategory) {
        self.caterogy = caterogy
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "E1E2E1")

        automaticallyAdjustsScrollViewInsets = false
        addSubTableView()
    }

    private func addSubTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addAllConstraints(equalTo: view)
    }
}

class CustomPlanAttractionsOfCategoryIndicatorVC: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
    }
}
