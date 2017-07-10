//
//  SettingTimePanel.swift
//  disney
//
//  Created by ebuser on 2017/7/5.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxSwift
import UIKit

//swiftlint:disable type_body_length file_length
class SettingTimePanel: UIView {

    let disposeBag = DisposeBag()

    let counterColor = UIColor.white
    let panelSize = CGSize(width: UIScreen.main.bounds.width * 0.85,
                           height: UIScreen.main.bounds.width * 0.85)

    // 开闭园时间，需要外部进行设置
    let openCloseTime: Variable<(open: Float, close: Float)> = Variable((8, 22))

    // 入退园时间，内部设置，外部读取
    let inOutTime: Variable<(in: Float, out: Float)> = {
        if let inDate = Preferences.shared.visitStart.value,
            let outDate = Preferences.shared.visitEnd.value {
            let calendar = Calendar.current
            let inComponents = calendar.dateComponents(in: TimeZone(secondsFromGMT: 3600 * 9)!, from: inDate)
            let outComponents = calendar.dateComponents(in: TimeZone(secondsFromGMT: 3600 * 9)!, from: outDate)
            if let inHour = inComponents.hour,
                let inMinute = inComponents.minute,
                let outHour = outComponents.hour,
                let outMinute = outComponents.minute {
                let fin = Float(inHour) + Float(inMinute) / 60
                let fout = Float(outHour) + Float(outMinute) / 60
                return Variable((in: fin, out: fout))
            } else {
                return Variable((in: 10, out: 18))
            }
        } else {
            return Variable((in: 10, out: 18))
        }
    }()

    //swiftlint:disable:next identifier_name
    let π = CGFloat.pi
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
    // 拖拽图标大小
    let iconSize = CGSize(width: 24, height: 24)
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
    // 选中区域高亮层
    let highlightLayer = CAShapeLayer()
    // 入园拖动点层
    let anchorInLayer = CAShapeLayer()
    // 退园拖动点层
    let anchorOutLayer = CAShapeLayer()

    var moveBeginPoint: CGPoint?
    var moveBeginTime: (in: Float, out: Float)?
    fileprivate var moveState = MoveState.none

