//
//  CreatePlanAttractionsOfGradeVC.swift
//  disney
//
//  Created by ebuser on 2017/7/11.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class CreatePlanAttractionsOfGradeVC: UIViewController {

    let localizeFileName = "CustomPlan"
    let identifier = "identifier"

    let tableView: UITableView

    var listData: [AttractionOfHotGrade]?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .plain)
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

    private func addSubTableView() {
        tableView.backgroundColor = DefaultStyle.viewBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 44
        tableView.sectionFooterHeight = 0.001
        tableView.register(CustomPlanAttractionsOfGradeCell.self, forCellReuseIdentifier: identifier)
    }

    private func requestAttractionList() {
        let requester = API.Attractions.hotGrade

        requester.request { [weak self] data in
            self?.listData = AttractionOfHotGrade.array(dataResponse: data)
            self?.tableView.reloadData()
        }
    }
}

extension CreatePlanAttractionsOfGradeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CustomPlanAttractionsOfGradeCell else {
            fatalError("Unknown cell type")
        }
        cell.data = listData?[safe: indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard var data = listData?[safe: indexPath.row] else { return }
        data.selected = !data.selected
        listData?[indexPath.row] = data
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
