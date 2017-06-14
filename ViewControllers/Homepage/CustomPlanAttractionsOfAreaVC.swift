//
//  CustomPlanAttractionsOfAreaVC.swift
//  disney
//
//  Created by ebuser on 2017/6/14.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class CustomPlanAttractionsOfAreaVC: UIViewController {

    let tableView: UITableView
    let identifier = "identifier"
    var listData: CustomPlanAttractionsOfAreaList?

    let sectionHeaderColors = [
        UIColor(hex: "F44336"),
        UIColor(hex: "4CAF50"),
        UIColor(hex: "795548"),
        UIColor(hex: "2196F3"),
        UIColor(hex: "9C27B0"),
        UIColor(hex: "FFC107"),
        UIColor(hex: "3F51B5"),
        UIColor(hex: "607D8B")
    ]

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .grouped)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubTableView()
        requestAttractionList()
    }

    private func requestAttractionList() {
        let attractionListRequest = API.Attractions.list

        attractionListRequest.request { [weak self] data in
            guard let list = AttractionListSpot.array(dataResponse: data) else { return }
            self?.listData = CustomPlanAttractionsOfAreaList(spots: list)
            self?.tableView.reloadData()
        }
    }

    private func addSubTableView() {
        tableView.backgroundColor = UIColor(hex: "E1E2E1")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 44
        tableView.sectionFooterHeight = 0.001
        tableView.register(CustomPlanAttractionsOfAreaCells.self, forCellReuseIdentifier: identifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}

extension CustomPlanAttractionsOfAreaVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return listData?.areas.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let area = listData?.areas[safe: section] {
            if area.selected {
                return area.elements.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CustomPlanAttractionsOfAreaCells else {
            fatalError("Unknown cell type!")
        }
        cell.data = listData?.areas[safe: indexPath.section]?.elements[safe: indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(origin: .zero,
                                          size: CGSize(width: UIScreen.main.bounds.width,
                                                       height: 44)))
        if let color = sectionHeaderColors[safe: section] {
            header.backgroundColor = color
        }

        let label = UILabel(frame: .zero)
        label.textColor = UIColor.white
        header.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 12).isActive = true

        let arrow = UIImageView(frame: .zero)
        arrow.tintColor = UIColor.white
        header.addSubview(arrow)
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        arrow.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -12).isActive = true

        if let area = listData?.areas[safe: section] {
            label.text = area.name
            if area.selected {
                arrow.image = #imageLiteral(resourceName: "ic_keyboard_arrow_up_black_24px")
            } else {
                arrow.image = #imageLiteral(resourceName: "ic_keyboard_arrow_down_black_24px")
            }
        }

        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(origin: .zero,
                                          size: CGSize(width: UIScreen.main.bounds.width,
                                                       height: 0.001)))
        footer.backgroundColor = UIColor.black
        return footer
    }
}
