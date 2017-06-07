//
//  AttractionDetailCell.swift
//  disney
//
//  Created by ebuser on 2017/5/11.
//  Copyright © 2017年 e-business. All rights reserved.
//

import CoreGraphics
import UIKit

// swiftlint:disable file_length
class AttractionDetailChartCell: UITableViewCell, FileLocalizable {

    let localizeFileName = "Attraction"

    var thum: String? {
        didSet {
            if let thum = thum {
                let url = URL(string: thum)
                mainImageView.kf.setImage(with: url)
            } else {
                mainImageView.kf.setImage(with: nil)
            }
        }
    }

    var data: AttractionDetailWaitTime? {
        didSet {
            chart.reloadData()
        }
    }

    private let chart: WaitTimeChart
    private let mainImageView: UIImageView

    private let chartCornerRadius = CGFloat(4)
    fileprivate let chartSize = CGSize(width: UIScreen.main.bounds.width - 24,
                                       height: (UIScreen.main.bounds.width - 24) * 0.5)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        mainImageView = UIImageView(frame: CGRect.zero)
        chart = WaitTimeChart(frame: CGRect.zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        configChart()
        configImage()

        backgroundColor = UIColor(hex: "E1E2E1")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configChart() {
        chart.tintColor = UIColor.white
        chart.backgroundColor = #colorLiteral(red: 0.4077090919, green: 0.4077090919, blue: 0.4077090919, alpha: 0.7504013271)
        chart.layer.cornerRadius = chartCornerRadius
        chart.layer.masksToBounds = true

        chart.title = localize(for: "waitTime")
        chart.delegate = self
        chart.dataSource = self

        addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        chart.widthAnchor.constraint(equalToConstant: chartSize.width).isActive = true
        chart.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        chart.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        let heightConstraint = chart.heightAnchor.constraint(equalToConstant: chartSize.height)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.isActive = true
        chart.layoutIfNeeded()
    }

    private func configImage() {
        mainImageView.layer.cornerRadius = chartCornerRadius
        mainImageView.layer.masksToBounds = true
        addSubview(mainImageView)
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.leftAnchor.constraint(equalTo: chart.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: chart.rightAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: chart.topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: chart.bottomAnchor).isActive = true
        mainImageView.layoutIfNeeded()
        bringSubview(toFront: chart)
    }
}

extension AttractionDetailChartCell: WaitTimeChartDelegate, WaitTimeChartDataSource {
    var firstIndex: Int? {
        return data?.firstRealtimeIndex
    }
    var lastIndex: Int? {
        return data?.lastRealtimeIndex
    }
    var maxIndex: Int? {
        return data?.maxIndex
    }

    var chartType: WaitTimeChartType {
        if let data = data {
            switch data.type {
            case .mix:
                return .mix
            case .realtimeOnly:
                return .realtimeOnly
            case .simOnly:
                return .simOnly
            }
        } else {
            return .mix
        }
    }

    func chartContentSize() -> CGSize {
        let fullSize = chartSize
        return CGSize(width: fullSize.width, height: fullSize.height - 24)
    }

    func chartTitleHeight() -> CGFloat {
        return 24
    }

    func numberOfVerticalAxis() -> Int {
        return 3
    }

    func titleForVerticalAxis(at: Int) -> String? {
        guard let data = data else {
            return nil
        }
        if at == 1 {
            return "\(data.scale / 2) min"
        } else if at == 2 {
            return "\(data.scale) min"
        } else {
            return nil
        }
    }

    func numberOfHorizontalAxis() -> Int {
        return 57
    }

    func titleForHorizontalAxis(at: Int) -> String? {
        if at % 4 == 0 {
            return "\(8 + at / 4)"
        } else {
            return nil
        }
    }

    func valueOfMaxVerticalAxis() -> CGFloat {
        guard let data = data else {
            return 99999
        }
        return CGFloat(data.scale)
    }

    func valueOfMinVerticalAxis() -> CGFloat {
        return 0
    }

