//
//  Homepage.swift
//  disney
//
//  Created by ebuser on 2017/4/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import CoreData
import UIKit

class HomepageVC: UIViewController, FileLocalizable {

    let localizeFileName = "Homepage"

    let tableView: UITableView
    let cellIdentifier = "cellIdentifier"

    let fetchedResultsController: NSFetchedResultsController<CustomPlan>

    var suggestedPlans = [PlanListElement]() {
        didSet {
            tableView.reloadData()
        }
    }

    // 保证菜单最多弹出一次
    var editMenuShown = false
    var editMenuIndex: IndexPath?
    lazy var editMenuForCustomized: UIAlertController = {
        return HomepageAlertMenu()
            .editAction({ _ in
                defer { self.editMenuShown = false }
                return
            })
            .deleteAction({ _ in
                defer { self.editMenuShown = false }
                guard let indexPath = self.editMenuIndex else { return }
                self.deletePlan(at: indexPath)
                return
            })
            .specifyAction({ _ in
                defer { self.editMenuShown = false }
                guard let indexPath = self.editMenuIndex else { return }
                self.specifyPlan(at: indexPath)
                return
            })
            .cancelAction({ _ in
                defer { self.editMenuShown = false }
                return
            })
            .asAlertController()
    }()
    lazy var editMenuForSuggested: UIAlertController = {
        return HomepageAlertMenu()
            .editAction({ _ in
                defer { self.editMenuShown = false }
                return
            })
            .specifyAction({ _ in
                defer { self.editMenuShown = false }
                guard let indexPath = self.editMenuIndex else { return }
                self.specifyPlan(at: indexPath)
                return
            })
            .cancelAction({ _ in
                defer { self.editMenuShown = false }
                return
            })
            .asAlertController()
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        let fetchRequest = NSFetchRequest<CustomPlan>(entityName: "CustomPlan")
        let createDateSort = NSSortDescriptor(key: "create", ascending: false)
        fetchRequest.sortDescriptors = [createDateSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: DataManager.shared.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        fetchedResultsController.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = localize(for: "Day plans")
        addNavigationItems()
        addSubTableView()
        requestPlanList()
        requestCustomPlanList()
    }

    private func addNavigationItems() {
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newPlanButtonHandler(_:)))
        navigationItem.rightBarButtonItem = rightItem
    }

    private func addSubTableView() {
        let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 1)))
        headerView.backgroundColor = DefaultStyle.viewBackgroundColor
        let footerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 1)))
        footerView.backgroundColor = DefaultStyle.viewBackgroundColor
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.register(HomepageCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none
        tableView.backgroundColor = DefaultStyle.viewBackgroundColor
        view.addSubview(tableView)

        // Manage Autolayout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        tableView.layoutIfNeeded()

        // Add delegates
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func requestPlanList() {
        let planListRequest = API.Plans.list

        planListRequest.request { [weak self] data in
            guard let plans: [PlanListElement] = PlanListElement.array(dataResponse: data) else {
                return
            }
            self?.suggestedPlans = plans
        }
    }

    private func requestCustomPlanList() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("无法取得数据")
        }
    }

    fileprivate func pushToNext(plan: String, type: PlanType) {
        let destination = HomepageDetailVC(plan: plan, type: type)
        navigationController?.pushViewController(destination, animated: true)
    }

    @objc
    func newPlanButtonHandler(_ sender: UIBarButtonItem) {
//        let destination = CustomPlanViewController()
//        navigationController?.pushViewController(destination, animated: true)
        let destination = CreatePlanVC()
        navigationController?.pushViewController(destination, animated: true)
    }

    fileprivate func showEditMenu(for indexPath: IndexPath) {
        if !editMenuShown {
            editMenuShown = true
            editMenuIndex = indexPath
            if indexPath.section == 0 {
                present(editMenuForCustomized, animated: true)
            } else {
                present(editMenuForSuggested, animated: true)
            }
        }
    }

    fileprivate func deletePlan(at indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        guard let object = fetchedResultsController.fetchedObjects?[safe: indexPath.row] else { return }
        DataManager.shared.context.delete(object)
        DataManager.shared.save()
    }

    fileprivate func specifyPlan(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let data = fetchedResultsController.fetchedObjects?[safe: indexPath.row] else { return }
            SpecifyPlanManager.shared.save(type: .custom, id: data.cId)
        } else {
            SpecifyPlanManager.shared.save(type: .suggestion, id: suggestedPlans[indexPath.row].id)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomepageVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return fetchedResultsController.fetchedObjects?.count ?? 0
        } else {
            return suggestedPlans.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HomepageCell else {
            fatalError("Unknown cell type")
        }
        if indexPath.section == 0 {
            // 自定义Plan
            if let data = fetchedResultsController.fetchedObjects?[safe: indexPath.row] {
                cell.data = data
            }
            cell.itemSelectedHandler = { [weak self] id in
                if self?.navigationController?.topViewController == self {
                    self?.pushToNext(plan: id, type: .custom)
                }
            }
        } else {
            // 系统推荐Plan
            cell.data = suggestedPlans[indexPath.row]
            cell.itemSelectedHandler = { [weak self] id in
                if self?.navigationController?.topViewController == self {
                    self?.pushToNext(plan: id, type: .suggestion)
                }
            }
        }
        cell.menuPressedHandler = { [weak self] in
            self?.showEditMenu(for: indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 {
            guard let data = fetchedResultsController.fetchedObjects?[safe: indexPath.row] else { return }
            pushToNext(plan: data.cId, type: .custom)
        } else {
            pushToNext(plan: suggestedPlans[indexPath.row].id, type: .suggestion)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.numberOfRows(inSection: section) == 0 {
            return nil
        }
        let headerSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
        let headerFrame = CGRect(origin: CGPoint.zero, size: headerSize)
        let header = AttractionBriefHeader(frame: headerFrame)

        if section == 0 {
            header.text = localize(for: "Created by you")
        } else {
            header.text = localize(for: "Suggested")
        }

        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 1.0)))
        view.backgroundColor = DefaultStyle.viewBackgroundColor
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.numberOfRows(inSection: section) == 0 {
            return 1
        }
        return 34
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension HomepageVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: 0), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: 0), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

class HomepageAlertMenu: FileLocalizable {

    let localizeFileName = "Homepage"

    private let alert: UIAlertController

    init() {
        alert = UIAlertController(title: nil,
                                  message: nil,
                                  preferredStyle: .actionSheet)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func editAction(_ handler: @escaping ((UIAlertAction) -> Swift.Void)) -> Self {
        let editAction = UIAlertAction(title: localize(for: "Edit Menu Edit"),
                                       style: .default,
                                       handler: handler)
        alert.addAction(editAction)
        return self
    }

    func deleteAction(_ handler: @escaping ((UIAlertAction) -> Swift.Void)) -> Self {
        let deleteAction = UIAlertAction(title: localize(for: "Edit Menu Delete"),
                                       style: .default,
                                       handler: handler)
        alert.addAction(deleteAction)
        return self
    }

    func specifyAction(_ handler: @escaping ((UIAlertAction) -> Swift.Void)) -> Self {
        let specifyAction = UIAlertAction(title: localize(for: "Edit Menu Specify"),
                                       style: .default,
                                       handler: handler)
        alert.addAction(specifyAction)
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
