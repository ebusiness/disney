//
//  WaittimeChart.swift
//  disney
//
//  Created by ebuser on 2017/5/13.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

// swiftlint:disable file_length
class WaitTimeChart: UIView {

    var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }

    override var tintColor: UIColor! {
        didSet {
            super.tintColor = tintColor
            titleLabel.textColor = tintColor
        }
    }

    weak var delegate: WaitTimeChartDelegate?
    weak var dataSource: WaitTimeChartDataSource?

    private let titleLabel: UILabel
    private var chart: ChartBase?

    override init(frame: CGRect) {
        titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: 8, y: 8),
                                           size: CGSize.zero))
        super.init(frame: frame)

        configTitleLabel()
    }

    private func configTitleLabel() {
        titleLabel.textColor = tintColor
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadData() {
        chart?.removeFromSuperview()
        if let dataSource = dataSource, let delegate = delegate {
            chart = ChartBase(frame: CGRect(origin: CGPoint(x: 0,
                                                            y: delegate.chartTitleHeight()),
                                            size: delegate.chartContentSize()))
            chart!.tintColor = tintColor
            chart!.delegate = delegate
            chart!.dataSource = dataSource
            addSubview(chart!)
        }
    }
}

protocol WaitTimeChartDelegate: NSObjectProtocol {
    func chartTitleHeight() -> CGFloat
    func chartContentSize() -> CGSize
}

protocol WaitTimeChartDataSource: NSObjectProtocol {
    var firstIndex: Int? { get }
    var lastIndex: Int? { get }
    var maxIndex: Int? { get }
    var chartType: WaitTimeChartType { get }
    func numberOfHorizontalAxis() -> Int
    func numberOfVerticalAxis() -> Int
    func titleForHorizontalAxis(at: Int) -> String?
    func titleForVerticalAxis(at: Int) -> String?
    func valueOfMaxVerticalAxis() -> CGFloat
    func valueOfMinVerticalAxis() -> CGFloat
    func value(at: Int) -> CGFloat?
    func simValue(at: Int) -> CGFloat?
}

enum WaitTimeChartType {
    case realtimeOnly
    case simOnly
    case mix
}

extension WaitTimeChartDataSource {
    var firstIndex: Int? {
        return nil
    }
    var lastIndex: Int? {
        return nil
    }
    var maxindex: Int? {
        return nil
    }
    func titleForVerticalAxis(at: Int) -> String? {
        return nil
    }

    func titleForHorizontalAxis(at: Int) -> String? {
        return nil
    }

    func numberOfVerticalAxis() -> Int {
        return 0
    }

    func numberOfHorizontalAxis() -> Int {
        return 0
    }
}

// swiftlint:disable type_body_length
private class ChartBase: UIView {

    weak var delegate: WaitTimeChartDelegate?
    weak var dataSource: WaitTimeChartDataSource?

