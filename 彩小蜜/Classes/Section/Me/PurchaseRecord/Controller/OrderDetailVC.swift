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

class OrderDetailVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - 点击事件
    @objc private func orderClicked(_ sender: UIButton) {
        
    }
    
    // MARK: - 属性
    private var orderList = ["","",""]
    
    private var orderBut : UIButton!
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 订单详情"
        self.view.addSubview(tableView)
        initSubview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
        orderBut.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-20)
            make.left.right.equalTo(self.view)
            make.height.equalTo(loginButHeight)
        }
    }
    // MARK: - 网络请求
    // MARK: - 初始化
    private func initSubview() {
        orderBut = UIButton(type: .custom)
        orderBut.setTitle("继续预约", for: .normal)
        orderBut.setTitleColor(ColorFFFFFF, for: .normal)
        orderBut.backgroundColor = ColorEA5504
        orderBut.addTarget(self, action: #selector(orderClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(orderBut)
    }

    // MARK: - 懒加载
    lazy private var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        let header = OrderDetailHeaderView()
        table.tableHeaderView = header
        
        table.tableFooterView = UIView()
        
        
        table.register(OrderDetailTitleCell.self, forCellReuseIdentifier: OrderDetailTitleCellId)
        table.register(OrderDetailCell.self, forCellReuseIdentifier: OrderDetailCellId)
        table.register(OrderRuleCell.self, forCellReuseIdentifier: OrderRuleCellId)
        table.register(OrderProgrammeCell.self, forCellReuseIdentifier: OrderProgrammeCellId)
        
        return table
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //guard recordListModel != nil else { return 0 }
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return orderList.count
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
                
            case orderList.count - 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderRuleCellId, for: indexPath) as! OrderRuleCell
                
                return cell
                
            default :
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailCellId, for: indexPath) as! OrderDetailCell
                
                return cell
                
            }
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderProgrammeCellId, for: indexPath) as! OrderProgrammeCell
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                 return OrderDetailCellHeight + 40
            case orderList.count - 1:
                return OrderDetailCellHeight - 30
            default:
                return OrderDetailCellHeight
            }
        case 1:
            return 150
        default:
            return 0
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
