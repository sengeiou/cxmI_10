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

class LotteryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, LotterySectionHeaderDelegate, LotteryHeaderViewDelegate, LotteryDateFilterVCDelegate, LotteryMoreFilterVCDelegate {
   
    
   
    
    
    
    
    

    // MARK: - 属性 public
    // MARK: - 属性 private
    private var dateFilter : String!
    private var isAlready : Bool = false
    private var leagueIds : String = ""
    private var selectedDateModel : LotteryDateModel!
    private var resultList : [LotteryResultModel]!
    private var headerView : LotteryHeaderView!
    private var dateList : [LotteryDateModel]!
    private var filterList: [FilterModel]!
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "彩小秘 · 开奖"
        
        hideBackBut()
        initSubview()
        
        self.dateList = LotteryDateModel().getDates()
        self.dateFilter = self.dateList.last?.date
        self.headerView.dateModel = self.dateList.last
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHidenBar = false
        filterRequest()
        self.lotteryResultRequest(date: self.dateFilter, isAlready: self.isAlready, leagueIds: self.leagueIds)
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
    
    //MARK: - 网络请求
    private func lotteryResultRequest(date : String, isAlready: Bool, leagueIds: String) {
        weak var weakSelf = self
        _ = lotteryProvider.rx.request(.lotteryResult(date: date, isAlready: isAlready, leagueIds: leagueIds))
            .asObservable()
            .mapArray(type: LotteryResultModel.self)
            .subscribe(onNext: { (data) in
                self.resultList = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    weakSelf?.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    private func filterRequest() {
        weak var weakSelf = self
        _ = homeProvider.rx.request(.filterMatchList)
            .asObservable()
            .mapArray(type: FilterModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.filterList = data
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    weakSelf?.showHUD(message: msg!)
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
        return UIView()
    }
    
    //MARK: - 分区头 ，delegate
    func spread(sender: UIButton, section: Int) {

        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    // MARK: - 筛选条件 delegate
    func didTipDateFilter() {
        let date = LotteryDateFilterVC()
        date.delegate = self
        date.dateList = self.dateList
        present(date)
    }
    
    func didTipMoreFilter() {
        let more = LotteryMoreFilterVC()
        more.delegate = self
        more.filterList = self.filterList
        more.isAlreadyBuy = self.isAlready
        present(more)
    }
    
    func didTipAllFilter() {
        
    }
    
    // MARK: - 时间筛选 delegate
    func didSelectDateItem(filter: LotteryDateFilterVC, dateModel: LotteryDateModel) {
        self.dateFilter = dateModel.date
        self.headerView.dateModel = dateModel
        lotteryResultRequest(date: dateFilter, isAlready: isAlready, leagueIds: leagueIds)
    }
    // MARK: - 更多筛选 delegate
    func filterConfirm(leagueId: String, isAlreadyBuy: Bool) {
        self.isAlready = isAlreadyBuy
        self.leagueIds = leagueId
        lotteryResultRequest(date: self.dateFilter, isAlready: isAlready, leagueIds: self.leagueIds)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
