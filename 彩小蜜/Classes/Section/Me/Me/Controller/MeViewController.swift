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

class MeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, MeHeaderViewDelegate, MeFooterViewDelegate, TTTAttributedLabelDelegate {
    
    
    
    public var showType: ShowType! = .onlyNews{
        didSet{
            guard showType != nil else { return }
            if showType == .onlyNews {
                tableView.tableHeaderView = newsheaderView
            }else {
                tableView.tableHeaderView = headerView
            }
            self.tableView.reloadData()
        }
    }
    //MARK: - 属性
    private var headerView: MeHeaderView!
    private var newsheaderView : NewsHeaderView!
    private var footerView: MeFooterView!
    private var userInfo  : UserInfoDataModel!
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBut()
        self.navigationItem.title = "彩小秘 · 我的"
        self.view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(configNotification(_:)), name: NSNotification.Name(rawValue: NotificationConfig), object: nil)
        
        
//        if getUserData() != nil {
//            
//        }else {
//            let login = LoginViewController()
//            
//            self.view = login.view
//        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInfoRequest()
        self.isHidenBar = false
        
        let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
        if turnOn {
            showType = .allShow
        }else {
            showType = .onlyNews
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    //MARK: - 点击事件
    
    @objc private func configNotification(_ notification : Notification) {
        guard let userinf = notification.userInfo else { return }
        guard let turn = userinf["showStyle"] as? Bool else { return }
        if turn {
            showType = .allShow
        }else {
            showType = .onlyNews
        }
    }
    
    // header delegate
    func rechargeClicked() {
        print("充值")
        let recharge = RechargeViewController()
        recharge.userInfo = userInfo
        pushViewController(vc: recharge)
    }
    
    func withdrawalClicked() {
        print("提现")
        guard self.userInfo != nil else { return }
        guard self.userInfo != nil, self.userInfo.isReal else {

            showCXMAlert(title: nil, message: "请先实名认证后再申请提现", action: "去认证", cancel: "知道了") { (action) in
                let authentication = AuthenticationVC()
                self.pushViewController(vc: authentication)
            }
            return }
        let draw = WithdrawalViewController()
        pushViewController(vc: draw)
    }
    // footer delegate
    func signOutClicked() {
        print("退出登录")
        weak var weakSelf = self
        self.showCXMAlert(title: nil, message: "您正在退出登录", action: "继续退出", cancel: "返回") { (action) in
            weakSelf?.logoutRequest()
            weakSelf?.removeUserData()
            weakSelf?.pushRootViewController(2)
        }
        //pushLoginVC(from: self)
        
    }
    // 未认证 警告条 去认证
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
        
        if showType == .onlyNews {
            let collection = MyCollectionVC()
            pushViewController(vc: collection)
        }else {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    pushPagerView(pagerType: .purchaseRecord)
                case 1:
                    pushPagerView(pagerType: .accountDetails)
                case 2:
                    pushPagerView(pagerType: .coupon)
                    
                default :
                    break
                }
            case 1:
                switch indexPath.row {
                case 0:
                    pushPagerView(pagerType: .message)
                case 1:
                    let collection = MyCollectionVC()
                    pushViewController(vc: collection)
                case 2:
                    let web = WebViewController()
                    web.urlStr = webHelp
                    pushViewController(vc: web)
                case 3:
                    UIApplication.shared.openURL(URL(string: "telprompt://\(phoneNum)")!)
                case 4:
                    let about = MeAboutViewController()
                    pushViewController(vc: about)
                default :
                    break
                }
            default:
                break
            }
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
                weakSelf?.newsheaderView.userInfo = data
                weakSelf!.tableView.layoutIfNeeded()
                weakSelf!.tableView.reloadData()
                print(data)
            }, onError: { (error) in
                print(error)
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        let login = VCodeLoginViewController()
                        weakSelf?.pushViewController(vc: login)
                        
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                    
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
                
            }, onError: { (error) in
                print(error)
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    if 300000...310000 ~= code {
                        self.showHUD(message: msg!)
                    }
                    print(code)
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

        newsheaderView = NewsHeaderView()
        newsheaderView.delegate = self
        
        //table.tableHeaderView = headerView
        table.tableFooterView = footerView
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if showType == .onlyNews {
            return 1
        }else {
           return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if showType == .onlyNews {
            return 1
        }else {
            switch section {
            case 0:
                return 3
            case 1:
                return 5
            default:
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: meCellIdentifier, for: indexPath) as! MeCell
        cell.accessoryType = .disclosureIndicator
        
        if showType == .onlyNews {
            switch indexPath.row {
            case 0:
                cell.icon.image = UIImage(named: "nformationsecurity")
                cell.title.text = "我的收藏"
            default :
                break
            }
            
        }else {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    cell.icon.image = UIImage(named: "recording")
                    cell.title.text = "投注记录"
                case 1:
                    cell.icon.image = UIImage(named: "Details")
                    cell.title.text = "账户明细"
                case 2:
                    cell.icon.image = UIImage(named: "coupon")
                    cell.title.text = "我的卡券"
                    
                default :
                    break
                }
            case 1:
                switch indexPath.row {
                case 0:
                    cell.icon.image = UIImage(named: "note-1")
                    cell.title.text = "消息中心"
                case 1:
                    cell.icon.image = UIImage(named: "collection")
                    cell.title.text = "我的收藏"
                case 2:
                    cell.icon.image = UIImage(named: "help")
                    cell.title.text = "帮助中心"
                case 3:
                    cell.icon.image = UIImage(named: "serive")
                    cell.title.text = "联系客服"
                    cell.serviceNum = phoneNum
                    cell.detail.delegate = self
                    cell.accessoryType = .none
                case 4:
                    cell.icon.image = UIImage(named: "our")
                    cell.title.text = "关于我们"
                default :
                    break
                }
            default:
                break
            }
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
        return 0.01
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
