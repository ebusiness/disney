//
//  CustomPlanVC.swift
//  disney
//
//  Created by ebuser on 2017/5/20.
//  Copyright © 2017年 e-business. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CustomPlanViewController: UIViewController, FileLocalizable {

    let localizeFileName = "CustomPlan"

    let disposeBag = DisposeBag()

    let tableView: UITableView
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
        tableView = UITableView(frame: .zero, style: .plain)
        titleTextField = UITextField(frame: .zero)
        titleTextCancelButton = UIButton(type: .custom)
        mainMenu = CustomPlanMenu(frame: .zero)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        hidesBottomBarWhenPushed = true

        setupNavigationBar()
        addSubTableView()
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
        let container = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 260, height: 32)))
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
            .subscribe (onNext: { [weak self] in
                self?.showTitleEditMask()
            })
            .addDisposableTo(disposeBag)

        navigationItem.titleView = container
    }

    private func addSubTableView() {
        tableView.backgroundColor = UIColor(hex: "E1E2E1")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
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
    private func save(_ sender: UIBarButtonItem) {

    }

    func titleEditMaskTapHandler(_ sender: UITapGestureRecognizer) {
        titleEditMask.removeFromSuperview()
        titleTextField.resignFirstResponder()
    }

    @objc
    private func titleTextCancelButtonPressHandler(_ sender: UIButton) {
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

    private func pushNext() {
        let destination = CustomPlanCategoryVC()
        navigationController?.pushViewController(destination, animated: true)
    }
}
