//
//  MeViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/2/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//  我的

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

class CXMMeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MeHeaderViewDelegate, MeFooterViewDelegate, TTTAttributedLabelDelegate, ClearCache {
    
    func didTipLogin() {
        goLogin()
    }
    
    
    /// 显示类型：资讯版||交易版
    public var showType: ShowType! = .onlyNews{
        didSet{
            guard showType != nil else { return }
            if showType == .onlyNews {
                tableView.tableHeaderView = newsheaderView
                self.meSectionList = getNewsData()
            }else {
                if hasLogin() {
                    tableView.tableHeaderView = headerView
                }else{
                    tableView.tableHeaderView = newsheaderView
                }
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
    
    private var photoSelect: YHPhotoSelect!
    //MARK: - View cycleLife
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBut()
        setRightBut()
        self.navigationItem.title = "我的"
        self.view.addSubview(tableView)
        
        self.photoSelect = YHPhotoSelect(controller: self, delegate: self)
        
        self.photoSelect.isAllowEdit = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(configNotification(_:)), name: NSNotification.Name(rawValue: NotificationConfig), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userIconSetting(_:)), name: NSNotification.Name(rawValue: UserIconSetting), object: nil)
        
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        setupNavigationBarTitle()
        
        if hasLogin() {
            userInfoRequest()
        }
    
        self.isHidenBar = false
        
        let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
        //TODO: 修改开关状态
        //let turnOn = true
        if turnOn && self.showType != .allShow{
            showType = .allShow
            //showType = .onlyNews
        }else if turnOn == false && self.showType != .onlyNews {
            showType = .onlyNews
        }

        // 隐藏消息 红点的显示
        hidenNotic()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TongJi.start("我的页")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TongJi.end("我的页")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    //MARK: - Event response
    func didTipUserIcon() {
        //showPhotoSelect()
    }
    @objc private func setting() {
        guard self.userInfo != nil else { return }
        let setting = CXMUserInfoSettingVC()
        setting.userInfo = self.userInfo
        pushViewController(vc: setting)
    }
    
    @objc private func configNotification(_ notification : Notification) {
        guard let userinf = notification.userInfo else { return }
        guard let turnOn = userinf["showStyle"] as? Bool else { return }
        if turnOn {
            showType = .allShow
            //showType = .onlyNews
        }else if turnOn == false {
            showType = .onlyNews
        }
    }
    
    @objc private func userIconSetting(_ notification : Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let image = userInfo["image"] as? UIImage else { return }
        
        if self.headerView != nil {
            self.headerView.setIcon(image: image)
        }
        
        if self.newsheaderView != nil {
            self.newsheaderView.setIcon(image: image)
        }
    }
    
    // header delegate
    func rechargeClicked() {
        print("充值")
        let recharge = CXMRechargeViewController()
        recharge.userInfo = userInfo
        pushViewController(vc: recharge)
        TongJi.log(.充值, label: "充值")

    }
    
    func withdrawalClicked() {
        print("提现")
        guard self.userInfo != nil else { return }
        guard self.userInfo != nil, self.userInfo.isReal else {

            showCXMAlert(title: nil, message: "请先实名认证后再申请提现", action: "去认证", cancel: "知道了") { (action) in
                let authentication = CXMAuthenticationVC()
                self.pushViewController(vc: authentication)
            }
            return }
        let draw = CXMWithdrawalViewController()
        pushViewController(vc: draw)
        TongJi.log(.提现, label: "提现")
    }
    
    // footer delegate
    func signOutClicked() {
        print("退出登录")
        guard getUserData() != nil else {
            goLogin()
            return
        }
        
        weak var weakSelf = self
        self.showCXMAlert(title: nil, message: "您正在退出登录", action: "继续退出", cancel: "返回") { (action) in
            weakSelf?.removeUserData()
            weakSelf?.pushRootViewController(0)
            weakSelf?.logoutRequest()
            TongJi.log(.退出登录, label: "退出登录")
        }
    }
    // 未认证 警告条 去认证
    func alertClicked() {
        TongJi.log(.实名认证, label: "实名认证")
        let authentication = CXMAuthenticationVC()
        pushViewController(vc: authentication)
    }
    // 客服电话
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        UIApplication.shared.openURL(URL(string: "telprompt://\(phoneNumber!)")!)
    }
    
