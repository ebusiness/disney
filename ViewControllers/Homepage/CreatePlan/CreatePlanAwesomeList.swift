//
//  CreatePlanAwesomeList.swift
//  disney
//
//  Created by ebuser on 2017/7/13.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

final class CreatePlanAwesomeList: UIVisualEffectView {

    var levelPoint: LevelPoint = {
        let top = CGPoint(x: 0, y: 120)
        let mid = CGPoint(x: 0, y: (UIScreen.main.bounds.height - 44 + 120) / 2 )
        let bottom = CGPoint(x: 0, y: UIScreen.main.bounds.height - 44)
        return LevelPoint(top: top, mid: mid, bottom: bottom)
    }()

    let header: CreatePlanAwesomeHeader
    let tableView: UITableView
    let dragHeader = UIPanGestureRecognizer()
    private var dragHeaderBeginPoint: CGPoint?

    init() {
        header = CreatePlanAwesomeHeader(frame: .zero)
        tableView = UITableView(frame: .zero, style: .plain)
        let blurEffect = UIBlurEffect(style: .extraLight)
        super.init(effect: blurEffect)

        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.backgroundColor = UIColor(baseColor: UIColor.white, alpha: 0.5).cgColor

        addSubHeader()
        addSubTableView()
        addDragHeaderGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubHeader() {
        contentView.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        header.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }

    private func addSubTableView() {
        tableView.backgroundColor = nil
        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    private func addDragHeaderGesture() {
        dragHeader.addTarget(self, action: #selector(dragHeaderHandler(_:)))
        header.addGestureRecognizer(dragHeader)
    }

    @objc
    private func dragHeaderHandler(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            dragHeaderBeginPoint = sender.location(in: self)
        case .changed:
            guard let dragHeaderBeginPoint = dragHeaderBeginPoint else { break }
            let deltav = sender.location(in: self).y - dragHeaderBeginPoint.y
            frame = CGRect(origin: CGPoint(x: frame.origin.x,
                                           y: frame.origin.y + deltav),
                           size: frame.size)
            let velocity = sender.velocity(in: self)
            print("velocity is \(velocity)")
        case .ended:
            break
        default:
            break
        }
    }

    struct LevelPoint {
        let top: CGPoint
        let mid: CGPoint
        let bottom: CGPoint
    }

}
