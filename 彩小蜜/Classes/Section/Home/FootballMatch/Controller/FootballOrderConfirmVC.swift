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


protocol FootballOrderConfirmVCDelegate {
    func orderConfirmBack(selectPlayList: [FootballPlayListModel]) -> Void
}

class FootballOrderConfirmVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FootballTeamViewDelegate, FootballOrderBottomViewDelegate, FootballTimesFilterVCDelegate, FootballPlayFilterVCDelegate, FootballFilterPro, FootballOrderProtocol, FootballOrderSPFCellDelegate, FootballTotalViewDelegate, FootballScoreViewDelegate, FootballTwoOneViewDelegate, FootballOrderFooterDelegate{
    
    
    
    
    // MARK: - 属性
    public var delegate : FootballOrderConfirmVCDelegate!
    
    public var matchType: FootballMatchType = .胜平负
    //public var homeData: HomePlayModel!
    
    public var playclassFyId : String!
    public var classFyId : String!
    
    public var selectPlayList: [FootballPlayListModel]! {
        didSet{
            guard selectPlayList != nil else { return }
 
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
            guard str != "" else { return }
            str.removeLast()
            self.betType = str
            
            if selectPlayList.count == 1 {
                let play = selectPlayList[0]
                if play.matchPlays.count == 1 {
                    guard play.matchPlays[0].single == true else {
                        showHUD(message: "您还需要再选择一场比赛")
                        self.canPush = false
                        return }
                    
                }else {
                    guard play.matchPlays.count == 5 else { return }
                    
                    let can = isAllSingle(playList: selectPlayList)
                    
                    if can {
    
                    }else {
                        self.canPush = false
                        showHUD(message: "您还需要再选择一场比赛")
                    }
                }
            }
        }
    }
    
    public var selectPlays : Set<FootballPlayListModel>! {
        didSet{
            guard selectPlays != nil else { return }
            self.selectPlayList = Array(selectPlays)
        }
    }
    
    public var playList: [FootballPlayListModel]! {
        didSet{
            guard playList != nil else { return }
            //selectPlays = Set(playList)
            self.tableView.reloadData()
        }
    }
    public var betInfo : FootballBetInfoModel! {
        didSet{
            guard betInfo != nil else { return }
            bottomView.betInfo = betInfo
        }
    }
    
    public var times : String = "5" {
        didSet{
            bottomView.times = times
        }
    } // 倍数  网络请求用
    public var betType : String! // 串关方式 网络请求用
    
    // 是否允许弹出下个界面 - 支付界面
    public var canPush : Bool = false
    public var showMsg : String!
    private var footer: FootballOrderFooter!
    private var isAgreement : Bool = true
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 投注确认"
        initSubview()
        setEmpty(title: "暂无可选赛事", tableView)
        
