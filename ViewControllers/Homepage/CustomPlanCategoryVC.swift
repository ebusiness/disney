//
//  CustomPlanCategoryVC.swift
//  disney
//
//  Created by ebuser on 2017/5/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class CustomPlanCategoryVC: UIViewController {

    let collectionView: UICollectionView

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        view.backgroundColor = UIColor.white

        addSubCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        requestAttractionTags()
    }

    private func addSubCollectionView() {
        collectionView.backgroundColor = UIColor(hex: "E1E2E1")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
    }

    private func requestAttractionTags() {
        
    }

}
