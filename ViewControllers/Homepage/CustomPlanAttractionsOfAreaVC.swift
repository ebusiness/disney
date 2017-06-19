//
//  CustomPlanAttractionsOfAreaVC.swift
//  disney
//
//  Created by ebuser on 2017/6/14.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class CustomPlanAttractionsOfAreaVC: UIViewController, FileLocalizable {

    let localizeFileName = "CustomPlan"

    let tableView: UITableView
    let identifier = "identifier"
    let headerIdentifier = "headerIdentifier"
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
        automaticallyAdjustsScrollViewInsets = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configNavigationBar()
        addSubTableView()
        requestAttractionList()
    }

    private func configNavigationBar() {
        let rightButton = UIBarButtonItem(barButtonSystemItem: .save,
                                          target: self,
                                          action: #selector(save(_:)))
        navigationItem.rightBarButtonItem = rightButton
        title = localize(for: "plan filter area")
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
        tableView.rowHeight = 160
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 44
        tableView.sectionFooterHeight = 0.001
        tableView.register(CustomPlanAttractionsOfAreaCell.self, forCellReuseIdentifier: identifier)
        tableView.register(CustomPlanAttractionsOfAreaHeader.self, forHeaderFooterViewReuseIdentifier: "headerIdentifier")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    @objc
    private func save(_ sender: UIBarButtonItem) {
        guard let home = navigationController?.viewControllers.first(where: { $0 is CustomPlanViewController }) as? CustomPlanViewController else { return }
//        var bucket = [CustomPlanAttractionsOfAreaList.CustomPlanAttractionsOfAreaElement]()
//        if let attractions = listData?.areas.reduce(bucket, <#T##nextPartialResult: (Result, CustomPlanAttractionsOfAreaList.CustomPlanAttractionsOfAreaArea) throws -> Result##(Result, CustomPlanAttractionsOfAreaList.CustomPlanAttractionsOfAreaArea) throws -> Result#>)
//        if let attractions = tagDetail?.attractions.filter ({ $0.selected }), !attractions.isEmpty {
//            home.addAttractions(attractions)
//        }
        navigationController?.popToViewController(home, animated: true)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CustomPlanAttractionsOfAreaCell else {
            fatalError("Unknown cell type!")
        }
        cell.data = listData?.areas[safe: indexPath.section]?.elements[safe: indexPath.row]
        return cell
    }
    //swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let area = listData?.areas[safe: section] else { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as? CustomPlanAttractionsOfAreaHeader else { return nil }
        header.setProperties(section: section,
                             selected: area.selected,
                             color: sectionHeaderColors[safe: section],
                             title: area.name)
        header.sectionOpenHandler = { [weak self] section in
            guard let area = self?.listData?.areas[safe: section] else { return }
            guard area.selected == false else { return }
            let previousOpenSectionIndex = self?.listData?.areas.index(where: { $0.selected })

            var indexPathsToInsert = [IndexPath]()
            self!.listData!.areas[section].selected = true
            for i in 0..<self!.listData!.areas[section].elements.count {
                indexPathsToInsert.append(IndexPath(row: i, section: section))
            }

            var indexPathsToDelete = [IndexPath]()
            if let index = previousOpenSectionIndex {
                self!.listData!.areas[index].selected = false
                for i in 0..<self!.listData!.areas[index].elements.count {
                    indexPathsToDelete.append(IndexPath(row: i, section: index))
                }
                if let headerToDelete = tableView.headerView(forSection: index) as? CustomPlanAttractionsOfAreaHeader {
                    headerToDelete.setProperties(section: index, selected: false)
                }

            }

            tableView.beginUpdates()
            tableView.insertRows(at: indexPathsToInsert, with: .fade)
            tableView.deleteRows(at: indexPathsToDelete, with: .fade)
            tableView.endUpdates()
            let headerRect = tableView.rectForHeader(inSection: section)
            tableView.scrollRectToVisible(headerRect, animated: true)
        }
        header.sectionCloseHandler = { [weak self] section in
            guard let area = self?.listData?.areas[safe: section] else { return }
            guard area.selected == true else { return }

            var indexPathsToDelete = [IndexPath]()
            self!.listData!.areas[section].selected = false
            for i in 0..<self!.listData!.areas[section].elements.count {
                indexPathsToDelete.append(IndexPath(row: i, section: section))
            }
            tableView.deleteRows(at: indexPathsToDelete, with: .fade)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selected = listData?.areas[safe: indexPath.section]?.elements[safe: indexPath.row]?.selected {
            listData?.areas[indexPath.section].elements[indexPath.row].selected = !selected
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