    // 长按操作切换不同开发环境
    @objc func longPressAction(_ sender: UIGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            print("长按")
            showPlatformActionSheet()
        }
    }
    
    // 切换开发环境
    func showPlatformActionSheet() {
        print("切换开发环境")
        
        // 实例化时添加代理对象，同时注意添加协议
        let alertSheet = UIActionSheet(title: "开发环境选择", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "生产环境", "测试环境")
        alertSheet.show(in: self.view)
        alertSheet.delegate = self
        
    }

    
    //MARK: - Setup
    private func hidenNotic() {
        guard let bonusNo = UserDefaults.standard.value(forKey: BonusNotice) as? String else { return }
        guard let messaNo = UserDefaults.standard.value(forKey: MessageNotice) as? String else { return }
        guard let bonusNum = Int(bonusNo) else { return }
        guard let messaNum = Int(messaNo) else { return }
        
        if bonusNum <= 0 && messaNum <= 0 {
            self.tabBarController?.tabBar.hideBadgeOnItemIndex(index: 3)
        }
    }
    
    private func setupNavigationBarTitle() {
        #if DEBUG
        self.navigationItem.title = "我的(\(getCurrentPlatformType().description))"
        #else
        self.navigationItem.title = "我的"
        #endif
    }
    
    private func setRightBut() {
        let but = UIButton(type: .custom)
        but.setTitle("设置", for: .normal)
        but.titleLabel?.font = Font15
        but.setTitleColor(ColorNavItem, for: .normal)
        but.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        but.addTarget(self, action: #selector(setting), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: but)
    }
    

    
    //MARK: - Private methods
    private func setData() {
        if self.showType == .allShow {
            self.meSectionList = self.getBuyData()
        }else {
            self.meSectionList = self.getNewsData()
        }
        self.tableView.reloadData()
    }
    
    ///在线客服配置
    private func initZhiChiService() {
        let initInfo = ZCLibInitInfo()
        
        initInfo.appKey = ZhiChiAppKey
        initInfo.userId = ""
        
        let uiInfo = ZCKitInfo()
        
        uiInfo.isShowTansfer = true
        
        uiInfo.customBannerColor = ColorD12120
        
        uiInfo.topViewTextColor = UIColor.white
        
        uiInfo.titleFont = Font15
        
        uiInfo.satisfactionSelectedBgColor = ColorEA5504
        
        uiInfo.commentOtherButtonBgColor = ColorEA5504
        
        uiInfo.commentCommitButtonColor = ColorEA5504
        
        uiInfo.commentCommitButtonBgColor = ColorEA5504
        
        uiInfo.commentCommitButtonBgHighColor = ColorD12120
     
        ZCLibClient.getZCLibClient().libInitInfo = initInfo
        
        ZCSobot.startZCChatVC(uiInfo, with: self, target: nil, pageBlock: { (chatVC, type) in
            
        }, messageLinkClick: nil)
    }
    
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
        
        if userInfo != nil, userInfo.recharegeTurnOn {
            section1.list.append(item2)
        }
    
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
        
        //        var item7 = MeListDataModel()
        //        item7.title = "联系客服"
        //        item7.iconStr = "serive"
        //        item7.pushType = .联系客服
        //        section2.list.append(item7)
        
        var service = MeListDataModel()
        service.title = "在线客服"
        service.iconStr = "zaixiankefu"
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

    
    private func setupUserInfo() {
        
    }
    
    private func userInfoRequest() {
        weak var weakSelf = self
        _ = userProvider.rx.request(.userInfo)
            .asObservable()
            .mapObject(type: UserInfoDataModel.self)
            .subscribe(onNext: { (data) in
                guard weakSelf != nil else { return }
                weakSelf?.userInfo = data
                weakSelf?.headerView.userInfo = data
                weakSelf?.newsheaderView.userInfo = data
                weakSelf?.footerView.changeLoginButtonStatus()
                weakSelf?.setupUserInfo()
                weakSelf?.setData()
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
                        let login = CXMVCodeLoginViewController()
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
    
    private func showPhotoSelect() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let libraryAct = UIAlertAction(title: "从手机相册选择", style: .default) { (action) in
            self.photoSelect.start(YHEPhotoSelectFromLibrary)
        }
        libraryAct.setValue(ColorA0A0A0, forKey: "titleTextColor")
        
        let cameraAct = UIAlertAction(title: "拍照", style: .default) { (action) in
            self.photoSelect.start(YHEPhotoSelectTakePhoto)
        }
        cameraAct.setValue(ColorA0A0A0, forKey: "titleTextColor")
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        cancel.setValue(ColorEA5504, forKey: "titleTextColor")
        
        alertController.addAction(cameraAct)
        alertController.addAction(libraryAct)
        alertController.addAction(cancel)
        
        self.present(alertController)
    }
    
    //MARK: - PUSH
    private func pushMeViewController (_ model: MeListDataModel) {
        switch model.pushType {
        case .投注记录:
            guard getUserData() != nil else {
                pushLoginVC(from: self)
                return
            }
            
//            let  vc = CXMActivityViewController()
//
//            vc.urlStr = getCurentBaseWebUrl() + OrderRecord
//
//            pushViewController(vc: vc)
            
            
            pushPagerView(pagerType: .purchaseRecord)
            TongJi.log(.投注记录, label: "投注记录")
        case .账户明细:
            guard getUserData() != nil else {
                pushLoginVC(from: self)
                return
            }
            pushPagerView(pagerType: .accountDetails)
            TongJi.log(.账户明细, label: "账户明细")
        case .我的卡券:
            guard getUserData() != nil else {
                pushLoginVC(from: self)
                return
            }
            pushPagerView(pagerType: .coupon)
            TongJi.log(.我的卡券, label: "我的卡券")
        case .消息中心:
            guard getUserData() != nil else {
                pushLoginVC(from: self)
                return
            }
            pushPagerView(pagerType: .message)
            TongJi.log(.消息中心, label: "消息中心")
        case .我的收藏:
            guard getUserData() != nil else {
                pushLoginVC(from: self)
                return
            }
            let collection = CXMMyCollectionVC()
            pushViewController(vc: collection)
            TongJi.log(.我的收藏, label: "我的收藏")
        case .帮助中心:
            let web = CXMWebViewController()
            web.webName = "帮助中心"
            web.urlStr = getCurentBaseWebUrl() + webHelp
            pushViewController(vc: web)
            TongJi.log(.帮助中心, label: "帮助中心")
        case .联系客服:
            UIApplication.shared.openURL(URL(string: "telprompt://\(phoneNum)")!)
            TongJi.log(.联系客服, label: "联系客服")
        case .关于我们:
            let about = CXMMeAboutViewController()
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
            guard getUserData() != nil else {
                pushLoginVC(from: self)
                return
            }
            let complaint = CXMMeComplaintVC()
            pushViewController(vc: complaint)
            TongJi.log(.关于我们投诉建议, label: "关于我们投诉建议")
            break
        case .注册协议:
            let regis = CXMWebViewController()
            regis.urlStr = getCurentBaseWebUrl() + webRegisterAgreement
            pushViewController(vc: regis)
            TongJi.log(.注册用户协议, label: "注册用户协议" )
        case .在线客服:
            initZhiChiService()
            
            
        }
    }

  

    //MARK: - UITableview DataSource & Delegate
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
        }else if row.pushType == .账户明细 {
            cell.icon.image = UIImage(named: section.list[indexPath.row].iconStr)
            cell.title.text = section.list[indexPath.row].title
            cell.numLabel.text = ""
        }else if row.pushType == .我的卡券 {
            cell.icon.image = UIImage(named: section.list[indexPath.row].iconStr)
            cell.title.text = section.list[indexPath.row].title
            if self.userInfo != nil{
                if self.userInfo.bonusNumber == "0" || self.userInfo.bonusNumber == nil{
                    cell.numLabel.text = ""
                }else{
                    cell.numLabel.text = "\(self.userInfo.bonusNumber ?? "0")可用张优惠券"
                }
            }else{
                cell.numLabel.text = ""
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
            
            //长按切换开发环境
            #if DEBUG
            if row.pushType == .关于我们 {
                let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
                longPressGes.minimumPressDuration = 1.5
                longPressGes.numberOfTouchesRequired = 1
                cell.addGestureRecognizer(longPressGes)
            }
            #endif
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = self.meSectionList[indexPath.section]
        
        let row  = section.list[indexPath.row]
        
        pushMeViewController(row)
    }
    
    // MARK: - UIActionSheetDelegate
    public func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        guard buttonIndex != 0  else { return  }
        switch buttonIndex {
        case 1:
            UserDefaults.standard.set("http://94.191.113.169:8765", forKey: kBaseUrl)
            UserDefaults.standard.set("https://m.caixiaomi.net", forKey: kBaseWebUrl)
        case 2:
            UserDefaults.standard.set("http://39.106.18.39:8765", forKey: kBaseUrl)
            UserDefaults.standard.set("http://t1.caixiaomi.net:9805", forKey: kBaseWebUrl)
        default:
            UserDefaults.standard.set("http://94.191.113.169:8765", forKey: kBaseUrl)
            UserDefaults.standard.set("https://m.caixiaomi.net", forKey: kBaseWebUrl)
        }
        UserDefaults.standard.synchronize()
        
        let url = UserDefaults.standard.string(forKey: kBaseUrl)
        print("\(String(describing: url))")
        print("当前开发环境为：\(String(describing: UserDefaults.standard.string(forKey: kBaseUrl)))")
        
        //logout
        setupNavigationBarTitle()
        removeUserData()
        logoutRequest()
        self.userInfo = nil
        
        newsheaderView.changeHeaderStatusWithLogin()
        footerView.changeLoginButtonStatus()
        UserDefaults.standard.set(false, forKey: TurnOn)
        self.showType = .onlyNews

    }


    
    //MARK: - Getters、Setters
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
                if hasLogin() {
                    table.tableHeaderView = headerView
                }else{
                    table.tableHeaderView = newsheaderView
                }
            }
        }
        
        table.tableFooterView = footerView
        return table
    }()
    
}


