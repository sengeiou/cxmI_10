//
//  FootballOrderConfirmVC.swift
//  彩小蜜
//
//  Created by HX on 2018/4/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let FootballOrderSPFCellId = "FootballOrderSPFCellId"
fileprivate let FootballOrderRangSPFCellId = "FootballOrderRangSPFCellId"
fileprivate let FootballOrderTotalCellId = "FootballOrderTotalCellId"
fileprivate let FootballOrderScoreCellId = "FootballOrderScoreCellId"
fileprivate let FootballOrderBanQuanCCellId = "FootballOrderBanQuanCCellId"
fileprivate let FootballOrder2_1CellId = "FootballOrder2_1CellId"
fileprivate let FootballOrderHunheCellId = "FootballOrderHunheCellId"


class FootballOrderConfirmVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FootballTeamViewDelegate, FootballOrderBottomViewDelegate, FootballTimesFilterVCDelegate, FootballPlayFilterVCDelegate, FootballFilterPro, FootballOrderProtocol, FootballOrderSPFCellDelegate{
   
    
    // MARK: - 属性
    public var matchType: FootballMatchType = .胜平负
    public var homeData: HomePlayModel!
    
    public var selectPlayList: [FootballPlayListModel]! {
        didSet{
            guard let filters = filterPlay(with: selectPlayList) else { return }
            bottomView.filterList = filters
            topView.playModelList = selectPlayList
            guard filters.isEmpty == false else { return }
            var str : String = ""
            for filter in filters {
                if filter.isSelected == true {
                    str += filter.titleNum + ","
                }
            }
            str.removeLast()
            self.playType = str
        }
    }
    public var playList: [FootballPlayListModel]! {
        didSet{
            selectPlayList = playList
            self.tableView.reloadData()
        }
    }
    public var betInfo : FootballBetInfoModel! {
        didSet{
            bottomView.betInfo = betInfo
        }
    }
    
    public var times : String = "5"  // 倍数  网络请求用
    public var playType : String! // 串关方式 网络请求用
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 投注确认"
        initSubview()
        setEmpty(title: "暂无可选赛事", tableView)
        setRightButtonItem()

