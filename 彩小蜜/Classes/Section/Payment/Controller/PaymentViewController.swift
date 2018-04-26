//
//  PaymentViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum PaymentMethod : String{
    case 微信 = "app_weixin"
    case 余额 = ""
}


fileprivate let PaymentCellId = "PaymentCellId"
fileprivate let PaymentMethodCellId = "PaymentMethodCellId"

class PaymentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, CouponFilterViewControllerDelegate, WeixinPayDelegate {
    
    
    

    public var requestModel: FootballRequestMode!
    
    private var saveBetInfo : FootballSaveBetInfoModel!
    
    private var confirmBut : UIButton!
    
    private var paymentMethod : PaymentMethod = .余额
    
    private var paymentResult : PaymentResultModel!
    
    private var canPayment : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeixinCenter.share.payDelegate = self
        initSubview()
        orderRequest()
    }

    func onPaybuyWeixin(response: PayResp) {
        
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
    
    // MARK: - 网络请求
    private func orderRequest() {
        weak var weakSelf = self
        _ = homeProvider.rx.request(.saveBetInfo(requestModel: self.requestModel))
            .asObservable()
            .mapObject(type: FootballSaveBetInfoModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.saveBetInfo = data
                data.setBonus() // 设置默认选中的优惠券
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    weakSelf?.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil )
    }
    
    private func paymentRequest() {
        weak var weakSelf = self
        guard self.saveBetInfo != nil else { return }
        _ = paymentProvider.rx.request(.payment(payCode: paymentMethod.rawValue, payToken: self.saveBetInfo.payToken))
            .asObservable()
            .mapObject(type: PaymentResultModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.canPayment = true
                weakSelf?.paymentResult = data
                weakSelf?.showHUD(message: data.showMsg)
                let order = OrderDetailVC()
                order.backType = .root
                order.orderId = data.orderId
                weakSelf?.pushViewController(vc: order)
                
            }, onError: { (error) in
                weakSelf?.canPayment = true
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    weakSelf?.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil)
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
            return 2
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
                cell.detail.text = "- ¥" + self.saveBetInfo.bonusAmount
                cell.accessoryType = .disclosureIndicator
                cell.cellStyle = .detail
            case 3:
                cell.title.text = "还需支付"
                let money = NSAttributedString(string:"- ¥ " + self.saveBetInfo.thirdPartyPaid, attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
                cell.detail.attributedText = money
            default: break
            }
            return cell
        case 1:
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: PaymentCellId, for: indexPath) as! PaymentCell
                cell.title.text = "支付方式"
                cell.title.textColor = Color505050
                cell.detail.text = ""
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodCellId, for: indexPath) as! PaymentMethodCell
                cell.title.text = "微信支付"
                return cell
            default: break
            }
        default: break
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 * defaultScale
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
                guard self.saveBetInfo != nil else { return }
                let coupon = CouponFilterViewController()
                coupon.delegate = self
                coupon.bonusList = self.saveBetInfo.bonusList
                present(coupon)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 支付
    @objc private func confirmClicked(_ sender: UIButton) {
        guard canPayment else { return }
        self.canPayment = false
        paymentRequest()
    }
    // 选取的  优惠券
    func didSelected(bonus bonusId: String) {
        self.saveBetInfo.bonusId = bonusId
        self.saveBetInfo.setBonus()
        
        self.saveBetInfo.bonusId = bonusId
        orderRequest()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
