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
    var data: PlanListElement? {
        didSet {
            if let data = data {
                titleLabel.text = data.name

                numLabel.text = "\(data.routes.count) " + localize(for: "MainCell.numAttractions")

                introductionLabel.text = data.introduction

                collectionView.reloadData()
            }
        }
    }

    var itemSelectedHandler: ((_ id: String) -> Void)?

    let borderImageView: UIImageView
    let titleLabel: UILabel
    let numLabel: UILabel
    let collectionView: UICollectionView
    let collectionViewIdentifier = "collectionViewIdentifier"
    let collectionCellSize = CGSize(width: 243, height: 150)
    let introductionLabel: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        borderImageView = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        numLabel = UILabel(frame: .zero)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        introductionLabel = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = UIColor(hex: "E1E2E1")

        addSubBorderImageView()
        addSubTitleLabel()
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
        titleLabel.rightAnchor.constraint(equalTo: borderImageView.rightAnchor, constant: -14).isActive = true
        titleLabel.topAnchor.constraint(equalTo: borderImageView.topAnchor, constant: 14).isActive = true
    }

    private func addSubNumLabel() {
        numLabel.numberOfLines = 1
        numLabel.font = UIFont.boldSystemFont(ofSize: 14)
        numLabel.textColor = #colorLiteral(red: 0.4725510478, green: 0.4725510478, blue: 0.4725510478, alpha: 1)
        addSubview(numLabel)
        numLabel.translatesAutoresizingMaskIntoConstraints = false
        numLabel.leftAnchor.constraint(equalTo: borderImageView.leftAnchor, constant: 14).isActive = true
        numLabel.rightAnchor.constraint(equalTo: borderImageView.rightAnchor, constant: -14).isActive = true
        numLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
    }

    private func addSubCollectionView() {
        collectionView.backgroundColor = UIColor.white
        collectionView.register(HomePageCollectionCell.self, forCellWithReuseIdentifier: collectionViewIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: borderImageView.leftAnchor, constant: 2).isActive = true
        collectionView.rightAnchor.constraint(equalTo: borderImageView.rightAnchor, constant: -2).isActive = true
        collectionView.topAnchor.constraint(equalTo: numLabel.bottomAnchor, constant: 12).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: collectionCellSize.height).isActive = true
    }

    private func addSubIntroductionLabel() {
        introductionLabel.numberOfLines = 0
        introductionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        introductionLabel.textColor = #colorLiteral(red: 0.4725510478, green: 0.4725510478, blue: 0.4725510478, alpha: 1)
        addSubview(introductionLabel)
        introductionLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionLabel.leftAnchor.constraint(equalTo: borderImageView.leftAnchor, constant: 14).isActive = true
        introductionLabel.rightAnchor.constraint(equalTo: borderImageView.rightAnchor, constant: -14).isActive = true
        introductionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12).isActive = true
        let lowPriorityLayout = introductionLabel.bottomAnchor.constraint(equalTo: borderImageView.bottomAnchor, constant: -16)
        lowPriorityLayout.priority = 999
        lowPriorityLayout.isActive = true
    }
}

extension HomepageCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.routes.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewIdentifier, for: indexPath) as? HomePageCollectionCell else {
            fatalError("Unknown cell type")
        }
        cell.route = data?.routes[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionCellSize
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = data?.id {
            itemSelectedHandler?(id)
        }
    }
}

class HomePageCollectionCell: UICollectionViewCell {

    var route: PlanListElement.Route? {
        didSet {
            if let route = route {
                imageView.kf.setImage(with: URL(string: route.images[0]))

                // 景点名称
                if let htmlStringData = route.name.data(using: .unicode) {
                    if let attributedName = try? NSMutableAttributedString(data: htmlStringData,
                                                                           options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                                           documentAttributes: nil) {
                        attributedName.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
                                                      NSForegroundColorAttributeName: UIColor.white],
                                                     range: NSRange(location: 0, length: attributedName.string.characters.count))
                        titleLabel.attributedText = attributedName
                    }
                }
            }
        }
    }

    private let imageView: UIImageView
    private let imageMaskView: UIView
    private let titleLabel: UILabel

    override init(frame: CGRect) {
        imageView = UIImageView(frame: .zero)
        imageMaskView = UIView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        super.init(frame: frame)

        clipsToBounds = true
        addSubImageView()
        addSubImageMaskView()
        addSubTitleLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubImageView() {
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.addAllConstraints(equalTo: self)
    }

    private func addSubImageMaskView() {
        imageMaskView.backgroundColor = #colorLiteral(red: 0.1326085031, green: 0.1326085031, blue: 0.1326085031, alpha: 0.3342519263)
        addSubview(imageMaskView)
        imageMaskView.addAllConstraints(equalTo: imageView)
    }

    private func addSubTitleLabel() {
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
}
