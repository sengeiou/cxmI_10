//
//  PurchaseRecordVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/23.
//  Copyright © 2018年 韩笑. All rights reserved.
// 投注记录

import UIKit
import XLPagerTabStrip

enum PurchaseRecordType: String {
    case all = "全部"
    case winning = "中奖"
    case prize = "待开奖"
}

fileprivate let PurchaseRecordCellId = "PurchaseRecordCellId"

class PurchaseRecordVC: BaseViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {

    //MARK: - 点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordInfo = recordList[indexPath.section]
        
        if recordInfo.orderType == "0" {
            let order = OrderDetailVC()
            order.orderId = recordInfo.orderId
            pushViewController(vc: order)
        }else if recordInfo.orderType == "1" {
            let order = WorldCupOrderDetailVC()
            order.orderId = recordInfo.orderId
            pushViewController(vc: order)
        }
    }
    
    public var recordType : PurchaseRecordType = .all {
        didSet{
            
            switch recordType {
            case .all:
                TongJi.log(.投注记录全部, label: "投注记录全部")
            case .prize:
                TongJi.log(.投注记录待开奖, label: "投注记录待开奖")
            case .winning :
                TongJi.log(.投注记录中奖, label: "投注记录中奖")
            }
        }
    }
    
    //MARK: - 属性
    private var recordListModel : PurchaseRecordListModel!
    private var recordList : [PurchaseRecordInfoModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "彩小秘 · 购彩记录"
        self.view.addSubview(self.tableView)
        setEmpty(title: "暂无投注记录", tableView)
        
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.footerRefresh {
            self.loadNextData()
        }
        self.recordList = []
        recordRequest(1)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: recordType.rawValue)
    }
    
    //MARK: - 加载数据
    private func loadNewData() {
        recordRequest(1)
    }
    private func loadNextData() {
        guard self.recordListModel.isLastPage == false else {
            self.tableView.noMoreData()
            return }
        
        recordRequest(self.recordListModel.nextPage)
    }
    //MARK: - 网络请求
    private func recordRequest(_ pageNum: Int) {
        var orderStatus:String!
        switch recordType {
        case .all:
            orderStatus = "-1"
            
        case .prize:
            orderStatus = "3"
            
        case .winning :
            orderStatus = "5"
            
        }
        //self.showProgressHUD()
        weak var weakSelf = self
        _ = userProvider.rx.request(.orderInfoList(fyId: "1", orderStatus: orderStatus, pageNum: pageNum))
            .asObservable()
            .mapObject(type: PurchaseRecordListModel.self)
            .subscribe(onNext: { (data) in
                //self.dismissProgressHud()
                weakSelf?.tableView.endrefresh()
                weakSelf?.recordListModel = data
                if pageNum == 1 {
                    weakSelf?.recordList.removeAll()
                }
                weakSelf?.recordList.append(contentsOf: data.list)
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
    // MARK: - 懒加载
    lazy private var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(PurchaseRecordCell.self, forCellReuseIdentifier: PurchaseRecordCellId)
        
        
        return table
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard recordListModel != nil else { return 0 }
        return recordList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseRecordCellId, for: indexPath) as! PurchaseRecordCell
        cell.recordInfo = recordList[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RecordCellHeight
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
        super.back(sender)
        TongJi.log(.投注记录返回, label: "投注记录返回")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
