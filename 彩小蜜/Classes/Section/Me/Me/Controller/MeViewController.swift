//
//  MeViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/2/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import TTTAttributedLabel

fileprivate let meCellIdentifier = "meCellIdentifier"

class MeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, MeHeaderViewDelegate, MeFooterViewDelegate, TTTAttributedLabelDelegate, UserInfoPro {
    
    //MARK: - 点击事件
    // header delegate
    func rechargeClicked() {
        print("充值")
        let recharge = RechargeViewController()
        pushViewController(vc: recharge)
    }
    
    func withdrawalClicked() {
        print("提现")
        let draw = WithdrawalViewController()
        pushViewController(vc: draw)
    }
    // footer delegate
    func signOutClicked() {
        print("退出登录")
        weak var weakSelf = self
        showConfirm(message: "您正在退出登录", action: "继续退出", cancel: "返回") { (action) in
            weakSelf?.logoutRequest()
        }
        pushLoginVC(from: self)
        
    }
    // 未认证 警告条
    func alertClicked() {
        let authentication = AuthenticationVC()
        pushViewController(vc: authentication)
    }
    // 客服电话
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        UIApplication.shared.openURL(URL(string: "telprompt://\(phoneNumber!)")!)
    }
    //MARK: - 设置用户信息
    private func setupUserInfo() {
        
    }
    
    //MARK: - tableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                pushPagerView(pagerType: .purchaseRecord)
            case 1:
                pushPagerView(pagerType: .accountDetails)
            case 2:
                pushPagerView(pagerType: .coupon)
            case 3:
                pushPagerView(pagerType: .message)
            default :
                break
            }
        case 1:
            switch indexPath.row {
            case 0: break
            case 1: break
            case 2:
                let about = MeAboutViewController()
                pushViewController(vc: about)
            default :
                break
            }
        default:
            break
        }
    }
    
    
    
    //MARK: - 属性
    private var headerView: MeHeaderView!
    private var footerView: MeFooterView!
    private var userInfo  : UserInfoDataModel!
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBut()
        self.navigationItem.title = "彩小秘 · 我的"
        self.view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHidenBar = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    
    //MARK: - 网络请求
    private func userInfoRequest() {
        weak var weakSelf = self
        _ = userProvider.rx.request(.userInfo)
            .asObservable()
            .mapObject(type: UserInfoDataModel.self)
            .subscribe(onNext: { (data) in
                guard weakSelf != nil else { return }
                weakSelf!.userInfo = data
                weakSelf!.headerView.userInfo = data
                weakSelf!.tableView.layoutIfNeeded()
                weakSelf!.tableView.reloadData()
                print(data)
            }, onError: { (error) in
                print(error)
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil)
    }
    // 退出登录
    private func logoutRequest() {
        weak var weakSelf = self
        _ = loginProvider.rx.request(.logout)
        .asObservable()
        .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.removeUserData()
                weakSelf?.pushRootViewController(2)
            }, onError: { (error) in
                print(error)
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil )
    }
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(MeCell.self, forCellReuseIdentifier: meCellIdentifier)
        
        headerView = MeHeaderView()
        headerView.delegate = self

        footerView = MeFooterView()
        footerView.delegate = self

        table.tableHeaderView = headerView
        table.tableFooterView = footerView
        
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: meCellIdentifier, for: indexPath) as! MeCell
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.icon.image = UIImage(named: "recording")
                cell.title.text = "投注记录"
            case 1:
                cell.icon.image = UIImage(named: "Details")
                cell.title.text = "账号明细"
            case 2:
                cell.icon.image = UIImage(named: "coupon")
                cell.title.text = "我的卡券"
            case 3:
                cell.icon.image = UIImage(named: "nformationsecurity")
                cell.title.text = "消息中心"
            default :
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.icon.image = UIImage(named: "help")
                cell.title.text = "帮助中心"
            case 1:
                cell.icon.image = UIImage(named: "serive")
                cell.title.text = "联系客服"
                cell.serviceNum = "400-123-1234"
                
                cell.detail.delegate = self
                cell.accessoryType = .none
            case 2:
                cell.icon.image = UIImage(named: "our")
                cell.title.text = "关于我们"
            default :
                break
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
