//
//  PaymentViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

//enum Paymenvarthod : String{
//    case 微信 = "app_weixin"
//    case 余额 = ""
//}

import SVProgressHUD

let NotificationWillEnterForeground = "NotificationWillEnterForeground"

fileprivate let PaymentCellId = "PaymentCellId"
fileprivate let PaymentMethodCellId = "PaymentMethodCellId"

class PaymentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, CouponFilterViewControllerDelegate, WeixinPayDelegate {
    
    
    private var maxTimes = 20
    private var timeInterval : Double = 3
    public var requestModel: FootballRequestMode!
    
    private var saveBetInfo : FootballSaveBetInfoModel!
    
    private var confirmBut : UIButton!
    
    //private var paymentMethod : PaymentMethod = .余额
    private var paymentAllList : [PaymentList]!
    
    private var paymentModel : PaymentList!
    
    private var paymentResult : PaymentResultModel!
    
    private var canPayment : Bool = true
    
    private var timer : Timer!
    
    private var selectedIndex : IndexPath!
    
    private var backed  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 支付订单"
        WeixinCenter.share.payDelegate = self
        initSubview()
        orderRequest()
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(pollingStart), userInfo: nil, repeats: true)
        timer.fire()
        timer.fireDate = Date.distantFuture
        
        NotificationCenter.default.addObserver(self, selector: #selector(startPollingTimer), name: NSNotification.Name(rawValue: NotificationWillEnterForeground), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didLogin(isLogin: Bool) {
        if isLogin == false {
            self.popViewController()
        }
    }
    
    @objc private func startPollingTimer() {
        if canPayment == false {
           timer.fireDate = Date.distantPast
        }
    }
    // 轮询
    @objc private func pollingStart() {
        
        guard maxTimes > 0 else {
            timer.invalidate()
            SVProgressHUD.dismiss()
            showCXMAlert(title: "查询失败", message: "暂未查询到您的支付结果，如果您已经确认支付并成功扣款，可能存在延迟到账的情况，请到账户明细中查看或联系客服查询", action: "知道了", cancel: nil) { (action) in
                self.canPayment = true
            }
            return
        }
        maxTimes -= 3
        print(maxTimes)
        queryPaymentResultRequest()
    }
    
    func onPaybuyWeixin(response: PayResp) {
        
    }

    // MARK: - 网络请求
    // 订单
    private func orderRequest() {
        weak var weakSelf = self
        _ = homeProvider.rx.request(.saveBetInfo(requestModel: self.requestModel))
            .asObservable()
            .mapObject(type: FootballSaveBetInfoModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.saveBetInfo = data
                data.setBonus() // 设置默认选中的优惠券
                //weakSelf?.tableView.reloadData()
                weakSelf?.allPaymentRequest()
            }, onError: { (error) in
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
            }, onCompleted: nil, onDisposed: nil )
    }
    // 支付方式
    private func allPaymentRequest() {
        weak var weakSelf = self
        _ = paymentProvider.rx.request(.paymentAll)
            .asObservable()
            .mapArray(type: PaymentList.self)
            .subscribe(onNext: { (data) in
                weakSelf?.paymentAllList = data
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
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
    // 支付
    private func paymentRequest() {
        weak var weakSelf = self
        guard self.saveBetInfo != nil else { return }
        if paymentModel == nil {
            paymentModel = PaymentList()
            paymentModel.payCode = ""
        }
        _ = paymentProvider.rx.request(.payment(payCode: paymentModel.payCode, payToken: self.saveBetInfo.payToken))
            .asObservable()
            .mapObject(type: PaymentResultModel.self)
            .subscribe(onNext: { (data) in
                if !self.backed {
                    self.paymentResult = data
                    self.handlePaymentResult()
                }else {
                    self.popViewController()
                }
                
            }, onError: { (error) in
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
                    self.showHUD(message: data.msg)
                    SVProgressHUD.dismiss()
                    let order = OrderDetailVC()
                    order.backType = .root
                    order.orderId = self.paymentResult.orderId
                    self.pushViewController(vc: order)
                case "304035":
                    self.canPayment = true
                    //self.showHUD(message: data.msg)
                    self.showCXMAlert(title: "查询失败", message: "暂未查询到您的支付结果，如果您已经确认支付并成功扣款，可能存在延迟到账的情况，请到账户明细中查看或联系客服查询", action: "知道了", cancel: nil) { (action) in
                        self.canPayment = true
                    }
                    SVProgressHUD.dismiss()
                case "304037":
                    self.showHUD(message: data.msg)
                case "304036":
                    break
                    
                default: break
                }
                
            }, onError: { (error) in
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
        SVProgressHUD.show()
        guard self.saveBetInfo != nil else { return }
        guard self.saveBetInfo.thirdPartyPaid != nil else { return }
        guard self.saveBetInfo.thirdPartyPaid != 0 else {
            showHUD(message: self.paymentResult.showMsg)
            SVProgressHUD.dismiss()
            self.canPayment = true
            let order = OrderDetailVC()
            order.backType = .root
            order.orderId = paymentResult.orderId
            pushViewController(vc: order)
            return
        }
        
        guard self.paymentResult != nil else { return }
        
        if let payUrl = self.paymentResult.payUrl {
            guard let url = URL(string: payUrl) else { return }
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            
                })
            } else {
                UIApplication.shared.openURL(url)
            }
            //timer.fire()
            //self.queryPaymentResultRequest()
        }else {
            //self.queryPaymentResultRequest()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(SafeAreaTopHeight)
            make.left.right.equalTo(0)
            make.bottom.equalTo(confirmBut.snp.top)
        }
        confirmBut.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(44 * defaultScale)
            make.bottom.equalTo(-SafeAreaBottomHeight)
        }
    }
    private func initSubview() {
        self.view.addSubview(tableView)
        initBottowView()
    }
    private func initBottowView() {
        confirmBut = UIButton(type: .custom)
        confirmBut.setTitle("确认支付", for: .normal)
        confirmBut.setTitleColor(ColorFFFFFF, for: .normal)
        confirmBut.backgroundColor = ColorEA5504
        confirmBut.titleLabel?.font = Font15
        confirmBut.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(confirmBut)
    }
    // MARK: 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        table.register(PaymentCell.self, forCellReuseIdentifier: PaymentCellId)
        table.register(PaymentMethodCell.self, forCellReuseIdentifier: PaymentMethodCellId)
        if #available(iOS 11.0, *) {
            
        }else {
            table.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 49, right: 0)
            table.scrollIndicatorInsets = table.contentInset
        }
        return table
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.saveBetInfo != nil else { return 0 }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            guard self.saveBetInfo != nil else { return 0 }
            guard self.saveBetInfo.thirdPartyPaid > 0 else { return 0 }
            guard paymentAllList != nil else { return 1 }
            return paymentAllList.count + 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard self.saveBetInfo != nil else { return UITableViewCell()}
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentCellId, for: indexPath) as! PaymentCell
            switch indexPath.row {
            case 0:
                cell.title.text = "订单金额"
                let money = NSAttributedString(string:"¥" + self.saveBetInfo.orderMoney, attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
                cell.detail.attributedText = money
            case 1:
                cell.title.text = "余额抵扣"
                cell.detail.text = "- ¥" + self.saveBetInfo.surplus
            case 2:
                cell.title.text = "优惠券抵扣"
                
                if self.saveBetInfo.bonusList.isEmpty {
                    cell.detail.text = "暂无优惠券"
                    cell.accessoryType = .none
                    cell.cellStyle = .defaults
                }else {
                    cell.detail.text = "- ¥" + self.saveBetInfo.bonusAmount
                    cell.accessoryType = .disclosureIndicator
                    cell.cellStyle = .detail
                }
                
            case 3:
                cell.title.text = "还需支付"
                let money = NSAttributedString(string:"¥ " + "\(self.saveBetInfo.thirdPartyPaid!)", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
                cell.detail.attributedText = money
            default: break
            }
            return cell
        case 1:
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: PaymentCellId, for: indexPath) as! PaymentCell
                cell.title.text = "支付方式"
                cell.title.font = Font16
                cell.title.textColor = Color505050
                cell.detail.text = ""
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodCellId, for: indexPath) as! PaymentMethodCell
                let paymentModel = paymentAllList[indexPath.row - 1 ]
                cell.paymentInfo = paymentModel
                if indexPath.row == 1 {
                    
                    if self.selectedIndex == nil {
                        self.selectedIndex = indexPath
                        self.paymentModel = paymentModel
                    }
                    tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
                }
                
                return cell
            }
        default: break
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 * defaultScale
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.01
        default:
            return 5
        }
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
    
    // MARK : - 点击事件
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                guard self.saveBetInfo != nil, self.saveBetInfo.bonusList.isEmpty == false else {
                    
                    return }
                let coupon = CouponFilterViewController()
                coupon.delegate = self
                coupon.bonusList = self.saveBetInfo.bonusList
                present(coupon)
                
            }
            
            guard self.selectedIndex != nil else { return }
            tableView.selectRow(at: self.selectedIndex, animated: true, scrollPosition: .none)
        }else if indexPath.section == 1 {
            
            if indexPath.row != 0 {
                self.paymentModel = paymentAllList[indexPath.row - 1 ]
                self.selectedIndex = indexPath
            }else {
                guard self.selectedIndex != nil else { return }
                tableView.selectRow(at: self.selectedIndex, animated: true, scrollPosition: .none)
            }
        }
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 支付
    @objc private func confirmClicked(_ sender: UIButton) {
        guard canPayment else { return }
        self.canPayment = false
        maxTimes = 20
        paymentRequest()
    }
    // 选取的  优惠券
    func didSelected(bonus bonusId: String) {
        self.saveBetInfo.bonusId = bonusId
        self.saveBetInfo.setBonus()
        
        self.requestModel.bonusId = bonusId
        orderRequest()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    override func back(_ sender: UIButton) {
        NotificationCenter.default.removeObserver(self)
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        self.backed = true
        self.dismissProgressHud()
        self.popViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
