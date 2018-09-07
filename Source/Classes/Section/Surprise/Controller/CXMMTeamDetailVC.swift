//
//  CXMMTeamDetailVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum TeamCellStyle  {
    case title
    case data
}

class CXMMTeamDetailVC: BaseViewController {

    public var teamId : String!
    
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var teamIcon : UIImageView!
    @IBOutlet weak var teamName : UILabel!
    @IBOutlet weak var teamTitle : UILabel!
    @IBOutlet weak var teamFoundingTime : UILabel! //成立时间
    @IBOutlet weak var teamRegion : UILabel! // 国家地区
    @IBOutlet weak var teamCity : UILabel! // 所在城市
    @IBOutlet weak var teamStadium : UILabel! // 球场
    @IBOutlet weak var teamStadiumCapacity : UILabel! // 球场容量
    @IBOutlet weak var teamValue : UILabel! // 球队价值
  
    private var style : TeamDetailStyle = .球员名单
    
    private var teamDetail : TeamDetailModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        
        tableView.headerRefresh {
            self.loadNewData()
        }
        tableView.beginRefreshing()
    }

    private func setData() {
        guard let model = self.teamDetail else { return }
        
        teamName.text = model.teamAddr
        teamFoundingTime.text = model.teamTime
        teamRegion.text = model.contry
        teamCity.text = model.city
        teamStadium.text = model.court
        teamStadiumCapacity.text = model.teamCapacity
        teamValue.text = model.teamValue
        
        if let url = URL(string: model.teamPic) {
            teamIcon.kf.setImage(with: url, placeholder: nil , options: nil , progressBlock: nil) { (image, error, type , url) in
                if let ima = image {
                    let size = ima.scaleImage(image: ima, imageLength: 80)
                    self.teamIcon.snp.remakeConstraints({ (make) in
                        make.top.equalTo(16)
                        make.centerY.equalTo(0)
                        make.size.equalTo(size)
                    })
                }
            }
        }
    }
    
    private func initSubview() {
        if #available(iOS 11.0, *) {
            
        }else {
            tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 49, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        tableView.separatorStyle = .none
        tableView.register(TeamDetailPagerHeader.self,
                           forHeaderFooterViewReuseIdentifier: TeamDetailPagerHeader.identifier)
        tableView.register(TeamDetailRecordHeader.self,
                           forHeaderFooterViewReuseIdentifier: TeamDetailRecordHeader.identifier)
    }
}

extension CXMMTeamDetailVC {
    private func loadNewData() {
        teamDetailRequest()
    }
    private func teamDetailRequest() {
        weak var weakSelf = self
        
        _ = surpriseProvider.rx.request(.teamDetail(teamId: teamId))
            .asObservable()
            .mapObject(type: TeamDetailModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.tableView.endrefresh()
                weakSelf?.teamDetail = data
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
extension CXMMTeamDetailVC : TeamDetailPagerHeaderDelegate {
    func didSelectHeaderPagerItem(style: TeamDetailStyle) {
        self.style = style
        self.tableView.reloadData()
    }
}
extension CXMMTeamDetailVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMTeamDetailVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch style {
        case .近期战绩:
            return 2
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard teamDetail != nil else { return 0 }
        
        switch style {
        case .球员名单:
            guard teamDetail.playerlist != nil else { return 0 }
            
           // return lineNumber(totalNum: teamDetail.playerlist.playerList.count, horizonNum: 2)
            return 0
        case .近期战绩:
            switch section {
            case 0:
                return 0
            case 1:
                guard teamDetail.recentRecord != nil else { return 0 }
                return teamDetail.recentRecord.recentRecordList.count + 1
            default : return 0
            }
            
        case .未来赛事:
            guard teamDetail.futureMatch != nil else { return 0 }
            return teamDetail.futureMatch.matchInfoFutureList.count + 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch style {
        case .球员名单:
            return initMemberCell(indexPath: indexPath)
        case .近期战绩:
            return initRecoreCell(indexPath: indexPath)
        case .未来赛事:
            return initFutureCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                TeamDetailPagerHeader.identifier) as! TeamDetailPagerHeader
            header.delegate = self
            return header
        default:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                TeamDetailRecordHeader.identifier) as! TeamDetailRecordHeader
            header.configure(with: teamDetail.recentRecord)
            return header
        }
        
    }
    
    private func initMemberCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamDetailMemberCell", for: indexPath) as! TeamDetailMemberCell
//        cell.configure(with: teamDetail.playerlist.playerList[indexPath.row],
//                       infoTwo: teamDetail.playerlist.playerList[indexPath.row + 1])
        return cell
    }
    private func initRecoreCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamDetailRecordCell", for: indexPath) as! TeamDetailRecordCell
        switch indexPath.row {
        case 0:
            cell.configure(with: teamDetail.recentRecord.recentRecordList[indexPath.row], homeMatch: teamDetail.recentRecord.homeTeam,
                           style: .title)
        default:
            cell.configure(with: teamDetail.recentRecord.recentRecordList[indexPath.row - 1], homeMatch: teamDetail.recentRecord.homeTeam,
                           style: .data)
        }
        
        return cell
    }
    private func initFutureCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamDetailFutureCell", for: indexPath) as! TeamDetailFutureCell
        switch indexPath.row {
        case 0:
            cell.configure(with: teamDetail.futureMatch.matchInfoFutureList[indexPath.row], style: .title)
        default:
            cell.configure(with: teamDetail.futureMatch.matchInfoFutureList[indexPath.row - 1], style: .data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch style {
        case .球员名单:
            return 80
        case .近期战绩:
            return 40
        case .未来赛事:
            return 40
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50
        case 1:
            return 40
        default:
            return 0.01
        }
    }
    
}

