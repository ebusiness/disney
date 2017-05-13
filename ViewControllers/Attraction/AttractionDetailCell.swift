//
//  AttractionDetailCell.swift
//  disney
//
//  Created by ebuser on 2017/5/11.
//  Copyright © 2017年 e-business. All rights reserved.
//

import CoreGraphics
import UIKit

// swiftlint:disable line_length
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
        heightConstraint.priority = 999
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
