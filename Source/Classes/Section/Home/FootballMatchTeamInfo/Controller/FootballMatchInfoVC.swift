//
//  FootballMatchInfoVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let FootballAnalysisSectionHeaderId = "FootballAnalysisSectionHeaderId"
fileprivate let FootballMatchInfoCellId = "FootballMatchInfoCellId"
fileprivate let FootballMatchInfoScaleCellId = "FootballMatchInfoScaleCellId"
fileprivate let FootballMatchIntegralCellId = "FootballMatchIntegralCellId"
fileprivate let FootballOddsTitleCellId = "FootballOddsTitleCellId"
fileprivate let FootballOddsCellId = "FootballOddsCellId"

enum TeamInfoStyle {
    case matchDetail //赛况
    case analysis  //分析
    case odds      //赔率
    case lineup    //阵容
}

class FootballMatchInfoVC: BaseViewController, UITableViewDelegate, LotteryProtocol {
    
    public var matchId : String!
    
    // MARK: - 属性 private
    private var teamInfoStyle : TeamInfoStyle = .analysis {
        didSet{
            self.tableView.reloadData()
        }
    }
    private var oddsStyle : OddsPagerStyle! = .欧赔 {
        didSet{
            self.tableView.reloadData()
        }
    }
    var matchInfoModel: FootballMatchInfoModel! {
        didSet{
            guard matchInfoModel != nil else { return }
            headerView.matchInfo = self.matchInfoModel.matchInfo
        }
    }
     //阵营信息
    private var lineupInfoModel : FootballLineupInfoModel!{
        didSet{
            
        }
    }
    //赛况信息
    private var liveInfoModel: FootballLiveInfoModel! {
        didSet{
            guard liveInfoModel != nil else { return }
            headerView.liveInfoModel = liveInfoModel
        }
    }
    
    private func shouldStartTimer() {
        if !CXMGCDTimer.shared.isExistTimer(WithTimerName: "cxmLiveInfoTimer") {
            startTimer()
        }
    }
    
    private func startTimer() {
        CXMGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "cxmLiveInfoTimer",
                                                  timeInterval: 60,
                                                  queue: .main,
                                                  repeats: true) {
            print("计时器")
            
            self.liveInfoRequest()
        }
    }
    
    private var homeLineupList : [[FootballLineupMemberInfo]]! //主队阵容
    private var visiLineupList : [[FootballLineupMemberInfo]]! //客队阵容
    
    private var headerView : FootballMatchInfoHeader!
    private var buyButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 查看详情"
        setEmpty(title: "暂无信息", self.tableView)
        initSubview()
        
        matchInfoRequest(matchId: matchId)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TongJi.start("赛事分析页/赔率页")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TongJi.end("赛事分析页/赔率页")
    }
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -10
    }
    // MARK: - 去投注
    @objc private func buyButtonClicked(_ sender: UIButton) {
        popToRootViewController()
        self.tabBarController?.selectedIndex = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            //make.bottom.equalTo(buyButton.snp.top)
            make.bottom.equalTo(-SafeAreaBottomHeight)
        }
        // 暂时隐藏
