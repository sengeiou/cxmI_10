//
//  LotteryViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/2/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let LotteryCellId = "LotteryCellId"
fileprivate let LotterySectionHeaderId = "LotterySectionHeaderId"

class CXMLotteryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, LotterySectionHeaderDelegate, LotteryHeaderViewDelegate, LotteryDateFilterVCDelegate, LotteryMoreFilterVCDelegate {
   

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard resultList != nil else { return }
        guard let matchId = resultList[indexPath.row].matchId else { return }
        let matchInfo = CXMFootballMatchInfoVC()
        matchInfo.matchId = matchId
        pushViewController(vc: matchInfo)
    }
    

    // MARK: - 属性 public
    // MARK: - 属性 private
    private var dateFilter : String!
    private var isAlready : Bool = false
    private var leagueIds : String = ""
    private var finished : Bool = false
    private var selectedDateModel : LotteryDateModel!
    private var resultList : [LotteryResultModel]!
    private var headerView : LotteryHeaderView!
    private var dateList : [LotteryDateModel]!
    private var filterList: [FilterModel]!
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "彩小秘 · 比分"
        
        hideBackBut()
        initSubview()
        
        
        //filterRequest()
        //self.lotteryResultRequest(date: self.dateFilter, isAlready: self.isAlready, leagueIds: self.leagueIds, finished: self.finished)
        
        self.tableView.headerRefresh {
            self.loadNewData()
        }
        self.tableView.beginRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHidenBar = false
        //self.dateList = LotteryDateModel().getDates()
        self.dateFilter = self.dateList.last?.strDate
        self.headerView.dateModel = self.dateList.last
        self.selectedDateModel = self.dateList.last
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TongJi.start("开奖页")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TongJi.end("开奖页")
    }
    
    
    override func viewDidLayoutSubviews() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(SafeAreaTopHeight)
            make.left.right.equalTo(0)
            make.height.equalTo(44 * defaultScale)
        }
    }
    
    private func initSubview() {
        headerView = LotteryHeaderView()
        headerView.delegate = self
        
        self.view.addSubview(tableView)
        self.view.addSubview(headerView)
    }
    
    private func loadNewData() {
        filterRequest()
        
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
                //self.dismissProgressHud()
                
                self.resultList = data
            
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
    
    private func filterRequest() {
        guard self.selectedDateModel != nil, self.selectedDateModel.strDate != nil else { return }
        weak var weakSelf = self
        _ = homeProvider.rx.request(.filterList(dateStr: self.selectedDateModel.strDate))
            .asObservable()
            .mapArray(type: FilterModel.self)
            .subscribe(onNext: { (data) in
                //self.tableView.endrefresh()
                weakSelf?.filterList = data
                
            }, onError: { (error) in
                //self.tableView.endrefresh()
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
            }, onCompleted: nil, onDisposed: nil )
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
    
    //MARK: - 分区头 ，delegate
    func spread(sender: UIButton, section: Int) {

        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    // MARK: - 筛选条件 delegate
    func didTipDateFilter() {
        let date = CXMLotteryDateFilterVC()
        date.delegate = self
        date.dateList = self.dateList
        present(date)
    }
    
    func didTipMoreFilter() {
        let more = CXMLotteryMoreFilterVC()
        more.delegate = self
        more.filterList = self.filterList
        more.isAlreadyBuy = self.isAlready
        present(more)
    }
    
    func didTipAllFilter(all: Bool) {
        self.finished = all
        lotteryResultRequest(date: dateFilter, isAlready: isAlready, leagueIds: leagueIds, finished: finished)
    }
    
    // MARK: - 时间筛选 delegate
    func didSelectDateItem(filter: CXMLotteryDateFilterVC, dateModel: LotteryDateModel) {
        self.dateFilter = dateModel.strDate
        self.headerView.dateModel = dateModel
        self.selectedDateModel = dateModel
        self.isAlready = false
        self.leagueIds = ""
        self.finished = false
        filterRequest()
        lotteryResultRequest(date: dateFilter, isAlready: isAlready, leagueIds: leagueIds, finished: finished)
    }
    // MARK: - 更多筛选 delegate
    func filterConfirm(leagueId: String, isAlreadyBuy: Bool) {
        self.isAlready = isAlreadyBuy
        self.leagueIds = leagueId
        lotteryResultRequest(date: self.dateFilter, isAlready: isAlready, leagueIds: self.leagueIds, finished: finished)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
