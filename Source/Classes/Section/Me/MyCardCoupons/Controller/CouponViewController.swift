//
//  CouponViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

//import DZNEmptyDataSet

fileprivate let CouponCellId = "CouponCellId"

enum CouponType: String {
    case unUsed = "未使用"
    case used = "已使用"
    case overdue = "已过期"
}

class CouponViewController: BaseViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {

    public var couponType : CouponType = .unUsed {
        didSet{
            switch couponType {
            case .unUsed:
                TongJi.log(.我的卡券未使用, label: nil)
            case .used:
                TongJi.log(.我的卡券已使用, label: nil)
            case .overdue:
                TongJi.log(.我的卡券已过期, label: nil)
            }
        }
    }
    
    private var couponListModel : CouponListModel!
    private var couponList : [CouponInfoModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        couponList = []
        couponListRequest(1)
        
        setEmpty(title: "暂无数据", tableView)
        
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.footerRefresh {
            self.loadNextData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: couponType.rawValue)
    }
    
    //MARK: - 加载数据
    private func loadNewData() {
        
        couponListRequest(1)
    }
    private func loadNextData() {
        guard self.couponListModel.isLastPage == false else {
            self.tableView.noMoreData()
            return }
        
        couponListRequest(self.couponListModel.nextPage)
    }
    
    //MARK: - 网络请求
    private func couponListRequest(_ pageNum: Int) {
        var status : String!
        switch couponType {
        case .unUsed:
            status = "0"
        case .used:
            status = "1"
        case .overdue:
            status = "2"
        }
        self.showProgressHUD()
        weak var weakSelf = self
        _ = userProvider.rx.request(.couponList(status: status, pageNum: pageNum))
           .asObservable()
           .mapObject(type: CouponListModel.self)
           .subscribe(onNext: { (data) in
            self.dismissProgressHud()
                weakSelf?.tableView.endrefresh()
                weakSelf?.couponListModel = data
                if pageNum == 1 {
                    weakSelf?.couponList.removeAll()
                }
                weakSelf?.couponList.append(contentsOf: data.list)
                weakSelf?.tableView.reloadData()
           }, onError: { (error) in
                self.dismissProgressHud()
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
    
    //MARK: - 懒加载
    lazy private var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(CouponCell.self, forCellReuseIdentifier: CouponCellId)
        
        
        return table
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard couponListModel != nil else { return 0 }
        return couponList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CouponCellId, for: indexPath) as! CouponCell
        cell.couponInfo = couponList[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CouponCellHeight
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
        TongJi.log(.我的卡券返回, label: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
