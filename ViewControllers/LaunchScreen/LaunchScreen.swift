//
//  LaunchScreen.swift
//  disney
//
//  Created by ebuser on 2017/5/18.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

// swiftlint:disable file_length
class LaunchScreenViewController: UIViewController, FileLocalizable {

    let localizeFileName = "Main"

    private let icon: ResizableIcon
    private let msg: UILabel
    private let alert: UILabel

    private var iconWidthConstraint: NSLayoutConstraint?
    private var iconHeightConstraint: NSLayoutConstraint?

    // 共享锁，防止多次请求API
    private var checked = false {
        didSet {
            if checked {
                msg.removeFromSuperview()
            }
        }
    }

    private let reachabilityManager = NetworkReachabilityManager(host: NetworkConstants.reachabilityTestURL)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        icon = ResizableIcon(frame: .zero)
        msg = UILabel(frame: .zero)
        alert = UILabel(frame: .zero)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        view.backgroundColor = UIColor(hex: "C770FC")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubIcon()
        addSubMsg()
        addSubAlert()

        if let reachable = reachabilityManager?.isReachable, !reachable {
            showNetworkUnReachable()
        }

        reachabilityManager?.listener = { [weak self] status in
            if let strongSelf = self {
                switch status {
                case .reachable:
                    strongSelf.hideNetworkUnReachable()
                    strongSelf.requestAppAvailable()
                case .unknown, .notReachable:
                    strongSelf.showNetworkUnReachable()
                }
            }
        }
        reachabilityManager?.startListening()
    }

    private func addSubIcon() {
        view.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        iconWidthConstraint = icon.widthAnchor.constraint(equalToConstant: 120)
        iconWidthConstraint?.isActive = true
        iconHeightConstraint = icon.heightAnchor.constraint(equalToConstant: 120)
        iconHeightConstraint?.isActive = true
    }

    private func addSubMsg() {
        msg.textColor = UIColor.white
        msg.numberOfLines = 0
        view.addSubview(msg)
        msg.translatesAutoresizingMaskIntoConstraints = false
        msg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        msg.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12).isActive = true
    }

    private func addSubAlert() {
        alert.font = UIFont.boldSystemFont(ofSize: 14)
        alert.textColor = UIColor.white
        alert.numberOfLines = 0
        alert.text = localize(for: "App version is too low, press to update")
        alert.isHidden = true
        view.addSubview(alert)
        alert.translatesAutoresizingMaskIntoConstraints = false
        alert.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alert.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true

        let tapGestureRecognizer = UITapGestureRecognizer()
        alert.isUserInteractionEnabled = true
        tapGestureRecognizer.addTarget(self, action: #selector(redirectToAppStore))
        alert.addGestureRecognizer(tapGestureRecognizer)
    }

    private func requestAppAvailable() {
        if checked { return }

        let versionCheck = API.VersionCheck()

        versionCheck.request { [weak self] data in
            if let strongSelf = self {
                guard let versions: [VersionStatus] = VersionStatus.array(dataResponse: data) else {
                    strongSelf.showServerError()
                    return
                }
                if !strongSelf.checked {
                    strongSelf.checked = true
                    if let currentVersion = versions.first(where: {
                        $0.version == NetworkConstants.rawVersion
                    }) {
                        if currentVersion.available {
                            // 可用版本
                            strongSelf.switchToNext()
                        } else {
                            // 版本过期
                            strongSelf.showNeedToUpdate()
                        }
                    } else {
                        // 没有相应的版本号
                        strongSelf.showServerError()
                    }
                }
            }
        }
    }

    private func showServerError() {
        showMessage(localize(for: "Server error"))
    }

    private func showNetworkUnReachable() {
        showMessage(localize(for: "Cannot connect to network"))
    }

    private func hideNetworkUnReachable() {
        showMessage(nil)
    }

    private func showMessage(_ text: String?) {
        if !checked {
            msg.text = text
        }
    }

    fileprivate func switchToNext() {
        guard let window = UIApplication.shared.keyWindow else { return }
        var rootVC: UIViewController!
        if !self.isVisitorTagAssigned() {
            // 用户选择标签
            let visitorTagVC = VisitorTagVC()
            rootVC = NavigationVC(rootViewController: visitorTagVC)
            rootVC.loadViewIfNeeded()

            visitorTagVC.loadViewIfNeeded()
        } else {
            // 主功能
            rootVC = TabVC()
        }

        iconAnimate { _ in
            window.rootViewController = rootVC
        }
    }

    fileprivate func iconAnimate(_ completionHandler: @escaping (Bool) -> Void) {
        UIView.animateKeyframes(withDuration: 1.25,
                                delay: 0,
                                options: [.calculationModeLinear],
                                animations: { [unowned self] in
                                    self.iconWidthConstraint?.constant = 80
                                    self.iconHeightConstraint?.constant = 80
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                        relativeDuration: 0.6,
                                        animations: {
                                            self.view.layoutIfNeeded()
                                    })
                                    self.iconWidthConstraint?.constant = 2000
                                    self.iconHeightConstraint?.constant = 2000
                                    UIView.addKeyframe(withRelativeStartTime: 0.6,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        self.view.layoutIfNeeded()
                                                        self.icon.alpha = 0
                                                        self.view.backgroundColor = UIColor.white
                                    })
                                },
                                completion: completionHandler)

    }

    fileprivate func showNeedToUpdate() {
        if let url = URL(string: NetworkConstants.appStoreURL),
            UIApplication.shared.canOpenURL(url) {

            let text = localize(for: "App version is too low") + "\n" + localize(for: "Press here to update")
            alert.text = text
            alert.isHidden = false
        } else {
            alert.text = localize(for: "App version is too low")
            alert.isHidden = false
        }
    }

    @objc
    func redirectToAppStore() {
        if let url = URL(string: NetworkConstants.appStoreURL),
            UIApplication.shared.canOpenURL(url) {

            UIApplication.shared.openURL(url)

        }
    }

    private func isVisitorTagAssigned() -> Bool {
        guard let date = UserDefaults.standard[.visitDate] as? Date else {
            return false
        }
        guard UserDefaults.standard[.visitPark] as? String != nil else {
            return false
        }
        let now = Date()
        let calendar = Calendar.current
        guard let timeZone = TimeZone(secondsFromGMT: 3600 * 9) else {
            return false
        }
        let tagComponents = calendar.dateComponents(in: timeZone, from: date)
        let nowComponents = calendar.dateComponents(in: timeZone, from: now)
        guard let tagYear = tagComponents.year, let tagMonth = tagComponents.month, let tagDay = tagComponents.day else {
            return false
        }
        guard let nowYear = nowComponents.year, let nowMonth = nowComponents.month, let nowDay = nowComponents.day else {
            return false
        }
        if tagYear < nowYear {
            return false
        } else if tagYear > nowYear {
            return true
        }
        if tagMonth < nowMonth {
            return false
        } else if tagMonth > nowMonth {
            return true
        }
        if tagDay < nowDay {
            return false
        }
        return true
    }

}

