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
    
    private var style : LeagueDetailStyle = .射手榜
    private var titleStyle : LeagueDetailTitleStyle = .hide
    @IBOutlet weak var tableView: UITableView!
    
    
    
    private var leagueDetailModel : LeagueDetailModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initSubview()
        
        loadNewData()
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
        
    }

}

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

extension CXMMLeagueMatchDetailVC : LeagueDetailPagerHeaderDelegate {
    func didSelectHeaderPagerItem(style: LeagueDetailStyle) {
        self.style = style
        self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
}

extension CXMMLeagueMatchDetailVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMLeagueMatchDetailVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard leagueDetailModel != nil else { return 0 }
       
        switch section {
        case 0:
            return 1
        default:
            switch style {
            case .积分榜:
                break
            case .射手榜:
                guard leagueDetailModel.leagueShooter != nil else { return 0}
                guard leagueDetailModel.leagueShooter.leagueShooterInfoList.count > 0 else { return 0 }
                return leagueDetailModel.leagueShooter.leagueShooterInfoList.count + 1 
            case .赛程安排:
                return leagueDetailModel.leagueMatch != nil ?
                leagueDetailModel.leagueMatch.futureMatchDTOList.count : 0
                
            case .球队资料:
                return leagueDetailModel.leagueTeam != nil ? 1 : 0
            }
            return 0
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
                return initLeagueMatchCell(indexPath: indexPath)
            case .球队资料:
                return initLeagueTeamCell(indexPath: indexPath)
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
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
    private func initLeagueDetailCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueMatchDetailCell", for: indexPath) as! LeagueMatchDetailCell
        cell.delegate = self
        cell.configure(with: self.leagueDetailModel)
        return cell
    }
    private func initLeagueScoreCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueMatchDetailCell", for: indexPath) as! LeagueMatchDetailCell
        cell.configure(with: self.leagueDetailModel)
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
    private func initLeagueMatchCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueDetailCourseCell", for: indexPath) as! LeagueDetailCourseCell
        
        switch indexPath.row {
        case 0:
            cell.topLine.isHidden = false
            cell.configure(with: self.leagueDetailModel.leagueMatch.futureMatchDTOList[indexPath.row],
                           style: .title)
        default:
            cell.topLine.isHidden = true
            cell.configure(with: self.leagueDetailModel.leagueMatch.futureMatchDTOList[indexPath.row],
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
                return 40 * defaultScale
            case .射手榜:
                return 40 * defaultScale
            case .赛程安排:
                return 40 * defaultScale
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
        switch section {
        case 1:
            return 50
        default:
            return 0.01
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
