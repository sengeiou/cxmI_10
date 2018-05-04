//
//  FootballProtocol.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation


protocol FootballCellProtocol: FootballSPFCellDelegate, FootballRangSPFCellDelegate, FootballTotalCellDelegate, FootballScoreCellDelegate, FootballBanQuanCCellDelegate, Football2_1CellDelegate, FootballHunheCellDelegate{
    
}

protocol FootballRequestPro {
    
}

extension FootballRequestPro where Self: FootballMatchVC {
    func footballRequest(leagueId: String) {
        
        switch matchType {
        case .胜平负:
            request(type: "2", leagueId: leagueId)
        case .让球胜平负:
            request(type: "1", leagueId: leagueId)
        case .总进球:
            request(type: "4", leagueId: leagueId)
        case .比分:
            request(type: "3", leagueId: leagueId)
        case .半全场:
            request(type: "5", leagueId: leagueId)
        case .二选一:
            request(type: "7", leagueId: leagueId)
        case .混合过关:
            request(type: "6", leagueId: leagueId)
        }
    }
    
    private func request(type: String, leagueId: String) {
        
        weak var weakSelf = self
        _ = homeProvider.rx.request(.matchList(playType: type, leagueId: leagueId))
            .asObservable()
            .mapObject(type: FootballMatchData.self)
            .subscribe(onNext: { (data) in
                
                print(data)
                weakSelf?.matchData = data
                weakSelf?.matchList = data.playList
                
                if data.hotPlayList.count > 0 {
                    let footb = FootballMatchModel()
                    footb.playList = data.hotPlayList
                    footb.title = "热门赛事"
                    weakSelf?.matchList.insert(footb, at: 0)
                }
                self.topView.number = data.allMatchCount
                //self.dismissProgressHud()
                DispatchQueue.main.async {
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
    
    func filterRequest() {
        self.showProgressHUD()
        weak var weakSelf = self
        _ = homeProvider.rx.request(.filterMatchList)
            .asObservable()
            .mapArray(type: FilterModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.filterList = data
                self.dismissProgressHud()
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
                    
                    if 30000...31000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil, onDisposed: nil )
    }
}








