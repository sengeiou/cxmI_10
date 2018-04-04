//
//  FootballMatchVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum FootballMatchType: String {
    case 胜平负 = "彩小秘 · 胜平负"
    case 让球胜平负 = "彩小秘 · 让球胜平负"
    case 总进球 = "彩小秘 · 总进球"
    case 比分 = "彩小秘 · 比分"
    case 半全场 = "彩小秘 · 半全场"
    case 二选一 = "彩小秘 · 2选1"
    case 混合过关 = "彩小秘 · 混合过关"
}

fileprivate let FootballSectionHeaderId = "FootballSectionHeaderId"
fileprivate let FootballSPFCellId = "FootballSPFCellId"
fileprivate let FootballRangSPFCellId = "FootballRangSPFCellId"
fileprivate let FootballTotalCellId = "FootballTotalCellId"
fileprivate let FootballScoreCellId = "FootballScoreCellId"
fileprivate let FootballBanQuanCCellId = "FootballBanQuanCCellId"
fileprivate let Football2_1CellId = "Football2_1CellId"
fileprivate let FootballHunheCellId = "FootballHunheCellId"


class FootballMatchVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FootballBottomViewDelegate, FootballSectionHeaderDelegate, FootballRequestPro, FootballTeamViewDelegate , FootballMatchFilterVCDelegate{
    
    
    // MARK: - 属性
    public var matchType: FootballMatchType = .胜平负
    
    public var matchList : [FootballMatchModel]!
    public var selectPlayList: [FootballPlayListModel]!
    public var matchData : FootballMatchData!
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = matchType.rawValue
        selectPlayList = [FootballPlayListModel]()
        initSubview()
        setEmpty(title: "暂无可选赛事", tableView)
        footballRequest(leagueId: "")
        setRightButtonItem()
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
            make.height.equalTo(44 * defaultScale + SafeAreaBottomHeight)
            make.bottom.equalTo(-0)
        }
    }
    // MARK: - 初始化子视图
    private func initSubview() {
        self.view.addSubview(tableView)
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
    }
    // MARK: - 网络请求
    // MARK: - 懒加载
    lazy public var topView: FootballTopView = {
        let topView = FootballTopView()
        return topView
    }()
    
    lazy public var bottomView: FootballBottomView = {
        let bottomView = FootballBottomView()
        bottomView.delegate = self
        return bottomView
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.register(FootballSectionHeader.self, forHeaderFooterViewReuseIdentifier: FootballSectionHeaderId)
        registerCell(table)
        return table
    }()
    private func registerCell(_ table: UITableView) {
        switch matchType {
        case .胜平负:
            table.register(FootballSPFCell.self, forCellReuseIdentifier: FootballSPFCellId)
        case .让球胜平负:
            table.register(FootballRangSPFCell.self, forCellReuseIdentifier: FootballRangSPFCellId)
        case .总进球:
            table.register(FootballTotalCell.self, forCellReuseIdentifier: FootballTotalCellId)
        case .比分:
            table.register(FootballScoreCell.self, forCellReuseIdentifier: FootballScoreCellId)
        case .半全场:
            table.register(FootballBanQuanCCell.self, forCellReuseIdentifier: FootballBanQuanCCellId)
        case .二选一:
            table.register(Football2_1Cell.self, forCellReuseIdentifier: Football2_1CellId)
        case .混合过关:
            table.register(FootballHunheCell.self, forCellReuseIdentifier: FootballHunheCellId)
        }
    }
    
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        guard matchList != nil else { return 0 }
        return matchList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let header = matchList[section]
        
        if header.isSpreading == true {
            let matchModel = matchList[section]
            return matchModel.playList.count
        }else {
            return 0
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballSPFCellId, for: indexPath) as! FootballSPFCell
        cell.teamView.delegate = self
        let matchModel = matchList[indexPath.section]
        cell.playInfoModel = matchModel.playList[indexPath.row]
        
        return cell
    }
    private func initRangSPFCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballSPFCellId, for: indexPath) as! FootballSPFCell
        
        return cell
    }
    private func initTatolCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballSPFCellId, for: indexPath) as! FootballSPFCell
        
        return cell
    }
    private func initScoreCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballSPFCellId, for: indexPath) as! FootballSPFCell
        
        return cell
    }
    private func initBanQuanCCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballSPFCellId, for: indexPath) as! FootballSPFCell
        
        return cell
    }
    private func init2Cell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballSPFCellId, for: indexPath) as! FootballSPFCell
        
        return cell
    }
    private func initHunheCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballSPFCellId, for: indexPath) as! FootballSPFCell
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballSectionHeaderId) as! FootballSectionHeader
        header.tag = section
        header.delegate = self


        if section == 0, self.matchData.hotPlayList.isEmpty == false {
            header.headerType = .hotMatch
        }else {
            header.headerType = .match
        }
        
        header.matchModel = matchList[section]
        
        return header
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88 * defaultScale
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49 * defaultScale
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
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
        filter.delegate = self
        present(filter)
    }
    
    // MARK: - delegate
    func spread(sender: UIButton, section: Int) {
        let header = matchList[section]
        
        header.isSpreading = !header.isSpreading
        
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    // MARK: - FootballTeamView Delegate 选取比赛，
    func select(teamInfo: FootballPlayListModel) {
        guard selectPlayList != nil else { return }
        selectPlayList.append(teamInfo)
    }
    
    func deSelect(teamInfo: FootballPlayListModel) {
        guard selectPlayList != nil else { return }
        selectPlayList.remove(teamInfo)
    }
    
    // MARK: - FOOTBALLBOTTOM delegate
    func delete() {
        showCXMAlert(title: nil, message: "您正在清空方案列表", action: "清空", cancel: "返回") { (action) in
            
        }
    }
    // 确认
    func confirm() {
        guard selectPlayList.isEmpty == false else {
            showHUD(message: "请至少选择1场单关比赛或者2场非单关比赛")
            return }

        guard selectPlayList.count >= 2 else {
            let play = selectPlayList[0]
            guard play.single == true else {
                showHUD(message: "请至少选择1场单关比赛或者2场非单关比赛")
                return }
            
            let order = FootballOrderConfirmVC()
            order.selectPlayList = selectPlayList
            pushViewController(vc: order)
            return
        }
        let order = FootballOrderConfirmVC()
        order.selectPlayList = selectPlayList
        pushViewController(vc: order)
    }
    
    // MARK: - 联赛 筛选 代理
    func filterConfirm(leagueId: String) {
        footballRequest(leagueId: leagueId)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