    private let baseLineInset = UIEdgeInsets(top: 1, left: 8, bottom: 24, right: 8)
    private let referenceLineInset = UIEdgeInsets(top: 20, left: 16, bottom: 24, right: 40)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        drawHeadline()
        drawFootline()
        drawReflinesAndTitles()
        drawTrend()
    }

    private func drawHeadline() {
        if baseLineInset.left + baseLineInset.right < bounds.width {
            let headline = UIBezierPath()
            headline.lineWidth = 1 / UIScreen.main.scale
            headline.move(to: CGPoint(x: baseLineInset.left, y: baseLineInset.top))
            headline.addLine(to: CGPoint(x: bounds.width - baseLineInset.right, y: baseLineInset.top))
            tintColor.setStroke()
            headline.stroke()
        }
    }

    private func drawFootline() {
        if baseLineInset.left + baseLineInset.right < bounds.width {
            let footline = UIBezierPath()
            footline.lineWidth = 1 / UIScreen.main.scale
            footline.move(to: CGPoint(x: baseLineInset.left, y: bounds.height - baseLineInset.bottom))
            footline.addLine(to: CGPoint(x: bounds.width - baseLineInset.right, y: bounds.height - baseLineInset.bottom))
            tintColor.setStroke()
            footline.stroke()
        }
    }

    private func drawReflinesAndTitles() {

        if referenceLineInset.left + referenceLineInset.right < bounds.width &&
            referenceLineInset.top + referenceLineInset.bottom < bounds.height {
            drawReflinesAndYtitles()
            drawXtitles()
        }
    }

    private func drawReflinesAndYtitles() {
        let context = UIGraphicsGetCurrentContext()!
        if let numberOfLines = dataSource?.numberOfVerticalAxis(), numberOfLines > 1 {
            let gap = (bounds.height - referenceLineInset.top - referenceLineInset.bottom) / CGFloat(numberOfLines - 1)
            for index in 0..<numberOfLines {
                let startX = referenceLineInset.left
                let startY = bounds.height - referenceLineInset.bottom - CGFloat(index) * gap
                let endX = bounds.width - referenceLineInset.right
                let endY = startY

                // draw reference line
                let referenceLine = UIBezierPath()
                referenceLine.lineWidth = 1 / UIScreen.main.scale
                referenceLine.move(to: CGPoint(x: startX, y: startY))
                referenceLine.addLine(to: CGPoint(x: endX, y: endY))
                UIColor(baseColor: tintColor, alpha: 0.5).setStroke()
                referenceLine.stroke()

                // draw title
                if let text = dataSource?.titleForVerticalAxis(at: index) {
                    let textRect = CGRect(x: endX + 2, y: endY - 7, width: 40, height: 16)
                    let textStyle = NSMutableParagraphStyle()
                    textStyle.alignment = .left
                    let textAttributes: [String: Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: 10),
                                                         NSForegroundColorAttributeName: tintColor,
                                                         NSParagraphStyleAttributeName: textStyle]
                    context.saveGState()
                    context.clip(to: textRect)
                    text.draw(in: textRect, withAttributes: textAttributes)
                    context.restoreGState()
                }
            }
        }
    }

    private func drawXtitles() {
        let context = UIGraphicsGetCurrentContext()!
        if let numberOfTitles = dataSource?.numberOfHorizontalAxis(), numberOfTitles > 1 {
            let gap = (bounds.width - referenceLineInset.left - referenceLineInset.right) / CGFloat(numberOfTitles - 1)
            for index in 0..<numberOfTitles {
                if let text = dataSource?.titleForHorizontalAxis(at: index) {
                    let x = referenceLineInset.left + CGFloat(index) * gap - 4
                    let y = bounds.height - referenceLineInset.bottom + 2
                    let textRect = CGRect(x: x, y: y, width: 20, height: 16)
                    let textStyle = NSMutableParagraphStyle()
                    textStyle.alignment = .left
                    let textAttributes: [String: Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: 10),
                                                         NSForegroundColorAttributeName: tintColor,
                                                         NSParagraphStyleAttributeName: textStyle]
                    context.saveGState()
                    context.clip(to: textRect)
                    text.draw(in: textRect, withAttributes: textAttributes)
                    context.restoreGState()
                }
            }

        }
    }

    private func drawTrend() {

        if let dataSource = dataSource {
            switch dataSource.chartType {
            case .mix:
                drawTrendMix()
            case .realtimeOnly:
                drawTrendRealtimeOnly()
            case .simOnly:
                drawTrendSimOnly()
            }
        }
    }

    private func drawTrendRealtimeOnly() {
        guard let dataSource = dataSource else {
                return
        }
        drawRealPart(from: 0, to: dataSource.numberOfHorizontalAxis() - 1)
    }

    private func drawTrendSimOnly() {
        guard let dataSource = dataSource else {
                return
        }
        drawSimPartOnly(from: 0, to: dataSource.numberOfHorizontalAxis() - 1)
    }

    private func drawTrendMix() {
        guard let dataSource = dataSource,
            let firstIndex = dataSource.firstIndex,
            let lastIndex = dataSource.lastIndex,
            let maxIndex = dataSource.maxIndex else {
                return
        }

        drawSimPart(from: lastIndex + 1, to: maxIndex)
        drawRealPart(from: firstIndex, to: lastIndex)
    }

    private func drawRealPart(from: Int, to: Int) {

        if let dataSource = dataSource, to >= from {
            // useful values
            let numberOfValues = dataSource.numberOfHorizontalAxis()
            let maxValue = dataSource.valueOfMaxVerticalAxis()
            let minValue = dataSource.valueOfMinVerticalAxis()
            let distance = bounds.height - referenceLineInset.bottom - referenceLineInset.top
            let valueDiff = maxValue - minValue
            let yScale = distance / valueDiff
            let xGap = (bounds.width - referenceLineInset.left - referenceLineInset.right) / CGFloat(numberOfValues - 1)

            // find first point
            var minIndex: Int?
            for index in from...to {
                if dataSource.value(at: index) != nil {
                    minIndex = index
                    break
                }
            }
            guard let firstIndex = minIndex, let firstValue = dataSource.value(at: firstIndex) else {
                return
            }

            // draw first point & line
            let startPoint = CGPoint(x: referenceLineInset.left + CGFloat(firstIndex) * xGap,
                                     y: bounds.height - referenceLineInset.bottom)
            let firstValueHeight = (firstValue - minValue) * yScale
            let firstPoint = CGPoint(x: referenceLineInset.left + CGFloat(firstIndex) * xGap,
                                     y: bounds.height - referenceLineInset.bottom - firstValueHeight)
            let trend = UIBezierPath()
            trend.move(to: startPoint)
            trend.addLine(to: firstPoint)

            // lastPoint
            var lastPoint = firstPoint

            // draw other point & lines
            if firstIndex + 1 <= to {
                for index in (firstIndex + 1)...to {
                    if let value = dataSource.value(at: index) {
                        let valueHeight = (value - minValue) * yScale
                        let point = CGPoint(x: referenceLineInset.left + CGFloat(index) * xGap,
                                            y: bounds.height - referenceLineInset.bottom - valueHeight)
                        trend.addLine(to: point)
                        lastPoint = point
                    }
                }
            }

            // close & fill
            let endPoint = CGPoint(x: lastPoint.x, y: startPoint.y)
            trend.addLine(to: endPoint)
            trend.close()
            tintColor.setStroke()
            trend.stroke()
        }
    }

    // swiftlint:disable:next function_body_length
    private func drawSimPart(from: Int, to: Int) {
        let context = UIGraphicsGetCurrentContext()!
        guard let dataSource = dataSource, to >= from else {
            return
        }
        // useful values
        let numberOfValues = dataSource.numberOfHorizontalAxis()
        let maxValue = dataSource.valueOfMaxVerticalAxis()
        let minValue = dataSource.valueOfMinVerticalAxis()
        let distance = bounds.height - referenceLineInset.bottom - referenceLineInset.top
        let valueDiff = maxValue - minValue
        let yScale = distance / valueDiff
        let xGap = (bounds.width - referenceLineInset.left - referenceLineInset.right) / CGFloat(numberOfValues - 1)

        guard let lastRealValue = dataSource.value(at: from - 1) else {
            return
        }
        let lastRealX = referenceLineInset.left + CGFloat(from - 1) * xGap
        let lastRealHeight = (lastRealValue - minValue) * yScale
        let lastRealTopY = bounds.height - referenceLineInset.bottom - lastRealHeight
        let lastRealTopPoint = CGPoint(x: lastRealX, y: lastRealTopY)

        let trend = UIBezierPath()
        trend.move(to: lastRealTopPoint)

        // find first point
        var minIndex: Int?
        for index in from...to {
            if dataSource.simValue(at: index) != nil {
                minIndex = index
                break
            }
        }
        guard let firstIndex = minIndex, let firstValue = dataSource.simValue(at: firstIndex) else {
            return
        }

        // draw first point & line
        let firstValueHeight = (firstValue - minValue) * yScale
        let firstPoint = CGPoint(x: referenceLineInset.left + CGFloat(firstIndex) * xGap,
                                 y: bounds.height - referenceLineInset.bottom - firstValueHeight)
        trend.addLine(to: firstPoint)

        // lastPoint
        var lastPoint = firstPoint

        // draw other point & lines
        if firstIndex + 1 <= to {
            for index in (firstIndex + 1)...to {
                if let value = dataSource.simValue(at: index) {
                    let valueHeight = (value - minValue) * yScale
                    let point = CGPoint(x: referenceLineInset.left + CGFloat(index) * xGap,
                                        y: bounds.height - referenceLineInset.bottom - valueHeight)
                    trend.addLine(to: point)
                    lastPoint = point
                }
            }
        }

        // close & fill
        let endPoint = CGPoint(x: lastPoint.x, y: bounds.height - referenceLineInset.bottom)
        trend.addLine(to: endPoint)
        tintColor.setStroke()
        context.saveGState()
        context.setLineDash(phase: 0, lengths: [2, 2])
        trend.stroke()
        context.restoreGState()
    }

    private func drawSimPartOnly(from: Int, to: Int) {
        let context = UIGraphicsGetCurrentContext()!
        if let dataSource = dataSource, to >= from {
            // useful values
            let numberOfValues = dataSource.numberOfHorizontalAxis()
            let maxValue = dataSource.valueOfMaxVerticalAxis()
            let minValue = dataSource.valueOfMinVerticalAxis()
            let distance = bounds.height - referenceLineInset.bottom - referenceLineInset.top
            let valueDiff = maxValue - minValue
            let yScale = distance / valueDiff
            let xGap = (bounds.width - referenceLineInset.left - referenceLineInset.right) / CGFloat(numberOfValues - 1)

            // find first point
            var minIndex: Int?
            for index in from...to {
                if dataSource.simValue(at: index) != nil {
                    minIndex = index
                    break
                }
            }
            guard let firstIndex = minIndex, let firstValue = dataSource.simValue(at: firstIndex) else {
                return
            }

            // draw first point & line
            let startPoint = CGPoint(x: referenceLineInset.left + CGFloat(firstIndex) * xGap,
                                     y: bounds.height - referenceLineInset.bottom)
            let firstValueHeight = (firstValue - minValue) * yScale
            let firstPoint = CGPoint(x: referenceLineInset.left + CGFloat(firstIndex) * xGap,
                                     y: bounds.height - referenceLineInset.bottom - firstValueHeight)
            let trend = UIBezierPath()
            trend.move(to: startPoint)
            trend.addLine(to: firstPoint)

            // lastPoint
            var lastPoint = firstPoint

            // draw other point & lines
            if firstIndex + 1 <= to {
                for index in (firstIndex + 1)...to {
                    if let value = dataSource.simValue(at: index) {
                        let valueHeight = (value - minValue) * yScale
                        let point = CGPoint(x: referenceLineInset.left + CGFloat(index) * xGap,
                                            y: bounds.height - referenceLineInset.bottom - valueHeight)
                        trend.addLine(to: point)
                        lastPoint = point
                    }
                }
            }

            // close & fill
            let endPoint = CGPoint(x: lastPoint.x, y: startPoint.y)
            trend.addLine(to: endPoint)
            tintColor.setStroke()
            context.saveGState()
            context.setLineDash(phase: 0, lengths: [2, 2])
            trend.stroke()
            context.restoreGState()
        }
    }
}
