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
fileprivate let OrderProgrammeCellId = "OrderProgrammeCellId"

enum BackType {
    case root
    case notRoot
}

class OrderDetailVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, OrderDetailFooterViewDelegate {
//    case .胜平负:
//    request(type: "2", leagueId: leagueId)
//    case .让球胜平负:
//    request(type: "1", leagueId: leagueId)
//    case .总进球:
//    request(type: "4", leagueId: leagueId)
//    case .比分:
//    request(type: "3", leagueId: leagueId)
//    case .半全场:
//    request(type: "5", leagueId: leagueId)
//    case .二选一:
//    request(type: "7", leagueId: leagueId)
//    case .混合过关:
//    request(type: "6", leagueId: leagueId)
    // MARK: - 点击事件
    func goBuy() {
        guard orderInfo != nil else { return }
        
        let football = FootballMatchVC()
        
        switch orderInfo.playType {
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
        homeData.playClassifyImg = orderInfo.lotteryClassifyImg
        homeData.playClassifyName = orderInfo.lotteryClassifyName
        homeData.playType = orderInfo.playType
        
        football.homeData = homeData
        pushViewController(vc: football)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let scheme = OrderSchemeVC()
            scheme.programmeSn = self.orderInfo.programmeSn
            scheme.orderSn = self.orderInfo.orderSn
            pushViewController(vc: scheme)
        }
    }
    
    // MARK: - 属性
    public var backType : BackType! = .notRoot
    
    public var orderId : String!
    private var orderInfo : OrderInfoModel!
    private var header : OrderDetailHeaderView!
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 订单详情"
        self.view.addSubview(tableView)
        orderInfoRequest()
        initSubview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHidenBar = true 
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    // MARK: - 网络请求
    private func orderInfoRequest() {
        weak var weakSelf = self
        guard orderId != nil  else { return }
        
        _ = userProvider.rx.request(.orderInfo(orderId: orderId))
            .asObservable()
            .mapObject(type: OrderInfoModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.orderInfo = data
                weakSelf?.header.orderInfo = self.orderInfo
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    // MARK: - 初始化
    private func initSubview() {
        
    }

    // MARK: - 懒加载
    lazy private var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        header = OrderDetailHeaderView()
        
        table.tableHeaderView = header
        let footer = OrderDetailFooterView()
        footer.delegate = self
        table.tableFooterView = footer
        table.estimatedRowHeight = 80
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(OrderDetailTitleCell.self, forCellReuseIdentifier: OrderDetailTitleCellId)
        table.register(OrderDetailCell.self, forCellReuseIdentifier: OrderDetailCellId)
        table.register(OrderRuleCell.self, forCellReuseIdentifier: OrderRuleCellId)
        table.register(OrderProgrammeCell.self, forCellReuseIdentifier: OrderProgrammeCellId)
        
        return table
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard orderInfo != nil else { return 0 }
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return orderInfo.matchInfos.count + 1
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
                if self.orderInfo.matchInfos.count >= 1 {
                    cell.matchInfo = self.orderInfo.matchInfos[indexPath.row]
                }
                return cell
                
            case orderInfo.matchInfos.count :
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderRuleCellId, for: indexPath) as! OrderRuleCell
                cell.orderInfo = self.orderInfo
                return cell
                
            default :
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailCellId, for: indexPath) as! OrderDetailCell
                if self.orderInfo.matchInfos.count >= 1 {
                    cell.matchInfo = self.orderInfo.matchInfos[indexPath.row]
                }
                return cell
            }
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderProgrammeCellId, for: indexPath) as! OrderProgrammeCell
                cell.orderInfo = self.orderInfo
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
        case 0:
            return UITableViewAutomaticDimension
        case 1:
            return 124
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
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
