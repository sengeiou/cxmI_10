//
//  OrderDetailVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let OrderDetailTitleCellId = "OrderDetailTitleCellId"
fileprivate let OrderDetailCellId = "OrderDetailCellId"
fileprivate let OrderRuleCellId = "OrderRuleCellId"
fileprivate let OrderPaymentCellId = "OrderPaymentCellId"
fileprivate let OrderProgrammeCellId = "OrderProgrammeCellId"
//奖金如何计算
fileprivate let OrdercalculateBonusesCellId = "OrdercalculateBonusesCell"

enum BackType {
    case root
    case notRoot
}

class CXMOrderDetailVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, OrderDetailFooterViewDelegate {
    
    // MARK: - 点击事件
    func goBuy() {
        guard orderInfo != nil else { return }
        
        let football = CXMFootballMatchVC()
        
        switch orderInfo.lotteryPlayClassifyId {
        case "2":
            football.matchType = .胜平负
        case "1":
            football.matchType = .让球胜平负
        case "4":
            football.matchType = .总进球
        case "5":
            football.matchType = .半全场
        case "3":
            football.matchType = .比分
        case "6":
            football.matchType = .混合过关
        case "7":
            football.matchType = .二选一
        default: break
            
        }
        
        var homeData = HomePlayModel()
        homeData.lotteryId = orderInfo.lotteryClassifyId
        homeData.playClassifyId = orderInfo.lotteryPlayClassifyId
        homeData.lotteryImg = orderInfo.lotteryClassifyImg
        homeData.lotteryName = orderInfo.lotteryClassifyName
        homeData.playType = orderInfo.lotteryPlayClassifyId
        

        pushViewController(vc: football)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
            
            //        case 0:
            //            switch indexPath.row{
            //            case orderInfo.matchInfos.count + 2:
            //                let web = CXMWebViewController()
            //                pushViewController(vc: web)
            //            default:
            //                break
        //            }
        case 1:
            let scheme = CXMOrderSchemeVC()
            scheme.programmeSn = self.orderInfo.programmeSn
            scheme.orderSn = self.orderInfo.orderSn
            pushViewController(vc: scheme)
        case 2:
            
            let model = orderInfo.appendInfoList[indexPath.row]
            
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
    
    // MARK: - 属性
    public var backType : BackType = .notRoot
    
    public var orderId : String!
    private var orderInfo : OrderInfoModel!
    private var header : OrderDetailHeaderView!
    private var offlineHeader : OfflineOrderDetailHeaderView!
    private var footer : OrderDetailFooterView!
    
    private var share : UIButton!
    
    private var modes = [HXGuideInfoModel]()
    
    private var timer : Timer!
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单详情"
        initSubview()
        
        //orderInfoRequest()
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.beginRefreshing()
        
        //        setRightNav()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHidenBar = true
        
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.beginRefreshing()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    // MARK: - 网络请求
    private func loadNewData() {
        orderInfoRequest()
    }
    
    private func orderInfoRequest() {
        weak var weakSelf = self
        guard orderId != nil  else { return }
        //self.showProgressHUD()
        _ = userProvider.rx.request(.orderInfo(orderId: orderId))
            .asObservable()
            .mapObject(type: OrderInfoModel.self)
            .subscribe(onNext: { (data) in
                //self.dismissProgressHud()
                weakSelf?.tableView.endrefresh()
                weakSelf?.orderInfo = data
                weakSelf?.header.orderInfo = weakSelf?.orderInfo
                weakSelf?.offlineHeader.orderInfo = weakSelf?.orderInfo
                
                if weakSelf?.orderInfo.orderStatus == "0" && weakSelf?.orderInfo.payCode == "app_offline"{
                    weakSelf?.tableView.tableHeaderView =  weakSelf?.offlineHeader
                    weakSelf?.computationTimestamp()
                    weakSelf?.timer = Timer.scheduledTimer(timeInterval: 1.0, target: weakSelf!, selector: #selector(weakSelf?.computationTimestamp), userInfo: nil, repeats:true);
                    weakSelf?.timer.fire()

                }else{
                    weakSelf?.tableView.tableHeaderView = weakSelf?.header
                }
                weakSelf?.tableView.reloadData()
                //                weakSelf?.showMask()
            }, onError: { (error) in
                //self.dismissProgressHud()
                weakSelf?.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: weakSelf!)
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        weakSelf?.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    
    
    @objc private func computationTimestamp(){
        let datefmatter = DateFormatter()
        datefmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = datefmatter.date(from: self.orderInfo.createTime)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let createStamp = Int(dateStamp)
        
        let now = NSDate()
        let timeInterval = now.timeIntervalSince1970
        let nowStamp = Int(timeInterval)
        
        let isPayTimeLong = Int(self.orderInfo.isPayTimeLong)
        let countDown =  isPayTimeLong! - (nowStamp - createStamp)
        print(countDown)
        
        if countDown < 0{
            stopTimer()
           navigationController?.popViewController(animated: true)
        }
        
        let num = self.transToHourMinSec(time: Float(countDown))
        let headerView = self.tableView.tableHeaderView as? OfflineOrderDetailHeaderView
        headerView!.countdownLB.text = num
    }
    
    private func stopTimer(){
        if timer != nil {
            timer.invalidate() //销毁timer
            timer = nil
            print("定时器销毁")
        }
    }
    
    private func transToHourMinSec(time: Float) -> String{
        let allTime: Int = Int(time)
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = allTime / 3600
        hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
        
        minutes = allTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        return "失效倒计时: \(minutesText):\(secondsText)"
    }
    
    // MARK: - 初始化
    private func initSubview() {
        footer = OrderDetailFooterView()
        footer.delegate = self
        
        self.view.addSubview(footer)
        self.view.addSubview(tableView)
        
        
        footer.snp.makeConstraints { (make) in
            make.height.equalTo(44 * defaultScale)
            make.top.equalTo(screenHeight - 44 * defaultScale)
            make.right.equalTo(self.view.snp_right)
            make.left.equalTo(self.view.snp_left)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(footer.snp.top)
        }
        
        tableView.separatorStyle = .none
        offlineHeader = OfflineOrderDetailHeaderView()
        offlineHeader.delegate = self
        header = OrderDetailHeaderView()

        
        //        tableView.tableFooterView = footer
        tableView.estimatedRowHeight = 80
        //table.rowHeight = UITableView.automaticDimension
        
        tableView.register(OrderDetailTitleCell.self, forCellReuseIdentifier: OrderDetailTitleCellId)
        tableView.register(OrderDetailCell.self, forCellReuseIdentifier: OrderDetailCellId)
        tableView.register(OrderRuleCell.self, forCellReuseIdentifier: OrderRuleCellId)
        tableView.register(OrderPaymentCell.self, forCellReuseIdentifier: OrderPaymentCellId)
        tableView.register(OrderProgrammeCell.self, forCellReuseIdentifier: OrderProgrammeCellId)
        tableView.register(OrderStoreCell.self, forCellReuseIdentifier: OrderStoreCell.identifier)
        tableView.register(OrdercalculateBonusesCell.self, forCellReuseIdentifier: OrdercalculateBonusesCellId)
    }
    
    @IBOutlet weak var tableView : UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard orderInfo != nil else { return 0 }
        
        return 2 + orderInfo.appendInfoList.count
        
        //        switch orderInfo.showStore {
        //        case "1":
        //            return 2 + 1
        //        default:
        //            return 2 + 1
        //        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return orderInfo.matchInfos.count + 3 // 显示 支付方式
        //            return orderInfo.matchInfos.count + 2
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailTitleCellId, for: indexPath) as! OrderDetailTitleCell
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailCellId, for: indexPath) as! OrderDetailCell
                if self.orderInfo.matchInfos.count >= 1 {
                    cell.matchInfo = self.orderInfo.matchInfos[indexPath.row - 1]
                }
                cell.line.isHidden = true
                return cell
            case orderInfo.matchInfos.count + 1 :
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderRuleCellId, for: indexPath) as! OrderRuleCell
                cell.orderInfo = self.orderInfo
                return cell
            case orderInfo.matchInfos.count + 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderPaymentCellId, for: indexPath) as! OrderPaymentCell
                cell.orderInfo = self.orderInfo
                return cell
            default :
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailCellId, for: indexPath) as! OrderDetailCell
                if self.orderInfo.matchInfos.count >= 1 {
                    cell.matchInfo = self.orderInfo.matchInfos[indexPath.row - 1]
                }
                cell.line.isHidden = false
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderProgrammeCellId, for: indexPath) as! OrderProgrammeCell
            cell.orderInfo = self.orderInfo
            return cell
            
        default:
            //            let model = orderInfo.appendInfoList[indexPath.row]
            //
            //            switch model.type {
            //            case "1":
            //                return initQRCodeCell(indexPath: indexPath)
            //            case "0":
            //                return initStoreCell(indexPath: indexPath)
            //            default :
            return UITableViewCell()
            //            }
            
        }
    }
    
    private func initStoreCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderStoreCell.identifier, for: indexPath) as! OrderStoreCell
        cell.configure(with: orderInfo.appendInfoList[indexPath.row])
        return cell
    }
    
    private func initQRCodeCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailQRCodeCell", for: indexPath) as! OrderDetailQRCodeCell
        cell.delegate = self
        cell.configure(with: orderInfo.appendInfoList[indexPath.row])
        print(cell.frame)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return 65 * defaultScale
            }else {
                return UITableView.automaticDimension
            }
        case 1:
            return 88
        case 2:
            let model = orderInfo.appendInfoList[indexPath.row]
            
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
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    override func back(_ sender: UIButton) {
        self.stopTimer()
        if offline == true{
            pushPagerView(pagerType: .purchaseRecord)
            TongJi.log(.投注记录, label: "投注记录")
        }else{
            switch backType {
            case .root:
                popToRootViewController()
            default:
                popViewController()
            }
        }
        self.tableView.endrefresh()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.stopTimer()
    }
    
    
}

