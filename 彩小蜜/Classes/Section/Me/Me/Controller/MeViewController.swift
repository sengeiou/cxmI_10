//
//  MeViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/2/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import TTTAttributedLabel

enum MePushType {
    case 投注记录
    case 账户明细
    case 我的卡券
    case 消息中心
    case 我的收藏
    case 帮助中心
    case 联系客服
    case 关于我们
    case 活动
}

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
    private var meSectionList : [MeSectionModel]!
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBut()
        self.navigationItem.title = "彩小秘 · 我的"
        self.view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(configNotification(_:)), name: NSNotification.Name(rawValue: NotificationConfig), object: nil)

        self.meSectionList = getData()
        self.tableView.reloadData()
        
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
            let section = self.meSectionList[indexPath.section]
            
            let row  = section.list[indexPath.row]
            
            pushMeViewController(row)
        }
    }
    
    private func pushMeViewController (_ model: MeListDataModel) {
        switch model.pushType {
        case .投注记录:
            pushPagerView(pagerType: .purchaseRecord)
        case .账户明细:
            pushPagerView(pagerType: .accountDetails)
        case .我的卡券:
            pushPagerView(pagerType: .coupon)
        case .消息中心:
            pushPagerView(pagerType: .message)
        case .我的收藏:
            let collection = MyCollectionVC()
            pushViewController(vc: collection)
        case .帮助中心:
            let web = WebViewController()
            web.urlStr = webHelp
            pushViewController(vc: web)
        case .联系客服:
            UIApplication.shared.openURL(URL(string: "telprompt://\(phoneNum)")!)
        case .关于我们:
            let about = MeAboutViewController()
            pushViewController(vc: about)
        case .活动:
            
            
            break
        default: break
            
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
        //weak var weakSelf = self
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
            guard self.meSectionList != nil else { return 0 }
            return self.meSectionList.count
            //return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if showType == .onlyNews {
            return 1
        }else {
            guard self.meSectionList != nil else { return 0 }
            return self.meSectionList[section].list.count
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
            
            let section = self.meSectionList[indexPath.section]
            
            let row  = section.list[indexPath.row]
            
            if row.pushType == .活动 {
                
            }else if row.pushType == .联系客服 {
                cell.icon.image = UIImage(named: section.list[indexPath.row].iconStr)
                cell.title.text = section.list[indexPath.row].title
                cell.serviceNum = phoneNum
                cell.detail.delegate = self
                cell.accessoryType = .none
            }else {
                cell.icon.image = UIImage(named: section.list[indexPath.row].iconStr)
                cell.title.text = section.list[indexPath.row].title
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
    
    // MARK: - 数据
    private func getData() -> [MeSectionModel] {
        var list = [MeSectionModel]()
        
        var section1 = MeSectionModel()
        var section2 = MeSectionModel()
        
        var item1 = MeListDataModel()
        item1.title = "投注记录"
        item1.iconStr = "recording"
        item1.pushType = .投注记录
        section1.list.append(item1)
        
        var item2 = MeListDataModel()
        item2.title = "账户明细"
        item2.iconStr = "Details"
        item2.pushType = .账户明细
        section1.list.append(item2)
        
        var item3 = MeListDataModel()
        item3.title = "我的卡券"
        item3.iconStr = "coupon"
        item3.pushType = .我的卡券
        section1.list.append(item3)
        
        var item4 = MeListDataModel()
        item4.title = "消息中心"
        item4.iconStr = "note-1"
        item4.pushType = .消息中心
        section2.list.append(item4)
        
        var item5 = MeListDataModel()
        item5.title = "我的收藏"
        item5.iconStr = "collection"
        item5.pushType = .我的收藏
        section2.list.append(item5)
        
        var item6 = MeListDataModel()
        item6.title = "帮助中心"
        item6.iconStr = "help"
        item6.pushType = .帮助中心
        section2.list.append(item6)
        
        var item7 = MeListDataModel()
        item7.title = "联系客服"
        item7.iconStr = "serive"
        item7.pushType = .联系客服
        section2.list.append(item7)
        
        var item8 = MeListDataModel()
        item8.title = "关于我们"
        item8.iconStr = "our"
        item8.pushType = .关于我们
        section2.list.append(item8)
        
        
        list.append(section1)
        list.append(section2)
        
        return list
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