        orderRequest ()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(bottomView.snp.top)
        }
        topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight)
            make.height.equalTo(44 * defaultScale)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(118 * defaultScale + SafeAreaBottomHeight)
            make.bottom.equalTo(-0)
        }
    }
    // MARK: - 初始化子视图
    private func initSubview() {
        self.view.addSubview(tableView)
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
    }
    
    // MARK: - 懒加载
    lazy public var topView: FootballOrderTopView = {
        let topView = FootballOrderTopView()
        return topView
    }()
    
    lazy public var bottomView: FootballOrderBottomView = {
        let bottomView = FootballOrderBottomView()
        bottomView.delegate = self
        return bottomView
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        registerCell(table)
        return table
    }()
    
    private func registerCell(_ table: UITableView) {
        switch matchType {
        case .胜平负:
            table.register(FootballOrderSPFCell.self, forCellReuseIdentifier: FootballOrderSPFCellId)
        case .让球胜平负:
            table.register(FootballOrderRangSPFCell.self, forCellReuseIdentifier: FootballOrderRangSPFCellId)
        case .总进球:
            table.register(FootballOrderTotalCell.self, forCellReuseIdentifier: FootballOrderTotalCellId)
        case .比分:
            table.register(FootballOrderScoreCell.self, forCellReuseIdentifier: FootballOrderScoreCellId)
        case .半全场:
            table.register(FootballOrderBanQuanCCell.self, forCellReuseIdentifier: FootballOrderBanQuanCCellId)
        case .二选一:
            table.register(FootballOrder2_1Cell.self, forCellReuseIdentifier: FootballOrder2_1CellId)
        case .混合过关:
            table.register(FootballOrderHunheCell.self, forCellReuseIdentifier: FootballOrderHunheCellId)
        }
    }
    
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        guard playList != nil else { return 0 }
        return playList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch matchType {
        case .胜平负:
            return initSPFCell(indexPath: indexPath)
        case .让球胜平负:
            return initSPFCell(indexPath: indexPath)
        case .总进球:
            return initSPFCell(indexPath: indexPath)
        case .比分:
            return initSPFCell(indexPath: indexPath)
        case .半全场:
            return initSPFCell(indexPath: indexPath)
        case .二选一:
            return initSPFCell(indexPath: indexPath)
        case .混合过关:
            return initSPFCell(indexPath: indexPath)
        }
    }
    
    private func initSPFCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrderSPFCellId, for: indexPath) as! FootballOrderSPFCell
        cell.delegate = self 
        cell.teamView.delegate = self 
        cell.playInfoModel = playList[indexPath.section]
        return cell
    }
    private func initRangSPFCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrderRangSPFCellId, for: indexPath) as! FootballOrderRangSPFCell
        
        return cell
    }
    private func initTatolCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrderTotalCellId, for: indexPath) as! FootballOrderTotalCell
        
        return cell
    }
    private func initScoreCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrderScoreCellId, for: indexPath) as! FootballOrderScoreCell
        
        return cell
    }
    private func initBanQuanCCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrderBanQuanCCellId, for: indexPath) as! FootballOrderBanQuanCCell
        
        return cell
    }
    private func init2Cell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrder2_1CellId, for: indexPath) as! FootballOrder2_1Cell
        
        return cell
    }
    private func initHunheCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrderHunheCellId, for: indexPath) as! FootballOrderHunheCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91 * defaultScale
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    // MARK: CELL  删除
    func deleteOrderSPFCell(playInfo: FootballPlayListModel) {
        playList.remove(playInfo)
    }
    
    // MARK: ITEM 选择 delegate
    func select(teamInfo: FootballPlayListModel) {
        guard selectPlayList != nil else { return }
        selectPlayList.append(teamInfo)
    }
    
    func deSelect(teamInfo: FootballPlayListModel) {
        guard selectPlayList != nil else { return }
        selectPlayList.remove(teamInfo)
    }
    func selectedItem() {
        guard homeData != nil else { return }
        
        orderRequest ()
    }
    // MARK: - Bottow Delegate
    // 确认键
    func orderConfirm(filterList: [FootballPlayFilterModel], times: String) {
        
        
    }
    // 串关 弹窗
    func orderPlay(filterList: [FootballPlayFilterModel]) {
        let play = FootballPlayFilterVC()
        play.delegate = self
        play.filterList = filterList
        present(play)
    }
    // 倍数弹窗
    func orderMultiple() {
        let times = FootballTimesFilterVC()
        times.delegate = self
        present(times)
    }
    
    // MARK: - 倍数弹窗 delegate
    func timesConfirm(times: String) {
        print(times)
        self.times = times
        bottomView.times = times
        orderRequest ()
    }
    
    // MARK: - 串关弹窗 delegate
    func playFilterConfirm(filterList: [FootballPlayFilterModel]) {
        bottomView.filterList = filterList

        guard filterList.isEmpty == false else { return }
        var str : String = ""
        for filter in filterList {
            if filter.isSelected == true {
                str += filter.titleNum + ","
            }
        }
        str.removeLast()
        self.playType = str
        orderRequest()
    }
    
    func playFilterCancel() {
        
    }
    // MARK: - right bar item
    private func setRightButtonItem() {
        
        let rightBut = UIButton(type: .custom)
        rightBut.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        rightBut.setBackgroundImage(UIImage(named:"Details"), for: .normal)
        
        rightBut.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBut)
    }
    
    @objc private func showMenu(_ sender: UIButton) {
        let filter = FootballMatchFilterVC()
        filter.popStyle = .fromCenter
        present(filter)
    }
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