fileprivate struct VersionStatus: SwiftJSONDecodable {
    let version: String
    let available: Bool

    init?(_ json: JSON) {
        guard let version = json["version"].string else { return nil }
        self.version = version

        guard let available = json["available"].bool else { return nil }
        self.available = available
    }
}

private class ResizableIcon: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentMode = .redraw
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // swiftlint:disable function_body_length
    override func draw(_ rect: CGRect) {
        drawCanvas(frame: rect)
    }

    func drawCanvas(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 111, height: 97), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 120, height: 120), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 120, y: resizedFrame.height / 120)

        //// Color Declarations
        let fillColor = UIColor.white

        //// Group 2
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 59.08, y: 105.73))
        bezierPath.addCurve(to: CGPoint(x: 27, y: 73.64), controlPoint1: CGPoint(x: 41.36, y: 105.73), controlPoint2: CGPoint(x: 27, y: 91.36))
        bezierPath.addCurve(to: CGPoint(x: 59.08, y: 41.56), controlPoint1: CGPoint(x: 27, y: 55.93), controlPoint2: CGPoint(x: 41.36, y: 41.56))
        bezierPath.addCurve(to: CGPoint(x: 91.17, y: 73.64), controlPoint1: CGPoint(x: 76.8, y: 41.56), controlPoint2: CGPoint(x: 91.17, y: 55.93))
        bezierPath.addCurve(to: CGPoint(x: 59.08, y: 105.73), controlPoint1: CGPoint(x: 91.17, y: 91.36), controlPoint2: CGPoint(x: 76.8, y: 105.73))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 59.08, y: 99.31))
        bezierPath.addCurve(to: CGPoint(x: 84.75, y: 73.64), controlPoint1: CGPoint(x: 73.26, y: 99.31), controlPoint2: CGPoint(x: 84.75, y: 87.82))
        bezierPath.addCurve(to: CGPoint(x: 59.08, y: 47.98), controlPoint1: CGPoint(x: 84.75, y: 59.47), controlPoint2: CGPoint(x: 73.26, y: 47.98))
        bezierPath.addCurve(to: CGPoint(x: 33.42, y: 73.64), controlPoint1: CGPoint(x: 44.91, y: 47.98), controlPoint2: CGPoint(x: 33.42, y: 59.47))
        bezierPath.addCurve(to: CGPoint(x: 59.08, y: 99.31), controlPoint1: CGPoint(x: 33.42, y: 87.82), controlPoint2: CGPoint(x: 44.91, y: 99.31))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        fillColor.setFill()
        bezierPath.fill()

        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 59.08, y: 105.73))
        bezier2Path.addCurve(to: CGPoint(x: 43.04, y: 73.64), controlPoint1: CGPoint(x: 49.34, y: 98.41), controlPoint2: CGPoint(x: 43.04, y: 86.76))
        bezier2Path.addCurve(to: CGPoint(x: 59.08, y: 41.56), controlPoint1: CGPoint(x: 43.04, y: 60.53), controlPoint2: CGPoint(x: 49.34, y: 48.88))
        bezier2Path.addCurve(to: CGPoint(x: 68.92, y: 43.1), controlPoint1: CGPoint(x: 62.52, y: 41.56), controlPoint2: CGPoint(x: 65.82, y: 42.1))
        bezier2Path.addCurve(to: CGPoint(x: 49.46, y: 73.64), controlPoint1: CGPoint(x: 57.43, y: 48.46), controlPoint2: CGPoint(x: 49.46, y: 60.12))
        bezier2Path.addCurve(to: CGPoint(x: 68.92, y: 104.19), controlPoint1: CGPoint(x: 49.46, y: 87.17), controlPoint2: CGPoint(x: 57.43, y: 98.83))
        bezier2Path.addCurve(to: CGPoint(x: 59.08, y: 105.73), controlPoint1: CGPoint(x: 65.82, y: 105.19), controlPoint2: CGPoint(x: 62.52, y: 105.73))
        bezier2Path.addLine(to: CGPoint(x: 59.08, y: 105.73))
        bezier2Path.close()
        bezier2Path.usesEvenOddFillRule = true
        fillColor.setFill()
        bezier2Path.fill()

        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 59.61, y: 41.57))
        bezier3Path.addCurve(to: CGPoint(x: 75.64, y: 73.64), controlPoint1: CGPoint(x: 69.35, y: 48.88), controlPoint2: CGPoint(x: 75.64, y: 60.53))
        bezier3Path.addCurve(to: CGPoint(x: 59.61, y: 105.72), controlPoint1: CGPoint(x: 75.64, y: 86.76), controlPoint2: CGPoint(x: 69.35, y: 98.41))
        bezier3Path.addCurve(to: CGPoint(x: 59.08, y: 105.73), controlPoint1: CGPoint(x: 59.44, y: 105.73), controlPoint2: CGPoint(x: 59.26, y: 105.73))
        bezier3Path.addCurve(to: CGPoint(x: 49.55, y: 104.29), controlPoint1: CGPoint(x: 55.76, y: 105.73), controlPoint2: CGPoint(x: 52.56, y: 105.22))
        bezier3Path.addCurve(to: CGPoint(x: 69.23, y: 73.64), controlPoint1: CGPoint(x: 61.16, y: 98.97), controlPoint2: CGPoint(x: 69.23, y: 87.25))
        bezier3Path.addCurve(to: CGPoint(x: 49.55, y: 43), controlPoint1: CGPoint(x: 69.23, y: 60.04), controlPoint2: CGPoint(x: 61.16, y: 48.32))
        bezier3Path.addCurve(to: CGPoint(x: 59.08, y: 41.56), controlPoint1: CGPoint(x: 52.56, y: 42.07), controlPoint2: CGPoint(x: 55.76, y: 41.56))
        bezier3Path.addCurve(to: CGPoint(x: 59.61, y: 41.57), controlPoint1: CGPoint(x: 59.26, y: 41.56), controlPoint2: CGPoint(x: 59.44, y: 41.56))
        bezier3Path.close()
        bezier3Path.usesEvenOddFillRule = true
        fillColor.setFill()
        bezier3Path.fill()

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 30.75, y: 61.35, width: 57.2, height: 6.4))
        fillColor.setFill()
        rectanglePath.fill()

        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 30.75, y: 81.15, width: 57.2, height: 6.4))
        fillColor.setFill()
        rectangle2Path.fill()

        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 76.9, y: 47.08))
        bezier4Path.addCurve(to: CGPoint(x: 78, y: 18.42), controlPoint1: CGPoint(x: 69.45, y: 37.55), controlPoint2: CGPoint(x: 69.94, y: 24.72))
        bezier4Path.addCurve(to: CGPoint(x: 106.07, y: 24.29), controlPoint1: CGPoint(x: 86.05, y: 12.13), controlPoint2: CGPoint(x: 98.62, y: 14.76))
        bezier4Path.addCurve(to: CGPoint(x: 104.97, y: 52.95), controlPoint1: CGPoint(x: 113.52, y: 33.82), controlPoint2: CGPoint(x: 113.03, y: 46.65))
        bezier4Path.addCurve(to: CGPoint(x: 76.9, y: 47.08), controlPoint1: CGPoint(x: 96.91, y: 59.24), controlPoint2: CGPoint(x: 84.35, y: 56.62))
        bezier4Path.close()
        bezier4Path.move(to: CGPoint(x: 41.27, y: 47.08))
        bezier4Path.addCurve(to: CGPoint(x: 13.2, y: 52.95), controlPoint1: CGPoint(x: 33.82, y: 56.62), controlPoint2: CGPoint(x: 21.25, y: 59.24))
        bezier4Path.addCurve(to: CGPoint(x: 12.1, y: 24.29), controlPoint1: CGPoint(x: 5.14, y: 46.65), controlPoint2: CGPoint(x: 4.65, y: 33.82))
        bezier4Path.addCurve(to: CGPoint(x: 40.17, y: 18.42), controlPoint1: CGPoint(x: 19.54, y: 14.76), controlPoint2: CGPoint(x: 32.11, y: 12.13))
        bezier4Path.addCurve(to: CGPoint(x: 41.27, y: 47.08), controlPoint1: CGPoint(x: 48.22, y: 24.72), controlPoint2: CGPoint(x: 48.72, y: 37.55))
        bezier4Path.close()
        bezier4Path.usesEvenOddFillRule = true
        fillColor.setFill()
        bezier4Path.fill()

        context.restoreGState()
    }

    public enum ResizingBehavior {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
