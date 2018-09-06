//
//  CXMMTeamDetailVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        
        tableView.headerRefresh {
            self.loadNewData()
        }
        tableView.beginRefreshing()
    }

    private func setData() {
        
    }
    
    private func initSubview() {
        tableView.separatorStyle = .none
        
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

extension CXMMTeamDetailVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMTeamDetailVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        switch style {
        case .球员名单:
            break
        case .近期战绩:
            break
        case .未来赛事:
            break
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
    
    private func initMemberCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamDetailMemberCell", for: indexPath) as! TeamDetailMemberCell
        
        return cell
    }
    private func initRecoreCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamDetailRecordCell", for: indexPath) as! TeamDetailRecordCell
        
        return cell
    }
    private func initFutureCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamDetailFutureCell", for: indexPath) as! TeamDetailFutureCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        switch style {
        case .球员名单:
            break
        case .近期战绩:
            break
        case .未来赛事:
            break
        }
    }
    
}

