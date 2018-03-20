//
//  RechargeViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let RechargeCardCellIdentifier = "RechargeCardCellIdentifier"
fileprivate let RechargeTitleCellIdentifier = "RechargeTitleCellIdentifier"
fileprivate let RechargePaymentTitleCellId = "RechargePaymentTitleCellId"

class RechargeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, RechargeFooterViewDelegate, UITextFieldDelegate, ValidatePro {
    
    //MARK: - 点击事件
    func recharge() {
        guard validate(.number, str: self.cardCell.textfield.text) else {
            showAlert(message: "请输入正确的金额")
            return
        }
        rechargeRequest(amount: self.cardCell.textfield.text!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        return true
    }
    
    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - 属性
    private var headerView : RechargeHeaderView!
    private var footerView : RechargeFooterView!
    private var rechargeAmount : String?
    private var cardCell : RechargeCardCell!
    
    
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 充值"
        initSubview()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    //MARK: - 网络请求
    private func rechargeRequest(amount: String) {
        
    }
    
    //MARK: - 懒加载
    lazy private var tableview : UITableView! = {
        let tableview = UITableView(frame: CGRect.zero, style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        self.view.addSubview(tableview)
        tableview.register(RechargeTitleCell.self, forCellReuseIdentifier: RechargeTitleCellIdentifier)
        tableview.register(RechargeCardCell.self, forCellReuseIdentifier: RechargeCardCellIdentifier)
        tableview.register(RechargeCell.self, forCellReuseIdentifier: RechargeCellIdentifier)
        tableview.register(RechargePaymentTitleCell.self, forCellReuseIdentifier: RechargePaymentTitleCellId)
        
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        headerView = RechargeHeaderView()
        tableview.tableHeaderView = headerView
        
        footerView = RechargeFooterView()
        footerView.delegate = self
        tableview.tableFooterView = footerView
        
        return tableview
    }()
    
    //MARK: - Tableview DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return 2
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: RechargeTitleCellIdentifier, for: indexPath) as! RechargeTitleCell
            
            return cell
        case 1:
            let cell = tableview.dequeueReusableCell(withIdentifier: RechargeCardCellIdentifier, for: indexPath) as! RechargeCardCell
            self.cardCell = cell
            return cell
        case 2:
            if indexPath.row == 0 {
                let cell = tableview.dequeueReusableCell(withIdentifier: RechargePaymentTitleCellId, for: indexPath) as! RechargePaymentTitleCell
                return cell
            }
            let cell = tableview.dequeueReusableCell(withIdentifier: RechargeCellIdentifier, for: indexPath) as! RechargeCell
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70
        case 1:
            return RechargeCardCell.height()
        case 2:
            return defaultCellHeight
        default:
            return defaultCellHeight
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
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
    //MARK: - UI
    private func initSubview() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