extension CXMOrderDetailVC : ShareProtocol {
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
        pop.configure(with: orderInfo.addFriendsQRBarUrl)
        self.present(pop)
    }
    @objc private func shareClicked(sender : UIButton) {
        
        var model = ShareContentModel()
        model.title = orderInfo.orderSn
        model.urlStr = orderInfo.orderShareUrl
        model.sharingType = .webPage
        share(model, from: self)
    }
}

// MARK: - 引导蒙版
extension CXMOrderDetailVC {
    
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
            
            if orderInfo != nil && orderInfo.appendInfoList.isEmpty == false {
                if orderInfo.appendInfoList[0].type == "1" {
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
            
            
            //            gv.showMask(data: modes)
        }
    }
}

extension CXMOrderDetailVC : OrderDetailQRCodeCellDelegate {
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


extension CXMOrderDetailVC : OfflineOrderDetailHeaderViewDelegate {
    
    func didTipDualPayment() {
        orderDetailid = self.orderId
        let vc = CXMPaymentViewController()
        vc.backType = .notRoot
        vc.lottoToken = self.orderInfo.payToken
        vc.payCode = self.orderInfo.payCode
        vc.orderSn = self.orderInfo.orderSn
        offline = true
        self.pushViewController(vc: vc)
    }

}
