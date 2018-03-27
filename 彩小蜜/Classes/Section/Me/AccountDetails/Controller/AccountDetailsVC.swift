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

class AccountDetailsVC: BaseViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {

    public var accountType : AccountDetailsType = .all
    
    private var pageDataModel: BasePageModel<AccountDetailModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHidenBar = true
        self.view.addSubview(tableView)
        setEmpty(title: "您还没有优惠券！", tableView)
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.footerRefresh {
            self.loadNextData()
        }
        
        accountListRequest(1)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    
    private func loadNewData() {
        accountListRequest(1)
    }
    private func loadNextData() {
        guard self.pageDataModel.isLastPage == true else {
            self.tableView.noMoreData()
            return }
        
        accountListRequest(self.pageDataModel.nextPage)
    }
    
    //MARK: - 网络请求
    private func accountListRequest(_ pageNum: Int) {
        weak var weakSelf = self
        _ = userProvider.rx.request(.accountDetailsList(pageNum: pageNum))
            .asObservable()
            .mapObject(type: BasePageModel<AccountDetailModel>.self)
            .subscribe(onNext: { (data) in
                weakSelf?.pageDataModel = data
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
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
        let footer = AccountDetailFooterView()
        
        table.tableFooterView = footer
        
        table.register(AccountDetailsCell.self, forCellReuseIdentifier: AccountDetailsCellId)
        table.register(AccountDetailSectionHeader.self, forHeaderFooterViewReuseIdentifier: AccountDetailSectionHeaderId)
        return table
    }()
    
    //MARK: - TABLEVIEW  DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let progress = WithdrawalProgressVC()
        pushViewController(vc: progress)
    }
    
    //MARK: - TABLEVIEW  DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        guard pageDataModel != nil else { return 0 }
        return pageDataModel.list.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailsCellId, for: indexPath) as! AccountDetailsCell
        
        cell.accountDetail = pageDataModel.list[indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            let acc = pageDataModel.list[section]
            let axx = pageDataModel.list[section - 1]

            if acc.addTime == axx.addTime {
                return 0
            }else {
                return 30
            }
        }
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccountDetailSectionHeaderId)as! AccountDetailSectionHeader
        header.accountDetail = pageDataModel.list[section]
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: section)) as! AccountDetailsCell
        if section == 0 {
            cell.line.isHidden = true
        }else {
            cell.line.isHidden = false
        }
        
        if section > 0 {
            let acc = pageDataModel.list[section]
            let axx = pageDataModel.list[section - 1]
            
            if acc.addTime == axx.addTime {
                
                return nil
            }else {
                cell.line.isHidden = true
                return header
            }
        }
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
