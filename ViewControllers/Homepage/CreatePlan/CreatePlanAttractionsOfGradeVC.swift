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

        automaticallyAdjustsScrollViewInsets = false
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
        tableView.separatorStyle = .none
        tableView.rowHeight = UIScreen.main.bounds.width / 2
        tableView.register(CreatePlanAttractionsOfGradeCell.self, forCellReuseIdentifier: identifier)
        view.addSubview(tableView)
        tableView.addAllConstraints(equalTo: view)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CreatePlanAttractionsOfGradeCell else {
            fatalError("Unknown cell type")
        }
        cell.data = listData?[safe: indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard var data = listData?[safe: indexPath.row] else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? CreatePlanAttractionsOfGradeCell else { return }
        data.selected = !data.selected
        listData?[indexPath.row] = data
        cell.data = data
    }
}
