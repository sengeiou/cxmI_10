//
//  RechargeViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

let QueryMaxTimes = 5

fileprivate let RechargeCardCellIdentifier = "RechargeCardCellIdentifier"
fileprivate let RechargeTitleCellIdentifier = "RechargeTitleCellIdentifier"
fileprivate let RechargePaymentTitleCellId = "RechargePaymentTitleCellId"

class RechargeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, RechargeFooterViewDelegate, UITextFieldDelegate, ValidatePro, ActivityRechargeResultVCDelegate, ActivityRechargeCouponVCDelegate {
    
    public var userInfo  : UserInfoDataModel!
    
    private var maxTimes = QueryMaxTimes
    private var timeInterval : Double = 3
    //MARK: - 属性
    private var headerView : RechargeHeaderView!
    private var footerView : RechargeFooterView!
    private var rechargeAmount : String?
    private var cardCell : RechargeCardCell!
    private var textfield : UITextField!
    private var paymentAllList : [PaymentList]!
    private var paymentModel : PaymentList!
    private var paymentMethodModel : AllPaymentModel!
    private var paymentResult : PaymentResultModel!
    private var canPayment : Bool = true
    private var timer : Timer!
    
    private var selectedIndex : IndexPath!
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 充值"
        initSubview()
        allPaymentRequest()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startPollingTimer), name: NSNotification.Name(rawValue: NotificationWillEnterForeground), object: nil)
    }
    
    //MARK: - 点击事件
    func didTipShowDetail(vc: ActivityRechargeResultVC) {
        vc.backPopVC()
        
        pushPagerView(pagerType: .coupon)
    }
    func didTipReceive(vc: ActivityRechargeCouponVC, amount: String) {
        vc.dismiss(animated: true , completion: nil)
        
        let activity = ActivityRechargeResultVC()
        activity.delegate = self
        activity.rechargeAmount = amount
        self.present(activity)
    }
    
    @objc private func startPollingTimer() {
        
        if canPayment == false {
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(pollingStart), userInfo: nil, repeats: true)
            
            timer.fire()
        }
    }
    // 轮询
    @objc private func pollingStart() {
        
        guard maxTimes > 0 else {
            timer.invalidate()
            self.dismissProgressHud()
            showCXMAlert(title: "查询失败", message: "暂未查询到您的支付结果，如果您已经确认支付并成功扣款，可能存在延迟到账的情况，请到账户明细中查看或联系客服查询", action: "知道了", cancel: nil) { (action) in
                self.canPayment = true
            }
            return
        }
        maxTimes -= 3
        print(maxTimes)
        queryPaymentResultRequest()
    }
    
    func recharge() {
        guard self.canPayment else { return }
        guard validate(.number, str: self.cardCell.textfield.text) else {
            showHUD(message: "请输入整数的充值金额")
            return
        }
        maxTimes = QueryMaxTimes
        self.canPayment = false
        rechargeRequest(amount: self.cardCell.textfield.text!)
        TongJi.log(.充值支付, label: "ios", att: .终端)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let tex = textField as? CustomTextField {
            tex.changeBorderColor(string)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textfield {
            TongJi.log(.充值输入金额, label: "充值输入金额")
        }
    }
    
    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2, indexPath.row != 0 {
            self.paymentModel = self.paymentAllList[indexPath.row - 1]
            self.selectedIndex = indexPath
        }else {
            guard self.selectedIndex != nil else { return }
            tableView.selectRow(at: self.selectedIndex, animated: false, scrollPosition: .none)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    //MARK: - 网络请求
    // 充值
    private func rechargeRequest(amount: String) {
      
        guard self.paymentModel != nil else { return }
        
//        if self.paymentModel.payCode == "app_weixin" {
//            if WXApi.isWXAppInstalled() == false {
//                showHUD(message: "请先安装微信")
//                return
//            }
//        }
        self.showProgressHUD()
        weak var weakSelf = self
        
        _ = paymentProvider.rx.request(.paymentRecharge(payCode: self.paymentModel.payCode, totalAmount: amount))
            .asObservable()
            .mapObject(type: PaymentResultModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                self.paymentResult = data
                self.handlePaymentResult()
            }, onError: { (error) in
                self.dismissProgressHud()
                weakSelf?.canPayment = true
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
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
    
    // 查询支付结果
    private func queryPaymentResultRequest() {
        guard self.paymentResult != nil else { return }
        guard self.paymentResult.payLogId != nil else { return }
        weak var weakSelf = self
        _ = paymentProvider.rx.request(.paymentQuery(payLogId: self.paymentResult.payLogId))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                switch data.code {
                case "0":
                    self.canPayment = true
                    self.timer.invalidate()
                    
                    guard self.paymentMethodModel != nil else { return }
                    
                    /// 是否有充值活动
                    guard self.paymentMethodModel.isHaveRechargeAct else {
                        self.dismissProgressHud()
                        self.showHUD(message: data.msg)
                        self.popViewController()
                        return
                    }
                    
                    self.receiveRechargeBonusRequest()
                case "304035":
                    self.canPayment = true
                    //self.showHUD(message: data.msg)
                    self.showCXMAlert(title: "查询失败", message: "暂未查询到您的支付结果，如果您已经确认支付并成功扣款，可能存在延迟到账的情况，请到账户明细中查看或联系客服查询", action: "知道了", cancel: nil) { (action) in
                        self.canPayment = true
                    }
                    self.dismissProgressHud()
                case "304037":
                    self.showHUD(message: data.msg)
                case "304036":
                    
                    break
                    
                default: break
                }
                
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    private func handlePaymentResult() {
        
        guard self.paymentResult != nil else { return }
        
        if let payUrl = self.paymentResult.payUrl {
            guard let url = URL(string: payUrl) else { return }
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: { (success) in
                  
                    if success {
                        self.showProgressHUD()
                    }
                })
            } else {
               let success = UIApplication.shared.openURL(url)
                if success {
                    self.showProgressHUD()
                }
            }
        }else {
            
        }
    }
    
    private func allPaymentRequest() {
        self.dismissProgressHud()
        weak var weakSelf = self
        _ = paymentProvider.rx.request(.allPayment)
            .asObservable()
            .mapObject(type: AllPaymentModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                weakSelf?.paymentMethodModel = data
                weakSelf?.paymentAllList = data.paymentDTOList
                weakSelf?.tableview.reloadData()
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        
                        self.showHUD(message: msg!)
                    }
                    print("\(code)   \(msg!)")
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    // 充值送红包活动
    private func receiveRechargeBonusRequest() {
        guard self.paymentResult.payLogId != nil else { return }
        
        _ = activityProvider.rx.request(.receiveRechargeBonus(payLogId: self.paymentResult.payLogId))
            .asObservable()
            .mapObject(type: ReceiveRechargeBonusModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                guard self.paymentMethodModel.rechargeUserDTO != nil else { return }
                if self.paymentMethodModel.rechargeUserDTO.oldUserBz == "0" { // 新用户
                    let activity = ActivityRechargeResultVC()
                    activity.delegate = self
                    activity.rechargeAmount = data.donationPrice
                    self.present(activity)
                }else if self.paymentMethodModel.rechargeUserDTO.oldUserBz == "1" { // 老用户
                    let activity = ActivityRechargeCouponVC()
                    activity.delegate = self
                    activity.rechargeAmount = data.donationPrice
                    self.present(activity)
                }
            }, onError: { (error) in
                self.dismissProgressHud()
                print(error)
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        break
                        
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                    
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
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
                weakSelf?.tableview.reloadData()
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
    
    //MARK: - 懒加载
    lazy private var tableview : UITableView! = {
        let tableview = UITableView(frame: CGRect.zero, style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        self.view.addSubview(tableview)
        tableview.register(RechargeTitleCell.self, forCellReuseIdentifier: RechargeTitleCellIdentifier)
        tableview.register(RechargeCardCell.self, forCellReuseIdentifier: RechargeCardCellIdentifier)
        tableview.register(RechargePaymentCell.self, forCellReuseIdentifier: RechargeCellIdentifier)
        tableview.register(RechargePaymentTitleCell.self, forCellReuseIdentifier: RechargePaymentTitleCellId)
        
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        headerView = RechargeHeaderView()
        tableview.tableHeaderView = headerView
        
        footerView = RechargeFooterView()
        footerView.delegate = self
        tableview.tableFooterView = footerView
        
        return tableview
    }()
    
    //MARK: - Tableview DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            guard self.paymentAllList != nil else { return 1 }
            return self.paymentAllList.count + 1
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: RechargeTitleCellIdentifier, for: indexPath) as! RechargeTitleCell
            cell.userInfo = self.userInfo
            return cell
        case 1:
            let cell = tableview.dequeueReusableCell(withIdentifier: RechargeCardCellIdentifier, for: indexPath) as! RechargeCardCell
            self.cardCell = cell
            cell.textfield.delegate = self
            self.textfield = cell.textfield
            return cell
        case 2:
            if indexPath.row == 0 {
                let cell = tableview.dequeueReusableCell(withIdentifier: RechargePaymentTitleCellId, for: indexPath) as! RechargePaymentTitleCell
                return cell
            }
            
            let cell = tableview.dequeueReusableCell(withIdentifier: RechargeCellIdentifier, for: indexPath) as! RechargePaymentCell
            cell.paymentInfo = self.paymentAllList[indexPath.row - 1]
            if indexPath.row == 1 {
                if selectedIndex == nil {
                    self.selectedIndex = indexPath
                    self.paymentModel = self.paymentAllList[indexPath.row - 1]
                }
                tableView.selectRow(at: self.selectedIndex, animated: true , scrollPosition: .none)
                
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70
        case 1:
            return RechargeCardCell.height()
        case 2:
            return defaultCellHeight
        default:
            return defaultCellHeight
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
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
    //MARK: - UI
    private func initSubview() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard self.textfield != nil else { return }
        self.textfield.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.textfield != nil else { return }
        self.textfield.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
        timer = nil
        
    }
    
    override func back(_ sender: UIButton) {
        NotificationCenter.default.removeObserver(self)
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        
        self.dismissProgressHud()
        self.popViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
