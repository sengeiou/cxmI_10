//
//  AccountDetailsVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum AccountDetailsType: String {
    case all = "全部"
    case bonus = "奖金"
    case recharge = "充值"
    case buy = "购彩"
    case withdrawal = "提现"
    case coupon = "红包"
}

fileprivate let AccountDetailsCellId = "AccountDetailsCellId"
fileprivate let AccountDetailSectionHeaderId = "AccountDetailSectionHeaderId"

class CXMAccountDetailsVC: BaseViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {

    public var accountType : AccountDetailsType = .all {
        didSet{
            switch accountType {
            case .all:
                TongJi.log(.账户明细全部, label: "账户明细全部")
            case .bonus:
                TongJi.log(.账户明细奖金, label: "账户明细奖金")
            case .recharge:
                TongJi.log(.账户明细充值, label: "账户明细充值")
            case .buy:
                TongJi.log(.账户明细购彩, label: "账户明细购彩")
            case .withdrawal:
                TongJi.log(.账户明细提现, label: "账户明细提现")
            case .coupon:
                TongJi.log(.账户明细红包, label: "账户明细红包")
            }
            
            
        }
    }
    
    public var filterTime: FilterTime! = .最近一周
    
    private var pageDataModel: BasePageModel<AccountDetailModel>!
    private var accountList: [AccountDetailModel]!
    private var statisticsModel : AccountStatisticsModel!
    
    private var footer : AccountDetailFooterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHidenBar = true
        accountList = []
        addPanGestureRecognizer = false
        
        self.view.addSubview(tableView)
//        footer = AccountDetailFooterView()
//        self.view.addSubview(footer)
        
        setEmpty(title: "暂无明细数据", tableView)
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.footerRefresh {
            self.loadNextData()
        }
        self.tableView.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(accountDetailsFilter(notification:)), name: NSNotification.Name(rawValue: AccountDetailsFilterName), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TongJi.start("账户明细页")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TongJi.end("账户明细页")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(0)
        }
