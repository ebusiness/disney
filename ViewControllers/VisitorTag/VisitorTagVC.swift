//
//  DSNVisitorTagVC.swift
//  disney
//
//  Created by ebuser on 2017/4/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxSwift
import UIKit

class VisitorTagVC: UIViewController, FileLocalizable {

    let localizeFileName = "VisitorTag"

    fileprivate var collectionView: UICollectionView!
    fileprivate var longPressGesture: UILongPressGestureRecognizer!

    fileprivate let essentialCellIdentifier = "essentialCellIdentifier"
    fileprivate let tagCellIdentifier = "tagCellIdentifier"
    fileprivate let headerCellIdentifier = "headerCellIdentifier"

    /// tags from server
    fileprivate var allTags = [VisitorTagModel]()
    fileprivate let defaultTagIds = ["58faed6067847695d6cfee06",
                                     "58fd5a2867847695d6cfee0d"]

    /// tags in collection view
    /// 0: empty
    /// 1: selected
    /// 2: unselected
    fileprivate var shownTags = [[VisitorTagModel]]()

    fileprivate var visitPark = TokyoDisneyPark.land
    fileprivate var visitDate = Date(timeIntervalSinceNow: 24 * 60 * 60)

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
        collectionView.register(VisitorTagCell.self, forCellWithReuseIdentifier: tagCellIdentifier)
        collectionView.register(VisitorEssentialInfoCell.self, forCellWithReuseIdentifier: essentialCellIdentifier)
        collectionView.register(VisitorTagHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: headerCellIdentifier)
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
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }

    private func addSubNextButton() {
        // Init next button
        let save = UIBarButtonItem(title: localize(for: "save"),
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

        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 3600 * 9)!

        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: visitDate)
        dateComponents.hour = 10
        dateComponents.minute = 0
        dateComponents.second = 0

        if let start = calendar.date(from: dateComponents),
            let end = calendar.date(bySetting: .hour, value: 20, of: start) {
                Preferences.shared.visitStart.value = start
                Preferences.shared.visitEnd.value = end
        }

        Preferences.shared.visitPark.value = visitPark
        if shownTags.count >= 3 {
            UserDefaults.standard[.visitorTags] = shownTags[1].map { $0.id }
        }

        appDelegate.switchToHomepage()
    }

    private func requestVisitorTags() {
        let tagsRequest = API.Visitor.tags
        tagsRequest.request { [weak self] data in

            guard let models: [VisitorTagModel] = VisitorTagModel.array(dataResponse: data) else {
                return
            }
            self?.allTags = models
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

    fileprivate func presentParkPicker() {
        let parkpicker = VisitparkPickVC(park: visitPark)
        parkpicker.subject.subscribe { [unowned self] parkEvent in
            guard let park = parkEvent.element else {
                return
            }
            self.visitPark = park
            self.collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
        }.disposed(by: parkpicker.disposeBag)
        present(parkpicker, animated: false, completion: nil)
    }

    fileprivate func presentDatePicker() {
        let datepicker = VisitdatePickVC(date: visitDate)
        datepicker.subject.subscribe { [unowned self] dateEvent in
            guard let date = dateEvent.element else {
                return
            }
            self.visitDate = date
            self.collectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
        }.disposed(by: datepicker.disposeBag)
        present(datepicker, animated: false, completion: nil)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
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

        if section == 0 {
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        } else {
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        if section == 0 {
            return 4
        } else {
            return 10
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {
            // Essential info cells
            let width = UIScreen.main.bounds.width - 16
            let height = CGFloat(72)
            return CGSize(width: width, height: height)
        } else {
            // Tag cells
            let width = (UIScreen.main.bounds.width - 48) / 4
            let height = width / 5 * 2
            return CGSize(width: width, height: height)
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: essentialCellIdentifier, for: indexPath) as? VisitorEssentialInfoCell else {
                fatalError("Unexpected cell class")
            }
            if indexPath.item == 0 {
                cell.spec = .park(visitPark)
            } else {
                cell.spec = .date(visitDate)
            }
            return cell
        case 1, 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellIdentifier, for: indexPath) as? VisitorTagCell else {
                fatalError("Unexpected cell class")
            }
            cell.visitorTag = shownTags[indexPath.section][indexPath.item]
            return cell
        default:
            fatalError()
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        if section == 1 {
            let width = UIScreen.main.bounds.width
            let height = CGFloat(48)
            return CGSize(width: width, height: height)
        } else {
            let width = UIScreen.main.bounds.width
            let height = CGFloat(24)
            return CGSize(width: width, height: height)
        }

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
                headerView.title = localize(for: "essentialInfo")
            } else if indexPath.section == 1 {
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
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)), selectedIndexPath.section > 0 else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            var destinationLocation = gesture.location(in: collectionView)
            if let limitTop = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 1))?.frame.maxY, destinationLocation.y < limitTop {
                destinationLocation.y = limitTop
            }
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

            if indexPath.item == 0 {
                // Park selector
                presentParkPicker()
            } else {
                // Date selector
                presentDatePicker()
            }

        } else if indexPath.section == 1 {

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
