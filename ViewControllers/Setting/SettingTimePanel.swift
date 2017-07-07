//
//  SettingTimePanel.swift
//  disney
//
//  Created by ebuser on 2017/7/5.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxSwift
import UIKit

class SettingTimePanel: UIView {

    let disposeBag = DisposeBag()

    let counterColor = UIColor.white
    let panelSize = CGSize(width: UIScreen.main.bounds.width * 0.85,
                           height: UIScreen.main.bounds.width * 0.85)

    // 开闭园时间，需要外部进行设置
    let openCloseTime: Variable<(Float, Float)> = Variable((8, 22))

    // 入退园时间，内部设置，外部读取
    let inTime: Variable<CGFloat> = Variable(9)
    let outTime: Variable<CGFloat> = Variable(21)

    // 外圈宽
    let circleWidth: CGFloat = 42
    // 内圈宽
    let arcWidth: CGFloat = 40
    // 刻度线与表盘间距
    let clocklineGap: CGFloat = 1
    // 刻度线长
    let clocklineLength: CGFloat = 4
    // 刻度文字字号
    let textLayerFontSize: CGFloat = 13
    // 刻度文字与表盘间距
    let textLayerGap: CGFloat = 15
    // 最下层
    let whiteCircleLayer = CAShapeLayer()
    // 锁定颜色层
    let lockCircleLayer = CAShapeLayer()
    // 可用颜色层
    let openTimeLayer = CAShapeLayer()
    // 刻度层
    let tickLayer = CAShapeLayer()
    // 刻度文字层
    let textLayers: [CATextLayer] = {
        var layers = [CATextLayer]()
        for _ in 0..<16 {
            layers.append(CATextLayer())
        }
        return layers
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(whiteCircleLayer)
        layer.addSublayer(lockCircleLayer)
        layer.addSublayer(openTimeLayer)
        layer.addSublayer(tickLayer)
        textLayers.forEach { layer.addSublayer($0) }

        // 开闭园时间监视
        openCloseTime
            .asObservable()
            .subscribe { [weak self] _ in
                self?.updateOpenTimeLayer()
            }
            .addDisposableTo(disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateLayers()
    }

    override var intrinsicContentSize: CGSize {
        return panelSize
    }

    private func updateLayers() {
        updateWhiteCircleLayer()
        updateLockCircleLayer()
        updateOpenTimeLayer()
        updateTickLayer()
        updateTextLayers()
    }

    private func updateWhiteCircleLayer() {
        let rect = CGRect(origin: CGPoint(x: circleWidth / 2, y: circleWidth / 2),
                          size: CGSize(width: bounds.width - circleWidth, height: bounds.height - circleWidth))
        let path = UIBezierPath(ovalIn: rect)

        whiteCircleLayer.path = path.cgPath
        whiteCircleLayer.lineWidth = circleWidth
        whiteCircleLayer.strokeColor = UIColor.white.cgColor
        whiteCircleLayer.fillColor = nil
    }

    private func updateLockCircleLayer() {
        let lockCircleWidth = arcWidth
        let rect = CGRect(origin: CGPoint(x: circleWidth / 2, y: circleWidth / 2),
                          size: CGSize(width: bounds.width - circleWidth, height: bounds.height - circleWidth))
        let path = UIBezierPath(ovalIn: rect)

        lockCircleLayer.path = path.cgPath
        lockCircleLayer.lineWidth = lockCircleWidth
        lockCircleLayer.strokeColor = DefaultStyle.viewBackgroundColor.cgColor
        lockCircleLayer.fillColor = nil
    }

    private func updateOpenTimeLayer() {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = (min(bounds.width, bounds.height) - circleWidth) / 2
        let startAngle = clockArcAt(time: openCloseTime.value.0)
        let endAngle = clockArcAt(time: openCloseTime.value.1)
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)

        openTimeLayer.path = path.cgPath
        openTimeLayer.lineWidth = arcWidth
        openTimeLayer.strokeColor = UIColor.white.cgColor
        openTimeLayer.lineCap = kCALineCapRound
        openTimeLayer.fillColor = nil
    }

    private func updateTickLayer() {
        let path = UIBezierPath()
        for index in 0..<16 {
            let start = startPointAt(index: index)
            let end = endPointAt(index: index)
            path.move(to: start)
            path.addLine(to: end)
        }
        tickLayer.path = path.cgPath
        tickLayer.lineWidth = 1
        tickLayer.strokeColor = DefaultStyle.darkPrimaryColor.cgColor
        tickLayer.fillColor = nil
    }

    private func updateTextLayers() {
        for (index, textlayer) in textLayers.enumerated() {
            let center = centerForTextAt(index: index)
            let text = textAt(index: index)
            let font = UIFont.systemFont(ofSize: textLayerFontSize)
            let textSize = text.size(withAttributes: [.font: font])

            textlayer.frame = CGRect(center: center,
                                     size: textSize)
            let fontName = font.fontName as NSString
            textlayer.font = CTFontCreateWithName(fontName, textLayerFontSize, nil)
            textlayer.string = text
            textlayer.fontSize = textLayerFontSize
            textlayer.foregroundColor = DefaultStyle.darkPrimaryColor.cgColor
            textlayer.contentsScale = UIScreen.main.scale
        }
    }

    private func clockArcAt(index: Int) -> CGFloat {
        let π = CGFloat.pi
        return (0.125 * CGFloat(index) - 0.5) * π
    }

    private func clockArcAt(time: Float) -> CGFloat {
        let π = CGFloat.pi
        return (0.125 * (CGFloat(time) - 7) - 0.5) * π
    }

    private func startPointAt(index: Int) -> CGPoint {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let innerRadius = min(bounds.width, bounds.height) / 2 - circleWidth - clocklineGap
        let arc = clockArcAt(index: index)
        let x = center.x + cos(arc) * innerRadius
        let y = center.y + sin(arc) * innerRadius
        return CGPoint(x: x, y: y)
    }

    private func endPointAt(index: Int) -> CGPoint {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let innerRadius = min(bounds.width, bounds.height) / 2 - circleWidth - clocklineGap - clocklineLength
        let arc = clockArcAt(index: index)
        let x = center.x + cos(arc) * innerRadius
        let y = center.y + sin(arc) * innerRadius
        return CGPoint(x: x, y: y)
    }

    private func centerForTextAt(index: Int) -> CGPoint {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let innerRadius = min(bounds.width, bounds.height) / 2 - circleWidth - textLayerGap
        let arc = clockArcAt(index: index)
        let x = center.x + cos(arc) * innerRadius
        let y = center.y + sin(arc) * innerRadius
        return CGPoint(x: x, y: y)
    }

    private func textAt(index: Int) -> NSString {
        if index == 0 {
            return "..."
        } else {
            return "\(index + 7)" as NSString
        }
    }
}