//        footer.snp.makeConstraints { (make) in
//            make.bottom.equalTo(-0)
//            make.left.right.equalTo(0)
//            make.height.equalTo(50 * defaultScale)
//        }
    }
    
    @objc private func accountDetailsFilter(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
//        let time = userInfo["filterTime"]
        
        loadNewData()
    }
    
    private func loadNewData() {
        accountListRequest(1)
    }
    private func loadNextData() {
        guard self.pageDataModel.isLastPage == false else {
            self.tableView.noMoreData()
            return }
        
        accountListRequest(self.pageDataModel.nextPage)
    }
    
    //MARK: - 网络请求
    private func accountListRequest(_ pageNum: Int) {
        var type: String!
        // 0-全部 1-奖金 2-充值 3-购彩 4-提现 5-红包
        switch accountType {
        case .all:
            type = "0"
        case .bonus:
            type = "1"
        case .recharge:
            type = "2"
        case .buy:
            type = "3"
        case .withdrawal:
            type = "4"
        case .coupon:
            type = "5"
        }
        //self.showProgressHUD()
        weak var weakSelf = self
        
        _ = userProvider.rx.request(.accountDetailsListAndTotal(amountType: type, pageNum: pageNum, timeType: self.filterTime.rawValue))
        .asObservable()
        .mapObject(type: AccountDetailData.self)
            .subscribe(onNext: { (data) in
                self.tableView.endrefresh()
                weakSelf?.pageDataModel = data.pageInfo
                if pageNum == 1 {
                    weakSelf?.accountList.removeAll()
                }
                weakSelf?.accountList.append(contentsOf: data.pageInfo.list)
                
//                if weakSelf?.accountList.count == 0 {
//                    weakSelf?.footer.isHidden = true
//                }else {
//                    weakSelf?.footer.isHidden = false
//                }
                
                //weakSelf?.footer.dataModel = data.userAccountByTimeDTO
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                self.tableView.endrefresh()
//                if weakSelf?.accountList.count == 0 {
//                    weakSelf?.footer.isHidden = true
//                }else {
//                    weakSelf?.footer.isHidden = false
//                }
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
            }, onCompleted: nil, onDisposed: nil)
        
        
//        _ = userProvider.rx.request(.accountDetailsList(amountType: type, pageNum: pageNum, timeType: self.filterTime.rawValue))
//            .asObservable()
//            .mapObject(type: BasePageModel<AccountDetailModel>.self)
//            .subscribe(onNext: { (data) in
//
//                //weakSelf?.tableView.endrefresh()
//                weakSelf?.pageDataModel = data
//                if pageNum == 1 {
//                    weakSelf?.accountList.removeAll()
//                }
//                weakSelf?.accountList.append(contentsOf: data.list)
//
//                if weakSelf?.accountList.count == 0 {
//                    weakSelf?.footer.isHidden = true
//                }else {
//                    weakSelf?.footer.isHidden = false
//                }
//                self.statisticsRequest()
//                //self.dismissProgressHud()
//
//            }, onError: { (error) in
//                //self.dismissProgressHud()
//                if weakSelf?.accountList.count == 0 {
//                    weakSelf?.footer.isHidden = true
//                }else {
//                    weakSelf?.footer.isHidden = false
//                }
//                weakSelf?.tableView.endrefresh()
//                guard let err = error as? HXError else { return }
//                switch err {
//                case .UnexpectedResult(let code, let msg):
//                    switch code {
//                    case 600:
//                        weakSelf?.removeUserData()
//                        weakSelf?.pushLoginVC(from: self)
//                    default : break
//                    }
//
//                    if 300000...310000 ~= code {
//                        print(code)
//                        self.showHUD(message: msg!)
//                    }
//                default: break
//                }
//            }, onCompleted: nil , onDisposed: nil )
    }
    
    // 统计账户信息
    private func statisticsRequest() {
        //self.showProgressHUD()
//        weak var weakSelf = self
//        _ = userProvider.rx.request(.accountStatistics(timeType: self.filterTime.rawValue))
//            .asObservable()
//            .mapObject(type: AccountStatisticsModel.self)
//            .subscribe(onNext: { (data) in
//                //self.dismissProgressHud()
//                self.tableView.endrefresh()
//                //weakSelf?.statisticsModel = data
//                weakSelf?.footer.dataModel = data
//                weakSelf?.tableView.reloadData()
//            }, onError: { (error) in
//                //self.dismissProgressHud()
//                self.tableView.endrefresh()
//                guard let err = error as? HXError else { return }
//                switch err {
//                case .UnexpectedResult(let code, let msg):
//                    if 300000...310000 ~= code {
//                        print(code)
//                        self.showHUD(message: msg!)
//                    }
//                default: break
//                }
//            }, onCompleted: nil , onDisposed: nil )
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: accountType.rawValue)
    }
    //MARK: - 懒加载
    lazy private var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        
        table.estimatedRowHeight = 80 * defaultScale
        
        //table.tableFooterView = footer
        
        table.register(AccountDetailsCell.self, forCellReuseIdentifier: AccountDetailsCellId)
        table.register(AccountDetailSectionHeader.self, forHeaderFooterViewReuseIdentifier: AccountDetailSectionHeaderId)
        return table
    }()
    
    //MARK: - TABLEVIEW  DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = accountList[indexPath.section]
        
        // 提现可进入详情
        guard account.processType == "4" else { return }
       
//        let progress = CXMWithdrawalProgressVC()
//        progress.withdawalSn = account.payId
//        pushViewController(vc: progress)
    }
    
    //MARK: - TABLEVIEW  DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        guard pageDataModel != nil else { return 0 }
        return accountList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailsCellId, for: indexPath) as! AccountDetailsCell
        
        cell.accountDetail = accountList[indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            let account = accountList[section]
            let accountNext = accountList[section - 1]

            if account.addTime == accountNext.addTime {
                return 0.01
            }else {
                return orderSectionHeaderHeight
            }
        }
        return orderSectionHeaderHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccountDetailSectionHeaderId)as! AccountDetailSectionHeader
        
        header.accountDetail = accountList[section]
        
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: section)) as? AccountDetailsCell {
            if section == 0 {
                cell.line.isHidden = true
            }else {
                cell.line.isHidden = false
            }
        }
        
        if section > 0 {
            let acc = accountList[section]
            let axx = accountList[section - 1]
            
            if acc.addTime == axx.addTime {
                
                return nil
            }else {
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: section)) as? AccountDetailsCell {
                    cell.line.isHidden = true
                }
                
                return header
            }
        }
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func back(_ sender: UIButton) {
        super.back(sender)
        TongJi.log(.账户明细返回, label: "账户明细返回")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
