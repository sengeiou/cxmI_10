//
//  OrderSchemeVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//  出票方案

import UIKit

fileprivate let OrderSchemeCellId = "OrderSchemeCellId"
fileprivate let OrderSchemeTitleCellId = "OrderSchemeTitleCellId"

class CXMOrderSchemeVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    public var programmeSn : String!
    public var orderSn: String!
    
    private var orderSchemeInfo : OrderSchemeInfoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "模拟方案"
        self.view.addSubview(self.tableView)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300
        orderSchemeRequest()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    
    // MARK: - 网络请求
    private func orderSchemeRequest() {
        self.showProgressHUD()
        weak var weakSelf = self
        _ = userProvider.rx.request(.orderScheme(programmeSn: programmeSn, orderSn: orderSn))
            .asObservable()
            .mapObject(type: OrderSchemeInfoModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                weakSelf?.orderSchemeInfo = data
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                self.dismissProgressHud()
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
    // MARK: - 懒加载
    lazy private var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        table.estimatedRowHeight = orderSectionHeaderHeight * 20
        table.rowHeight = UITableView.automaticDimension
        
        table.register(OrderSchemeTitleCell.self, forCellReuseIdentifier: OrderSchemeTitleCellId)
        table.register(OrderSchemeCell.self, forCellReuseIdentifier: OrderSchemeCellId)
        
        return table
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //guard orderInfo != nil else { return 0 }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.orderSchemeInfo != nil && orderSchemeInfo.ticketSchemeDetailDTOs.isEmpty == false else { return 1 }
        return self.orderSchemeInfo.ticketSchemeDetailDTOs.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0: 
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderSchemeTitleCellId, for: indexPath) as! OrderSchemeTitleCell
            cell.schemeInfo = self.orderSchemeInfo
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderSchemeCellId, for: indexPath) as! OrderSchemeCell
            cell.schemeDetail = self.orderSchemeInfo.ticketSchemeDetailDTOs[indexPath.row - 1]
            if indexPath.row == 1{
                cell.ishidenLine = true
            }
            
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.row {
        case 0:
            return  orderSectionHeaderHeight * 2 - 10
        case 1:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
