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
    
    func getRequestModel(betType: String, times: String, homeData: HomePlayModel) -> FootballRequestMode {
        var requestModel = FootballRequestMode()
        
        requestModel.betType = betType
        requestModel.lotteryClassifyId = homeData.lotteryId
        
        var matchBetCells = [FootballMatchBetCellReq]()
        for playInfo in selectPlayList {
            var matchBetCell = FootballMatchBetCellReq()
            var betCells = [FootballPlayCellModel]()
            
            let matchPlay = playInfo.matchPlays[0]
            
            if matchPlay.homeCell.isSelected == true {
                betCells.append(matchPlay.homeCell)
            }
            if matchPlay.flatCell.isSelected == true {
                betCells.append(matchPlay.flatCell)
            }
            if matchPlay.visitingCell.isSelected == true {
                betCells.append(matchPlay.visitingCell)
            }
            
            matchBetCell.betCells = betCells
            matchBetCell.changci = playInfo.changci
            matchBetCell.isDan = playInfo.isDan
            matchBetCell.lotteryClassifyId = homeData.lotteryId
            matchBetCell.lotteryPlayClassifyId = homeData.playClassifyId
            matchBetCell.matchId = playInfo.matchId
            matchBetCell.matchTeam = matchPlay.homeCell.cellName + "VS" + matchPlay.visitingCell.cellName
            matchBetCell.matchTime = playInfo.matchTime
            matchBetCell.playCode = playInfo.playCode
            matchBetCell.playType = homeData.playType
            
            matchBetCells.append(matchBetCell)
        }
        
        requestModel.matchBetCells = matchBetCells
        requestModel.playType = homeData.playType
        requestModel.times = times
        
        return requestModel
    }
    
    func orderRequest () {
        
        self.orderReuqest(betType: self.playType, times: times)
    }
    
    private func orderReuqest(betType: String, times: String) {
        guard selectPlayList.isEmpty == false else { return }
        
        if selectPlayList.count == 1 {
            guard selectPlayList[0].single == true else {
                showHUD(message: "请选择一场单关或2场以上非单关比赛")
                return }
        }
        
        let requestModel = getRequestModel(betType: betType, times: times, homeData: self.homeData)
        
        weak var weakSelf = self
        _ = homeProvider.rx.request(.getBetInfo(requestModel: requestModel))
            .asObservable()
            .mapObject(type: FootballBetInfoModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.betInfo = data
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
