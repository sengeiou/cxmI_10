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

class CXMMLeagueMatchDetailVC: BaseViewController {
    
    public var leagueInfo : LeagueInfoModel! {
        didSet{
            guard leagueInfo != nil else { return }
            
            self.navigationItem.title = leagueInfo.leagueAddr
        }
    }
    
    private var style : LeagueDetailStyle = .射手榜
    
    @IBOutlet weak var tableView: UITableView!
    
    private var leagueDetailModel : LeagueDetailModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initSubview()
        
        loadNewData()
    }

    private func initSubview() {
        self.tableView.estimatedRowHeight = 100
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
        
        _ = surpriseProvider.rx.request(.leagueDetail(leagueId: leagueInfo.leagueId))
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
                return leagueDetailModel.leagueShooter != nil ?
                    leagueDetailModel.leagueShooter.leagueShooterInfoList.count + 1 : 0
            case .赛程安排:
                return leagueDetailModel.leagueMatch != nil ?
                leagueDetailModel.leagueMatch.futureMatchDTOList.count : 0
                
            case .球队资料:
                return leagueDetailModel.leagueTeam != nil ?
                leagueDetailModel.leagueTeam.leagueTeamInfoDTOList.count : 0
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueMatchDetailCell", for: indexPath) as! LeagueMatchDetailCell
        cell.configure(with: self.leagueDetailModel)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableViewAutomaticDimension
        default:
            
            switch style {
            case .积分榜:
                return 40 * defaultScale
            case .射手榜:
                return 40 * defaultScale
            case .赛程安排:
                return 40 * defaultScale
            case .球队资料:
                return 40 * defaultScale
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
