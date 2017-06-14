//
//  CustomPlanCategoryVC.swift
//  disney
//
//  Created by ebuser on 2017/5/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class CustomPlanCategoryVC: UIViewController, FileLocalizable {

    let localizeFileName = "CustomPlan"

    var tagData = [PlanCategoryAttractionTag]()

    let collectionView: UICollectionView
    let identifierForTopCells = "identifierForTopCells"
    let identifierForTagCells = "identifierForTagCells"

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
        collectionView.register(CustomPlanCategoryTopCell.self, forCellWithReuseIdentifier: identifierForTopCells)
        collectionView.register(CustomPlanCategoryTagCell.self, forCellWithReuseIdentifier: identifierForTagCells)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(hex: "E1E2E1")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
    }

    private func requestAttractionTags() {
        let requester = API.AttractionTags.list

        requester.request { [weak self] data in
            if let retrieved = PlanCategoryAttractionTag.array(dataResponse: data) {
                self?.tagData = retrieved
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.reloadSections(IndexSet(integer: 1))
                })
            }
        }
    }

    fileprivate func pushToAttractionsOfTag(_ tag: PlanCategoryAttractionTag) {
        let destination = CustomPlanAttractionsOfTagVC(tag: tag)
        navigationController?.pushViewController(destination, animated: true)
    }

    fileprivate func pushToAttractionsOfArea() {
        let destination = CustomPlanAttractionsOfAreaVC()
        navigationController?.pushViewController(destination, animated: true)
    }
}

extension CustomPlanCategoryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return tagData.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierForTopCells, for: indexPath) as? CustomPlanCategoryTopCell else { fatalError("Unknown cell type") }
            if indexPath.item == 0 {
                cell.position = .top
                cell.iconImage = #imageLiteral(resourceName: "ic_filter_none_black_24px")
                cell.title = localize(for: "plan filter all")
            } else if indexPath.item == 2 {
                cell.position = .bottom
                cell.iconImage = #imageLiteral(resourceName: "ic_bubble_chart_black_24px")
                cell.title = localize(for: "plan filter area")
            } else {
                cell.position = .mid
                cell.iconImage = #imageLiteral(resourceName: "ic_whatshot_black_24px")
                cell.title = localize(for: "plan filter hot")
            }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierForTagCells, for: indexPath) as? CustomPlanCategoryTagCell else { fatalError("Unknown cell type") }
            cell.data = tagData[indexPath.item]
            return cell
        } else {
            fatalError("Unknown cell section")
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        if indexPath.section == 0 {
            return CGSize(width: screenSize.width - 2 * 12, height: 44)
        } else if indexPath.section == 1 {
            let width = (screenSize.width - 3 * 12) / 2
            let height = width * 2 / 3
            return CGSize(width: width, height: height)
        } else {
            return .zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 12
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        case 1:
            return UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
        default:
            return .zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            pushToAttractionsOfTag(tagData[indexPath.item])
        } else {
            if indexPath.row == 2 {
                // 区域分类
                pushToAttractionsOfArea()
            }
        }
    }
}
