//
//  HomepageCells.swift
//  disney
//
//  Created by ebuser on 2017/5/16.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Kingfisher
import UIKit

class HomepageCell: UITableViewCell, FileLocalizable {

    let localizeFileName = "Main"
    var data: PlanConvertible? {
        didSet {
            if let data = data {
                titleLabel.text = data.cName
                numLabel.text = "\(data.cRoutes.count) " + localize(for: "MainCell.numAttractions")
                introductionLabel.text = data.cIntroduction
                collectionView.reloadData()
            }
        }
    }

    var itemSelectedHandler: ((_ id: String) -> Void)?
    var menuPressedHandler: (() -> Void)?

    let borderImageView: UIImageView
    let titleLabel: UILabel
    let menu: UIButton
    let numLabel: UILabel
    let collectionView: UICollectionView
    let collectionViewPathIdentifier = "collectionViewPathIdentifier"
    let collectionViewIdentifier = "collectionViewIdentifier"
    let collectionPathCellSize = CGSize(width: 110, height: 95)
    let collectionCellSize = CGSize(width: 64, height: 95)
    let introductionLabel: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        borderImageView = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        menu = UIButton(type: .custom)
        numLabel = UILabel(frame: .zero)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        introductionLabel = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = DefaultStyle.viewBackgroundColor

        addSubBorderImageView()
        addSubTitleLabel()
        addSubMenu()
        addSubNumLabel()
        addSubCollectionView()
        addSubIntroductionLabel()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubBorderImageView() {
        addSubview(borderImageView)
        borderImageView.translatesAutoresizingMaskIntoConstraints = false
        borderImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        borderImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        borderImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        borderImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        borderImageView.image = #imageLiteral(resourceName: "card")
        borderImageView.layoutIfNeeded()
    }

    private func addSubTitleLabel() {
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: borderImageView.leftAnchor, constant: 14).isActive = true
        titleLabel.topAnchor.constraint(equalTo: borderImageView.topAnchor, constant: 14).isActive = true
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private func addSubMenu() {
        menu.tintColor = UIColor(hex: "797979")
        menu.setImage(#imageLiteral(resourceName: "ic_more_horiz_black_24px"), for: .normal)
        menu.addTarget(self, action: #selector(menuButtonPressed(_:)), for: .touchUpInside)
        addSubview(menu)
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        menu.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 12).isActive = true
        menu.rightAnchor.constraint(equalTo: borderImageView.rightAnchor, constant: -14).isActive = true
        menu.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    private func addSubNumLabel() {
        numLabel.numberOfLines = 1
        numLabel.font = UIFont.boldSystemFont(ofSize: 14)
        numLabel.textColor = UIColor(hex: "797979")
        addSubview(numLabel)
        numLabel.translatesAutoresizingMaskIntoConstraints = false
        numLabel.leftAnchor.constraint(equalTo: borderImageView.leftAnchor, constant: 14).isActive = true
        numLabel.rightAnchor.constraint(equalTo: borderImageView.rightAnchor, constant: -14).isActive = true
        numLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
    }

    private func addSubCollectionView() {
        collectionView.backgroundColor = UIColor.white
        collectionView.register(HompPageCollectionPathCell.self, forCellWithReuseIdentifier: collectionViewPathIdentifier)
        collectionView.register(HomePageCollectionCell.self, forCellWithReuseIdentifier: collectionViewIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: borderImageView.leftAnchor, constant: 2).isActive = true
        collectionView.rightAnchor.constraint(equalTo: borderImageView.rightAnchor, constant: -2).isActive = true
        collectionView.topAnchor.constraint(equalTo: borderImageView.topAnchor, constant: 72).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: collectionCellSize.height).isActive = true
    }

    private func addSubIntroductionLabel() {
        introductionLabel.numberOfLines = 0
        introductionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        introductionLabel.textColor = UIColor(hex: "797979")
        addSubview(introductionLabel)
        introductionLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionLabel.leftAnchor.constraint(equalTo: borderImageView.leftAnchor, constant: 14).isActive = true
        introductionLabel.rightAnchor.constraint(equalTo: borderImageView.rightAnchor, constant: -14).isActive = true
        introductionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12).isActive = true
        let lowPriorityLayout = introductionLabel.bottomAnchor.constraint(equalTo: borderImageView.bottomAnchor, constant: -16)
        lowPriorityLayout.priority = UILayoutPriority(rawValue: 999)
        lowPriorityLayout.isActive = true
    }

    @objc
    private func menuButtonPressed(_ sender: UIButton) {
        menuPressedHandler?()
    }
}

extension HomepageCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return data?.cPathImageURL != nil ? 1 : 0
        } else {
            return data?.cRoutes.count ?? 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewPathIdentifier, for: indexPath) as? HompPageCollectionPathCell else { fatalError("Unknown cell type") }
            cell.imageURL = data?.cPathImageURL
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewIdentifier, for: indexPath) as? HomePageCollectionCell else {
                fatalError("Unknown cell type")
            }
            cell.route = data?.cRoutes[indexPath.item]
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return collectionPathCellSize
        } else {
            return collectionCellSize
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = data?.cId {
            itemSelectedHandler?(id)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        } else {
            return .zero
        }
    }
}

class HomePageCollectionCell: UICollectionViewCell {

    var route: RouteConvertible? {
        didSet {
            if let route = route {
                imageView.kf.setImage(with: URL(string: route.cImages[0]))
            }
        }
    }

    private let imageView: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView(frame: .zero)
        super.init(frame: frame)

        clipsToBounds = true
        addSubImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubImageView() {
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.addAllConstraints(equalTo: self)
    }
}

class HompPageCollectionPathCell: UICollectionViewCell {

    var imageURL: URL? {
        didSet {
            imageView.contentMode = .center
            imageView
                .kf
                .setImage(with: imageURL,
                          placeholder: #imageLiteral(resourceName: "placeHolder"),
                          options: nil,
                          progressBlock: nil,
                          completionHandler: ({ [weak self] image, _, _, _ in
                            if image != nil {
                                self?.imageView.contentMode = .scaleAspectFill
                            }
                          }))
        }
    }

    private let imageView: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView(frame: .zero)
        super.init(frame: frame)

        clipsToBounds = true
        addSubImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubImageView() {
        imageView.backgroundColor = UIColor.lightGray
        addSubview(imageView)
        imageView.addAllConstraints(equalTo: self)
    }
}
