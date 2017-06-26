//
//  CustomPlanVC.swift
//  disney
//
//  Created by ebuser on 2017/5/20.
//  Copyright © 2017年 e-business. All rights reserved.
//

import CoreData
import RxCocoa
import RxSwift
import UIKit

class CustomPlanViewController: UIViewController, FileLocalizable {

    let localizeFileName = "CustomPlan"

    let disposeBag = DisposeBag()

    var attractionList = [CustomPlanAttraction]()

    let collectionView: UICollectionView
    let identifier = "CustomPlanCellIdentifier"
    let titleTextField: UITextField
    lazy var titleEditMask: UIView = {
        let pv = UIView(frame: .zero)
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.isUserInteractionEnabled = true
        pv.backgroundColor = #colorLiteral(red: 0.3197864294, green: 0.3197864294, blue: 0.3197864294, alpha: 0.5)
        let tapHandler = UITapGestureRecognizer(target: self, action: #selector(titleEditMaskTapHandler(_:)))
        pv.addGestureRecognizer(tapHandler)
        return pv
    }()
    let titleTextCancelButton: UIButton
    let mainMenu: CustomPlanMenu

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        // configure collection view
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 52)
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

        titleTextField = UITextField(frame: .zero)
        titleTextCancelButton = UIButton(type: .custom)
        mainMenu = CustomPlanMenu(frame: .zero)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        hidesBottomBarWhenPushed = true

