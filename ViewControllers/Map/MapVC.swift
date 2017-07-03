//
//  MapVC.swift
//  disney
//
//  Created by ebuser on 2017/4/25.
//  Copyright © 2017年 e-business. All rights reserved.
//

import CoreData
import UIKit

class MapVC: UIViewController {

    let tableView: UITableView
    let pointCellIdentifier = "pointCellIdentifier"
    let lineCellIdentifier = "lineCellIdentifier"

    let fetchedResultsController: NSFetchedResultsController<SpecifiedPlan>

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .plain)
        let fetchRequest = NSFetchRequest<SpecifiedPlan>(entityName: "SpecifiedPlan")
        let createDateSort = NSSortDescriptor(key: "park", ascending: false)
        fetchRequest.sortDescriptors = [createDateSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: DataManager.shared.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        view.backgroundColor = UIColor.white
        fetchedResultsController.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubTableView()
        requestSpecifiedPlan()
    }

    private func addSubTableView() {
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MapPointCell.self, forCellReuseIdentifier: pointCellIdentifier)
        tableView.register(MapLineCell.self, forCellReuseIdentifier: lineCellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func requestSpecifiedPlan() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("无法取得数据")
        }
    }

}

extension MapVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let routes = fetchedResultsController.fetchedObjects?.first?.routes else { return 0 }
        return routes.count * 2 - 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: pointCellIdentifier, for: indexPath) as? MapPointCell else { fatalError("Unknown cell type") }
            if let data = fetchedResultsController.fetchedObjects?.first?.routes?.object(at: indexPath.row / 2) as? SpecifiedPlanRoute {
                cell.data = data
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: lineCellIdentifier, for: indexPath) as? MapLineCell else { fatalError("Unknown cell type") }
            if let data = fetchedResultsController.fetchedObjects?.first?.routes?.object(at: indexPath.row / 2) as? SpecifiedPlanRoute {
                cell.data = data
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 160
        } else {
            return 40
        }
    }
}

extension MapVC: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
