//
//  CXMMLeagueMatchDetailVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum LeagueDetailStyle  {
    case 积分榜
    case 赛程安排
    case 射手榜
    case 球队资料
    
    
}

enum LeagueScoreStyle {
    case 总积分
    case 主场积分
    case 客场积分
}
enum LeagueCourseStyle{
    case showTab
    case showData
}

enum LeagueDetailTitleStyle {
    case show
    case hide
}

class CXMMLeagueMatchDetailVC: BaseViewController {
    
    public var leagueInfo : LeagueInfoModel! {
        didSet{
            guard leagueInfo != nil else { return }
            
            self.navigationItem.title = leagueInfo.leagueAddr
        }
    }
    
    private var style : LeagueDetailStyle = .积分榜 {
        didSet{
            setEmptyView()
        }
    }
    private var scoreStyle : LeagueScoreStyle = .总积分
    private var courseStyle : LeagueCourseStyle = .showData
    
    private var titleStyle : LeagueDetailTitleStyle = .hide
    
    @IBOutlet weak var tableView: UITableView!
    
    private var leagueDetailModel : LeagueDetailModel!
    
    private var groupSelectIndex : Int = 0
    
    private var courseViewModel : CourseTabCellViewModel!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEmpty(title: "暂无数据", tableView)
        initSubview()
        self.footerLabel.text = ""
        tableView.headerRefresh {
            self.loadNewData()
        }
        tableView.beginRefreshing()
    }

    private func setData() {
        courseViewModel = CourseTabCellViewModel()
        courseViewModel.setData(data: leagueDetailModel.matchGroupData.matchTurnGroupList)
        
         _ = courseViewModel.reloadData.asObserver()
            .subscribe { (event) in
                guard let index = event.element else { return }
                
                self.groupSelectIndex = index
                
                self.courseStyle = .showData
                
                self.tableView.reloadData()
        }
        
        setEmptyView()
        
    }
    
    private func initSubview() {
        if #available(iOS 11.0, *) {
            
        }else {
            tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 49, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        self.tableView.estimatedRowHeight = 100
        tableView.backgroundColor = ColorFFFFFF
        tableView.separatorStyle = .none
        tableView.register(LeagueDetailPagerHeader.self,
                           forHeaderFooterViewReuseIdentifier: LeagueDetailPagerHeader.identifier)
        tableView.register(LeagueDetailScorePagerHeader.self,
                           forHeaderFooterViewReuseIdentifier: LeagueDetailScorePagerHeader.identifier)
        tableView.register(LeagueDetailScoreHeader.self,
                           forHeaderFooterViewReuseIdentifier: LeagueDetailScoreHeader.identifier)
        tableView.register(LeagueDetailCourseHeader.self,
                           forHeaderFooterViewReuseIdentifier: LeagueDetailCourseHeader.identifier)
        
    }

    private func setEmptyView() {
        switch style {
        case .积分榜:
            if leagueDetailModel.leagueScore.matchScoreDTOList.isEmpty {
                footerLabel.text = "暂无数据"
            }else {
                footerLabel.text = ""
            }
        case .射手榜:
            if leagueDetailModel.leagueShooter.leagueShooterInfoList.isEmpty {
                footerLabel.text = "暂无数据"
            }else {
                footerLabel.text = ""
            }
        case .赛程安排:
            if leagueDetailModel.matchGroupData.matchTurnGroupList.isEmpty {
                footerLabel.text = "暂无数据"
            }else {
                footerLabel.text = ""
            }
        case .球队资料:
            if leagueDetailModel.leagueTeam.leagueTeamInfoDTOList.isEmpty {
                footerLabel.text = "暂无数据"
            }else {
                footerLabel.text = ""
            }
        }
    }
}
// MARK: - 网络请求
extension CXMMLeagueMatchDetailVC {
    private func loadNewData() {
        leagueDetailRequest()
    }
    private func leagueDetailRequest() {
        
        weak var weakSelf = self
        
        _ = surpriseProvider.rx.request(.leagueDetail(leagueId: leagueInfo.leagueId, seasonId: leagueInfo.seasonId))
            .asObservable()
            .mapObject(type: LeagueDetailModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.leagueDetailModel = data
                weakSelf?.setData()
                weakSelf?.tableView.reloadData()
                
            }, onError: { (error) in
                weakSelf?.tableView.endrefresh()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    if 300000...310000 ~= code {
                        weakSelf?.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
}
// MARK: - 详情 - 收起，
extension CXMMLeagueMatchDetailVC : LeagueMatchDetailCellDelete {
    func didTipShowDetailButton(isSeletced: Bool) {
        switch isSeletced {
        case true:
            self.titleStyle = .show
        case false :
            self.titleStyle = .hide
        }
    
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
//        UIView.performWithoutAnimation {
//            self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
//        }
    }
}

// MARK: - 球队信息 - 点击
extension CXMMLeagueMatchDetailVC : LeagueDetailTeamCellDelegate {
    func didSelectTeamItem(teamInfo: LeagueTeamInfo, index: IndexPath) {
        let story = UIStoryboard(name: "Surprise", bundle: nil )
        
        let teamDetail = story.instantiateViewController(withIdentifier: "TeamDetailVC") as! CXMMTeamDetailVC
        teamDetail.teamId = teamInfo.teamId
        pushViewController(vc: teamDetail)
    }
}
// MARK: - 赛程安排 选项卡
extension CXMMLeagueMatchDetailVC : LeagueDetailCourseHeaderDelegate {
    // 左移
    func didTipLeftButton(leftSender : UIButton, rightSender: UIButton) {
        guard courseViewModel != nil else { return }
        leftSender.isHidden = courseViewModel.leftShift()
        rightSender.isHidden = false
    }
    // 右移
    func didTipRightButton(leftSender : UIButton, rightSender: UIButton) {
        guard courseViewModel != nil else { return }
        rightSender.isHidden = courseViewModel.rightShift()
        leftSender.isHidden = false
    }
    
    func didTipCenterButton(sender : UIButton) {
        
        if courseStyle == .showData {
            self.courseStyle = .showTab
        }else {
            self.courseStyle = .showData
        }
        
        self.tableView.reloadData()
    }
    
}
// MARK: - 积分，选项卡
extension CXMMLeagueMatchDetailVC : LeagueDetailScorePagerHeaderDelegate {
    func didSelectScorePagerItem(style: LeagueScoreStyle) {
        self.scoreStyle = style
        UIView.performWithoutAnimation {
            self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
        }
        
    }
}
// MARK: - 联赛选项卡
extension CXMMLeagueMatchDetailVC : LeagueDetailPagerHeaderDelegate {
    func didSelectHeaderPagerItem(style: LeagueDetailStyle) {
        self.style = style
        //self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        self.tableView.reloadData()
    }
}

extension CXMMLeagueMatchDetailVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMLeagueMatchDetailVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard leagueDetailModel != nil else { return 0 }
        
        switch style {
        case .积分榜:
            guard let model = leagueDetailModel.leagueScore else { return 0 }
            
            switch model.matchType {
            case "0": // 杯赛
                return model.matchScoreDTOList.count + 2
            case "1":  // 联赛
                return 3
            default : return 0
            }
        case .赛程安排:
            
            switch courseStyle {
            case .showTab:
                return 3
            case .showData:
                guard leagueDetailModel.matchGroupData.matchTurnGroupList.isEmpty == false else { return 3 }
                
                return leagueDetailModel.matchGroupData.matchTurnGroupList[groupSelectIndex].groupDTOList.count + 3
            }
        default:
            return 2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard leagueDetailModel != nil else { return 0 }
        
        switch section {
        case 0:
            return 1
        default:
            switch style {
            case .积分榜:
                if section == 1 { return 0 }
            
                switch scoreStyle {
                case .总积分:
                    guard leagueDetailModel.leagueScore.matchScoreDTOList.count > 0 else { return  0 }
                    return leagueDetailModel.leagueScore.matchScoreDTOList[0].leagueCcoreList.count + 1
                case .主场积分:
                    guard leagueDetailModel.leagueScore.matchScoreDTOList.count > 1 else { return  0 }
                    return leagueDetailModel.leagueScore.matchScoreDTOList[1].leagueCcoreList.count + 1
                case .客场积分:
                    guard leagueDetailModel.leagueScore.matchScoreDTOList.count > 2 else { return  0 }
                    return leagueDetailModel.leagueScore.matchScoreDTOList[2].leagueCcoreList.count + 1
                }
            case .射手榜:
                guard leagueDetailModel.leagueShooter != nil else { return 0}
                guard leagueDetailModel.leagueShooter.leagueShooterInfoList.count > 0 else { return 0 }
                return leagueDetailModel.leagueShooter.leagueShooterInfoList.count + 1 
            case .赛程安排:
                if section == 1 { return 0 }
                
                switch courseStyle {
                case .showTab:
                    return 1
                case .showData:
                    if section == 2 { return 0 }
                    return leagueDetailModel.matchGroupData.matchTurnGroupList[groupSelectIndex].groupDTOList[section - 3].futureMatchDTOList.count + 1
                }

            case .球队资料:
                return leagueDetailModel.leagueTeam != nil ? 1 : 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return initLeagueDetailCell(indexPath: indexPath)
        default:
            switch style {
            case .积分榜:
                return initLeagueScoreCell(indexPath: indexPath)
            case .射手榜:
                return initLeagueShooterCell(indexPath: indexPath)
            case .赛程安排:
                
                switch courseStyle {
                case .showTab:
                    return initLeagueCourseTabCell(indexPath: indexPath)
                case .showData:
                    return initLeagueMatchCell(indexPath: indexPath)
                }
                
            case .球队资料:
                return initLeagueTeamCell(indexPath: indexPath)
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch style {
        case .积分榜:
            
            guard let model = leagueDetailModel.leagueScore else { return nil }
            
            switch model.matchType {
            case "0": // 杯赛
                switch section {
                case 0:
                    return nil
                case 1:
                    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: LeagueDetailPagerHeader.identifier) as! LeagueDetailPagerHeader
                    header.delegate = self
                    header.configure(with: self.style)
                    return header
                default:
                    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: LeagueDetailScoreHeader.identifier) as! LeagueDetailScoreHeader
                    header.configure(with: model.matchScoreDTOList[section - 2].groupName)
                    return header
                }
            case "1": // 联赛
                switch section {
                case 1:
                    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: LeagueDetailPagerHeader.identifier) as! LeagueDetailPagerHeader
                    header.delegate = self
                    header.configure(with: self.style)
                    return header
                case 2:
                    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: LeagueDetailScorePagerHeader.identifier) as! LeagueDetailScorePagerHeader
                    header.delegate = self
                    header.configure(with: self.scoreStyle)
                    return header
                default:
                    return nil
                }
            default : return nil
            }
            
        case .赛程安排:
            
            guard let model = leagueDetailModel.matchGroupData else { return nil }
            
            switch section {
            case 0:
                return nil
            case 1:
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: LeagueDetailPagerHeader.identifier) as! LeagueDetailPagerHeader
                header.delegate = self
                header.configure(with: self.style)
                return header
            case 2:
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: LeagueDetailCourseHeader.identifier) as! LeagueDetailCourseHeader
                header.delegate = self
                if courseViewModel != nil {
                     _ = courseViewModel.showTitle.asObserver()
                        .subscribe { (event) in
                            guard let title = event.element else { return }
                            
                            header.titleButton.setTitle(title, for: .normal)
                    }
                }
                return header
                
            default :
                
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: LeagueDetailScoreHeader.identifier) as! LeagueDetailScoreHeader
                header.configure(with: model.matchTurnGroupList[groupSelectIndex].groupDTOList[section - 3].groupName)
                return header
              
            }
        default :
            switch section {
            case 1:
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LeagueDetailPagerHeader") as! LeagueDetailPagerHeader
                header.delegate = self
                header.configure(with: self.style)
                return header
            default:
                return nil
            }
        }
    }
    private func initLeagueDetailCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueMatchDetailCell", for: indexPath) as! LeagueMatchDetailCell
        cell.delegate = self
        cell.configure(with: self.leagueDetailModel, style: self.titleStyle)
        
        let strHeight = leagueDetailModel.leagueRule.heightForComment(fontSize: 12, width: screenWidth - 160)
        
        if strHeight < 50 {
            cell.detailButton.isHidden = true
        }else {
            cell.detailButton.isHidden = false
        }
        
        return cell
    }
    private func initLeagueScoreCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueDetailScoreCell", for: indexPath) as! LeagueDetailScoreCell
        
        switch indexPath.row {
        case 0:
            cell.topLine.isHidden = false
            
            cell.configure(with: leagueDetailModel.leagueScore.matchScoreDTOList[0].leagueCcoreList[indexPath.row], style: .title)
            
        default:
            cell.topLine.isHidden = true
            
            switch scoreStyle {
            case .总积分:
                cell.configure(with: self.leagueDetailModel.leagueScore.matchScoreDTOList[0].leagueCcoreList[indexPath.row - 1], style: .data)
            case .主场积分:
                if leagueDetailModel.leagueScore.matchScoreDTOList.count > 1 {
                    cell.configure(with: self.leagueDetailModel.leagueScore.matchScoreDTOList[1].leagueCcoreList[indexPath.row - 1], style: .data)
                }
            case .客场积分:
                if leagueDetailModel.leagueScore.matchScoreDTOList.count > 2 {
                    cell.configure(with: self.leagueDetailModel.leagueScore.matchScoreDTOList[2].leagueCcoreList[indexPath.row - 1], style: .data)
                }
            }
        }
        
        return cell
    }
    private func initLeagueShooterCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueDetailShooterCell", for: indexPath) as! LeagueDetailShooterCell
        switch indexPath.row {
        case 0:
            cell.configure(with: self.leagueDetailModel.leagueShooter.leagueShooterInfoList[indexPath.row], style: .title)
            cell.topLine.isHidden = false
        default:
            cell.topLine.isHidden = true
            cell.configure(with: self.leagueDetailModel.leagueShooter.leagueShooterInfoList[indexPath.row - 1], style: .defau)
        }
        return cell
    }
    
    private func initLeagueCourseTabCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueDetailCourseTabCell", for: indexPath) as! LeagueDetailCourseTabCell
        //cell.viewModel = courseViewModel
        
        cell.configure(with: courseViewModel)
        return cell
    }
    
    private func initLeagueMatchCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueDetailCourseCell", for: indexPath) as! LeagueDetailCourseCell
        
        switch indexPath.row {
        case 0:
            cell.topLine.isHidden = false
            cell.configure(with: leagueDetailModel.matchGroupData.matchTurnGroupList[groupSelectIndex].groupDTOList[indexPath.section - 3].futureMatchDTOList[indexPath.row],
                           style: .title)
        default:
            cell.topLine.isHidden = true
            cell.configure(with: leagueDetailModel.matchGroupData.matchTurnGroupList[groupSelectIndex].groupDTOList[indexPath.section - 3].futureMatchDTOList[indexPath.row - 1],
                           style: .defau)
        }
        
        
        
        return cell
    }
    private func initLeagueTeamCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueDetailTeamCell", for: indexPath) as! LeagueDetailTeamCell
        cell.delegate = self
        cell.configure(with: self.leagueDetailModel.leagueTeam)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch titleStyle {
            case .hide:
                return 180
            case .show:
                return UITableViewAutomaticDimension
            }
        default:
            
            switch style {
            case .积分榜:
                return 30 * defaultScale
            case .射手榜:
                return 40 * defaultScale
            case .赛程安排:
                switch courseStyle {
                case .showData:
                    return 40 * defaultScale
                case .showTab:
                    guard courseViewModel != nil else { return 0 }
                    let count = CGFloat( lineNumber(totalNum: courseViewModel.list.count, horizonNum: 4))
                    return 10 + (LeagueDetailCourseTabItem.height + 10) * count
                }
                
            case .球队资料:
                guard leagueDetailModel.leagueTeam.leagueTeamInfoDTOList.count != 0 else { return 0 }
                let count = lineNumber(totalNum: leagueDetailModel.leagueTeam.leagueTeamInfoDTOList.count,
                                       horizonNum: 4)
                
                if count == 0 {
                    return 135
                }else {
                    return CGFloat(count * 135)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch style {
        case .积分榜:
            
            guard let model = leagueDetailModel.leagueScore else { return 0.01 }
            
            switch model.matchType {
            case "0": // 杯赛
                switch section {
                case 0:
                    return 0.01
                case 1:
                    return 50
                default:
                    return 45
                }
            case "1": // 联赛
                switch section {
                case 1:
                    return 50
                case 2:
                    return 50
                default:
                    return 0.01
                }
            default : return 0.01
            }
            
        case .赛程安排:
            
            switch section {
            case 0:
                return 0.01
            case 1:
                return 50
            case 2:
                guard let model = leagueDetailModel.matchGroupData else { return 0.01 }
                guard model.matchTurnGroupList.isEmpty == false else { return 0.01 }
                
                let groupType = model.matchTurnGroupList[groupSelectIndex].groupType
                switch groupType {
                case "0":
                    return 35
                case "1":
                    return 30
                default :
                    return 0.01
                }
            default:
                guard let model = leagueDetailModel.matchGroupData else { return 0.01 }
                guard model.matchTurnGroupList.isEmpty == false else { return 0.01 }
                
                let groupType = model.matchTurnGroupList[groupSelectIndex].groupType
                switch groupType {
                case "0":
                    return 0.01
                case "1":
                    return 45
                default :
                    return 45
                }
              
            }
        default:
            switch section {
            case 1:
                return 50
            default:
                return 0.01
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
