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


class FootballOrderConfirmVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FootballTeamViewDelegate, FootballOrderBottomViewDelegate, FootballTimesFilterVCDelegate, FootballPlayFilterVCDelegate, FootballFilterPro, FootballOrderProtocol, FootballOrderSPFCellDelegate, FootballTotalViewDelegate, FootballScoreViewDelegate, FootballTwoOneViewDelegate{
    
    
   
    
    

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
    
    public var times : String = "5" {
        didSet{
            bottomView.times = times
        }
    } // 倍数  网络请求用
    public var playType : String! // 串关方式 网络请求用
    
    // 是否允许弹出下个界面 - 支付界面
    public var canPush : Bool = false
    public var showMsg : String!
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
        table.estimatedRowHeight = 84 * defaultScale
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
            return initRangSPFCell(indexPath: indexPath)
        case .总进球:
            return initTatolCell(indexPath: indexPath)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrderSPFCellId, for: indexPath) as! FootballOrderSPFCell
        cell.delegate = self 
        cell.teamView.delegate = self 
        cell.playInfoModel = playList[indexPath.section]
        return cell
    }
    private func initRangSPFCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrderRangSPFCellId, for: indexPath) as! FootballOrderRangSPFCell
        cell.delegate = self
        cell.teamView.delegate = self
        cell.playInfoModel = playList[indexPath.section]
        return cell
    }
    private func initTatolCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrderTotalCellId, for: indexPath) as! FootballOrderTotalCell
        cell.delegate = self
        cell.totalView.delegate = self
        cell.playInfoModel = playList[indexPath.section]
        return cell
    }
    private func initScoreCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrderScoreCellId, for: indexPath) as! FootballOrderScoreCell
        cell.delegate = self
        cell.scoreView.delegate = self
        cell.playInfoModel = playList[indexPath.section]
        return cell
    }
    private func initBanQuanCCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrderBanQuanCCellId, for: indexPath) as! FootballOrderBanQuanCCell
        cell.delegate = self
        cell.scoreView.delegate = self
        cell.playInfoModel = playList[indexPath.section]
        return cell
    }
    private func init2Cell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrder2_1CellId, for: indexPath) as! FootballOrder2_1Cell
        cell.delegate = self
        cell.twoOneView.delegate = self
        cell.playInfoModel = playList[indexPath.section]
        return cell
    }
    private func initHunheCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOrderHunheCellId, for: indexPath) as! FootballOrderHunheCell
        cell.delegate = self
        cell.scoreView.delegate = self
        cell.playInfoModel = playList[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        switch matchType {
        case .半全场, .比分:
            return 84 * defaultScale
        case .混合过关:
            return UITableViewAutomaticDimension + (84 * defaultScale)
        default:
            return 91 * defaultScale
        }
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
        
        if playList.count < 3 {
            danMaxNum = 0
            self.tableView.reloadData()
        }
    }
    // MARK: CELL 选择胆
    func danSelected() {
        guard selectPlayList.count > 1 else {
            showHUD(message: "请选择2场以上比赛")
            return }
        danMaxNum -= 1
        self.tableView.reloadData()
        orderRequest()
    }
    func danDeSelected() {
        danMaxNum += 1
        self.tableView.reloadData()
        orderRequest()
    }
    
    // MARK: - Bottow Delegate
    // 确认键
    func orderConfirm(filterList: [FootballPlayFilterModel], times: String) {
        guard self.canPush == true else {
            showHUD(message: self.showMsg)
            return }
        let requestModel = getRequestModel(betType: self.playType, times: self.times, bonusId: "", homeData: self.homeData)
        
        let payment = PaymentViewController()
        payment.requestModel = requestModel
        pushViewController(vc: payment)
        
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
        guard str != "" else { return }
        str.removeLast()
        var maxStr : String!
        if str.lengthOfBytes(using: .utf8) > 3 {
            maxStr = str.components(separatedBy: ",").last!
        }else {
            maxStr = str
        }
        

        self.playType = str
        orderRequest()
        
        for info in playList {
            info.isDan = false
        }
        let numStr = str.first?.description
        let num = Int(numStr!)
        
        // 取最后一个串关方式
        let lastStr = maxStr.first?.description
        let lastNum = Int(lastStr!)
        if lastNum! < selectPlayList.count {
            danMaxNum = num! - 1
        }
        self.tableView.reloadData()
        
    }
    
    func playFilterCancel() {
        
    }
    
    // MARK: ITEM 选择 delegate
    func select(teamInfo: FootballPlayListModel) {
        guard selectPlayList != nil else { return }
        
        selectPlayList.append(teamInfo)
        self.resetDanState()
    }
    
    func deSelect(teamInfo: FootballPlayListModel) {
        guard selectPlayList != nil else { return }
        selectPlayList.remove(teamInfo)
        self.resetDanState()
    }
    func selectedItem() {
        guard homeData != nil else { return }
        orderRequest ()
    }
    // MARK: - 选取比赛 FootballTotalView Delegate
    func totalSelected(view: FootballTotalView, teamInfo: FootballPlayListModel) {

        var canAdd = true
        for cell in teamInfo.matchPlays[0].matchCells {
            if cell.isSelected == true {
                canAdd = false
                break
            }
        }
        guard canAdd == true else { return }
        guard selectPlayList.count < 15 else {
            view.backSelected()
            showHUD(message: "最多可选15场比赛")
            return }
        guard selectPlayList != nil else { return }
        selectPlayList.append(teamInfo)
        
        
        self.resetDanState()
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
        
        guard selectPlayList != nil else { return }
        selectPlayList.remove(teamInfo)
        
        self.resetDanState()
    }
    func totalSelectedItem() {
        guard homeData != nil else { return }
        orderRequest ()
    }
    
    // MARK: - 比分 点击 delegate
    func didTipScoreView(scoreView: FootballScoreView, teamInfo: FootballPlayListModel) {
        
        switch matchType {
        case .比分:
            pushScoreView(scoreView: scoreView, teamInfo: teamInfo)
        case .半全场:
            pushBanQuanCView(scoreView: scoreView, teamInfo: teamInfo)
        case .混合过关:
            pushHunheView(scoreView: scoreView, teamInfo: teamInfo)
        default: break
        }
    }
    
    private func pushScoreView(scoreView: FootballScoreView, teamInfo: FootballPlayListModel) {
        weak var weakSelf = self
        let score = FootballScoreFilterVC()
        score.teamInfo = teamInfo

        score.selected = { (selectedCells, canAdd) in
            scoreView.selectedCells = selectedCells
            guard canAdd == true else { return }
            guard (weakSelf?.selectPlayList.count)! < 15  else {
                scoreView.backSelectedState()
                weakSelf?.showHUD(message: "最多可选15场比赛")
                return }
            
            weakSelf?.selectPlayList.append(teamInfo)
            weakSelf?.resetDanState()
        }
        score.deSelected = { (selectedCells, canRemove) in
            scoreView.selectedCells = selectedCells
            guard canRemove == true else { return }
            weakSelf?.selectPlayList.remove(teamInfo)
            weakSelf?.resetDanState()
        }
        score.didSelected = {
            guard weakSelf?.homeData != nil else { return }
                weakSelf?.orderRequest()
        }
        present(score)
    }
    
    private func pushBanQuanCView(scoreView: FootballScoreView, teamInfo: FootballPlayListModel) {
        weak var weakSelf = self
        let score = FootballBanQuanCFilterVC()
        score.teamInfo = teamInfo
        
        score.selected = { (selectedCells, canAdd) in
            scoreView.selectedCellList = selectedCells
            guard canAdd == true else { return }
            guard (weakSelf?.selectPlayList.count)! < 15  else {
                scoreView.backSelectedState()
                weakSelf?.showHUD(message: "最多可选15场比赛")
                return }
            
            weakSelf?.selectPlayList.append(teamInfo)
            weakSelf?.resetDanState()
        }
        score.deSelected = { (selectedCells, canRemove) in
            scoreView.selectedCellList = selectedCells
            guard canRemove == true else { return }
            weakSelf?.selectPlayList.remove(teamInfo)
            weakSelf?.resetDanState()
        }
        score.didSelected = {
            guard weakSelf?.homeData != nil else { return }
            weakSelf?.orderRequest()
        }
        present(score)
    }
    private func pushHunheView(scoreView: FootballScoreView, teamInfo: FootballPlayListModel) {
        weak var weakSelf = self
        let score = FootballHunheFilterVC()
        score.teamInfo = teamInfo
        
        score.selected = { (selectedCells, canAdd) in
            scoreView.selectedCellList = selectedCells
            guard canAdd == true else { return }
            guard (weakSelf?.selectPlayList.count)! < 15  else {
                scoreView.backSelectedState()
                weakSelf?.showHUD(message: "最多可选15场比赛")
                return }
            
            weakSelf?.selectPlayList.append(teamInfo)
            weakSelf?.resetDanState()
        }
        score.deSelected = { (selectedCells, canRemove) in
            scoreView.selectedCellList = selectedCells
            guard canRemove == true else { return }
            weakSelf?.selectPlayList.remove(teamInfo)
            weakSelf?.resetDanState()
        }
        score.didSelected = {
            guard weakSelf?.homeData != nil else { return }
            weakSelf?.orderRequest()
        }
        present(score)
    }
    
    
    func didSelectedTwoOneView(view: FootballTwoOneView, teamInfo: FootballPlayListModel) {
        guard teamInfo.matchPlays[0].homeCell.isSelected == false else { return }
        guard teamInfo.matchPlays[0].visitingCell.isSelected == false else { return }
        guard selectPlayList.count < 15 else {
            view.backSelectedState()
            showHUD(message: "最多可选15场比赛")
            return }
        guard selectPlayList != nil else { return }
        selectPlayList.append(teamInfo)
        
        self.resetDanState()
    }
    
    func didDeSelectedTwoOneView(view: FootballTwoOneView, teamInfo: FootballPlayListModel) {
        guard teamInfo.matchPlays[0].homeCell.isSelected == false else { return }
        guard teamInfo.matchPlays[0].visitingCell.isSelected == false else { return }
        guard selectPlayList != nil else { return }
        selectPlayList.remove(teamInfo)
        
        self.resetDanState()
    }
    
    func didSelectedTwoOneView() {
        guard homeData != nil else { return }
        orderRequest ()
    }
    
    private func resetDanState() {
        danMaxNum = 0
        
        for play in playList {
            play.isDan = false
        }
        
        self.tableView.reloadData()
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
    
    override func back(_ sender: UIButton) {
        danMaxNum = 0
        
        guard playList != nil else {
            popViewController()
            return }
        for play in playList{
            play.isDan = false
        }
        popViewController()
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
