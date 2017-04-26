//
//  DSNVisitorTagVC.swift
//  disney
//
//  Created by ebuser on 2017/4/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

// swiftlint:disable line_length
class VisitorTagVC: UIViewController {

    let localizeFileName = "VisitorTag"

    var collectionView: UICollectionView!
    var longPressGesture: UILongPressGestureRecognizer!
    let cellIdentifier = "cellIdentifier"
    let headerCellIdentifier = "headerCellIdentifier"

    /// tags from server
    fileprivate var allTags = [VisitorTagModel]()
    fileprivate let defaultTagIds = ["58faed6067847695d6cfee06",
                                     "58fd5a2867847695d6cfee0d"]

    /// tags in collection view
    /// 0: empty
    /// 1: selected
    /// 2: unselected
    fileprivate var shownTags = [[VisitorTagModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLogo()
        addSubCollectionView()
        addSubNextButton()

        requestVisitorTags()
    }

    private func setupLogo() {

        let imageView = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        let logo = UIBarButtonItem(customView: imageView)
        navigationItem.leftBarButtonItem = logo

    }

    private func addSubCollectionView() {
        // Init collection view
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(VisitorTagCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(VisitorTagHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: headerCellIdentifier)
        view.addSubview(collectionView)

        // Manage Autolayout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        collectionView.layoutIfNeeded()

        // Add delegates
        collectionView.delegate = self
        collectionView.dataSource = self

        // Add gestures
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }

    private func addSubNextButton() {
        // Init next button
        let save = UIBarButtonItem(title: NSLocalizedString("save", tableName: localizeFileName, comment: ""),
                                   style: .plain,
                                   target: self,
                                   action: #selector(handleNextButton(sender:)))
        navigationItem.setRightBarButton(save, animated: false)
    }

    @objc
    func handleNextButton(sender: UIBarButtonItem) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.switchToHomepage()
    }

    private func requestVisitorTags() {
        let tagsRequest = API.Visitor.tags
        tagsRequest.request { [weak self] data in

            self?.allTags = VisitorTagModel.arraySerialize(data)
            let empty = [VisitorTagModel]()
            var selectedGroup = [VisitorTagModel]()
            var unselectedGroup = [VisitorTagModel]()
            guard let defaultTagIds = self?.defaultTagIds else { return }

            self?.allTags.forEach { model in

                if defaultTagIds.contains(model.id) {
                    selectedGroup.append(model)
                } else {
                    unselectedGroup.append(model)
                }
            }

            self?.shownTags.append(empty)
            self?.shownTags.append(selectedGroup)
            self?.shownTags.append(unselectedGroup)

            self?.collectionView.reloadSections(IndexSet(integersIn: 1...2))
        }
    }
}

extension VisitorTagVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 3

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 2
        case 1, 2:
            if shownTags.isEmpty {
                return 0
            } else {
                return shownTags[section].count
            }
        default:
            fatalError()
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (UIScreen.main.bounds.width - 48) / 4
        let height = width / 5 * 2
        return CGSize(width: width, height: height)

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? VisitorTagCell else {
            fatalError("Unexpected cell class")
        }
        switch indexPath.section {
        case 0:
            cell.visitorTag = nil
        case 1, 2:
            cell.visitorTag = shownTags[indexPath.section][indexPath.item]
        default:
            fatalError()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let width = UIScreen.main.bounds.width
        let height = CGFloat(24)
        return CGSize(width: width, height: height)

    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: headerCellIdentifier,
                                                                                   for: indexPath) as? VisitorTagHeaderCell else {
                fatalError("Unexpected cell class")
            }

            if indexPath.section == 0 {
                headerView.title = NSLocalizedString("essentialInfo", tableName: localizeFileName, comment: "")
            } else if indexPath.section == 1 {
                headerView.title = NSLocalizedString("selectedTags", tableName: localizeFileName, comment: "")
            } else {
                headerView.title = NSLocalizedString("unselectedTags", tableName: localizeFileName, comment: "")
            }
            return headerView
        default:
            fatalError("Unexpected element kind")
        }

    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let temp = shownTags[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        shownTags[destinationIndexPath.section].insert(temp, at: destinationIndexPath.item)

    }

    @objc
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {

        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)), selectedIndexPath.section > 0 else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            guard let destinationIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)), destinationIndexPath.section > 0 else {
                break
            }
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)

        // Move selected tag to the alternative section.
        if indexPath.section == 1 {

            let destination = IndexPath(item: 0, section: 2)
            let temp = shownTags[indexPath.section].remove(at: indexPath.item)
            shownTags[destination.section].insert(temp, at: destination.item)

            collectionView.moveItem(at: indexPath, to: destination)

        } else if indexPath.section == 2 {

            let destination = IndexPath(item: collectionView.numberOfItems(inSection: 1), section: 1)
            let temp = shownTags[indexPath.section].remove(at: indexPath.item)
            shownTags[destination.section].insert(temp, at: destination.item)

            collectionView.moveItem(at: indexPath, to: destination)

        }
    }

}
