//
//  ScoreListViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/4.
//  Copyright © 2018年 韩笑. All rights reserved.
//  比赛列表

import UIKit

fileprivate let LotteryCellId = "LotteryCellId"
fileprivate let LotterySectionHeaderId = "LotterySectionHeaderId"

class CXMScoreListViewController: BaseViewController, LotterySectionHeaderDelegate, LotteryProtocol {

    // MARK: - 属性 public
    
    public var changeNum : ((_ notFinishNum: String, _ finishNum: String, _ collectNum: String) -> Void)!
    public var shouldLogin : ( () -> Void )!
    public var matchType : String = "0"
    
    /// 置顶
    public var shouldReloadData : Bool = false
    public var shouldReload  = false // 刷新数据
    
    // MARK: - 属性 private
    public var dateFilter : String! = ""
    private var isAlready : Bool = false
    private var leagueIds : String = ""
    private var lotteryModel : LotteryModel! {
        didSet{
            //self.changeNum(lotteryModel.notfinishCount, lotteryModel.finishCount, lotteryModel.matchCollectCount)
        }
    }
    
    private var resultList : [LotteryResultModel]!
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "比赛"
        setEmpty(title: "暂无比赛", self.tableView)
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
        self.tableView.isUserInteractionEnabled = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TongJi.start("开奖页")
        if self.shouldReloadData, self.resultList != nil , self.resultList.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
        }
        
        if matchType == "0" {
            self.loadNewData()
            self.shouldStartTimer(true)
        }else {
            if self.shouldReload {
                self.loadNewData()
            }
        }
        self.shouldReload = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.shouldStartTimer(false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TongJi.end("开奖页")
        self.shouldReload = true
        self.tableView.endrefresh()
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
       
        if let type = userInfo["type"] as? String, type == self.matchType {
            self.loadNewData()
        }
    }
    @objc private func dateFilter(_ notification : Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let model = userInfo["date"] as?  LotteryDateModel else { return }
        self.dateFilter = model.strDate
        self.isAlready = false
        self.leagueIds = ""
        
        if let type = userInfo["type"] as? String, type == self.matchType {
            self.loadNewData()
        }
    }
    
    private func initSubview() {
        self.view.addSubview(tableView)
    }
    
    private func loadNewData(_ cell : LotteryCell? = nil) {
        guard self.dateFilter != nil else {
            self.tableView.endrefresh()
            return }
        self.lotteryResultRequest(date: self.dateFilter, isAlready: self.isAlready, leagueIds: self.leagueIds, type: self.matchType, cell : cell)
    }
    
    //MARK: - 网络请求
    private func lotteryResultRequest(date : String, isAlready: Bool, leagueIds: String, type : String, cell: LotteryCell? ) {
        //self.showProgressHUD()
        weak var weakSelf = self
        
        DispatchQueue.global().async {
            weakSelf?.semaphore.wait()
            _ = lotteryProvider.rx.request(.lotteryResultNew(date: date, isAlready: isAlready, leagueIds: leagueIds, type: type))
                .asObservable()
                .mapObject(type: LotteryModel.self)
                .subscribe(onNext: { (data) in
                    
                    self.tableView.endrefresh()
                    self.dismissProgressHud()
                    self.lotteryModel = data
                    self.resultList = data.lotteryMatchDTOList
                    
                    DispatchQueue.main.async {
                        if cell != nil {
                            cell?.collectionButton.isUserInteractionEnabled = true
                        }
                        self.tableView.reloadData()
                    }
                    
                    weakSelf?.semaphore.signal()
                }, onError: { (error) in
                    self.tableView.endrefresh()
                    DispatchQueue.main.async {
                        if cell != nil {
                            cell?.collectionButton.isUserInteractionEnabled = true
                        }
                    }
                    //self.dismissProgressHud()
                    weakSelf?.semaphore.signal()
                    guard let err = error as? HXError else { return }
                    switch err {
                    case .UnexpectedResult(let code, let msg):
                        switch code {
                        case 600:
                            weakSelf?.removeUserData()
                            weakSelf?.isAlready = false
                            //weakSelf?.pushLoginVC(from: self)
                            weakSelf?.shouldLogin()
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
    }
    
    //MARK: - 收藏赛事
    private func collectRequest(matchId: String, cell: LotteryCell) {
        weak var weakSelf = self
        self.showProgressHUD()
        _ = userProvider.rx.request(.collectMatch(matchId: matchId, dateStr: self.dateFilter))
            .asObservable()
            .mapObject(type: LotteryCollectModel.self)
            .subscribe(onNext: { (data) in
                //self.dismissProgressHud()
                
                weakSelf?.loadNewData(cell)
                guard let notCount = weakSelf?.lotteryModel.notfinishCount else { return }
                guard let finishCount = weakSelf?.lotteryModel.finishCount else { return }
                
                weakSelf?.changeNum(notCount,
                                    finishCount,
                                    data.matchCollectCount)
                
            }, onError: { (error) in
                weakSelf?.loadNewData(cell)
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.isAlready = false
                        //weakSelf?.pushLoginVC(from: self)
                        weakSelf?.shouldLogin()
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
        
        self.showProgressHUD()
        
        _ = userProvider.rx.request(.collectMatchCancle(matchId: matchId, dateStr: self.dateFilter))
            .asObservable()
            .mapObject(type: LotteryCollectModel.self)
            .subscribe(onNext: { (data) in
                
                weakSelf?.loadNewData(cell)
                guard let notCount = weakSelf?.lotteryModel.notfinishCount else { return }
                guard let finishCount = weakSelf?.lotteryModel.finishCount else { return }
                
                weakSelf?.changeNum(notCount,
                                    finishCount,
                                    data.matchCollectCount)
                
            }, onError: { (error) in
                weakSelf?.loadNewData(cell)
                
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.isAlready = false
                        //weakSelf?.pushLoginVC(from: self)
                        weakSelf?.shouldLogin()
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

extension CXMScoreListViewController {
    private func shouldStartTimer(_ start : Bool) {
        if start {
            if !CXMGCDTimer.shared.isExistTimer(WithTimerName: "cxmTimer") {
                startTimer()
                print("计时开始")
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
}

//MARK: - 收藏
extension CXMScoreListViewController : LotteryCellDelegate {
    func didTipCollection(cell: LotteryCell, model: LotteryResultModel, selected: Bool) {
        
        if matchType == "2" {
            collectCancelRequest(matchId: model.matchId, cell : cell)
            self.resultList.remove(model)
            self.tableView.reloadData()
            return
        }else {
            if model.isCollect == false {
                collectRequest(matchId: model.matchId, cell : cell)
            }else {
                collectCancelRequest(matchId: model.matchId, cell : cell)
            }
        }
    }
}

extension CXMScoreListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard resultList != nil else { return }
        guard let matchId = resultList[indexPath.row].matchId else { return }
        let matchInfo = CXMFootballMatchInfoVC()
        matchInfo.matchId = matchId
        self.shouldReloadData = false
        self.shouldReload = false
        pushViewController(vc: matchInfo)
    }
}

extension CXMScoreListViewController : UITableViewDataSource {
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
        header.lotteryModel = self.lotteryModel
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

