//
//  FootballMatchVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import SVProgressHUD

let MaxSelectedNum = 15

enum FootballMatchType: String {
    case 胜平负 = "胜平负"
    case 让球胜平负 = "让球胜平负"
    case 总进球 = "总进球"
    case 比分 = "比分"
    case 半全场 = "半全场"
    case 二选一 = "2选1"
    case 混合过关 = "混合投注"
    
    func getMatchType(type: String) -> FootballMatchType {
        var matchType : FootballMatchType = .胜平负
        
        switch type {
        case "2":
            matchType = .胜平负
        case "1":
            matchType = .让球胜平负
        case "4":
            matchType = .总进球
        case "5":
            matchType = .半全场
        case "3":
            matchType = .比分
        case "6":
            matchType = .混合过关
        case "7":
            matchType = .二选一
        default: break
            
        }
        
        return matchType
    }
}

fileprivate let FootballSectionHeaderId = "FootballSectionHeaderId"
fileprivate let FootballHotSectionHeaderId = "FootballHotSectionHeaderId"
fileprivate let FootballSPFCellId = "FootballSPFCellId"
fileprivate let FootballRangSPFCellId = "FootballRangSPFCellId"
fileprivate let FootballTotalCellId = "FootballTotalCellId"
fileprivate let FootballScoreCellId = "FootballScoreCellId"
fileprivate let FootballBanQuanCCellId = "FootballBanQuanCCellId"
fileprivate let Football2_1CellId = "Football2_1CellId"
fileprivate let FootballHunheCellId = "FootballHunheCellId"


class CXMFootballMatchVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FootballBottomViewDelegate, FootballSectionHeaderDelegate, FootballRequestPro, FootballTeamViewDelegate , FootballMatchFilterVCDelegate, FootballTotalViewDelegate, FootballScoreViewDelegate, FootballTwoOneViewDelegate , FootballHunheViewDelegate , FootballSPFCellDelegate, FootballMatchInfoPopVCDelegate, FootballCellProtocol, FootballFilterPro, FootballOrderConfirmVCDelegate, FootballHotSectionHeaderDelegate{
    
    
    // MARK: - 属性
    public var matchType: FootballMatchType = .混合过关 {
        didSet{
            TongJi.log(.足彩彩种, label: matchType.rawValue, att: .彩种)
            guard titleView != nil else { return }
            titleView.setTitle(matchType.rawValue, for: .normal)
        }
    }
    
    //public var homeData : HomePlayModel!
    
    public var matchList : [FootballMatchModel]!
    
    public var matchData : FootballMatchData!
    // 筛选列表
    public var filterList: [FilterModel]!
    
    public var selectPlayList: [FootballPlayListModel]! {
        didSet{
            guard selectPlayList != nil else { return }
            self.bottomView.number = selectPlayList.count
        }
    }
    public let semaphoreSignal = DispatchSemaphore(value: 1)
    
    private var selectPlays : Set<FootballPlayListModel>! {
        didSet{
            guard selectPlays != nil else { return }
            self.selectPlayList = Array(selectPlays)
            
        }
    }
    private var menu : CXMMFootballMatchMenu = CXMMFootballMatchMenu()
    public var titleView : UIButton!
    public var titleIcon : UIImageView!
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitleView()
        setRightButtonItem()
        self.title = matchType.rawValue
        selectPlayList = [FootballPlayListModel]()
        selectPlays = Set<FootballPlayListModel>()
        initSubview()
        setEmpty(title: "暂无可选赛事", tableView)
        menu.delegate = self
        footballRequest(leagueId: "")
        filterRequest()
        
        
        
