//
//  SettingTagVC.swift
//  disney
//
//  Created by ebuser on 2017/6/23.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class SettingTagVC: UIViewController, FileLocalizable {

    let localizeFileName = "Setting"

    let collectionView: UICollectionView
    let cellIdentifier = "cellIdentifier"
    let headerIdentifier = "headerIdentifier"

    /// tags from server
    fileprivate var allTags = [VisitorTagModel]()
    /// tags in collection view
    /// 0: selected
    /// 1: unselected
    fileprivate var shownTags = [[VisitorTagModel]]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        view.backgroundColor = DefaultStyle.viewBackgroundColor
        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configNavigationItems()
        addSubCollectionView()
        requestVisitorTags()
    }

    private func configNavigationItems() {
        title = localize(for: "setting tags")
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveHandler(_:)))
        navigationItem.rightBarButtonItem = saveButton
    }

    private func addSubCollectionView() {
        collectionView.backgroundColor = DefaultStyle.viewBackgroundColor
        collectionView.register(VisitorTagCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(VisitorTagHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)

        // Manage Autolayout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        collectionView.layoutIfNeeded()

        // Add delegates
        collectionView.delegate = self
        collectionView.dataSource = self

        // Add gestures
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }

    private func requestVisitorTags() {
        let tagsRequest = API.Visitor.tags
        tagsRequest.request { [weak self] data in

            guard let models: [VisitorTagModel] = VisitorTagModel.array(dataResponse: data) else {
                return
            }
            self?.allTags = models
            var selectedGroup = [VisitorTagModel]()
            var unselectedGroup = [VisitorTagModel]()
            guard let selectedTagIds = UserDefaults.standard[.visitorTags] as? [String] else { return }

            self?.allTags.forEach { model in

                if selectedTagIds.contains(model.id) {
                    selectedGroup.append(model)
                } else {
                    unselectedGroup.append(model)
                }
            }

            self?.shownTags.append(selectedGroup)
            self?.shownTags.append(unselectedGroup)

            self?.collectionView.reloadData()
        }
    }

    @objc
    private func saveHandler(_ sender: UIBarButtonItem) {
        if !shownTags.isEmpty {
            UserDefaults.standard[.visitorTags] = shownTags[0].map { $0.id }
        }
        navigationController?.popViewController(animated: true)
    }

}

extension SettingTagVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shownTags.isEmpty {
            return 0
        } else {
            return shownTags[section].count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // Tag cells
            let width = (UIScreen.main.bounds.width - 48) / 4
            let height = width / 5 * 2
            return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? VisitorTagCell else {
            fatalError("Unexpected cell class")
        }
        cell.visitorTag = shownTags[indexPath.section][indexPath.item]
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
                                                                                   withReuseIdentifier: headerIdentifier,
                                                                                   for: indexPath) as? VisitorTagHeaderCell else {
                                                                                    fatalError("Unexpected cell class")
            }

            if indexPath.section == 0 {
                headerView.title = localize(for: "selectedTags")
            } else {
                headerView.title = localize(for: "unselectedTags")
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
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { break }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            let destinationLocation = gesture.location(in: collectionView)
            collectionView.updateInteractiveMovementTargetPosition(destinationLocation)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)

        // Move selected tag to the alternative section.
        if indexPath.section == 0 {

            let destination = IndexPath(item: 0, section: 1)
            let temp = shownTags[indexPath.section].remove(at: indexPath.item)
            shownTags[destination.section].insert(temp, at: destination.item)

            collectionView.moveItem(at: indexPath, to: destination)

        } else if indexPath.section == 1 {

            let destination = IndexPath(item: collectionView.numberOfItems(inSection: 0), section: 0)
            let temp = shownTags[indexPath.section].remove(at: indexPath.item)
            shownTags[destination.section].insert(temp, at: destination.item)

            collectionView.moveItem(at: indexPath, to: destination)

        }
    }
}