//        buyButton.snp.makeConstraints { (make) in
//            make.bottom.equalTo(-SafeAreaBottomHeight)
//            make.height.equalTo(36 * defaultScale)
//            make.left.right.equalTo(0)
//        }
    }
    // MARK: - 网络请求
    func matchInfoRequest(matchId: String) {
        self.showProgressHUD()
        weak var weakSelf = self
        
        _ = homeProvider.rx.request(.matchTeamInfo(matchId: matchId))
            .asObservable()
            .mapObject(type: FootballMatchInfoModel.self)
            .subscribe(onNext: { (data) in
                //self.dismissProgressHud()
                weakSelf?.matchInfoModel = data
                
                //weakSelf?.tableView.reloadData()
                
                weakSelf?.lineupInfoRequest(matchId: matchId)
                weakSelf?.liveInfoRequest()
            }, onError: { (error) in
                self.dismissProgressHud()
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
            }, onCompleted: nil , onDisposed: nil )
    }
    // 阵容
    private func lineupInfoRequest(matchId: String) {
        
        weak var weakSelf = self
        
        _ = lotteryProvider.rx.request(.lineupInfo(matchId: matchId)).asObservable()
            .mapObject(type: FootballLineupInfoModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.dismissProgressHud()
                weakSelf?.lineupInfoModel = data
                weakSelf?.homeLineupList = weakSelf?.lineupInfoModel.getHomeLineup()
                weakSelf?.visiLineupList = weakSelf?.lineupInfoModel.getVisiLineup()
                
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                self.dismissProgressHud()
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
    
    // 赛况
    private func liveInfoRequest() {
        guard self.matchId != nil else { fatalError("matchId 为空")}
        weak var weakSelf = self
        
        _ = lotteryProvider.rx.request(.liveInfo(matchId: matchId)).asObservable()
            .mapObject(type: FootballLiveInfoModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.liveInfoModel = data
                if weakSelf?.teamInfoStyle == .matchDetail {
                    weakSelf?.tableView.reloadData()
                }
            }, onError: { (error) in
                self.dismissProgressHud()
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
            }, onCompleted: nil , onDisposed: nil )
        
    }
    
    private func initSubview() {
        buyButton = UIButton(type: .custom)
        buyButton.setTitle("去投注", for: .normal)
        buyButton.setTitleColor(ColorFFFFFF, for: .normal)
        buyButton.backgroundColor = ColorEA5504
        buyButton.addTarget(self, action: #selector(buyButtonClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(tableView)
        //self.view.addSubview(buyButton)
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.separatorStyle = .none
        table.register(FootballMatchInfoCell.self, forCellReuseIdentifier: FootballMatchInfoCellId)
        table.register(FootballMatchInfoScaleCell.self, forCellReuseIdentifier: FootballMatchInfoScaleCellId)
        table.register(FootballMatchIntegralCell.self, forCellReuseIdentifier: FootballMatchIntegralCellId)
        table.register(FootballOddsTitleCell.self, forCellReuseIdentifier: FootballOddsTitleCellId)
        table.register(FootballOddsCell.self, forCellReuseIdentifier: FootballOddsCellId)
        table.register(FootballAnalysisSectionHeader.self, forHeaderFooterViewReuseIdentifier: FootballAnalysisSectionHeaderId)
        table.register(FootballDetailSectionHeader.self, forHeaderFooterViewReuseIdentifier: FootballDetailSectionHeader.identifier)
        table.register(FootballDetailEventCell.self, forCellReuseIdentifier: FootballDetailEventCell.identifier)
        table.register(FootballDetailEventExplainCell.self, forCellReuseIdentifier: FootballDetailEventExplainCell.identifier)
        table.register(FootballDetailTeamInfoCell.self, forCellReuseIdentifier: FootballDetailTeamInfoCell.identifier)
        table.register(FootballDetailStatisticsCell.self, forCellReuseIdentifier: FootballDetailStatisticsCell.identifier)
        
        table.register(FootballMatchInfoFutureHeader.self, forHeaderFooterViewReuseIdentifier: FootballMatchInfoFutureHeader.identifier)
        table.register(FootballMatchInfoFutureCell.self, forCellReuseIdentifier: FootballMatchInfoFutureCell.identifier)
        
        table.register(FootballLineupHeader.self, forHeaderFooterViewReuseIdentifier: FootballLineupHeader.identifier)
        table.register(FootballLineupMemberCell.self, forCellReuseIdentifier: FootballLineupMemberCell.identifier)
        table.register(FootballLineupCell.self, forCellReuseIdentifier: FootballLineupCell.identifier)
        
        headerView = FootballMatchInfoHeader()
        headerView.pagerView.delegate = self
        
        table.tableHeaderView = headerView
        return table
    }()
    
    
}

// MARK: -  pagerView delegate
extension FootballMatchInfoVC : FootballMatchPagerViewDelegate {
    func didSelected(_ teamInfoStyle: TeamInfoStyle) {
        CXMGCDTimer.shared.cancleTimer(WithTimerName: "cxmLiveInfoTimer")
        self.teamInfoStyle = teamInfoStyle
        if teamInfoStyle == .matchDetail {
            shouldStartTimer()
        }
    }
}

extension FootballMatchInfoVC : FootballOddsPagerViewDelegate {
    // MARK: - 赔率 pagerView delegate
    func didSelected(_ oddsStyle: OddsPagerStyle) {
        self.oddsStyle = oddsStyle
    }
}

extension FootballMatchInfoVC : UITableViewDataSource {
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        switch teamInfoStyle {
        case .odds:
            return 1
        case .analysis:
            return 7
        case .matchDetail:
            guard self.liveInfoModel != nil else { return 0 }
            guard self.liveInfoModel.eventList.count != 0 ||
                self.liveInfoModel.matchLiveStatisticsDTO.count != 0
                else { return 0 }
            return 2
        case .lineup :
            guard self.lineupInfoModel != nil else { return 0 }
            guard self.lineupInfoModel.alineupPersons.count != 0 ||
                self.lineupInfoModel.hlineupPersons.count != 0
                else { return 0 }
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.matchInfoModel != nil else { return 0 }
        
        switch teamInfoStyle {
        case .odds:
            switch oddsStyle {
            case .欧赔:
                guard self.matchInfoModel.leagueMatchEuropes.isEmpty == false else { return 1 }
                return self.matchInfoModel.leagueMatchEuropes.count + 1
            case .亚盘:
                guard self.matchInfoModel.leagueMatchAsias.isEmpty == false else { return 1 }
                return self.matchInfoModel.leagueMatchAsias.count + 1
            case .大小球:
                guard self.matchInfoModel.leagueMatchDaoxiaos.isEmpty == false else { return 1 }
                return self.matchInfoModel.leagueMatchDaoxiaos.count + 1
            default : return 1
            }
        case .analysis:
            switch section {
            case 0:
                return 1
            case 1:
                guard self.matchInfoModel.hvMatchTeamInfo.matchInfos != nil else { return 0 }
                return self.matchInfoModel.hvMatchTeamInfo.matchInfos.count
            case 2:
                guard self.matchInfoModel.hMatchTeamInfo.matchInfos != nil else { return 0 }
                return self.matchInfoModel.hMatchTeamInfo.matchInfos.count
            case 3:
                guard self.matchInfoModel.vMatchTeamInfo.matchInfos != nil else { return 0 }
                return self.matchInfoModel.vMatchTeamInfo.matchInfos.count
            case 4:
                return 1 // 暂时隐藏 积分排名，如需打开  return 1
            case 5:
                return self.matchInfoModel.hFutureMatchInfos.count
            case 6:
                return self.matchInfoModel.vFutureMatchInfos.count
            default:
                return 0
            }
        case .matchDetail:
            guard self.liveInfoModel != nil else { return 0 }
            if section == 0 {
                return self.liveInfoModel.eventList.count + 2
            }else {
                return self.liveInfoModel.matchLiveStatisticsDTO.count + 2
            }
        case .lineup:
            switch section {
            case 0:
                return 1
            case 1:
                guard self.lineupInfoModel != nil else { return 0 }
                return self.lineupInfoModel.hbenchPersons.count > lineupInfoModel.abenchPersons.count ? lineupInfoModel.hbenchPersons.count : lineupInfoModel.abenchPersons.count
            case 2:
                guard self.lineupInfoModel != nil else { return 0 }
                return self.lineupInfoModel.hinjureiesPersons.count > lineupInfoModel.ainjureiesPersons.count ? lineupInfoModel.hinjureiesPersons.count : lineupInfoModel.ainjureiesPersons.count
            default : return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch teamInfoStyle {
        case .odds:
            switch indexPath.row {
            case 0:
                return initOddsTitleCell(indexPath: indexPath)
            default:
                return initOddsCell(indexPath: indexPath)
            }
        case .analysis:
            switch indexPath.section {
            case 0:
                return initAnalysisScaleCell(indexPath: indexPath)
            case 1, 2, 3:
                return initAnalysisMatchInfoCell(indexPath: indexPath)
            case 4:
                return initAnalysisIntegralCell(indexPath: indexPath)
            case 5,6:
                return initAnalysisFutureCell(indexPath: indexPath)
            default:
                return UITableViewCell()
            }
        case .matchDetail:
          
            if indexPath.section == 0 {
        
                if indexPath.row == self.liveInfoModel.eventList.count + 1 {
                    return initMatchDetailEventExplain(indexPath: indexPath)
                }else {
                    return initMatchDetailEventCell(indexPath: indexPath)
                }
                
            }else {
                if indexPath.row == 0 {
                    return initMatchDetailTeamInfo(indexPath: indexPath)
                }else if indexPath.row == self.liveInfoModel.matchLiveStatisticsDTO.count + 1 {
                    let cell = UITableViewCell()
                    cell.selectionStyle = .none
                    return cell
                }
                else {
                    return initMatchDetailStatisticsCell(indexPath: indexPath)
                }
            }
            
        case .lineup:
            if indexPath.section == 0 {
                return initLineupCell(indexPath: indexPath)
            }
            return initLineupMemberCell(indexPath: indexPath)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard self.matchInfoModel != nil else { return UIView() }
        
        switch teamInfoStyle {
        case .odds:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballAnalysisSectionHeaderId) as! FootballAnalysisSectionHeader
            
            switch section {
                //            case 0:
                //                header.headerStyle = .标题
            //                header.teamInfo = self.matchInfoModel.hvMatchTeamInfo
            case 1:
                header.headerStyle = .赛事
                
            case 2:
                header.headerStyle = .主队
                header.teamInfo = self.matchInfoModel.hMatchTeamInfo
            case 3:
                header.headerStyle = .客队
                header.teamInfo = self.matchInfoModel.vMatchTeamInfo
            case 4:
                return UIView()
            default:
                return UIView()
                
            }
            
            return header
        case .analysis:
            if section == 5 {
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballMatchInfoFutureHeader.identifier) as! FootballMatchInfoFutureHeader
                header.teamName.text = self.matchInfoModel.matchInfo.homeTeamAbbr
                return header
            }else if section == 6 {
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballMatchInfoFutureHeader.identifier) as! FootballMatchInfoFutureHeader
                header.teamName.text = self.matchInfoModel.matchInfo.visitingTeamAbbr
                return header
            }
            
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballAnalysisSectionHeaderId) as! FootballAnalysisSectionHeader
            
            switch section {
            case 0:
                header.headerStyle = .标题
                header.teamInfo = self.matchInfoModel.hvMatchTeamInfo
            case 1:
                header.headerStyle = .赛事
                
            case 2:
                header.headerStyle = .主队
                header.teamInfo = self.matchInfoModel.hMatchTeamInfo
            case 3:
                header.headerStyle = .客队
                header.teamInfo = self.matchInfoModel.vMatchTeamInfo
            case 4:
                return UIView()
            
            default:
                break
                
            }
            return header
            
        case .matchDetail:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballDetailSectionHeader.identifier) as! FootballDetailSectionHeader
            
            if section == 0{
                header.titleLabel.text = "事件"
            }else {
                header.titleLabel.text = "技术统计"
            }
            return header
            
        case .lineup:
            if section == 0{
                return nil
            }
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballLineupHeader.identifier) as! FootballLineupHeader
            
            if section == 1{
                header.titleLabel.text = "替补阵容"
                
            }else {
                header.titleLabel.text = "伤停"
            }
            
            header.homeLabel.text = self.lineupInfoModel.homeTeamAbbr
            header.visiLabel.text = self.lineupInfoModel.visitingTeamAbbr
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch teamInfoStyle {
        case .odds:
            switch indexPath.row {
            case 0:
                return 72 * defaultScale
            default:
                return 50 * defaultScale
            }
        case .analysis:
            switch indexPath.section {
            case 0:
                return 96 * defaultScale
            case 1, 2, 3:
                return 42 * defaultScale
            case 4:
                return 375 * defaultScale
            case 5,6:
                return 42 * defaultScale
            default:
                return 0
            }
        case .matchDetail:
            if indexPath.section == 0 {
                if indexPath.row == self.liveInfoModel.eventList.count + 1 {
                    return 100
                }
                return 50 * defaultScale
            }else {
                if indexPath.row == 0 {
                    return 90 * defaultScale
                }
                return 30 * defaultScale
            }
            
        case .lineup:
            if indexPath.section == 0 {
                return 660 * defaultScale
            }
            return 36 * defaultScale
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch teamInfoStyle {
        case .odds:
            return 0
        case .analysis:
            switch section {
            case 0:
                return 44 * defaultScale
            case 1:
                return 44 * defaultScale
            case 2, 3:
                return 80 * defaultScale
            case 4:
                return 0.01
            case 5,6:
                return 88 * defaultScale
            default:
                return 0
            }
        case .matchDetail:
            return 44 * defaultScale
        case .lineup:
            if section == 0 {
                return 0.01
            }
            return 88 * defaultScale
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    /// 赛况 - 事件信息
    private func initMatchDetailEventCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballDetailEventCell.identifier, for: indexPath) as! FootballDetailEventCell
        
        //cell.score = "2:0"
        if indexPath.row == 0 {
            cell.hiddenStart = false
            cell.hiddenTop = true
            cell.eventInfo = FootballLiveEventInfo()
        }else {
            cell.hiddenTop = false
            cell.hiddenStart = true
            cell.eventInfo = self.liveInfoModel.eventList[indexPath.row - 1]
        }
        if indexPath.row == liveInfoModel.eventList.count {
            cell.hiddenBot = true
        }else {
            cell.hiddenBot = false
        }
        
        return cell
    }
    /// 赛况 - 技术统计 - 球队信息
    private func initMatchDetailTeamInfo(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballDetailTeamInfoCell.identifier, for: indexPath) as! FootballDetailTeamInfoCell
        cell.matchInfo = self.matchInfoModel.matchInfo
        return cell
    }
    /// 赛况 - 说明
    private func initMatchDetailEventExplain(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballDetailEventExplainCell.identifier, for: indexPath) as! FootballDetailEventExplainCell
        return cell
    }
    /// 赛况 - 技术统计
    private func initMatchDetailStatisticsCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballDetailStatisticsCell.identifier, for: indexPath) as! FootballDetailStatisticsCell
        if indexPath.row != 0 {
            cell.changeData(data: self.liveInfoModel.matchLiveStatisticsDTO[indexPath.row - 1], indexPath: indexPath)
        }
    
        return cell
    }
    /// 阵容 - 阵容图
    private func initLineupCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballLineupCell.identifier, for: indexPath) as! FootballLineupCell
        cell.homeLineup = self.homeLineupList
        cell.visiLineup = self.visiLineupList
        cell.lineupInfo = self.lineupInfoModel
        return cell
    }
    /// 阵容 - 替补/伤停
    private func initLineupMemberCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballLineupMemberCell.identifier, for: indexPath) as! FootballLineupMemberCell
        switch indexPath.section {
        case 1:
            if indexPath.row < self.lineupInfoModel.hbenchPersons.count {
                cell.homeMemberInfo = self.lineupInfoModel.hbenchPersons[indexPath.row]
            }else {
                cell.homeMemberInfo = FootballLineupMemberInfo()
            }
            if indexPath.row < self.lineupInfoModel.abenchPersons.count {
                cell.visiMemberInfo = self.lineupInfoModel.abenchPersons[indexPath.row]
            }else {
                cell.visiMemberInfo = FootballLineupMemberInfo()
            }
        case 2:
            if indexPath.row < self.lineupInfoModel.hinjureiesPersons.count {
                cell.homeMemberInfo = self.lineupInfoModel.hinjureiesPersons[indexPath.row]
            }else {
                cell.homeMemberInfo = FootballLineupMemberInfo()
            }
            if indexPath.row < self.lineupInfoModel.ainjureiesPersons.count {
                cell.visiMemberInfo = self.lineupInfoModel.ainjureiesPersons[indexPath.row]
            }else {
                cell.visiMemberInfo = FootballLineupMemberInfo()
            }
        default: break }
    
        return cell
    }
    /// 分析 统计 历史交锋 Cell
    private func initAnalysisScaleCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballMatchInfoScaleCellId, for: indexPath) as! FootballMatchInfoScaleCell
        cell.teamInfo = self.matchInfoModel.hvMatchTeamInfo
        return cell
    }
    /// 分析  Cell
    private func initAnalysisMatchInfoCell(indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballMatchInfoCellId, for: indexPath) as! FootballMatchInfoCell
        cell.homeMatch = self.matchInfoModel.matchInfo.homeTeamAbbr
        cell.visiMatch = self.matchInfoModel.matchInfo.visitingTeamAbbr
        switch indexPath.section {
        case 1:
            var teamInfo = self.matchInfoModel.hvMatchTeamInfo.matchInfos[indexPath.row]
            teamInfo.teamType = "1"
            cell.teamInfo = teamInfo
        case 2:
            var teamInfo = self.matchInfoModel.hMatchTeamInfo.matchInfos[indexPath.row]
            teamInfo.teamType = "2"
            cell.teamInfo = teamInfo
        case 3:
            var teamInfo = self.matchInfoModel.vMatchTeamInfo.matchInfos[indexPath.row]
            teamInfo.teamType = "3"
            cell.teamInfo = teamInfo
        default:
            break
        }
        return cell
    }
    /// 分析 积分 Cell
    private func initAnalysisIntegralCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballMatchIntegralCellId, for: indexPath) as! FootballMatchIntegralCell
        cell.homeScoreInfo = self.matchInfoModel.homeTeamScoreInfo
        cell.visiScoreInfo = self.matchInfoModel.visitingTeamScoreInfo
        return cell
    }
    /// 分析 - 未来赛事
    private func initAnalysisFutureCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballMatchInfoFutureCell.identifier, for: indexPath) as! FootballMatchInfoFutureCell
        
        if indexPath.section == 5 {
            cell.setFutureInfo(with: self.matchInfoModel.hFutureMatchInfos[indexPath.row],
                               highlightTeam: self.matchInfoModel.matchInfo.homeTeamAbbr)
        }else {
           cell.setFutureInfo(with: self.matchInfoModel.vFutureMatchInfos[indexPath.row],
                              highlightTeam: self.matchInfoModel.matchInfo.visitingTeamAbbr)
        }
    
        return cell
    }
    /// 赔率 title Cell
    private func initOddsTitleCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOddsTitleCellId, for: indexPath) as! FootballOddsTitleCell
        cell.pagerView.delegate = self
        switch oddsStyle {
        case .欧赔:
            cell.titleView.homelb.text = "胜"
            cell.titleView.flatlb.text = "平"
            cell.titleView.visilb.text = "负"
        case .亚盘:
            cell.titleView.homelb.text = "主水"
            cell.titleView.flatlb.text = "盘口"
            cell.titleView.visilb.text = "客水"
        case .大小球:
            cell.titleView.homelb.text = "大球"
            cell.titleView.flatlb.text = "盘口"
            cell.titleView.visilb.text = "小球"
        default : break
            
        }
        return cell
    }
    /// 赔率  Cell
    private func initOddsCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOddsCellId, for: indexPath) as! FootballOddsCell
        switch oddsStyle {
        case .欧赔:
            cell.europeInfo = self.matchInfoModel.leagueMatchEuropes[indexPath.row - 1]
        case .亚盘:
            cell.asiaInfo = self.matchInfoModel.leagueMatchAsias[indexPath.row - 1]
        case .大小球:
            cell.daxiaoInfo = self.matchInfoModel.leagueMatchDaoxiaos[indexPath.row - 1]
        default : break
        }
        return cell
    }
}

