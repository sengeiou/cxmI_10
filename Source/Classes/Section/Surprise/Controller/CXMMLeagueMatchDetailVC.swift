//
//  CXMMLeagueMatchDetailVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMLeagueMatchDetailVC: BaseViewController {
    
    public var leagueInfo : LeagueInfoModel! {
        didSet{
            guard leagueInfo != nil else { return }
            
            self.navigationItem.title = leagueInfo.leagueAddr
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var leagueDetailModel : LeagueDetailModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initSubview()
        
        loadNewData()
    }

    private func initSubview() {
    
    }

}

extension CXMMLeagueMatchDetailVC {
    private func loadNewData() {
        leagueDetailRequest()
    }
    private func leagueDetailRequest() {
        
        weak var weakSelf = self
        
        surpriseProvider.rx.request(.leagueDetail(leagueId: leagueInfo.leagueId))
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

extension CXMMLeagueMatchDetailVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMLeagueMatchDetailVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return initLeagueDetailCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    private func initLeagueDetailCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueMatchDetailCell", for: indexPath) as! LeagueMatchDetailCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableViewAutomaticDimension
        default:
            return 200
        }
    }
    
}
