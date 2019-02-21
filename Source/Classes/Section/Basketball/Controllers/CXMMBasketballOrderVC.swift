//
//  CXMMBasketballOrderVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift

class CXMMBasketballOrderVC: BaseViewController {

    public var orderId : String = ""
    
    public var backType : BackType = .notRoot
    
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var orderIcon: UIImageView!
    
    @IBOutlet weak var playName: UILabel!
    
    @IBOutlet weak var payMoney: UILabel!
    // 订单状态
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderStatusIcon: UIImageView!
    
    @IBOutlet weak var oneMsgOrderStatus: UILabel!
    
    // 中奖信息
    @IBOutlet weak var winningTitle: UILabel!
    @IBOutlet weak var winningAmount: UILabel!
    
    // 预测奖金
    @IBOutlet weak var forecastBonus : UILabel!
    // 继续预约 按钮
    @IBOutlet weak var goBuyButton : UIButton!
    
    private var disposeBag : DisposeBag = DisposeBag()
    
    private var orderInfo : OrderInfoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "模拟订单详情"
        initSubview()
        
        tableView.headerRefresh {
            self.loadNewData()
        }
        tableView.beginRefreshing()
        setDefaultData()
    }

    private func initSubview() {
        self.goBuyButton.backgroundColor = ColorEA5504
    }
    private func setDefaultData() {
        winningTitle.text = ""
        winningAmount.text = ""
        orderStatusIcon.image = nil
    }
    private func setData() {
        guard orderInfo != nil else { return }
        if let url = URL(string: orderInfo.lotteryClassifyImg) {
            orderIcon.kf.setImage(with: url)
        }
        
        playName.text = orderInfo.lotteryClassifyName
        
        let moneyAtt = NSMutableAttributedString(string: "¥", attributes: [NSAttributedString.Key.font: Font10])
        let money = NSAttributedString(string: orderInfo.ticketAmount)
        moneyAtt.append(money)
        
        payMoney.attributedText = moneyAtt
        
        orderStatus.text = orderInfo.orderStatusDesc
        
        switch orderInfo.orderStatus {
        case "2":
            winningTitle.text = ""
            winningAmount.text = ""
            orderStatusIcon.image = nil
            oneMsgOrderStatus.text = orderInfo.processStatusDesc
            
            forecastBonus.text = orderInfo.forecastMoney
            
        case "4": // 未中奖
            winningTitle.text = ""
            winningAmount.text = ""
            forecastBonus.text = ""
            oneMsgOrderStatus.text = orderInfo.processStatusDesc
            orderStatusIcon.image = UIImage(named: "NoPrize")
        case "5", "6" , "7": // 已中奖
            oneMsgOrderStatus.text = ""
            forecastBonus.text = ""
            winningTitle.text = "中奖金额"
            winningAmount.text = "¥ " + orderInfo.processStatusDesc
            orderStatusIcon.image = UIImage(named: "Prize")
            
        default:
            winningTitle.text = ""
            winningAmount.text = ""
            forecastBonus.text = ""
            orderStatusIcon.image = nil
            oneMsgOrderStatus.text = ""
            break
        }
    }
    
    override func back(_ sender: UIButton) {
        switch backType {
        case .notRoot:
            self.popViewController()
        case .root:
            self.popToRootViewController()
            //self.popToHome()
        }
    }
}
// MARK: - 点击事件
extension CXMMBasketballOrderVC {
    @IBAction func goBuyClick(_ sender : UIButton) {
        guard orderInfo != nil else { return }
        
        let story = UIStoryboard(storyboard: .Basketball)
        
        let basketball = story.instantiateViewController(withIdentifier: "BasketballVC") as! CXMMBasketballVC

        pushViewController(vc: basketball)
    }
}
// MARK: - tableview Delegate
extension CXMMBasketballOrderVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let story = UIStoryboard(storyboard: .Basketball)
            let vc = story.instantiateViewController(withIdentifier: "BasketballOrderScheme") as! CXMMBasketballOrderScheme
            vc.orderSn = self.orderInfo.orderSn
            vc.programmeSn = self.orderInfo.programmeSn
            pushViewController(vc: vc)
            
//            let scheme = CXMOrderSchemeVC()
//            scheme.programmeSn = self.orderInfo.programmeSn
//            scheme.orderSn = self.orderInfo.orderSn
//            pushViewController(vc: scheme)
        default:
            break
        }
    }
}
// MARK: - tableview DataSource
extension CXMMBasketballOrderVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard orderInfo != nil else { return 0 }
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return orderInfo.matchInfos.count + 2
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return initDetailTitleCell(indexPath: indexPath)
            case orderInfo.matchInfos.count + 1:
                return initBetInfoCell(indexPath: indexPath)
            default :
                return initDetailCell(indexPath: indexPath)
            }
        default:
            return initProgrammeCell(indexPath: indexPath)
        }
    }
    
    private func initDetailTitleCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BBOrderDetailTitleCell", for: indexPath) as! BBOrderDetailTitleCell
        return cell
    }
    private func initDetailCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BBOrderDetailCell", for: indexPath) as! BBOrderDetailCell
        if indexPath.row > 0 {
            cell.configure(with: orderInfo.matchInfos[indexPath.row - 1])
        }
        return cell
    }
    private func initBetInfoCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BBOrderBetInfoCell", for: indexPath) as! BBOrderBetInfoCell
        cell.configure(with: orderInfo)
        return cell
    }
    private func initProgrammeCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BBProgrammeCell", for: indexPath) as! BBProgrammeCell
        cell.configure(with: self.orderInfo)
        return cell
    }
    
}
extension CXMMBasketballOrderVC {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
            case 0:
                return 100 * defaultScale
            case self.orderInfo.matchInfos.count + 1:
                return 70
            default :
                return UITableView.automaticDimension
            }
        
        case 1:
            return 180
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
// MARK: - 网络请求
extension CXMMBasketballOrderVC {
    private func loadNewData() {
        orderDetailRequest()
    }
    private func orderDetailRequest() {
        weak var weakSelf = self
        
        _ = basketBallProvider.rx.request(.orderDetail(orderId: orderId))
            .asObservable()
            .mapObject(type: OrderInfoModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.orderInfo = data
                weakSelf?.tableView.reloadData()
                weakSelf?.setData()
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    if 300000...310000 ~= code {
                        weakSelf?.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
