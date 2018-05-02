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
fileprivate let NoticeCellId = "NoticeCellId"

class MessageCenterVC: BaseViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {

    public var messageType: MessageCenterType = .notice
    
    private var messageModel : BasePageModel<MessageCenterModel>!
    private var messageList: [MessageCenterModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEmpty(title: "暂无消息", tableView)
        self.view.addSubview(self.tableView)
        
        messageList = []
        
        messageListRequest(1)
        
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
    //MARK: - 加载数据
    private func loadNewData() {
        
        messageListRequest(1)
    }
    private func loadNextData() {
        guard self.messageModel.isLastPage == false else {
            self.tableView.noMoreData()
            return }
        
        messageListRequest(self.messageModel.nextPage)
    }
    // MARK: - 网络请求
    private func messageListRequest(_ pageNum: Int) {
        var type : String!
        switch messageType {
        case .message:
            type = "1"
        case .notice:
            type = "0"
        }
        
        weak var weakSelf = self
        _ = userProvider.rx.request(.messageList(msgType: type, pageNum: pageNum))
            .asObservable()
            .mapObject(type: BasePageModel<MessageCenterModel>.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.messageModel = data
                if pageNum == 1 {
                    weakSelf?.messageList.removeAll()
                }
                weakSelf?.messageList.append(contentsOf: data.list)
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: messageType.rawValue)
    }
    
    //MARK: - 懒加载
    lazy private var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(MessageCenterCell.self, forCellReuseIdentifier: MessageCenterCellId)
        table.register(NoticeCell.self, forCellReuseIdentifier: NoticeCellId)
        
        return table
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard messageModel != nil else { return 0 }
        return messageList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messageType == .message {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCellId, for: indexPath) as! NoticeCell
            cell.messageModel = messageList[indexPath.section]
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageCenterCellId, for: indexPath) as! MessageCenterCell
            cell.messageModel = messageList[indexPath.section]
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 121 * defaultScale
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
        
    }
    

    

}
