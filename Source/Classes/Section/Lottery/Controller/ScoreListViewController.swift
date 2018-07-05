//
//  ScoreListViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/4.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let LotteryCellId = "LotteryCellId"
fileprivate let LotterySectionHeaderId = "LotterySectionHeaderId"

class ScoreListViewController: BaseViewController, LotterySectionHeaderDelegate {

    // MARK: - 属性 public
    
    public var changeNum : ((_ numStr: String) -> Void)!
    
    // MARK: - 属性 private
    public var dateFilter : String!
    private var isAlready : Bool = false
    private var leagueIds : String = ""
    private var finished : Bool = false
    
    private var resultList : [LotteryResultModel]!
    
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "彩小秘 · 比分xx"
        self.addPanGestureRecognizer = false
        hideBackBut()
        initSubview()
        
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(matchFilter(_:)), name: NSNotification.Name(rawValue: MatchFilterNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dateFilter(_:)), name: NSNotification.Name(rawValue: DateFilterNotificationName), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHidenBar = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TongJi.start("开奖页")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TongJi.end("开奖页")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.bottom.equalTo(0)
        }
    }
    
    @objc private func matchFilter(_ notification : Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let leagueId = userInfo["leagueId"] as? String else { return }
        guard let isAlreadyBuy = userInfo["isAlreadyBuy"] as? Bool else { return }
        self.isAlready = isAlreadyBuy
        self.leagueIds = leagueId
        self.loadNewData()
    }
    @objc private func dateFilter(_ notification : Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let model = userInfo["date"] as?  LotteryDateModel else { return }
        self.dateFilter = model.date
        self.isAlready = false
        self.loadNewData()
    }
    
    private func initSubview() {
        self.view.addSubview(tableView)
    }
    
    private func loadNewData() {
        guard self.dateFilter != nil else {
            self.tableView.endrefresh()
            return }
        self.lotteryResultRequest(date: self.dateFilter, isAlready: self.isAlready, leagueIds: self.leagueIds, finished: self.finished)
    }
    
    //MARK: - 网络请求
    private func lotteryResultRequest(date : String, isAlready: Bool, leagueIds: String, finished : Bool) {
        //self.showProgressHUD()
        weak var weakSelf = self
        _ = lotteryProvider.rx.request(.lotteryResult(date: date, isAlready: isAlready, leagueIds: leagueIds, finished: finished))
            .asObservable()
            .mapArray(type: LotteryResultModel.self)
            .subscribe(onNext: { (data) in
                self.tableView.endrefresh()
                
                self.resultList = data
                
                self.changeNum("\(self.resultList.count)")
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
            }, onError: { (error) in
                //self.dismissProgressHud()
                self.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.isAlready = false
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
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.separatorColor = ColorFFFFFF
        table.backgroundColor = ColorF4F4F4
        table.register(LotteryCell.self, forCellReuseIdentifier: LotteryCellId)
        table.register(LotterySectionHeader.self, forHeaderFooterViewReuseIdentifier: LotterySectionHeaderId)
        if #available(iOS 11.0, *) {
            
        }else {
            table.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 49, right: 0)
            table.scrollIndicatorInsets = table.contentInset
        }
        return table
    }()
    
    
    //MARK: - 分区头 ，delegate
    func spread(sender: UIButton, section: Int) {
        
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }

}

extension ScoreListViewController : LotteryCellDelegate {
    func didTipCollection(cell: LotteryCell, model: LotteryResultModel) {
        
    }
}

extension ScoreListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard resultList != nil else { return }
        guard let matchId = resultList[indexPath.row].matchId else { return }
        let matchInfo = FootballMatchInfoVC()
        matchInfo.matchId = matchId
        pushViewController(vc: matchInfo)
    }
}

extension ScoreListViewController : UITableViewDataSource {
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard resultList != nil else { return 0 }
        return self.resultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LotteryCellId, for: indexPath) as! LotteryCell
        cell.resultModel = resultList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: LotterySectionHeaderId) as! LotterySectionHeader
        header.tag = section
        //header.delegate = self
        header.resultList = self.resultList
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91 * defaultScale
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36 * defaultScale
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

