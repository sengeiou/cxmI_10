//
//  CXMMDaletouOrderVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMDaletouOrderVC: BaseViewController {

    public var orderId: String!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var orderIcon: UIImageView!
    
    @IBOutlet weak var stageNum: UILabel!
    
    @IBOutlet weak var payMoney: UILabel!
    // 订单状态
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderStatusIcon: UIImageView!
    
    @IBOutlet weak var winningTitle: UILabel!
    @IBOutlet weak var winningAmount: UILabel!
    
    private var orderModel : DLTOrderDetailModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableview()
        //loadNewData()
        setDefaultData()
        
        self.orderModel = DLTOrderDetailModel()
        
        var list = [DLTOrderResult]()
        
        for _ in 0...2{
            var model = DLTOrderResult()
            model.playType = "2"
            var reds = [DLTOrderItemInfo]()
            var blues = [DLTOrderItemInfo]()
            
            var danReds = [DLTOrderItemInfo]()
            var dragReds  = [DLTOrderItemInfo]()
            var danBlues  = [DLTOrderItemInfo]()
            var dragBlues  = [DLTOrderItemInfo]()
            
            for i in 0...5 {
                let red = DLTOrderItemInfo()
                red.cathectic = "\(i)"
                reds.append(red)
            }
            
            for i in 5...7 {
                let blue = DLTOrderItemInfo()
                blue.cathectic = "\(i)"
                blues.append(blue)
            }
            
            
            for i in 5...15 {
                let blue = DLTOrderItemInfo()
                blue.cathectic = "\(i)"
                danReds.append(blue)
            }
            for i in 5...7 {
                let blue = DLTOrderItemInfo()
                blue.cathectic = "\(i)"
                dragReds.append(blue)
            }
            for i in 8...10 {
                let blue = DLTOrderItemInfo()
                blue.cathectic = "\(i)"
                danBlues.append(blue)
            }
            for i in 5...7 {
                let blue = DLTOrderItemInfo()
                blue.cathectic = "\(i)"
                dragBlues.append(blue)
            }
            
            
            //model.redCathectics = reds
            //model.blueCathectics = blues
            
            model.redDanCathectics = danReds
            model.redTuoCathectics = dragReds
            
            model.blueDanCathectics = danBlues
            model.blueTuoCathectics = dragBlues
            
            list.append(model)
        }
        
        
        
        self.orderModel.prePrizeInfo = "xxxxxxxx"
        self.orderModel.cathecticResults = list
        self.tableView.reloadData()
        
        
    }

  

    

}
extension CXMMDaletouOrderVC {
    private func setTableview() {
        self.tableView.separatorStyle = .none
    }
    private func setDefaultData() {
        winningTitle.text = ""
        winningAmount.text = ""
        orderStatusIcon.image = nil
    }
    private func setData() {
        if let url = URL(string: orderModel.lotteryClassifyImg) {
            self.orderIcon.kf.setImage(with: url)
        }
        
        orderStatus.text = orderModel.orderStatusDesc
        
        let moneyAtt = NSMutableAttributedString(string: "¥", attributes: [NSAttributedStringKey.font: Font10])
        let money = NSAttributedString(string: orderModel.ticketAmount)
        moneyAtt.append(money)
        
        payMoney.attributedText = moneyAtt
        
        switch orderModel.orderStatus {
        case "4": // 未中奖
            winningTitle.text = ""
            winningAmount.text = ""
            orderStatusIcon.image = UIImage(named: "NoPrize")
        case "5": // 已中奖
            winningTitle.text = "中奖金额"
            winningAmount.text = orderModel.orderStatusDesc
            orderStatusIcon.image = UIImage(named: "Prize")
        default:
            winningTitle.text = ""
            winningAmount.text = ""
            orderStatusIcon.image = nil
            break
        }
        
    }
}
// MARK: - 请求
extension CXMMDaletouOrderVC {
    private func loadNewData() {
        
    }
    private func orderDetailRequest() {
        guard orderId != nil else { fatalError("orderId 为空") }
        weak var weakSelf = self
        
        _ = dltProvider.rx.request(.orderDetail(orderId: orderId))
            .asObservable()
            .mapObject(type: DLTOrderDetailModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.orderModel = data
                weakSelf?.setData()
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
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
extension CXMMDaletouOrderVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            let story = UIStoryboard(name: "Daletou", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "DaletouProVC") as! CXMMDaletouProVC
            pushViewController(vc: vc)
        default:
            break
        }
    }
}
extension CXMMDaletouOrderVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard orderModel != nil else { return 0 }
        switch section {
        case 0:
            return 1
        case 1:
            return orderModel.cathecticResults != nil ? orderModel.cathecticResults.count + 2 : 0
        case 2:
            return 1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if orderModel.prizeNum == nil {
                return initNotPrizeTitleCell(indexPath: indexPath)
            }
            else {
                return initPrizeTitleCell(indexPath: indexPath)
            }
        case 1:
            switch indexPath.row{
            case 0:
                return initOrderTitleCell(indexPath: indexPath)
            case orderModel.cathecticResults.count + 1:
                return initPrizeExplainCell(indexPath: indexPath)
            default :
                return initPrizeOrderCell(indexPath: indexPath)
            }
            
        case 2:
            return initProgrammeCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 50
        case 1:
            
            switch indexPath.row{
            case 0:
                return 50
            case orderModel.cathecticResults.count + 1:
                return 50
            default :
                
                let model = orderModel.cathecticResults[indexPath.row - 1]
                
                var listCount = 0
                
                switch model.playType {
                case "0", "1":
                    listCount = model.redCathectics.count + model.blueCathectics.count
                case "2":
                    listCount = model.redDanCathectics.count + 1 + model.redTuoCathectics.count
                    if model.blueDanCathectics.count != 0 {
                        listCount += 1
                    }
                    listCount += model.blueDanCathectics.count
                    listCount += model.blueTuoCathectics.count
                default : break
                }
                
                let count : Int = listCount / 10
                
                if count == 0 {
                    return 75
                }else {
                    let num : Int = listCount % 10
                    if num == 0 {
                        return CGFloat(40 + 40 * count)
                    }else {
                        return CGFloat(40 + 40 * (count + 1))
                    }
                }
                
                return 50
            }
            
            
            
         
        case 2:
            return 180
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    private func initNotPrizeTitleCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DLTNotPrizeTitleCell", for: indexPath) as! DLTNotPrizeTitleCell
        cell.configure(with: orderModel.prePrizeInfo)
        return cell
    }
    private func initPrizeTitleCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DLTPrizeTitleCell", for: indexPath) as! DLTPrizeTitleCell
        cell.configure(with: orderModel.prizeNum)
        return cell
    }
    private func initPrizeOrderCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DLTPrizeOrderCell", for: indexPath) as! DLTPrizeOrderCell
        cell.configure(with: orderModel.cathecticResults[indexPath.row - 1])
        return cell
    }
    private func initProgrammeCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DLTProgrammeCell", for: indexPath) as! DLTProgrammeCell
        cell.configure(with: orderModel)
        return cell
    }
    private func initOrderTitleCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DLTOrderTitleCell", for: indexPath) as! DLTOrderTitleCell
        
        return cell
    }
    private func initPrizeExplainCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DLTPrizeExplainCell", for: indexPath) as! DLTPrizeExplainCell
        
        return cell
    }
}
