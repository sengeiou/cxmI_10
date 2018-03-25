//
//  PurchaseRecordVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum PurchaseRecordType: String {
    case all = "全部"
    case winning = "中奖"
    case prize = "带开奖"
}

fileprivate let PurchaseRecordCellId = "PurchaseRecordCellId"

class PurchaseRecordVC: BaseViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {

    //MARK: - 点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = OrderDetailVC()
        pushViewController(vc: order)
    }
    
    public var recordType : PurchaseRecordType = .all
    
    //MARK: - 属性
    private var recordListModel : PurchaseRecordListModel!
    private var recordList : [PurchaseRecordInfoModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 购彩记录"
        self.view.addSubview(self.tableView)
        setEmpty(title: "您还没有优惠券！", tableView)
        
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
        return IndicatorInfo(title: recordType.rawValue)
    }
    
    //MARK: - 加载数据
    private func loadNewData() {
        
        
    }
    private func loadNextData() {
        
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
        //guard recordListModel != nil else { return 0 }
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseRecordCellId, for: indexPath) as! PurchaseRecordCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RecordCellHeight
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
