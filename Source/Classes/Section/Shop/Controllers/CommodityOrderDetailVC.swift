//
//  CommodityOrderDetailVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/28.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class CommodityOrderDetailVC: BaseViewController, UIGestureRecognizerDelegate, Service {

    public var orderId : String!
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var payMentBut : UIButton!
    
    private var nameTextField : UITextField!
    private var phoneTextField : UITextField!
    private var adressTextView : HHTextView!
    private var goodsNumTF : UITextField!
    
    
    private var orderDetail : GoodsOrderDetail!
    private var calculate : GoodsCalculate!
    
    private var numViewModel : NumPlusReduceViewModel = NumPlusReduceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "订单详情"
        initSubview()
        orderDetailRequest()
        
    }
    
    private func initSubview() {
        tableView.register(ComOrderHeaderFooter.self, forHeaderFooterViewReuseIdentifier: ComOrderHeaderFooter.identifier)
    }
    
}
// MARK: - setupData
extension CommodityOrderDetailVC {
    private func setupData() {
        _ = numViewModel.number.subscribe { (event) in
            if let num = event.element {
                self.calculatePriceRequest(num: num)
            }
        }
    }
}
// MARK: - 点击事件
extension CommodityOrderDetailVC : UITableViewDelegate, NumPlusReduceViewProtocol {
    
    // -
    func reduce(view: NumPlusReduceView) {
        numViewModel.reduce()
    }
    // +
    func plus(view: NumPlusReduceView) {
        numViewModel.plus()
    }
    
    
    @IBAction func paymentClicked(_ sender: UIButton) {
        guard nameTextField.text != nil && nameTextField.text != "" else {
            showHUD(message: "请输入正确的联系人")
            return
        }
        guard phoneTextField.text != nil && phoneTextField.text != "" else {
            showHUD(message: "请输入联系电话")
            return
        }
        guard adressTextView.text != nil && adressTextView.text != "" else {
            showHUD(message: "请输入地址")
            return
        }
        
        var model = GoodsOrderUpdate()
        model.orderId = self.orderId
        model.contactsName = self.nameTextField.text ?? ""
        model.phone = self.phoneTextField.text ?? ""
        model.address = self.adressTextView.text
        if let num = try? numViewModel.number.value() {
            model.num = num
        }
        
        goodsUpdateRequest(model: model)
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.endEditing(true)
    }
}
// MARK: - DataSource
extension CommodityOrderDetailVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard orderDetail != nil else { return 0 }
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return initOrderInfoCell(indexPath: indexPath)
        case 1:
            switch indexPath.row {
            case 2:
                return initOrderAdressCell(indexPath: indexPath)
            default :
                return initOrderInputCell(indexPath: indexPath)
            }
        case 2:
            return initOrderPriceCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ComOrderHeaderFooter.identifier) as! ComOrderHeaderFooter
        switch section {
        case 1:
            header.configure(title: "收货地址")
            return header
        case 2:
            header.configure(title: "结算明细")
            return header
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            switch indexPath.row {
            case 2:
                return 150
            default :
                return 50
            }
        default:
            return 60
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.01
        default:
            return 40
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    private func initOrderInfoCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComOrderInfoCell", for: indexPath) as! ComOrderInfoCell
        cell.numView.viewModel = self.numViewModel
        
        cell.numView.delegate = self
        cell.numView.configure(with: "")
        cell.configure(with: orderDetail)
        self.goodsNumTF = cell.numView.textField
        return cell
    }
    private func initOrderInputCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComOrderInputCell", for: indexPath) as! ComOrderInputCell
        switch indexPath.row {
        case 0:
            cell.title.text = "收件人"
            cell.textField.placeholder = "请输入姓名"
            nameTextField = cell.textField
        default:
            cell.title.text = "联系电话"
            cell.textField.placeholder = "请输入联系电话"
            phoneTextField = cell.textField
        }
        return cell
    }
    private func initOrderAdressCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComOrderAdressCell", for: indexPath) as! ComOrderAdressCell
        adressTextView = cell.textView
        return cell
    }
    private func initOrderPriceCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComOrderPriceCell", for: indexPath) as! ComOrderPriceCell
        switch indexPath.row {
        case 0:
            cell.title.text = "商品数量"
            _ = numViewModel.number.subscribe { (event) in
                cell.detail.text = event.element
            }
            
        default:
            cell.title.text = "商品总价"
            _ = numViewModel.totalPrice.subscribe({ (event) in
                if let price = event.element {
                    cell.detail.text = "¥ " + price
                }
            })
            
        }
        return cell
    }
}
// MARK: - 网络请求
extension CommodityOrderDetailVC {
    private func orderDetailRequest() {
        weak var weakSelf = self
        
        _ = shopProvider.rx.request(.orderDetail(orderId: orderId)).asObservable()
            .mapObject(type: GoodsOrderDetail.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.orderDetail = data
                weakSelf?.setupData()
                weakSelf?.tableView.reloadData()
                weakSelf?.payMentBut.setTitle(data.bottonInfo, for: .normal)
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
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
                    print(code)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    private func calculatePriceRequest(num : String) {
        weak var weakSelf = self
        _ = shopProvider.rx.request(.calculatePrice(orderId: orderId, goodsNum: num)).asObservable()
            .mapObject(type: GoodsCalculate.self)
            .subscribe(onNext: { (data) in
                weakSelf?.calculate = data
                weakSelf?.numViewModel.totalPrice.onNext(data.totalPrice)
                
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
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
                    print(code)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    private func goodsUpdateRequest(model : GoodsOrderUpdate) {
        
        weak var weakSelf = self
        showProgressHUD()
        _ = shopProvider.rx.request(.goodsUpdate(model : model)).asObservable()
            .mapObject(type: PaymentModel.self)
            .subscribe(onNext: { (data) in
                if data.payToken != "" {
                    let payment = CXMPaymentViewController()
                    payment.lottoToken = data.payToken
                    weakSelf?.pushViewController(vc: payment)
                }else{
                    weakSelf?.initZhiChiService()
                }
               weakSelf?.dismissProgressHud()
               
            }, onError: { (error) in
                weakSelf?.dismissProgressHud()
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
                    print(code)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
}