        selectPlayList = [FootballPlayListModel]()
        selectPlays = Set(playList)
        orderRequest()
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
        table.estimatedRowHeight = 40
        table.separatorStyle = .none
        footer = FootballOrderFooter()
        footer.delegate = self 
        table.tableFooterView = footer
        if #available(iOS 11.0, *) {
            
        }else {
            table.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 49, right: 0)
            table.scrollIndicatorInsets = table.contentInset
        }
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
            return 104 * defaultScale
        case .总进球:
            return 115 * defaultScale
        case .混合过关:
            return UITableViewAutomaticDimension
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
    
    // MARK: - FOOTER  delegate 协议
    func didTipSelectedAgreement(isAgerr: Bool) {
        self.isAgreement = isAgerr
    }
    
    func didTipAgreement() {
        let agreement = WebViewController()
        agreement.urlStr = webBuyAgreement
        pushViewController(vc: agreement)
    }
    // MARK: CELL  删除
    func deleteOrderSPFCell(playInfo: FootballPlayListModel) {
        
        playList.remove(playInfo)
        if selectPlays != nil {
            selectPlays.remove(playInfo)
        }
        
        orderRequest()
        if playList.count < 3 {
            danMaxNum = 0
            self.tableView.reloadData()
        }
        resetSelected(playInfo: playInfo)
        
        playInfo.selectedHunhe.removeAll()
        
        if playList.isEmpty == true {
            self.popViewController()
            guard delegate != nil else { return }
            delegate.orderConfirmBack(selectPlayList: self.selectPlayList)
        }
    }
    
    private func resetSelected(playInfo: FootballPlayListModel) {
        for match in playInfo.matchPlays {
            if match.homeCell != nil {
                match.homeCell.isSelected = false
                if match.homeCell.cellSons != nil {
                    for cell in match.homeCell.cellSons {
                        cell.isSelected = false
                    }
                }
            }
            if match.flatCell != nil {
                match.flatCell.isSelected = false
                if match.flatCell.cellSons != nil {
                    for cell in match.flatCell.cellSons {
                        cell.isSelected = false
                    }
                }
            }
            if match.visitingCell != nil {
                match.visitingCell.isSelected = false
                if match.visitingCell.cellSons != nil {
                    for cell in match.visitingCell.cellSons {
                        cell.isSelected = false
                    }
                }
            }
            
            if match.matchCells != nil {
                for play in match.matchCells {
                    play.isSelected = false
                }
            }
            
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
    
    // MARK: - Bottow Delegate 确认键
    //
    func orderConfirm(filterList: [FootballPlayFilterModel], times: String) {
        guard self.isAgreement == true else {
            showCXMAlert(title: nil, message: "尊敬的用户，购彩需同意并接受《彩小秘投注服务协议》", action: "确定", cancel: nil) { (action) in
                
            }
            return }
        guard self.canPush == true else {
            if self .showMsg != nil {
                 showHUD(message: self.showMsg)
            }
            return }
        let requestModel = getRequestModel(betType: self.betType, times: self.times, bonusId: "")
        
        if getUserData() != nil {
            let payment = PaymentViewController()
            payment.requestModel = requestModel
            pushViewController(vc: payment)
        }else {
            pushLoginVC(from: self)
        }
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
        times.times = self.times
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
        

        self.betType = str
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
        guard selectPlays != nil else { return }
        
        //selectPlayList.append(teamInfo)
        selectPlays.insert(teamInfo)
        self.resetDanState()
    }
    
    func deSelect(teamInfo: FootballPlayListModel) {
        guard selectPlays != nil else { return }
        //selectPlayList.remove(teamInfo)
        selectPlays.remove(teamInfo)
        self.resetDanState()
    }
    func selectedItem() {
       // guard homeData != nil else { return }
        guard self.playclassFyId != nil, self.classFyId != nil else { return }
        
        orderRequest ()
    }
    // MARK: - 选取比赛 FootballTotalView Delegate
    func totalSelected(view: FootballTotalView, teamInfo: FootballPlayListModel) {

//        var canAdd = true
//        for cell in teamInfo.matchPlays[0].matchCells {
//            if cell.isSelected == true {
//                canAdd = false
//                break
//            }
//        }
//        guard canAdd == true else { return }
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
//            view.backSelected()
//            showHUD(message: "最多可选15场比赛")
            return }
        guard selectPlays != nil else { return }
        selectPlays.insert(teamInfo)
        
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
        
        guard selectPlays != nil else { return }
        selectPlays.remove(teamInfo)
        
        self.resetDanState()
    }
    func totalSelectedItem() {
        //guard homeData != nil else { return }
        guard self.classFyId != nil , self.playclassFyId != nil else { return }
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
            weakSelf?.resetDanState()
        }
        
        score.didSelected = {
            //guard weakSelf?.homeData != nil else { return }
            guard weakSelf?.playclassFyId != nil , weakSelf?.classFyId != nil else { return }
                weakSelf?.orderRequest()
        }
        present(score)
    }
    
    private func pushBanQuanCView(scoreView: FootballScoreView, teamInfo: FootballPlayListModel) {
        weak var weakSelf = self
        let score = FootballBanQuanCFilterVC()
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
            weakSelf?.resetDanState()
        }
        
        score.didSelected = {
            //guard weakSelf?.homeData != nil else { return }
            guard weakSelf?.playclassFyId != nil , weakSelf?.classFyId != nil else { return }
            weakSelf?.orderRequest()
        }
        present(score)
    }
    private func pushHunheView(scoreView: FootballScoreView, teamInfo: FootballPlayListModel) {

        weak var weakSelf = self
        
        let score = FootballHunheFilterVC()
        score.teamInfo = teamInfo
        
        score.selected = { (selectedCells, canAdd) in
            scoreView.selectedCells = selectedCells
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
            weakSelf?.resetDanState()
        }
        score.didSelected = {
            //guard weakSelf?.homeData != nil else { return }
            guard weakSelf?.playclassFyId != nil , weakSelf?.classFyId != nil else { return }
            weakSelf?.orderRequest()
        }
        present(score)
    }
    
    // MARK: - 二选一
    func didSelectedTwoOneView(view: FootballTwoOneView, teamInfo: FootballPlayListModel) {
//        guard teamInfo.matchPlays[0].homeCell.isSelected == false else { return }
//        guard teamInfo.matchPlays[0].visitingCell.isSelected == false else { return }
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
            
//            view.backSelectedState()
//            showHUD(message: "最多可选15场比赛")
            return }
        guard selectPlays != nil else { return }
        
        selectPlays.insert(teamInfo)
        self.resetDanState()
    }
    
    func didDeSelectedTwoOneView(view: FootballTwoOneView, teamInfo: FootballPlayListModel) {
        guard teamInfo.matchPlays[0].homeCell.isSelected == false else { return }
        guard teamInfo.matchPlays[0].visitingCell.isSelected == false else { return }
        guard selectPlays != nil else { return }
        selectPlays.remove(teamInfo)
        
        self.resetDanState()
    }
    
    func didSelectedTwoOneView() {
        //guard homeData != nil else { return }
        guard self.playclassFyId != nil , self.classFyId != nil else { return }
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
        guard delegate != nil else { return }
        delegate.orderConfirmBack(selectPlayList: self.selectPlayList)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
