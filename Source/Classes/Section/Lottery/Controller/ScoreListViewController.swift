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

class ScoreListViewController: BaseViewController, LotterySectionHeaderDelegate, LotteryProtocol {

    // MARK: - 属性 public
    
    public var changeNum : ((_ notFinishNum: String, _ finishNum: String, _ collectNum: String) -> Void)!
    public var matchType : String = "0"
    
    // MARK: - 属性 private
    public var dateFilter : String!
    private var isAlready : Bool = false
    private var leagueIds : String = ""
    private var lotteryModel : LotteryModel! {
        didSet{
            self.changeNum(lotteryModel.notfinishCount, lotteryModel.finishCount, lotteryModel.matchCollectCount)
        }
    }
    
    private var resultList : [LotteryResultModel]! {
        didSet{

            if matchType == "0" {
                //resultList[0].matchTimeStart = 1531291178
                shouldStartTimer(true)
            }
        }
    }
    
    private func shouldStartTimer(_ start : Bool) {
        // 开赛时间>0且<150时启动计时器
//        var start = false
//        for match in resultList {
//            if matchStart(with: match.matchTimeStart) {
//                if matchIntervalue(with: match.matchTimeStart) < 150 {
//                    start = true
//                }else {
//                    start = false
//                }
//            }
//        }
    
        if start {
            print("计时开始")
            if !CXMGCDTimer.shared.isExistTimer(WithTimerName: "cxmTimer") {
                startTimer()
            }
        }else {
            print("计时结束")
            CXMGCDTimer.shared.cancleTimer(WithTimerName: "cxmTimer")
        }
    }
    
    private func startTimer() {
        CXMGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "cxmTimer", timeInterval: 60, queue: .main, repeats: true) {
            print(1)
            
            self.loadNewData()
        }
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "彩小秘 · 比赛"
        //setEmpty(title: "暂无比赛", self.tableView)
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
        if matchType == "0" {
            self.shouldStartTimer(true)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TongJi.end("开奖页")
        if matchType == "0" {
            self.shouldStartTimer(false)
        }
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
        self.leagueIds = ""
        self.loadNewData()
    }
    
    private func initSubview() {
        self.view.addSubview(tableView)
    }
    
    private func loadNewData() {
        guard self.dateFilter != nil else {
            self.tableView.endrefresh()
            return }
        self.lotteryResultRequest(date: self.dateFilter, isAlready: self.isAlready, leagueIds: self.leagueIds, type: self.matchType)
    }
    
    //MARK: - 网络请求
    private func lotteryResultRequest(date : String, isAlready: Bool, leagueIds: String, type : String) {
        //self.showProgressHUD()
        weak var weakSelf = self
        
        _ = lotteryProvider.rx.request(.lotteryResultNew(date: date, isAlready: isAlready, leagueIds: leagueIds, type: type))
            .asObservable()
            .mapObject(type: LotteryModel.self)
            .subscribe(onNext: { (data) in
                self.tableView.endrefresh()
                self.lotteryModel = data
                self.resultList = data.lotteryMatchDTOList
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }, onError: { (error) in
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
    
    //MARK: - 收藏赛事
    private func collectRequest(matchId: String, cell: LotteryCell) {
        weak var weakSelf = self
        
        _ = userProvider.rx.request(.collectMatch(matchId: matchId))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                //self.showHUD(message: data.msg)
            }, onError: { (error) in
                cell.changeCollectionSelected(selected: false)
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
    
    //MARK: - 取消收藏赛事
    private func collectCancelRequest(matchId: String, cell: LotteryCell) {
        weak var weakSelf = self
        _ = userProvider.rx.request(.collectMatchCancle(matchId: matchId))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                //self.showHUD(message: data.msg)
                
            }, onError: { (error) in
                cell.changeCollectionSelected(selected: true)
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
            }, onCompleted: nil, onDisposed: nil)
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

//MARK: - 收藏
extension ScoreListViewController : LotteryCellDelegate {
    func didTipCollection(cell: LotteryCell, model: LotteryResultModel, selected: Bool) {
        if matchType == "2" {
            collectCancelRequest(matchId: model.matchId, cell : cell)
            self.resultList.remove(model)
            self.tableView.reloadData()
        }
        if model.isCollect {
            collectRequest(matchId: model.matchId, cell : cell)
        }else {
            collectCancelRequest(matchId: model.matchId, cell : cell)
        }
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
        cell.matchType = self.matchType
        cell.resultModel = resultList[indexPath.row]
        cell.indexPath = indexPath
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