    fileprivate enum MoveState {
        case together
        case inOnly
        case outOnly
        case none
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(whiteCircleLayer)
        layer.addSublayer(lockCircleLayer)
        layer.addSublayer(openTimeLayer)
        layer.addSublayer(tickLayer)
        layer.addSublayer(highlightLayer)
        layer.addSublayer(anchorInLayer)
        layer.addSublayer(anchorOutLayer)
        textLayers.forEach { layer.addSublayer($0) }

        // 开闭园时间监听
        openCloseTime
            .asObservable()
            .subscribe { [weak self] _ in
                self?.updateOpenTimeLayer()
            }
            .addDisposableTo(disposeBag)

        // 入退园时间监听
        inOutTime
            .asObservable()
            .subscribe { [weak self] _ in
                self?.updateHighlightLayer()
                self?.updateAnchorLayers()
            }
            .addDisposableTo(disposeBag)

        let moveTogetherGesture = UIPanGestureRecognizer(target: self, action: #selector(moveTogether(_:)))
        moveTogetherGesture.delegate = self
        addGestureRecognizer(moveTogetherGesture)
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
        updateHighlightLayer()
        updateAnchorLayers()
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

    //swiftlint:disable:next function_body_length
    private func updateHighlightLayer() {
        let R = min(bounds.width, bounds.height) / 2
        let r = R - circleWidth
        let arcIn = clockArcAt(time: inOutTime.value.in)
        let arcOut = clockArcAt(time: inOutTime.value.out)
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        let pointInOuter = CGPoint(x: center.x + cos(arcIn) * R,
                                   y: center.y + sin(arcIn) * R)
        let pointInInner = CGPoint(x: center.x + cos(arcIn) * r,
                                   y: center.y + sin(arcIn) * r)
        let pointOutOuter = CGPoint(x: center.x + cos(arcOut) * R,
                                    y: center.y + sin(arcOut) * R)
        let pointOutInner = CGPoint(x: center.x + cos(arcOut) * r,
                                    y: center.y + sin(arcOut) * r)
        let centerIn = CGPoint.midOf(x: pointInOuter, y: pointInInner)
        let centerOut = CGPoint.midOf(x: pointOutOuter, y: pointOutInner)
        let path = UIBezierPath()
        path.move(to: pointInOuter)
        path.addLine(to: pointInInner)
        path.addArc(withCenter: center,
                    radius: r,
                    startAngle: arcIn,
                    endAngle: arcOut,
                    clockwise: true)
        path.addLine(to: pointOutOuter)
        path.addArc(withCenter: center,
                    radius: R,
                    startAngle: arcOut,
                    endAngle: arcIn,
                    clockwise: false)

        let circleIn = UIBezierPath()
        circleIn.addArc(withCenter: centerIn,
                        radius: circleWidth * 0.5,
                        startAngle: 0,
                        endAngle: π * 2,
                        clockwise: true)
        let circleInLayer = CAShapeLayer()
        circleInLayer.path = circleIn.cgPath
        circleInLayer.fillColor = DefaultStyle.primaryColor.cgColor
        let circleOut = UIBezierPath()
        circleOut.addArc(withCenter: centerOut,
                         radius: circleWidth * 0.5,
                         startAngle: 0,
                         endAngle: π * 2,
                         clockwise: true)
        let circleOutLayer = CAShapeLayer()
        circleOutLayer.path = circleOut.cgPath
        circleOutLayer.fillColor = DefaultStyle.primaryColor.cgColor
        highlightLayer.path = path.cgPath
        highlightLayer.fillColor = DefaultStyle.primaryColor.cgColor
        if let sublayers = highlightLayer.sublayers {
            sublayers.forEach {
                $0.removeFromSuperlayer()
            }
        }
        highlightLayer.addSublayer(circleInLayer)
        highlightLayer.addSublayer(circleOutLayer)
    }

    private func updateAnchorLayers() {
        let R = min(bounds.width, bounds.height) / 2 - circleWidth / 2
        let arcIn = clockArcAt(time: inOutTime.value.in)
        let arcOut = clockArcAt(time: inOutTime.value.out)
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        // 入园
        let centerIn = CGPoint(x: center.x + R * cos(arcIn),
                               y: center.y + R * sin(arcIn))
        let sizeIn = CGSize(width: arcWidth, height: arcWidth)
        let inImageLayer = CALayer()
        let inMaskLayer = CALayer()
        inImageLayer.frame = CGRect(center: centerIn, size: iconSize)
        inMaskLayer.frame = CGRect(origin: .zero, size: inImageLayer.bounds.size)
        inMaskLayer.contents = #imageLiteral(resourceName: "ic_timer_black_24px").cgImage
        inImageLayer.mask = inMaskLayer
        inImageLayer.backgroundColor = UIColor.white.cgColor
        let inCircleFrame = CGRect(center: centerIn, size: sizeIn)
        let pathOvalIn = UIBezierPath(ovalIn: inCircleFrame)
        anchorInLayer.path = pathOvalIn.cgPath
        anchorInLayer.fillColor = DefaultStyle.darkPrimaryColor.cgColor
        if let subLayers = anchorInLayer.sublayers {
            subLayers.forEach {
                $0.removeFromSuperlayer()
            }
        }
        anchorInLayer.addSublayer(inImageLayer)
        // 退园
        let centerOut = CGPoint(x: center.x + R * cos(arcOut),
                               y: center.y + R * sin(arcOut))
        let sizeOut = CGSize(width: arcWidth, height: arcWidth)
        let outImageLayer = CALayer()
        let outMaskLayer = CALayer()
        outImageLayer.frame = CGRect(center: centerOut, size: iconSize)
        outMaskLayer.frame = CGRect(origin: .zero, size: outImageLayer.bounds.size)
        outMaskLayer.contents = #imageLiteral(resourceName: "ic_timer_off_black_24px").cgImage
        outImageLayer.mask = outMaskLayer
        outImageLayer.backgroundColor = UIColor.white.cgColor
        let outCircleFrame = CGRect(center: centerOut, size: sizeOut)
        let pathOvalOut = UIBezierPath(ovalIn: outCircleFrame)
        anchorOutLayer.path = pathOvalOut.cgPath
        anchorOutLayer.fillColor = DefaultStyle.darkPrimaryColor.cgColor
        if let subLayers = anchorOutLayer.sublayers {
            subLayers.forEach {
                $0.removeFromSuperlayer()
            }
        }
        anchorOutLayer.addSublayer(outImageLayer)
    }

    private func clockArcAt(index: Int) -> CGFloat {
        return (0.125 * CGFloat(index) - 0.5) * π
    }

    private func clockArcAt(time: Float) -> CGFloat {
        return (0.125 * (CGFloat(time) - 7) - 0.5) * π
    }

    private func clockArcAt(point: CGPoint) -> CGFloat {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let dx = point.x - center.x
        let dy = point.y - center.y
        if dx == 0 && dy == 0 {
            return -99999
        } else if dx == 0 {
            if dy > 0 {
                return π * 0.5
            } else {
                return -π * 0.5
            }
        } else if dy == 0 {
            if dx > 0 {
                return 0
            } else {
                return π
            }
        } else {
            let tan = dy / dx
            if dx > 0 {
                return atan(tan)
            } else {
                return atan(tan) + π
            }
        }
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

extension SettingTimePanel: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: self)
        if anchorInLayer.path?.contains(point) ?? false ||
            anchorOutLayer.path?.contains(point) ?? false ||
            highlightLayer.path?.contains(point) ?? false {
            return true
        } else {
            return false
        }
    }

    @objc
    func moveTogether(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let position = sender.location(in: self)
            if let inPath = anchorInLayer.path,
                inPath.contains(position) {
                // 入园时间单独移动
                moveState = .inOnly
            } else if let outPath = anchorOutLayer.path,
                outPath.contains(position) {
                // 退园时间单独移动
                moveState = .outOnly
            } else {
                // 出退园同时移动
                moveState = .together
            }
            moveBeginPoint = position
            moveBeginTime = (inOutTime.value.in, inOutTime.value.out)
        case .changed:
            let position = sender.location(in: self)
            switch moveState {
            case .inOnly:
                moveOnlyIn(to: position)
            case .outOnly:
                moveOnlyOut(to: position)
            case .together:
                moveTogether(to: position)
            case .none:
                break
            }
        case .ended:
            moveState = .none
        default:
            break
        }
    }

