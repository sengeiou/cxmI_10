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
    
    public var backType : BackType = .notRoot
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var orderIcon: UIImageView!
    
    @IBOutlet weak var stageNum: UILabel!
    
    @IBOutlet weak var payMoney: UILabel!
    // 订单状态
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderStatusIcon: UIImageView!
    
    @IBOutlet weak var oneMsgOrderStatus: UILabel!
    
    @IBOutlet weak var winningTitle: UILabel!
    @IBOutlet weak var winningAmount: UILabel!
    
    @IBOutlet weak var buyThisButton : UIButton!
    
    @IBOutlet weak var buyDaletouButton : UIButton!
    
    private var orderModel : DLTOrderDetailModel!
    
    private var share : UIButton!
    private var modes = [HXGuideInfoModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "订单详情"
        setTableview()
        loadNewData()
        setDefaultData()
        
        buyThisButton.backgroundColor = ColorEA5504
        buyDaletouButton.backgroundColor = ColorEA5504
        
        setRightNav()
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

extension CXMMDaletouOrderVC {
    @IBAction func buyDaletou(_ sender: UIButton) {
//        let stor = UIStoryboard(name: "Daletou", bundle: nil)
//
//        let dlt = stor.instantiateViewController(withIdentifier: "DaletouViewController") as! CXMMDaletouViewController
//
//        pushViewController(vc: dlt)
    }
    
    @IBAction func buyThisNumber(_ sender: UIButton) {
        
//        let stor = UIStoryboard(name: "Daletou", bundle: nil)
//
//        let dlt = stor.instantiateViewController(withIdentifier: "DaletouConfirmVC") as! CXMMDaletouConfirmVC
//
//        dlt.list = parse().0
//        dlt.isAppendSubject.onNext(parse().1)
//        dlt.multiple.onNext(parse().2)
//        pushViewController(vc: dlt)
    }
    
    private func parse() -> ([DaletouDataList], Bool, Int){
        var list = [DaletouDataList]()
        var isAppend : Bool = false
        var times : Int = 1
        for data in self.orderModel.cathecticResults {
            let model = DaletouDataList()
            model.bettingNum = Int(data.betNum)!
            model.multiple = Int(data.cathectic)!
            times = model.multiple
            if data.isAppend == "0" {
                model.money = 2
                model.isAppend = false
                isAppend = false
            }else {
                model.money = 3
                model.isAppend = true
                isAppend = true
            }
         
            switch data.playType {
            case "0", "1":
                model.type = .标准选号
                for mo in data.redCathectics {
                    let redModel = DaletouDataModel()
                    redModel.num = mo.cathectic
                    redModel.number = Int(mo.cathectic)
                    redModel.selected = true
                    redModel.style = .red
                    model.redList.append(redModel)
                }
                for mo in data.blueCathectics {
                    let redModel = DaletouDataModel()
                    redModel.num = mo.cathectic
                    redModel.number = Int(mo.cathectic)
                    redModel.selected = true
                    redModel.style = .blue
                    model.blueList.append(redModel)
                }
            case "2":
                model.type = .胆拖选号
                for redDan in data.redDanCathectics {
                    let redModel = DaletouDataModel()
                    redModel.num = redDan.cathectic
                    redModel.number = Int(redDan.cathectic)
                    redModel.selected = true
                    redModel.style = .danRed
                    model.danRedList.append(redModel)
                }
                for redDrag in data.redTuoCathectics {
                    let redModel = DaletouDataModel()
                    redModel.num = redDrag.cathectic
                    redModel.number = Int(redDrag.cathectic)
                    redModel.selected = true
                    redModel.style = .dragRed
                    model.dragRedList.append(redModel)
                }
                for mo in data.blueDanCathectics {
                    let redModel = DaletouDataModel()
                    redModel.num = mo.cathectic
                    redModel.number = Int(mo.cathectic)
                    redModel.selected = true
                    redModel.style = .danBlue
                    model.danBlueList.append(redModel)
                }
                for mo in data.blueTuoCathectics {
                    let redModel = DaletouDataModel()
                    redModel.num = mo.cathectic
                    redModel.number = Int(mo.cathectic)
                    redModel.selected = true
                    redModel.style = .dragBlue
                    model.dragBlueList.append(redModel)
                }
            default : break
            }
            
            list.append(model)
        }
        
        return (list, isAppend, times)
    }
    
    
}

extension CXMMDaletouOrderVC {
    private func setTableview() {
        self.tableView.separatorStyle = .none
        self.tableView.register(OrderStoreCell.self, forCellReuseIdentifier: OrderStoreCell.identifier)
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
        stageNum.text = "大乐透" + orderModel.termNum + "期"
        orderStatus.text = orderModel.orderStatusDesc
        
        // 1.2.0 去掉¥符号
        let moneyAtt = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: Font10])
        let money = NSAttributedString(string: orderModel.ticketAmount)
        moneyAtt.append(money)
        
        payMoney.attributedText = moneyAtt
        
        switch orderModel.orderStatus {
        case "2":
            winningTitle.text = ""
            winningAmount.text = ""
            orderStatusIcon.image = nil
            oneMsgOrderStatus.text = orderModel.processStatusDesc
        case "4": // 未中奖
            winningTitle.text = ""
            winningAmount.text = ""
            oneMsgOrderStatus.text = orderModel.processStatusDesc
            orderStatusIcon.image = UIImage(named: "NoPrize")
        case "5", "6" , "7": // 已中奖
            oneMsgOrderStatus.text = ""
            winningTitle.text = "中奖金额"
            winningAmount.text = "¥ " + orderModel.winningMoney
            orderStatusIcon.image = UIImage(named: "Prize")
        case "9" :
            oneMsgOrderStatus.text = ""
            winningTitle.text = "中奖金额"
            winningAmount.text = "¥ " + orderModel.winningMoney
            orderStatusIcon.image = UIImage(named: "Prize")
        default:
            winningTitle.text = ""
            winningAmount.text = ""
            orderStatusIcon.image = nil
            oneMsgOrderStatus.text = ""
            break
        }
        
    }
}
// MARK: - 请求
extension CXMMDaletouOrderVC {
    private func loadNewData() {
        orderDetailRequest()
    }
    private func orderDetailRequest() {
        guard orderId != nil else { fatalError("orderId 为空") }
        weak var weakSelf = self
        self.showProgressHUD()
        _ = dltProvider.rx.request(.orderDetail(orderId: orderId))
            .asObservable()
            .mapObject(type: DLTOrderDetailModel.self)
            .subscribe(onNext: { (data) in
                
                weakSelf?.orderModel = data
                weakSelf?.setData()
                weakSelf?.tableView.reloadData()
                weakSelf?.dismissProgressHud()
                weakSelf?.showMask()
            }, onError: { (error) in
                weakSelf?.dismissProgressHud()
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
        case 1:
            if indexPath.row == self.orderModel.cathecticResults.count + 1 { // 最后一个 -》 奖金如何计算
                let web = CXMWebViewController()
                web.urlStr = getCurentBaseWebUrl() + DLTPlayHelpUrl
                pushViewController(vc: web)
            }
        case 2:
            let story = UIStoryboard(name: "Daletou", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "DaletouProVC") as! CXMMDaletouProVC
            vc.orderSn = self.orderModel.orderSn
            vc.proSn = self.orderModel.programmeSn
            pushViewController(vc: vc)
        case 3:
            
            let model = orderModel.appendInfoList[indexPath.row]
            
            switch model.type {
            case "0":
                let story = UIStoryboard.init(storyboard: .Seller)
                let vc = story.instantiateViewController(withIdentifier: "SellerListVC") as! SellerListVC
                pushViewController(vc: vc)
            case "1":
                pushRouterVC(urlStr: model.pushurl, from: self)
            default :
                break
            }
        default:
            break
        }
    }
}
extension CXMMDaletouOrderVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard orderModel != nil else { return 0 }
        return 3 + orderModel.appendInfoList.count
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
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if orderModel.prizeNum == nil || orderModel.prizeNum.isEmpty {
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
            
            let model = orderModel.appendInfoList[indexPath.row]
            
            switch model.type {
            case "1":
                return initQRCodeCell(indexPath: indexPath)
            case "0":
                return initStoreCell(indexPath: indexPath)
            default :
                return UITableViewCell()
            }
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
                    listCount += 1
                    listCount += model.blueTuoCathectics.count
                default : break
                }
                