        setupNavigationBar()
        addSubCollectionView()
        addSubMainMenu()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //swiftlint:disable:next function_body_length
    private func setupNavigationBar() {
        // 保存
        let saveItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_save_white_24px"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(save(_:)))
        navigationItem.rightBarButtonItem = saveItem

        // 题目
        let containerWidth = UIScreen.main.bounds.width - 177
        let containerHeight: CGFloat = 32
        let container = UIView(frame: CGRect(origin: .zero, size: CGSize(width: containerWidth, height: containerHeight)))
        container.translatesAutoresizingMaskIntoConstraints = false
        container.widthAnchor.constraint(equalToConstant: containerWidth).isActive = true
        container.heightAnchor.constraint(equalToConstant: containerHeight).isActive = true
        // 文本框
        titleTextField.textColor = UIColor.white
        titleTextField.text = localize(for: "default plan name prefix")
        container.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        titleTextField.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        // 下划线
        let underline = UIView(frame: .zero)
        underline.backgroundColor = UIColor.white
        container.addSubview(underline)
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        underline.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        underline.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        underline.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        // 取消按钮
        titleTextCancelButton.setImage(#imageLiteral(resourceName: "ic_clear_white_24px"), for: .normal)
        titleTextCancelButton.isHidden = true
        container.addSubview(titleTextCancelButton)
        titleTextCancelButton.translatesAutoresizingMaskIntoConstraints = false
        titleTextCancelButton.centerYAnchor.constraint(equalTo: titleTextField.centerYAnchor).isActive = true
        titleTextCancelButton.leftAnchor.constraint(equalTo: titleTextField.rightAnchor).isActive = true
        titleTextCancelButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        titleTextCancelButton.addTarget(self, action: #selector(titleTextCancelButtonPressHandler(_:)), for: .touchUpInside)

        // 控制取消按钮显示
        let titleTextEditing = titleTextField.rx.isEditing.shareReplay(1)
        let titleTextEmpty = titleTextField
            .rx
            .text
            .map {
                $0?.isEmpty ?? true
            }
            .shareReplay(1)
        let shouldHideCancelButton = Observable
            .combineLatest(titleTextEditing, titleTextEmpty) { !$0 || $1 }
            .shareReplay(1)

        shouldHideCancelButton.bind(to: titleTextCancelButton.rx.isHidden).disposed(by: disposeBag)

        // 控制误操作保护层显示
        titleTextField
            .rx
            .controlEvent(.editingDidBegin)
            .subscribe { [weak self] _ in
                self?.showTitleEditMask()
            }
            .addDisposableTo(disposeBag)
        titleTextField
            .rx
            .controlEvent(.editingDidEnd)
            .subscribe { [weak self] _ in
                self?.hideTitleEditMask()
            }
            .addDisposableTo(disposeBag)

        navigationItem.titleView = container
    }

    private func addSubCollectionView() {
        collectionView.backgroundColor = DefaultStyle.viewBackgroundColor
        collectionView.register(CustomPlanCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        // drag and drop support
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPress)
    }

    private func addSubMainMenu() {
        // 子菜单的按钮触发回调
        mainMenu.subject.subscribe { [weak self] event in
            guard let strongSelf = self else { return }
            switch event {
            case .next(let e):
                switch e {
                case .addPressed:
                    strongSelf.pushNext()
                case .randomPressed:
                    fallthrough
                case .backPressed:
                    break
                }
            default:
                break
            }
            strongSelf.mainMenu.collapse()

        }.disposed(by: disposeBag)

        view.addSubview(mainMenu)
        mainMenu.translatesAutoresizingMaskIntoConstraints = false
        mainMenu.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        mainMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
    }

    @objc
    func save(_ sender: UIBarButtonItem) {
        guard let date = Preferences.shared.visitStart.value else { return }
        let routes = attractionList.filter { $0.selected } .map { ["str_id": $0.id] }
        let parameter = API.Plans.CustomizeParameter(start: date, route: routes)
        let requester = API.Plans.customize(parameter)

        requester.request { [weak self] data in
            guard let planDetail = PlanDetail(data) else { return }
            guard let strongSelf = self else { return }
            strongSelf.saveToCoreData(customPlan: planDetail)
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }

    private func saveToCoreData(customPlan: PlanDetail) {
        guard let myPlan = CustomPlan.from(planDetail: customPlan) else { return }
        myPlan.name = titleTextField.text ?? localize(for: "default plan name prefix")
        myPlan.id = DataManager.shared.randomID()
        myPlan.create = Date()
        DataManager.shared.save()
    }

    @objc
    func titleEditMaskTapHandler(_ sender: UITapGestureRecognizer) {
        hideTitleEditMask()
    }

    @objc
    func titleTextCancelButtonPressHandler(_ sender: UIButton) {
        titleTextField.text = ""
        sender.isHidden = true
    }

    fileprivate func showTitleEditMask() {
        view.addSubview(titleEditMask)
        titleEditMask.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleEditMask.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleEditMask.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        titleEditMask.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        titleEditMask.layoutIfNeeded()
    }

    fileprivate func hideTitleEditMask() {
        titleEditMask.removeFromSuperview()
        titleTextField.resignFirstResponder()
    }

    private func pushNext() {
        let destination = CustomPlanCategoryVC()
        navigationController?.pushViewController(destination, animated: true)
    }

//    func addAttractions(_ attractions: [PlanCategoryAttractionTagDetail.Attraction]) {
//        var append  = [CustomPlanAttraction]()
//        for attraction in attractions {
//            if !attractionList.contains(where: { $0 == attraction })
//                && !append.contains(where: { $0 == attraction }) {
//                append.append(attraction.asCustomPlanAttraction())
//            }
//        }
//        if !append.isEmpty {
//            attractionList.append(contentsOf: append)
//            collectionView.reloadData()
//        }
//    }
    func addAttractions<T: PlanAttractionConvertible>(_ attractions: [T]) {
        var append  = [CustomPlanAttraction]()
        for attraction in attractions {
            if !attractionList.contains(where: { $0 == attraction })
                && !append.contains(where: { $0 == attraction }) {
                append.append(attraction.asCustomPlanAttraction())
            }
        }
        if !append.isEmpty {
            attractionList.append(contentsOf: append)
            collectionView.reloadData()
        }
    }

    @objc
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}

extension CustomPlanViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attractionList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CustomPlanCell else { fatalError("Unknown cell type") }
        cell.data = attractionList[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = attractionList.remove(at: sourceIndexPath.item)
        attractionList.insert(temp, at: destinationIndexPath.item)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var item = attractionList[indexPath.item]
        item.selected = !item.selected
        attractionList[indexPath.item] = item
        collectionView.reloadItems(at: [indexPath])
    }
}
