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
        switch indexPath.section {
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
    private var footer : OrderDetailFooterView!
    
    private var share : UIButton!
    
    private var modes = [HXGuideInfoModel]()
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "模拟订单详情"
        initSubview()
        
        //orderInfoRequest()
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.beginRefreshing()
        
        setRightNav()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHidenBar = true
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showMask()
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
                weakSelf?.header.orderInfo = self.orderInfo
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                //self.dismissProgressHud()
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
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    // MARK: - 初始化
    private func initSubview() {
        footer = OrderDetailFooterView()
        footer.delegate = self
        
        self.view.addSubview(tableView)
//        self.view.addSubview(footer)
        
//        footer.snp.makeConstraints { (make) in
//            make.bottom.equalTo(-SafeAreaBottomHeight)
//            make.left.right.equalTo(0)
//            make.height.equalTo(44 * defaultScale)
//        }
        
//        tableView.snp.makeConstraints { (make) in
//            make.top.left.right.equalTo(self.view)
//            make.bottom.equalTo(0)
//        }
        
        tableView.separatorStyle = .none
        
        header = OrderDetailHeaderView()
        
        tableView.tableHeaderView = header
        
        tableView.estimatedRowHeight = 80
        //table.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(OrderDetailTitleCell.self, forCellReuseIdentifier: OrderDetailTitleCellId)
        tableView.register(OrderDetailCell.self, forCellReuseIdentifier: OrderDetailCellId)
        tableView.register(OrderRuleCell.self, forCellReuseIdentifier: OrderRuleCellId)
        tableView.register(OrderPaymentCell.self, forCellReuseIdentifier: OrderPaymentCellId)
        tableView.register(OrderProgrammeCell.self, forCellReuseIdentifier: OrderProgrammeCellId)
        tableView.register(OrderStoreCell.self, forCellReuseIdentifier: OrderStoreCell.identifier)
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
//            return orderInfo.matchInfos.count + 3 // 显示 支付方式
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

            let model = orderInfo.appendInfoList[indexPath.row]
            
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
    
    private func initStoreCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderStoreCell.identifier, for: indexPath) as! OrderStoreCell
        cell.configure(with: orderInfo.appendInfoList[indexPath.row])
        return cell
    }
    
    private func initQRCodeCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailQRCodeCell", for: indexPath) as! OrderDetailQRCodeCell
        cell.delegate = self
        cell.configure(with: orderInfo.appendInfoList[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return 65 * defaultScale
            }else {
                return UITableViewAutomaticDimension
            }
        case 1:
            return 124
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
        switch backType {
        case .root:
            popToRootViewController()
        default:
            popViewController()
        }
        self.tableView.endrefresh()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        model.sharingType = .text
        share(model, from: self)
    }
}

// MARK: - 引导蒙版
extension CXMOrderDetailVC {
    
    private func showMask() {
        
        if UserDefaults.standard.bool(forKey: MaskShow) == false {
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
            modes.append(model)
            
            let gv = HXGuideMaskView(frame: self.view.bounds)
            gv.showMask(data: modes)
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