                let count : Int = listCount / 10
                
                if count == 0 {
                    return 75
                }else {
                    let num : Int = listCount % 10
                    if num == 0 {
                        return CGFloat(40 + 44 * count)
                    }else {
                        return CGFloat(40 + 44 * (count + 1))
                    }
                }
            }
            
        case 2:
            return 120
        case 3:
            
            let model = orderModel.appendInfoList[indexPath.row]
            
            switch model.type {
            case "1":
                return 250
            case "0":
                return 90
            default :
                return 0
            }
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
    
    private func initStoreCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderStoreCell.identifier, for: indexPath) as! OrderStoreCell
        cell.configure(with: orderModel.appendInfoList[indexPath.row])
        return cell
    }
    
    private func initQRCodeCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailQRCodeCell", for: indexPath) as! OrderDetailQRCodeCell
        cell.delegate = self
        cell.configure(with: orderModel.appendInfoList[indexPath.row])
        print(cell.frame)
        return cell
    }
}
extension CXMMDaletouOrderVC : ShareProtocol {
    private func setRightNav(){
        //        let codeItem = getRightNavOfQRCode()
        let shareItem = getRightNavOfShare()
        
        navigationItem.rightBarButtonItems = [shareItem]
    }
    
    private func getRightNavOfQRCode() -> UIBarButtonItem {
        let code = UIButton(type: .custom)
        
        code.setImage(UIImage(named: "ewm"), for: .normal)
        code.addTarget(self, action: #selector(qrCodeClicked(sender:)), for: .touchUpInside)
        return UIBarButtonItem(customView: code)
    }
    private func getRightNavOfShare() -> UIBarButtonItem {
        share = UIButton(type: .custom)
        share.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        share.setImage(UIImage(named: "fenxiang"), for: .normal)
        share.addTarget(self, action: #selector(shareClicked(sender:)), for: .touchUpInside)
        return UIBarButtonItem(customView: share)
    }
    
    @objc private func qrCodeClicked(sender : UIButton) {
        let pop = CXMOrderDetailPop()
        pop.configure(with: orderModel.addFriendsQRBarUrl)
        self.present(pop)
    }
    
    @objc private func shareClicked(sender : UIButton) {
        
        var model = ShareContentModel()
        model.title = orderModel.orderSn
        model.urlStr = orderModel.orderShareUrl
        model.sharingType = .webPage
        share(model, from: self)
    }
}
extension CXMMDaletouOrderVC : OrderDetailQRCodeCellDelegate {
    func didTipCopy(cell: OrderDetailQRCodeCell, model: AppendInfo) {
        showHUD(message: "复制成功")
        let paseboard = UIPasteboard.general
        
        paseboard.string = model.wechat
    }
    
    func didTipCall(cell: OrderDetailQRCodeCell, model: AppendInfo) {
        if let url = URL(string: "tel://\(model.phone)") {
            UIApplication.shared.openURL(url)
        }
        
    }
    
    
}

// MARK: - 引导蒙版
extension CXMMDaletouOrderVC {
    
    private func showMask() {
        
        if UserDefaults.standard.bool(forKey: MaskShow) == false {
            
            let gv = HXGuideMaskView(frame: self.view.bounds)
            UserDefaults.standard.set(true, forKey: MaskShow)
            let model = HXGuideInfoModel()
            model.text = """
            添加彩票店主微信号完成后
            返回APP订单页，点击此按钮分享给微信店主
            """
            
            model.frameBaseWindow = share.convert(share.bounds, to: nil)
            model.textColor = ColorFFFFFF
            model.insetEdge = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            model.maskCornerRadius = 15
            
            
            let model2 = HXGuideInfoModel()
            model2.text = """
            首先添加店主微信号
            """
            
            if orderModel != nil && orderModel.appendInfoList.isEmpty == false {
                if orderModel.appendInfoList[0].type == "1" {
                    DispatchQueue.main.async {
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .none, animated: true)
                    }
                    
                    if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? OrderDetailQRCodeCell {
                        
                        if cell.frame.maxY >= tableView.bounds.size.height {
                            
                            model2.frameBaseWindow = CGRect(x: 0, y: UIScreen.main.bounds.size.height - cell.bounds.size.height, width: cell.bounds.size.width, height: cell.bounds.size.height)
                        }else {
                            var fra = cell.frame
                            fra.origin.y -= 68.0
                            model2.frameBaseWindow = gv.convert(fra, from: cell.superview!)
                        }
                        
                        model2.textColor = ColorFFFFFF
                        model2.insetEdge = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        model2.maskCornerRadius = 15
                        
                        modes.append(model2)
                    }
                }
            }
            
            modes.append(model)
            
            
            gv.showMask(data: modes)
        }
    }
}