//MARK: - Extension
extension CXMMeViewController : NewsHeaderViewDelegate {
    func didTipNewsLogin() {
        goLogin()
    }
    
    func didTipNewsUserIcon() {
        //showPhotoSelect()
    }
    
    private func goLogin() {
        //        let login = LDTYVCodeLoginViewController()
        //        pushViewController(vc: login)
        
        pushLoginVC(from: self)
    }
}

// MARK: - PhotoSelect Deleate
extension CXMMeViewController: YHDPhotoSelectDelegate {
    func imageFrom(image : UIImage, in rect: CGRect) -> UIImage {
        let sourceImageRef : CGImage = image.cgImage!
        
        let newImageRef = sourceImageRef.cropping(to: rect)
        
        return UIImage(cgImage: newImageRef!)
    }
    
    func yhdOptionalPhotoSelect(_ photoSelect: YHPhotoSelect!, didFinishedWithImageArray imageArray: [Any]!) {
        let img : UIImage = imageArray.last as! UIImage
        
        var resultImg = img
        
        if img.size.width != img.size.height {
            if img.size.width > img.size.height {
                let left : CGFloat = (img.size.width - img.size.height) / 2
                resultImg = self.imageFrom(image: img, in: CGRect(x: left, y: 0, width: img.size.height, height: img.size.height))
            }else if img.size.width < img.size.width {
                let top : CGFloat = (img.size.height - img.size.width) / 2
                resultImg = self.imageFrom(image: img, in: CGRect(x: 0, y: top, width: img.size.width, height: img.size.width))
            }
        }
        if self.headerView != nil {
            self.headerView.setIcon(image: resultImg)
        }
        if self.newsheaderView != nil {
            self.newsheaderView.setIcon(image: resultImg)
        }
        
        let data = resultImg.pngData()
        
        UserDefaults.standard.set(data, forKey: UserIconData)
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserIconSetting), object: nil, userInfo: ["image" : resultImg] )
    }
    
    func yhdOptionalPhotoSelectDidCancelled(_ photoSelect: YHPhotoSelect!) {
        
    }
}
