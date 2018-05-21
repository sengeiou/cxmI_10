//
//  FootballMatchInfoProtocol.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation


protocol FootballMatchInfoProtocol {
    
}

extension FootballMatchInfoProtocol where Self : FootballMatchInfoVC {
    func matchInfoRequest(matchId: String) {
        
        weak var weakSelf = self
        
        _ = homeProvider.rx.request(.matchTeamInfo(matchId: matchId))
            .asObservable()
            .mapObject(type: FootballMatchInfoModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.matchInfoModel = data
            }, onError: { (error) in
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
}
