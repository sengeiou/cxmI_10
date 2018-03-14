//
//  MeViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/2/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class MeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, MeHeaderViewDelegate, MeFooterViewDelegate, TTTAttributedLabelDelegate {
    
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
        //let vc = LoginViewController()
        //pushViewController(vc: vc)
        
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
            case 0: break
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
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: .grouped)
        self.view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .singleLine
        //tableview.separatorColor = UIColor.red
        tableview.register(MeCell.self, forCellReuseIdentifier: meCellIdentifier)
        
        headerView = MeHeaderView()
        headerView.delegate = self
        
        footerView = MeFooterView()
        footerView.delegate = self
        
        tableview.tableHeaderView = headerView
        tableview.tableFooterView = footerView
        return tableview
    }()
    
    //MARK: - 属性
    private var headerView: MeHeaderView!
    private var footerView: MeFooterView!
    private var userInfo  : UserInfoDataModel!
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBut()
        userInfoRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //hideNavigationBar()
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
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil)
    }
    
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: meCellIdentifier, for: indexPath) as! MeCell
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.title.text = "投注记录"
            case 1:
                cell.title.text = "账号明细"
            case 2:
                cell.title.text = "我的卡券"
            default :
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.title.text = "帮助中心"
            case 1:
                cell.title.text = "联系客服"
                let phoneNum = "400-133-1234"
                cell.detail.attributedText = NSAttributedString(string: "400-133-1234")
                cell.detail.addLink(toPhoneNumber: phoneNum, with: NSRange.init(location: 0, length: phoneNum.lengthOfBytes(using: .utf8)))
                cell.detail.delegate = self
                cell.accessoryType = .none
            case 2:
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
        return 50
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