        limitNum = 1
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TongJi.start(self.matchType.rawValue)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TongJi.end(self.matchType.rawValue)
    }
    // MARK: - 查看详情
    func didTipPopConfirm(matchId : String) {
        let matchInfo = CXMFootballMatchInfoVC()
        matchInfo.matchId = matchId
        pushViewController(vc: matchInfo)
    }
    
    // MARK: - cell delegate
    func didTipSPFCellDetail(teamInfo: FootballPlayListModel) {
        presentMatchInfoPopVC(teamInfo)
    }
    func didTipTwoOneCellDetail(teamInfo: FootballPlayListModel) {
        presentMatchInfoPopVC(teamInfo)
    }
    func didTipBanQuanCCellDetail(teamInfo: FootballPlayListModel) {
        presentMatchInfoPopVC(teamInfo)
    }
    func didTipScoreCellDetail(teamInfo: FootballPlayListModel) {
        presentMatchInfoPopVC(teamInfo)
    }
    func didTipTotalCellDetail(teamInfo: FootballPlayListModel) {
        presentMatchInfoPopVC(teamInfo)
    }
    func didTipHunheCellDetail(teamInfo: FootballPlayListModel) {
        presentMatchInfoPopVC(teamInfo)
    }
    func didTipRangSPFCellDetail(teamInfo: FootballPlayListModel) {
        presentMatchInfoPopVC(teamInfo)
    }
    
    func didTipStopSelling(cell: FootballHunheCell, teamInfo: FootballPlayListModel) {
        showCXMAlert(title: "停售原因", message: "\n因出票限制，暂停销售！", action: "我知道了", cancel: nil) { (action) in
            
        }
    }
    
    func didTipStopSelling(cell: FootballSPFCell, teamInfo: FootballPlayListModel) {
        showCXMAlert(title: "停售原因", message: "\n因出票限制，暂停销售！", action: "我知道了", cancel: nil) { (action) in
            
        }
    }
    
    func didTipStopSelling(cell: FootballTotalCell, teamInfo: FootballPlayListModel) {
        showCXMAlert(title: "停售原因", message: "\n因出票限制，暂停销售！", action: "我知道了", cancel: nil) { (action) in
            
        }
    }
    
    func didTipStopSelling(cell: FootballScoreCell, teamInfo: FootballPlayListModel) {
        showCXMAlert(title: "停售原因", message: "\n因出票限制，暂停销售！", action: "我知道了", cancel: nil) { (action) in
            
        }
    }
    
    func didTipStopSelling(cell: FootballBanQuanCCell, teamInfo: FootballPlayListModel) {
        showCXMAlert(title: "停售原因", message: "\n因出票限制，暂停销售！", action: "我知道了", cancel: nil) { (action) in
            
        }
    }
    
    func didTipStopSelling(cell: Football2_1Cell, teamInfo: FootballPlayListModel) {
        showCXMAlert(title: "停售原因", message: "\n因出票限制，暂停销售！", action: "我知道了", cancel: nil) { (action) in
            
        }
    }
    
    func didTipStopSelling(cell: FootballRangSPFCell, teamInfo: FootballPlayListModel) {
        showCXMAlert(title: "停售原因", message: "\n因出票限制，暂停销售！", action: "我知道了", cancel: nil) { (action) in
            
        }
    }
    
    private func presentMatchInfoPopVC(_ teamInfo: FootballPlayListModel) {
        let matchInfo = CXMFootballMatchInfoPopVC()
        matchInfo.matchId = teamInfo.matchId
        matchInfo.delegate = self
        present(matchInfo)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.tableView.reloadData()
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
        self.view.addSubview(menu)
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
        table.separatorStyle = .none
        table.register(FootballSectionHeader.self, forHeaderFooterViewReuseIdentifier: FootballSectionHeaderId)
        registerCell(table)
        table.register(FootballHotSectionHeader.self, forHeaderFooterViewReuseIdentifier: FootballHotSectionHeaderId)
        if #available(iOS 11.0, *) {
            
        }else {
            table.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 49, right: 0)
            table.scrollIndicatorInsets = table.contentInset
        }
        
        return table
    }()
    private func registerCell(_ table: UITableView) {
        table.register(FootballSPFCell.self, forCellReuseIdentifier: FootballSPFCellId)
        table.register(FootballRangSPFCell.self, forCellReuseIdentifier: FootballRangSPFCellId)
        table.register(FootballTotalCell.self, forCellReuseIdentifier: FootballTotalCellId)
        table.register(FootballScoreCell.self, forCellReuseIdentifier: FootballScoreCellId)
        table.register(FootballBanQuanCCell.self, forCellReuseIdentifier: FootballBanQuanCCellId)
        table.register(Football2_1Cell.self, forCellReuseIdentifier: Football2_1CellId)
        table.register(FootballHunheCell.self, forCellReuseIdentifier: FootballHunheCellId)
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
            return initRangSPFCell(indexPath: indexPath)
        case .总进球:
            return initTotalCell(indexPath: indexPath)
        case .比分:
            return initScoreCell(indexPath: indexPath)
        case .半全场:
            return initBanQuanCCell(indexPath: indexPath)
        case .二选一:
            return init2Cell(indexPath: indexPath)
        case .混合过关:
            return initHunheCell(indexPath: indexPath)
        }
    }
    
    private func initSPFCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballSPFCellId, for: indexPath) as! FootballSPFCell
        cell.teamView.delegate = self
        cell.delegate = self
        let matchModel = matchList[indexPath.section]
        
        cell.playInfoModel = matchModel.playList[indexPath.row]
        
        return cell
    }
    private func initRangSPFCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballRangSPFCellId, for: indexPath) as! FootballRangSPFCell
        cell.teamView.delegate = self
        cell.delegate = self
        let matchModel = matchList[indexPath.section]
        cell.playInfoModel = matchModel.playList[indexPath.row]
        return cell
    }
    private func initTotalCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballTotalCellId, for: indexPath) as! FootballTotalCell
        cell.totalView.delegate = self
        cell.delegate = self
        let matchModel = matchList[indexPath.section]
        cell.playInfoModel = matchModel.playList[indexPath.row]
        return cell
    }
    private func initScoreCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballScoreCellId, for: indexPath) as! FootballScoreCell
        cell.scoreView.delegate = self
        cell.delegate = self
        let matchModel = matchList[indexPath.section]
        cell.playInfoModel = matchModel.playList[indexPath.row]
        return cell
    }
    private func initBanQuanCCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballBanQuanCCellId, for: indexPath) as! FootballBanQuanCCell
        cell.scoreView.delegate = self
        cell.delegate = self
        let matchModel = matchList[indexPath.section]
        cell.playInfoModel = matchModel.playList[indexPath.row]
        return cell
    }
    private func init2Cell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Football2_1CellId, for: indexPath) as! Football2_1Cell
        cell.twoOneView.delegate = self
        cell.delegate = self
        let matchModel = matchList[indexPath.section]
        cell.playInfoModel = matchModel.playList[indexPath.row]
        return cell
    }
    private func initHunheCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballHunheCellId, for: indexPath) as! FootballHunheCell
        cell.teamView.delegate = self
        cell.rangTeamView.delegate = self
        cell.delegate = self
        cell.index = indexPath
        let matchModel = matchList[indexPath.section]
        cell.playInfoModel = matchModel.playList[indexPath.row]
        return cell
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        if section == 0, self.matchData.hotPlayList.isEmpty == false {
    
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballHotSectionHeaderId) as! FootballHotSectionHeader
            header.tag = section
            header.delegate = self
            header.matchModel = matchList[section]
            return header
        }else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballSectionHeaderId) as! FootballSectionHeader
            header.tag = section
            header.delegate = self
            header.matchModel = matchList[section]
            return header
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch matchType {
        case .胜平负, .让球胜平负:
            return 84 * defaultScale
        case .总进球:
            return (100 + 15) * defaultScale
        case .比分, .半全场:
            return 84 * defaultScale
        case .二选一:
            return 84 * defaultScale
        case .混合过关:
            return 120 * defaultScale
        default: return 0
            
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38 * defaultScale
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
        rightBut.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        
        //rightBut.setBackgroundImage(UIImage(named:"filter"), for: .normal)
        
        rightBut.setImage(UIImage(named:"filter"), for: .normal)
        rightBut.imageEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        rightBut.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
        
        let helpBut = UIButton(type: .custom)
        helpBut.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        helpBut.setTitle("帮助", for: .normal)
        helpBut.setTitleColor(Color787878, for: .normal)
        helpBut.addTarget(self, action: #selector(helpClicked(_:)), for: .touchUpInside)
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBut)
        let rightItem = UIBarButtonItem(customView: rightBut)
        let helpItem = UIBarButtonItem(customView: helpBut)
        self.navigationItem.rightBarButtonItems = [helpItem, rightItem]
    }
    
    // MARK: - 帮助
    @objc private func helpClicked(_ sender: UIButton) {
        TongJi.log(.帮助, label: self.matchType.rawValue, att: .彩种)
        let homeWeb = CXMWebViewController()
        homeWeb.urlStr = webPlayHelp
        pushViewController(vc: homeWeb)
    }
    @objc private func showMenu(_ sender: UIButton) {
        TongJi.log(.赛事筛选, label: self.matchType.rawValue, att: .彩种)
        let filter = CXMFootballMatchFilterVC()
        filter.delegate = self
        filter.filterList = filterList
        present(filter)
    }
    
    // MARK: - delegate
    func spreadHot(sender: UIButton, section: Int) {
        let header = matchList[section]
        
        header.isSpreading = !header.isSpreading
        
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func spread(sender: UIButton, section: Int) {
        let header = matchList[section]
        
        header.isSpreading = !header.isSpreading
        
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    // MARK: - FOOTBALL Bottom delegate  确认 取消
    func delete() {
        weak var weakSelf = self
        showCXMAlert(title: nil, message: "您正在清空方案列表", action: "清空", cancel: "返回") { (action) in
            //weakSelf?.selectPlayList.removeAll()
            weakSelf?.selectPlays.removeAll()
            weakSelf?.footballRequest(leagueId: "")
            limitNum = 1
        }
    }
    // 确认
    func confirm() {
        
        guard selectPlayList.isEmpty == false else {
            showHUD(message: "您还未选择比赛")
            return }

        guard selectPlayList.count >= 2 else {
            let play = selectPlayList[0]
            if play.matchPlays.count == 1 {
                guard play.matchPlays[0].single == true else {
                    showHUD(message: "您还需要再选择一场比赛")
                    return }
                TongJi.log(.场次确认, label: self.matchType.rawValue, att: .彩种)
                let order = CXMFootballOrderConfirmVC()
                order.delegate = self
                order.matchType = self.matchType
                order.playList = selectPlayList
                order.playclassFyId = self.matchData.lotteryPlayClassifyId
                order.classFyId = self.matchData.lotteryClassifyId
                pushViewController(vc: order)
            }else {
                guard play.matchPlays.count == 5 else { return }

                let can = isAllSingle(playList: selectPlayList)
                
                if can {
                    TongJi.log(.场次确认, label: self.matchType.rawValue, att: .彩种)
                    let order = CXMFootballOrderConfirmVC()
                    order.delegate = self
                    order.playclassFyId = self.matchData.lotteryPlayClassifyId
                    order.classFyId = self.matchData.lotteryClassifyId
                    order.matchType = self.matchType
                    order.playList = selectPlayList
                    pushViewController(vc: order)
                }else {
                    showHUD(message: "您还需要再选择一场比赛")
                }
            }
            
            return
        }
        TongJi.log(.场次确认, label: self.matchType.rawValue, att: .彩种)
        let order = CXMFootballOrderConfirmVC()
        order.delegate = self
        order.matchType = self.matchType
        order.playList = selectPlayList
        order.classFyId = self.matchData.lotteryClassifyId
        order.playclassFyId = self.matchData.lotteryPlayClassifyId
        //order.homeData = homeData
        pushViewController(vc: order)
    }
    // MARK: - 确认订单页， 返回
    func orderConfirmBack(selectPlayList: [FootballPlayListModel]) {
        //self.selectPlayList = selectPlayList
        self.selectPlays = Set(selectPlayList)
        limitNum = self.selectPlays.count + 1
        self.tableView.reloadData()
    }
    // MARK: - 联赛 筛选 代理
    func filterConfirm(leagueId: String) {
        footballRequest(leagueId: leagueId)
    }
    
    // MARK: - 选取比赛 FootballTeamView Delegate ，
    func select(teamInfo: FootballPlayListModel) {
        guard selectPlays != nil else { return }
        //selectPlayList.append(teamInfo)
        selectPlays.insert(teamInfo)
    }
    
    func deSelect(teamInfo: FootballPlayListModel) {
        guard selectPlays != nil else { return }
        //selectPlayList.remove(teamInfo)
        selectPlays.remove(teamInfo)
    }
    func selectedItem() {
        
    }
    // MARK: - 选取比赛 FootballTotalView Delegate
    func totalSelected(view: FootballTotalView, teamInfo: FootballPlayListModel) {
        
        //var canAdd = true
//        for cell in teamInfo.matchPlays[0].matchCells {
//            if cell.isSelected == true {
//                canAdd = false
//                break
//            }
//        }
        //guard canAdd == true else { return }
        guard selectPlayList.count < MaxSelectedNum else {
            
            var change = true
            
            for team in selectPlayList {
                if team == teamInfo {
                    change = false
                    break
                }
            }
            if change {
                view.backSelected()
                showHUD(message: "最多可选15场比赛")
            }

            return }
        selectPlays.insert(teamInfo)
    }
    
    func totalDeSelected(view: FootballTotalView, teamInfo: FootballPlayListModel) {
        var canRemove = true
        for cell in teamInfo.matchPlays[0].matchCells {
            if cell.isSelected == true {
                canRemove = false
                break
            }
        }
        guard canRemove == true  else { return }
       
        guard selectPlays != nil else { return }
        
        selectPlays.remove(teamInfo)
    }
    func totalSelectedItem() {
        
    }
    // MARK: - 比分 点击 delegate
    func didTipScoreView(scoreView: FootballScoreView, teamInfo: FootballPlayListModel) {
        
        switch matchType {
        case .比分:
            pushScoreView(scoreView: scoreView, teamInfo: teamInfo)
        case .半全场:
            pushBanQuanCView(scoreView: scoreView, teamInfo: teamInfo)
        default: break
        }
    }
    
    private func pushScoreView(scoreView: FootballScoreView, teamInfo: FootballPlayListModel) {
        weak var weakSelf = self
        let score = CXMFootballScoreFilterVC()
        score.teamInfo = teamInfo
    
        score.selected = { (selectedCells, canAdd) in
            scoreView.selectedCells = selectedCells
            
            guard (weakSelf?.selectPlayList.count)! < MaxSelectedNum  else {
                
                var change = true
                
                for team in self.selectPlayList {
                    if team == teamInfo {
                        change = false
                        break
                    }
                }
                if change {
                    scoreView.backSelectedState()
                    weakSelf?.showHUD(message: "最多可选15场比赛")
                    
                }
                
//                scoreView.backSelectedState()
//                weakSelf?.showHUD(message: "最多可选15场比赛")
                return }
            
            if selectedCells.isEmpty == false {
                self.selectPlays.insert(teamInfo)
            }else {
                self.selectPlays.remove(teamInfo)
            }
        }
        present(score)
    }
    
    private func pushBanQuanCView(scoreView: FootballScoreView, teamInfo: FootballPlayListModel) {
        weak var weakSelf = self
        let score = CXMFootballBanQuanCFilterVC()
        score.teamInfo = teamInfo
    
        score.selected = { (selectedCells, canAdd) in
            scoreView.selectedCells = selectedCells
            
            guard (weakSelf?.selectPlayList.count)! < MaxSelectedNum  else {
                
                var change = true
                
                for team in (weakSelf?.selectPlayList)! {
                    if team == teamInfo {
                        change = false
                        break
                    }
                }
                if change {
                    scoreView.backSelectedState()
                    weakSelf?.showHUD(message: "最多可选15场比赛")
                }
                return }
            
            if selectedCells.isEmpty == false {
                self.selectPlays.insert(teamInfo)
            }else {
                self.selectPlays.remove(teamInfo)
            }
        }
    
        present(score)
    }
    
    // MARK: - 2选1 点击事件
    func didSelectedTwoOneView(view: FootballTwoOneView, teamInfo: FootballPlayListModel) {

        guard selectPlayList.count < MaxSelectedNum else {
            
            var change = true
            
            for team in selectPlayList {
                if team == teamInfo {
                    change = false
                    break
                }
            }
            if change {
                view.backSelectedState()
                showHUD(message: "最多可选15场比赛")
            }
           
            return }
        selectPlays.insert(teamInfo)
    }
    
    func didDeSelectedTwoOneView(view: FootballTwoOneView, teamInfo: FootballPlayListModel) {
        guard teamInfo.matchPlays[0].homeCell.isSelected == false else { return }
        guard teamInfo.matchPlays[0].visitingCell.isSelected == false else { return }
        guard selectPlays != nil else { return }
        selectPlays.remove(teamInfo)
    }
    func didSelectedTwoOneView() {
        
    }
    
    // MARK: - 混合 按钮 点击   delegate
    func didSelectedHunHeView(view: FootballHunheView, teamInfo: FootballPlayListModel, index: IndexPath) {
        guard self.matchList.isEmpty == false else { return }
        let cell = self.tableView.cellForRow(at: index) as! FootballHunheCell
        let matchModel = matchList[index.section]
        cell.playInfoModel = matchModel.playList[index.row]
        
        //self.tableView.reloadRows(at: [index], with: .none)
        guard selectPlayList.count < MaxSelectedNum else {
            
            var change = true
            
            for team in selectPlayList {
                if team == teamInfo {
                    change = false
                    break
                }
            }
            if change {
                view.backSelectedState()
                showHUD(message: "最多可选15场比赛")
                self.tableView.reloadRows(at: [index], with: .none)
            }
            
            return }
        selectPlays.insert(teamInfo)
        
    }
    func didDeSelectedHunHeView(view: FootballHunheView, teamInfo: FootballPlayListModel, index: IndexPath) {
        //self.tableView.reloadRows(at: [index], with: .none)
        
        let cell = self.tableView.cellForRow(at: index) as! FootballHunheCell
        let matchModel = matchList[index.section]
        cell.playInfoModel = matchModel.playList[index.row]
        
        guard teamInfo.selectedHunhe.count == 0 else { return }
        selectPlays.remove(teamInfo)
    }
    
    // Mark: - 混合 cell 点击更多  delegate
    func didTipMoreButton(view : FootballHunheView, rangView : FootballHunheView, teamInfo: FootballPlayListModel) {

        weak var weakSelf = self
        
        let score = CXMFootballHunheFilterVC()
        score.teamInfo = teamInfo
        
        score.selected = { (selectedCells, canAdd) in
            //view.selectedCellList = selectedCells
            self.tableView.reloadData()
            guard (weakSelf?.selectPlayList.count)! < MaxSelectedNum  else {
                
                var change = true
                
                for team in self.selectPlayList {
                    if team == teamInfo {
                        change = false
                        break
                    }
                }
                if change {
                    view.backSelectedState()
                    weakSelf?.showHUD(message: "最多可选15场比赛")
                }
                
//                view.backSelectedState()
//                weakSelf?.showHUD(message: "最多可选15场比赛")
                //self.tableView.reloadData()
                return }
            
            if selectedCells.isEmpty == false {
                self.selectPlays.insert(teamInfo)
            }else {
                self.selectPlays.remove(teamInfo)
            }
        }
        
        present(score)
    }
    
    override func back(_ sender: UIButton) {
        super.back(sender)
        TongJi.log(.场次返回, label: self.matchType.rawValue, att: .彩种)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension CXMFootballMatchVC : CXMMFootballMatchMenuDelegate{
    private func setNavigationTitleView() {
        titleView = UIButton(type: .custom)
        
        titleView.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        titleView.titleLabel?.font = Font17
        titleView.setTitle(matchType.rawValue, for: .normal)
        titleView.setTitleColor(Color505050, for: .normal)

        titleView.addTarget(self, action: #selector(titleViewClicked(_:)), for: .touchUpInside)

        self.navigationItem.titleView = titleView
        titleIcon = UIImageView(image: UIImage(named: "Down"))
        
        titleView.addSubview(titleIcon)
        
        titleIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(12)
            make.right.equalTo(14)
            make.centerY.equalTo(titleView.snp.centerY)
        }
    }
    
    @objc private func titleViewClicked(_ sender: UIButton) {
        showMatchMenu()
        titleIcon.image = UIImage(named: "Upon")
    }
    
    private func showMatchMenu() {
        menu.configure(with: matchType)
        menu.show()
    }
    func didTipMenu(view: CXMMFootballMatchMenu, type: FootballMatchType) {
        
        titleIcon.image = UIImage(named: "Down")
//        if matchData != nil {
//            matchData = nil
//        }
//        if matchList != nil {
//            matchList.removeAll()
//        }
        matchData = nil
        matchList = nil
        self.tableView.reloadData()
        
        self.matchType = type
        
        if selectPlays != nil {
            selectPlays.removeAll()
        }
        
        footballRequest(leagueId: "")
        filterRequest()
    }
    func didCancel() {
        titleIcon.image = UIImage(named: "Down")
    }
    
}
