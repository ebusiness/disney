//
//  CustomPlanAttractionsOfRankingVC.swift
//  disney
//
//  Created by ebuser on 2017/6/16.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class CustomPlanAttractionsOfGradeVC: UIViewController, FileLocalizable {

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

        configNavigationBar()
        addSubTableView()
        requestAttractionList()
    }

    private func configNavigationBar() {
        let rightButton = UIBarButtonItem(barButtonSystemItem: .save,
                                          target: self,
                                          action: #selector(save(_:)))
        navigationItem.rightBarButtonItem = rightButton
        title = localize(for: "plan filter grade")
    }

    @objc
    private func save(_ sender: UIButton) {
        guard let home = navigationController?.viewControllers.first(where: { $0 is CustomPlanViewController }) as? CustomPlanViewController else { return }
        if let attractions = listData?.filter ({ $0.selected }), !attractions.isEmpty {
            home.addAttractions(attractions)
        }
        navigationController?.popToViewController(home, animated: true)
    }

    private func addSubTableView() {
        tableView.backgroundColor = UIColor(hex: "E1E2E1")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 44
        tableView.sectionFooterHeight = 0.001
        tableView.register(CustomPlanAttractionsOfGradeCell.self, forCellReuseIdentifier: identifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func requestAttractionList() {
        let requester = API.Attractions.hotGrade

        requester.request { [weak self] data in
            self?.listData = AttractionOfHotGrade.array(dataResponse: data)
            self?.tableView.reloadData()
        }
    }
}

extension CustomPlanAttractionsOfGradeVC: UITableViewDelegate, UITableViewDataSource {
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