    func value(at: Int) -> CGFloat? {
        if let realTime = data?.realtime {
            if at < realTime.count {
                if let waitTime = realTime[at]?.waitTime {
                    return CGFloat(waitTime)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func simValue(at: Int) -> CGFloat? {
        if let simTime = data?.prediction {
            if at < simTime.count {
                if let waitTime = simTime[at]?.waitTime {
                    return CGFloat(waitTime)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

}

class AttractionDetailInfoCell: UITableViewCell, FileLocalizable {

    var data: AttractionDetail.CardInfo? {
        didSet {
            if let data = data {
                // title
                titleLabel.text = data.title

                // content
                if let htmlStringData = data.content.data(using: .unicode) {
                    if let attributedName = try? NSMutableAttributedString(data: htmlStringData,
                                                                           options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                                                                           documentAttributes: nil) {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.paragraphSpacing = 6.0
                        let range = (attributedName.string as NSString).range(of: attributedName.string)
                        attributedName.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                                                      NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4717842937, green: 0.4717842937, blue: 0.4717842937, alpha: 1),
                                                      NSAttributedStringKey.paragraphStyle: paragraphStyle],
                                                     range: range)
                        contentLabel.attributedText = attributedName
                    }
                } else {
                    contentLabel.attributedText = nil
                }

                // type
                switch data.cardType {
                case .introduction:
                    icon.image = #imageLiteral(resourceName: "AttractionDetailIntroduction")
                    icon.backgroundColor = UIColor(hex: "2196F3")
                    icon.layoutIfNeeded()
                case .duration:
                    icon.image = #imageLiteral(resourceName: "AttractionDetailDuration")
                    icon.backgroundColor = UIColor(hex: "E91E63")
                    icon.layoutIfNeeded()
                case .capacity:
                    icon.image = #imageLiteral(resourceName: "AttractionDetailCapcity")
                    icon.backgroundColor = UIColor(hex: "03A9F4")
                    icon.layoutIfNeeded()
                case .restriction:
                    icon.image = #imageLiteral(resourceName: "AttractionDetailRestriction")
                    icon.backgroundColor = UIColor(hex: "FF9800")
                    icon.layoutIfNeeded()
                case .appropriateFor:
                    icon.image = #imageLiteral(resourceName: "AttractionDetailAppropriateFor")
                    icon.backgroundColor = UIColor(hex: "8BC34A")
                    icon.layoutIfNeeded()
                case .attractionType:
                    icon.image = #imageLiteral(resourceName: "AttractionDetailAttractionType")
                    icon.backgroundColor = UIColor(hex: "607D8B")
                    icon.layoutIfNeeded()
                }
            }
        }
    }

    let localizeFileName = "Attraction"

    private let borderImageView: UIImageView
    private let leadColorView: LeadColorView
    private let icon: IconImageView

    private let titleLabel: UILabel
    private let contentLabel: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        borderImageView = UIImageView(frame: CGRect.zero)
        leadColorView = LeadColorView(frame: CGRect.zero)
        icon = IconImageView(frame: CGRect.zero)
        titleLabel = UILabel(frame: CGRect.zero)
        contentLabel = UILabel(frame: CGRect.zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        addSubBorderImageView()
        addSubLeadColorView()
        addIcon()
        addTitleLabel()
        addContentLabel()

        backgroundColor = UIColor(hex: "E1E2E1")
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

    private func addSubLeadColorView() {
        leadColorView.backgroundColor = UIColor(hex: "2196F3")
        addSubview(leadColorView)
        leadColorView.translatesAutoresizingMaskIntoConstraints = false
        leadColorView.leftAnchor.constraint(equalTo: borderImageView.leftAnchor, constant: 2).isActive = true
        leadColorView.topAnchor.constraint(equalTo: borderImageView.topAnchor, constant: 2).isActive = true
        leadColorView.bottomAnchor.constraint(equalTo: borderImageView.bottomAnchor, constant: -4).isActive = true
        leadColorView.widthAnchor.constraint(equalToConstant: 6).isActive = true
    }

    private func addIcon() {
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.leftAnchor.constraint(equalTo: leadColorView.rightAnchor, constant: 12).isActive = true
        icon.topAnchor.constraint(equalTo: borderImageView.topAnchor, constant: 14).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let bottomConstraint = icon.bottomAnchor.constraint(lessThanOrEqualTo: borderImageView.bottomAnchor, constant: -16)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        bottomConstraint.isActive = true
    }

    private func addTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: icon.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 12).isActive = true
    }

    private func addContentLabel() {
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.numberOfLines = 0
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        contentLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 12).isActive = true
        contentLabel.rightAnchor.constraint(equalTo: borderImageView.rightAnchor, constant: -14).isActive = true
        contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: borderImageView.bottomAnchor, constant: -16).isActive = true
    }
}

private class IconImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = UIColor.white
        contentMode = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.height, bounds.width) / 2
    }
}

private class LeadColorView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.bottomLeft, .topLeft],
                                cornerRadii: CGSize(width: 2, height: 2))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}

class AttractionDetailThumsCell: UITableViewCell {

    var thums: [String] = [String]() {
        didSet {
            updatePageControl()
            collectionView.reloadData()
        }
    }

    fileprivate let collectionView: UICollectionView
    fileprivate let collectionCellIdentifier = "collectionCellIdentifier"
    private let pageControl: UIPageControl

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        pageControl = UIPageControl(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(hex: "E1E2E1")

        addSubCollectionView()
        addSubPageControl()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor(hex: "E1E2E1")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 2.0
        collectionView.layer.masksToBounds = true
        collectionView.register(AttractionDetailThumsCollectionCell.self, forCellWithReuseIdentifier: collectionCellIdentifier)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        let heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 24) / 2)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.isActive = true
    }

    private func addSubPageControl() {
        updatePageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    fileprivate func updatePageControl(to currentPage: Int = 0) {
        pageControl.numberOfPages = thums.count
        pageControl.currentPage = currentPage
    }
}

extension AttractionDetailThumsCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thums.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as? AttractionDetailThumsCollectionCell else {
            fatalError("Unknown cell type")
        }
        cell.imageUrl = thums[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 24, height: (UIScreen.main.bounds.width - 24) / 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let contentOffsetX = scrollView.contentOffset.x
            let pageWidth = UIScreen.main.bounds.width - 24
            let page = Int(contentOffsetX / pageWidth)
            updatePageControl(to: page)
        }
    }
}

private class AttractionDetailThumsCollectionCell: UICollectionViewCell {

    var imageUrl: String? {
        didSet {
            if let imageUrl = imageUrl {
                let url = URL(string: imageUrl)
                imageView.kf.setImage(with: url)
            } else {
                imageView.kf.setImage(with: nil)
            }
        }
    }

    private let imageView: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView(frame: .zero)
        super.init(frame: frame)

        backgroundColor = UIColor(hex: "E1E2E1")

        addSubImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addAllConstraints(equalTo: self)
    }
}
