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

class AccountDetailsVC: BaseViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {

    public var accountType : AccountDetailsType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        setEmpty(title: "您还没有优惠券！", tableView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
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
        table.register(AccountDetailsCell.self, forCellReuseIdentifier: AccountDetailsCellId)
        
        return table
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //guard couponListModel != nil else { return 0 }
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailsCellId, for: indexPath) as! AccountDetailsCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CouponCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