    func moveTogether(to newPoint: CGPoint) {
        guard let moveBeginPoint = moveBeginPoint else { return }
        guard let moveBeginTime = moveBeginTime else { return }
        let visitPeriod = moveBeginTime.out - moveBeginTime.in
        let darc = clockArcAt(point: newPoint) - clockArcAt(point: moveBeginPoint)
        let dperc = darc / (1.75 * π)
        let dtime = Float(14 * dperc)
        // 检查是否越界
        if moveBeginTime.in + dtime <= openCloseTime.value.open {
            // 最小值越界
            let inTimeValue = openCloseTime.value.open
            let outTimeValue = inTimeValue + visitPeriod
            inOutTime.value = (inTimeValue, outTimeValue)
        } else if moveBeginTime.out + dtime >= openCloseTime.value.close {
            // 最大值越界
            let outTimeValue = openCloseTime.value.close
            let inTimeValue = outTimeValue - visitPeriod
            inOutTime.value = (inTimeValue, outTimeValue)
        } else {
            // 正常移动
            let inTimeValue = moveBeginTime.in + dtime
            let outTimeValue = moveBeginTime.out + dtime
            inOutTime.value = (inTimeValue, outTimeValue)
        }
    }

    func moveOnlyIn(to newPoint: CGPoint) {
        guard let moveBeginPoint = moveBeginPoint else { return }
        guard let moveBeginTime = moveBeginTime else { return }
        let darc = clockArcAt(point: newPoint) - clockArcAt(point: moveBeginPoint)
        let dperc = darc / (1.75 * π)
        let dtime = Float(14 * dperc)
        // 检查是否越界
        if moveBeginTime.in + dtime <= openCloseTime.value.open {
            // 最小值越界
            let inTimeValue = openCloseTime.value.open
            let outTimeValue = moveBeginTime.out
            inOutTime.value = (inTimeValue, outTimeValue)
        } else if moveBeginTime.in + dtime >= moveBeginTime.out {
            // 最大值越界
            let outTimeValue = moveBeginTime.out
            let inTimeValue = moveBeginTime.out
            inOutTime.value = (inTimeValue, outTimeValue)
        } else {
            // 正常移动
            let inTimeValue = moveBeginTime.in + dtime
            let outTimeValue = moveBeginTime.out
            inOutTime.value = (inTimeValue, outTimeValue)
        }
    }

    func moveOnlyOut(to newPoint: CGPoint) {
        guard let moveBeginPoint = moveBeginPoint else { return }
        guard let moveBeginTime = moveBeginTime else { return }
        let darc = clockArcAt(point: newPoint) - clockArcAt(point: moveBeginPoint)
        let dperc = darc / (1.75 * π)
        let dtime = Float(14 * dperc)
        // 检查是否越界
        if moveBeginTime.out + dtime <= moveBeginTime.in {
            // 最小值越界
            let inTimeValue = moveBeginTime.in
            let outTimeValue = moveBeginTime.in
            inOutTime.value = (inTimeValue, outTimeValue)
        } else if moveBeginTime.out + dtime >= openCloseTime.value.close {
            // 最大值越界
            let outTimeValue = openCloseTime.value.close
            let inTimeValue = moveBeginTime.in
            inOutTime.value = (inTimeValue, outTimeValue)
        } else {
            // 正常移动
            let inTimeValue = moveBeginTime.in
            let outTimeValue = moveBeginTime.out + dtime
            inOutTime.value = (inTimeValue, outTimeValue)
        }
    }
}
