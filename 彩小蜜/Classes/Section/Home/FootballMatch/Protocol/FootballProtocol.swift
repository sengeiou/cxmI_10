//
//  FootballProtocol.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation


protocol FootballRequestPro {
    
}

extension FootballRequestPro where Self: FootballMatchVC {
    func footballRequest() {
        switch matchType {
        case .胜平负:
            request(type: "1")
        case .让球胜平负:
            request(type: "")
        case .总进球:
            request(type: "")
        case .比分:
            request(type: "")
        case .半全场:
            request(type: "")
        case .二选一:
            request(type: "")
        case .混合过关:
            request(type: "")
        }
    }
    
    private func request(type: String) {
        weak var weakSelf = self
        _ = homeProvider.rx.request(.matchList(playType: type))
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
                self.topView.number = data.playList.count
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    
}
