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
    case 清除缓存
    case 投诉建议
    case 帮助中心
    case 联系客服
    case 在线客服
    case 注册协议
    case 关于我们
    case 活动
}

fileprivate let meCellIdentifier = "meCellIdentifier"

class MeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, MeHeaderViewDelegate, MeFooterViewDelegate, TTTAttributedLabelDelegate, ClearCache {
    
    
    
    public var showType: ShowType! = .onlyNews{
        didSet{
            guard showType != nil else { return }
            if showType == .onlyNews {
                tableView.tableHeaderView = newsheaderView
                self.meSectionList = getNewsData()
            }else {
                tableView.tableHeaderView = headerView
                self.meSectionList = getBuyData()
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
        setRightBut()
        self.navigationItem.title = "彩小秘 · 我的"
        self.view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(configNotification(_:)), name: NSNotification.Name(rawValue: NotificationConfig), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInfoRequest()
        self.isHidenBar = false
        
        let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
        //turnOn = false
        if turnOn && self.showType != .allShow{
            showType = .allShow
            //showType = .onlyNews
        }else if turnOn == false && self.showType != .onlyNews {
            showType = .onlyNews
        }
        
        hidenNotic()
    }
    
    private func hidenNotic() {
        guard let bonusNo = UserDefaults.standard.value(forKey: BonusNotice) as? String else { return }
        guard let messaNo = UserDefaults.standard.value(forKey: MessageNotice) as? String else { return }
        guard let bonusNum = Int(bonusNo) else { return }
        guard let messaNum = Int(messaNo) else { return }
        
        if bonusNum <= 0 && messaNum <= 0 {
            self.tabBarController?.tabBar.hideBadgeOnItemIndex(index: 3)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    //MARK: - 点击事件
    @objc private func setting() {
        let setting = UserInfoSettingVC()
        setting.userInfo = self.userInfo
        pushViewController(vc: setting)
    }
    
    @objc private func configNotification(_ notification : Notification) {
        guard let userinf = notification.userInfo else { return }
        guard let turnOn = userinf["showStyle"] as? Bool else { return }
        if turnOn && self.showType != .allShow{
            showType = .allShow
            //showType = .onlyNews
        }else if turnOn == false && self.showType != .onlyNews {
            showType = .onlyNews
        }
    }
    
    // header delegate
    func rechargeClicked() {
        print("充值")
        let recharge = RechargeViewController()
        recharge.userInfo = userInfo
        pushViewController(vc: recharge)
        TongJi.log(.充值, label: "充值")
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
        TongJi.log(.提现, label: "提现")
    }
    
    // footer delegate
    func signOutClicked() {
        print("退出登录")
        weak var weakSelf = self
        self.showCXMAlert(title: nil, message: "您正在退出登录", action: "继续退出", cancel: "返回") { (action) in
            weakSelf?.logoutRequest()
            weakSelf?.removeUserData()
            weakSelf?.pushRootViewController(3)
            TongJi.log(.退出登录, label: "退出登录")
        }
    }
    // 未认证 警告条 去认证
    func alertClicked() {
        TongJi.log(.实名认证, label: "实名认证")
        let authentication = AuthenticationVC()
        pushViewController(vc: authentication)
    }
    // 客服电话
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        UIApplication.shared.openURL(URL(string: "telprompt://\(phoneNumber!)")!)
    }
    
    //MARK: - tableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = self.meSectionList[indexPath.section]
        
        let row  = section.list[indexPath.row]
        
        pushMeViewController(row)
    }
    
    //MARK: - 设置用户信息
    private func setupUserInfo() {
        
    }
    
    private func pushMeViewController (_ model: MeListDataModel) {
        switch model.pushType {
        case .投注记录:
            pushPagerView(pagerType: .purchaseRecord)
            TongJi.log(.投注记录, label: "投注记录")
        case .账户明细:
            pushPagerView(pagerType: .accountDetails)
            TongJi.log(.账户明细, label: "账户明细")
        case .我的卡券:
            pushPagerView(pagerType: .coupon)
            TongJi.log(.我的卡券, label: "我的卡券")
        case .消息中心:
            pushPagerView(pagerType: .message)
            TongJi.log(.消息中心, label: "消息中心")
        case .我的收藏:
            let collection = MyCollectionVC()
            pushViewController(vc: collection)
            TongJi.log(.我的收藏, label: "我的收藏")
        case .帮助中心:
            let web = WebViewController()
            web.urlStr = webHelp
            pushViewController(vc: web)
            TongJi.log(.帮助中心, label: "帮助中心")
        case .联系客服:
            UIApplication.shared.openURL(URL(string: "telprompt://\(phoneNum)")!)
            TongJi.log(.联系客服, label: "联系客服")
        case .关于我们:
            let about = MeAboutViewController()
            about.showType = self.showType
            pushViewController(vc: about)
            TongJi.log(.关于我们, label: "关于我们")
        case .活动:
            guard model.actUrl != nil else { return }
            pushRouterVC(urlStr: model.actUrl, from: self)
            
        case .清除缓存:
            showCXMAlert(title: "清除缓存", message: "确认要清除吗？", action: "确定", cancel: "取消") { (action) in
                self.showProgressHUD()
                self.clearImageCache {
                    self.dismissProgressHud()
                    self.showHUD(message: "清理成功")
                }
            }
        case .投诉建议:
            let complaint = MeComplaintVC()
            pushViewController(vc: complaint)
            TongJi.log(.关于我们投诉建议, label: "关于我们投诉建议")
            break
        case .注册协议:
            let regis = WebViewController()
            regis.urlStr = webRegisterAgreement
            pushViewController(vc: regis)
            TongJi.log(.注册用户协议, label: "注册用户协议" )
        case .在线客服:
            initZhiChiService()
            
            
        }
    }
    
    private func initZhiChiService() {
        let initInfo = ZCLibInitInfo()
        
        initInfo.appKey = ZhiChiAppKey
        initInfo.userId = ""
        
        let uiInfo = ZCKitInfo()
        
        uiInfo.isShowTansfer = true
        
        uiInfo.customBannerColor = ColorFFFFFF
        
        uiInfo.topViewTextColor = UIColor.black
        
        uiInfo.titleFont = Font15
        
        //uiInfo.serviceNameTextColor = Color0099D9
        
        
        
        ZCLibClient.getZCLibClient().libInitInfo = initInfo
        
        ZCSobot.startZCChatVC(uiInfo, with: self, target: nil, pageBlock: { (chatVC, type) in
            
        }, messageLinkClick: nil)
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

                if self.showType == .allShow {
                    self.meSectionList = self.getBuyData()
                    if data.activityDTOList != nil {
                        var section = MeSectionModel()
                        
                        for activity in data.activityDTOList {
                            section.list.append(activity)
                        }
                        
                        if self.meSectionList.count == 2 {
                            self.meSectionList.insert(section, at: 1)
                        }
                    }
                }else {
                    self.meSectionList = self.getNewsData()
                }
                //weakSelf!.tableView.layoutIfNeeded()
                
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
        let table = UITableView(frame: CGRect.zero, style: .plain)
        
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
        
        if showType != nil {
            if showType == .onlyNews {
                table.tableHeaderView = newsheaderView
            }else {
                table.tableHeaderView = headerView
            }
        }
        
        table.tableFooterView = footerView
        return table
    }()
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.meSectionList != nil else { return 0 }
        return self.meSectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.meSectionList != nil else { return 0 }
        return self.meSectionList[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: meCellIdentifier, for: indexPath) as! MeCell
        cell.accessoryType = .disclosureIndicator
        cell.serviceNum = ""
        cell.noticeIcon.isHidden = true
        let section = self.meSectionList[indexPath.section]
        
        let row  = section.list[indexPath.row]
        
        if row.pushType == .活动 {
            if row.icon != nil, row.title != nil {
                if let url = URL(string: row.icon) {
                    cell.icon.kf.setImage(with: url)
                }
                cell.title.text = row.title
            }
        }else if row.pushType == .联系客服 {
            cell.icon.image = UIImage(named: section.list[indexPath.row].iconStr)
            cell.title.text = section.list[indexPath.row].title
            cell.serviceNum = phoneNum
            cell.detail.delegate = self
            cell.accessoryType = .none
        }else {
            cell.icon.image = UIImage(named: section.list[indexPath.row].iconStr)
            cell.title.text = section.list[indexPath.row].title
            if row.showNotic {
                cell.noticeIcon.isHidden = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 7
        }
        return 4
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
    private func getNewsData() -> [MeSectionModel] {
        var list = [MeSectionModel]()
        
        var section1 = MeSectionModel()
        var section2 = MeSectionModel()
        
        var item5 = MeListDataModel()
        item5.title = "我的收藏"
        item5.iconStr = "collection"
        item5.pushType = .我的收藏
        section1.list.append(item5)
        
        var item9 = MeListDataModel()
        item9.title = "清除缓存"
        item9.iconStr = "rem"
        item9.pushType = .清除缓存
        section1.list.append(item9)
        
        var item7 = MeListDataModel()
        item7.title = "联系客服"
        item7.iconStr = "serive"
        item7.pushType = .联系客服
        section2.list.append(item7)
        
        var item1 = MeListDataModel()
        item1.title = "注册协议"
        item1.iconStr = "pro"
        item1.pushType = .注册协议
        section2.list.append(item1)
        
        var item6 = MeListDataModel()
        item6.title = "投诉建议"
        item6.iconStr = "help"
        item6.pushType = .投诉建议
        section2.list.append(item6)
        
        var item8 = MeListDataModel()
        item8.title = "关于我们"
        item8.iconStr = "our"
        item8.pushType = .关于我们
        section2.list.append(item8)
        
        
        list.append(section1)
        list.append(section2)
        
        return list
    }
    private func getBuyData() -> [MeSectionModel] {
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
        if let bonusNo = UserDefaults.standard.value(forKey: BonusNotice) as? String {
            if let bonusNom = Int(bonusNo) {
                if bonusNom > 0 {
                    item3.showNotic = true
                }
            }
        }
        section1.list.append(item3)
        
        var item4 = MeListDataModel()
        item4.title = "消息中心"
        item4.iconStr = "note-1"
        item4.pushType = .消息中心
        if let bonusNo = UserDefaults.standard.value(forKey: MessageNotice) as? String {
            if let bonusNom = Int(bonusNo) {
                if bonusNom > 0 {
                    item4.showNotic = true
                }
            }
        }
        section2.list.append(item4)
        
        var item5 = MeListDataModel()
        item5.title = "我的收藏"
        item5.iconStr = "collection"
        item5.pushType = .我的收藏
        section2.list.append(item5)
        
        var item9 = MeListDataModel()
        item9.title = "清除缓存"
        item9.iconStr = "rem"
        item9.pushType = .清除缓存
        section2.list.append(item9)
        
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
        
        var service = MeListDataModel()
        service.title = "在线客服"
        service.iconStr = "serive"
        service.pushType = .在线客服
        section2.list.append(service)
        
        var item8 = MeListDataModel()
        item8.title = "关于我们"
        item8.iconStr = "our"
        item8.pushType = .关于我们
        section2.list.append(item8)
        
        
        list.append(section1)
        list.append(section2)
        
        return list
    }
    
    private func setRightBut() {
        let but = UIButton(type: .custom)
        but.setTitle("设置", for: .normal)
        but.titleLabel?.font = Font17
        but.setTitleColor(Color787878, for: .normal)
        but.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        but.addTarget(self, action: #selector(setting), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: but)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
