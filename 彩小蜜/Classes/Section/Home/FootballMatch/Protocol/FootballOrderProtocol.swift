//
//  FootballOrderProtocol.swift
//  彩小蜜
//
//  Created by HX on 2018/4/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation


protocol FootballOrderProtocol { }

extension FootballOrderProtocol where Self: FootballOrderConfirmVC {
    func orderReuqest(betType: String, times: String) {
       
        
        var requestModel = FootballRequestMode()
        
        requestModel.betType = betType
        requestModel.lotteryClassifyId = homeData.lotteryId
        
        var matchBetCells = [FootballMatchBetCellReq]()
        for playInfo in selectPlayList {
            var matchBetCell = FootballMatchBetCellReq()
            var betCells = [FootballPlayCellModel]()
            betCells.append(playInfo.homeCell)
            betCells.append(playInfo.flatCell)
            betCells.append(playInfo.visitingCell)
            
            matchBetCell.betCells = betCells
            matchBetCell.changci = playInfo.changci
            matchBetCell.isDan = playInfo.isDan
            matchBetCell.lotteryClassifyId = homeData.lotteryId
            matchBetCell.lotteryPlayClassifyId = homeData.playClassifyId
            matchBetCell.matchId = playInfo.matchId
            matchBetCell.matchTeam = playInfo.homeCell.cellName + "VS" + playInfo.visitingCell.cellName
            matchBetCell.matchTime = playInfo.matchTime
            matchBetCell.playCode = playInfo.playCode
            matchBetCell.playType = homeData.playType
            
            matchBetCells.append(matchBetCell)
        }
        
        requestModel.matchBetCells = matchBetCells
        requestModel.playType = homeData.playType
        requestModel.times = times
        
        
        _ = homeProvider.rx.request(.getBetInfo(requestModel: requestModel))
            .asObservable()
            .mapObject(type: FootballBetInfoModel.self)
            .subscribe(onNext: { (data) in
                
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil)
    }
}
