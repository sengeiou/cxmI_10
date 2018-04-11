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
    
    func getRequestModel(betType: String, times: String, bonusId: String, homeData: HomePlayModel) -> FootballRequestMode {
        var requestModel = FootballRequestMode()
        
        requestModel.betType = betType
        requestModel.bonusId = bonusId
        requestModel.lotteryClassifyId = homeData.lotteryId
        requestModel.lotteryPlayClassifyId = homeData.playClassifyId
        requestModel.playType = playType
        requestModel.times = times
        
        
        var matchBetPlays = [MatchBetPlay]()
        for playInfo in selectPlayList {
            var matchBetCell = MatchBetPlay()
            matchBetCell.changci = playInfo.changci
            matchBetCell.isDan = playInfo.isDan
            matchBetCell.lotteryClassifyId = homeData.lotteryId
            matchBetCell.lotteryPlayClassifyId = homeData.playClassifyId
            matchBetCell.matchId = playInfo.matchId
            matchBetCell.matchTeam = playInfo.homeTeamAbbr + "VS" + playInfo.visitingTeamAbbr
            matchBetCell.matchTime = playInfo.matchTime
            matchBetCell.playCode = playInfo.playCode
            
            var matchBetCells = [FootballMatchBetCell]()
            
            for matchPlay in playInfo.matchPlays {
                var matchBetCell = FootballMatchBetCell()
                
                var betCells = [FootballPlayCellModel]()
                
                if matchPlay.homeCell != nil, matchPlay.homeCell.isSelected {
                    betCells.append(matchPlay.homeCell)
                }
                if matchPlay.flatCell != nil, matchPlay.flatCell.isSelected {
                    betCells.append(matchPlay.flatCell)
                }
                if matchPlay.visitingCell != nil, matchPlay.visitingCell.isSelected {
                    betCells.append(matchPlay.visitingCell)
                }
                
                if matchPlay.matchCells.isEmpty == false {
                    for cell in matchPlay.matchCells {
                        if cell.isSelected == true {
                            betCells.append(cell)
                        }
                    }
                }
                
                matchBetCell.betCells = betCells
                
                matchBetCells.append(matchBetCell)
            }
            
            matchBetCell.matchBetCells = matchBetCells
            matchBetPlays.append(matchBetCell)
        }
       
        requestModel.matchBetPlays = matchBetPlays
        
        return requestModel
    }
    
    func orderRequest () {
        guard self.homeData != nil else { return }
        self.orderReuqest(betType: self.playType, times: times)
    }
    
    private func orderReuqest(betType: String, times: String) {
        guard selectPlayList.isEmpty == false else { return }
        
        if selectPlayList.count == 1 {
            guard selectPlayList[0].matchPlays[0].single == true else {
                showHUD(message: "请选择一场单关或2场以上非单关比赛")
                return }
        }
        
        let requestModel = getRequestModel(betType: betType, times: times, bonusId: "", homeData: self.homeData)
        
        weak var weakSelf = self
        _ = homeProvider.rx.request(.getBetInfo(requestModel: requestModel))
            .asObservable()
            .mapObject(type: FootballBetInfoModel.self)
            .subscribe(onNext: { (data) in
                weakSelf?.betInfo = data
                weakSelf?.canPush = true
            }, onError: { (error) in
                weakSelf?.canPush = false
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showMsg = msg
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil)
    }
}
