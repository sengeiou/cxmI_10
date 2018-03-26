//
//  MessageCenterVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum MessageCenterType : String{
    case notice = "通知"
    case message = "消息"
}

fileprivate let MessageCenterCellId = "MessageCenterCellId"

class MessageCenterVC: BaseViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {

    public var messageType: MessageCenterType = .notice
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableview)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: messageType.rawValue)
    }
    
    //MARK: - 懒加载
    lazy private var tableview : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(MessageCenterCell.self, forCellReuseIdentifier: MessageCenterCellId)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCenterCellId, for: indexPath) as! MessageCenterCell
        
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
        
    }
    

    

}
