//
//  MapAlertController.swift
//  disney
//
//  Created by ebuser on 2017/7/4.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class MapAlertController: FileLocalizable {

    let localizeFileName = "Map"

    private let alert: UIAlertController

    init() {
        alert = UIAlertController(title: nil,
                                  message: nil,
                                  preferredStyle: .actionSheet)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fastpassAction(_ handler: @escaping ((UIAlertAction) -> Swift.Void)) -> Self {
        let fastpassAction = UIAlertAction(title: localize(for: "Edit Menu Fastpass"),
                                           style: .default,
                                           handler: handler)
        alert.addAction(fastpassAction)
        return self
    }

    func cancelAction(_ handler: @escaping ((UIAlertAction) -> Swift.Void)) -> Self {
        let cancelAction = UIAlertAction(title: localize(for: "Edit Menu Cancel"),
                                         style: .cancel,
                                         handler: handler)
        alert.addAction(cancelAction)
        return self
    }

    func asAlertController() -> UIAlertController {
        return alert
    }
}
