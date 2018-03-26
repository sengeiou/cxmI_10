//
//  OrderSchemeVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let OrderSchemeCellId = "OrderSchemeCellId"
fileprivate let OrderSchemeTitleCellId = "OrderSchemeTitleCellId"

class OrderSchemeVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    public var programmeSn : String!
    
    private var orderSchemeInfo : OrderSchemeInfoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 出票方案"
        self.view.addSubview(self.tableView)
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
        weak var weakSelf = self
        _ = userProvider.rx.request(.orderScheme(programmeSn: programmeSn))
            .asObservable()
            .mapObject(type: OrderSchemeInfoModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.orderSchemeInfo = data
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
    // MARK: - 懒加载
    lazy private var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        table.register(OrderSchemeTitleCell.self, forCellReuseIdentifier: OrderSchemeTitleCellId)
        table.register(OrderSchemeCell.self, forCellReuseIdentifier: OrderSchemeCellId)
        
        return table
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //guard orderInfo != nil else { return 0 }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.orderSchemeInfo != nil else { return 0 }
        return self.orderSchemeInfo.ticketSchemeDetailDTOs.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderSchemeTitleCellId, for: indexPath) as! OrderSchemeTitleCell
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderSchemeCellId, for: indexPath) as! OrderSchemeCell
        
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return OrderDetailCellHeight + orderSectionHeaderHeight + 23
            case 1:
                return OrderDetailCellHeight - 2
            default:
                return OrderDetailCellHeight
            }
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
