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
    
    
    
    func orderRequest () {
        //guard self.homeData != nil else { return }
        guard self.betType != nil else { return }
        self.orderReuqest(betType: betType, times: times)
    }
    
    func getRequestModel(betType: String, times: String, bonusId: String) -> FootballRequestMode {
        var requestModel = FootballRequestMode()
        
        requestModel.betType = betType
        requestModel.bonusId = bonusId
        requestModel.lotteryClassifyId = self.classFyId
        requestModel.lotteryPlayClassifyId = self.playclassFyId
        requestModel.playType = self.playclassFyId
        requestModel.times = times
        
        
        var matchBetPlays = [MatchBetPlay]()
        for playInfo in selectPlayList {
            var matchBetCell = MatchBetPlay()
            matchBetCell.changci = playInfo.changci
            matchBetCell.isDan = playInfo.isDan
            matchBetCell.lotteryClassifyId = self.classFyId
            matchBetCell.lotteryPlayClassifyId = self.playclassFyId
            matchBetCell.matchId = playInfo.matchId
            matchBetCell.matchTeam = playInfo.homeTeamAbbr + "VS" + playInfo.visitingTeamAbbr
            matchBetCell.matchTime = playInfo.matchTime
            matchBetCell.playCode = playInfo.playCode
            matchBetCell.changciId = playInfo.changciId
            
            
            var matchBetCells = [FootballMatchBetCell]()
            
            for matchPlay in playInfo.matchPlays {
                var matchBetCell = FootballMatchBetCell()
                
                var betCells = [FootballPlayCellModel]()
                
                if matchPlay.isShow, matchPlay.homeCell != nil, matchPlay.homeCell.isSelected {
                    betCells.append(matchPlay.homeCell)
                }
                if matchPlay.isShow, matchPlay.flatCell != nil, matchPlay.flatCell.isSelected {
                    betCells.append(matchPlay.flatCell)
                }
                if matchPlay.isShow, matchPlay.visitingCell != nil, matchPlay.visitingCell.isSelected {
                    betCells.append(matchPlay.visitingCell)
                }
                
                if matchPlay.isShow, matchPlay.homeCell != nil, matchPlay.homeCell.cellSons.isEmpty == false {
                    for cell in matchPlay.homeCell.cellSons {
                        if cell.isSelected == true {
                            let ce = FootballPlayCellModel()
                            ce.cellCode = cell.cellCode
                            ce.cellName = cell.cellName
                            ce.cellOdds = cell.cellOdds
                            betCells.append(ce)
                        }
                    }
                }
                
                if matchPlay.isShow, matchPlay.flatCell != nil, matchPlay.flatCell.cellSons.isEmpty == false {
                    for cell in matchPlay.flatCell.cellSons {
                        if cell.isSelected == true {
                            let ce = FootballPlayCellModel()
                            ce.cellCode = cell.cellCode
                            ce.cellName = cell.cellName
                            ce.cellOdds = cell.cellOdds
                            betCells.append(ce)
                        }
                    }
                }
                
                if matchPlay.isShow, matchPlay.visitingCell != nil, matchPlay.visitingCell.cellSons.isEmpty == false {
                    for cell in matchPlay.visitingCell.cellSons {
                        if cell.isSelected == true {
                            let ce = FootballPlayCellModel()
                            ce.cellCode = cell.cellCode
                            ce.cellName = cell.cellName
                            ce.cellOdds = cell.cellOdds
                            betCells.append(ce)
                        }
                    }
                }
                
                if matchPlay.isShow, matchPlay.matchCells.isEmpty == false {
                    for cell in matchPlay.matchCells {
                        if cell.isSelected == true {
                            betCells.append(cell)
                        }
                    }
                }
                
                guard betCells.isEmpty == false else { continue }
                matchBetCell.betCells = betCells
                matchBetCell.playType = matchPlay.playType
                matchBetCell.single = matchPlay.single
                
                matchBetCells.append(matchBetCell)
                if matchPlay.fixedOdds != nil {
                    matchBetCell.fixedOdds = String(matchPlay.fixedOdds)
                }else {
                    matchBetCell.fixedOdds = nil
                }
            }
            // 2选1 玩法转换
            if requestModel.playType == "7" {
                
                let mbetCells = matchBetCells
                matchBetCells.removeAll()
                for betCell in mbetCells {
                    //let cell =
                    
                    for cell in betCell.betCells {
                        var matchBetCell = FootballMatchBetCell()
                        var betCells = [FootballPlayCellModel]()
                        let cellc = FootballPlayCellModel()
                        if cell.cellCode == "30" || cell.cellCode == "0" {
                            
                            matchBetCell.playType = "2"
                            cellc.cellCode = "0"
                            cellc.cellName = "客胜"
                            cellc.cellOdds = cell.cellOdds
                        }else if cell.cellCode == "31" || cell.cellCode == "3" {
                            matchBetCell.playType = "2"
                            cellc.cellCode = "3"
                            cellc.cellName = "主胜"
                            cellc.cellOdds = cell.cellOdds
                        }else if cell.cellCode == "32" || cell.cellCode == "3" {
                            matchBetCell.playType = "1"
                            cellc.cellCode = "3"
                            cellc.cellName = "让球主胜"
                            cellc.cellOdds = cell.cellOdds
                        }else if cell.cellCode == "33" || cell.cellCode == "0" {
                            matchBetCell.playType = "1"
                            cellc.cellCode = "0"
                            cellc.cellName = "让球客胜"
                            cellc.cellOdds = cell.cellOdds
                        }
                        
                        betCells.append(cellc)
                        matchBetCell.betCells = betCells
                        matchBetCell.single = betCell.single
                        matchBetCells.append(matchBetCell)
                        
                        if betCell.fixedOdds != nil {
                            matchBetCell.fixedOdds = String(betCell.fixedOdds)
                        }else {
                            matchBetCell.fixedOdds = nil
                        }
                    }
                   
                }
            }
            
            
            matchBetCell.matchBetCells = matchBetCells
            matchBetPlays.append(matchBetCell)
        }
        
        requestModel.matchBetPlays = matchBetPlays
        if requestModel.playType == "7" {
            requestModel.playType = "6"
        }
        
        let xxx = requestModel.toJSONString()
        
        //NSLog(xxx!)
        print(xxx!)
        return requestModel
    }
    
    private func orderReuqest(betType: String, times: String) {
        guard selectPlayList.isEmpty == false else { return }
        
        if selectPlayList.count == 1 {
            let play = selectPlayList[0]
            if play.matchPlays.count == 1 {
                guard selectPlayList[0].matchPlays[0].single == true else {
                    showHUD(message: "您还需要再选择一场比赛")
                    return }
            }else {
                guard play.matchPlays.count == 5 else { return }
                guard play.matchPlays[0].single == true ||
                    play.matchPlays[1].single == true ||
                    play.matchPlays[2].single == true ||
                    play.matchPlays[3].single == true ||
                    play.matchPlays[4].single == true else {
                        showHUD(message: "您还需要再选择一场比赛")
                        return }
            }
        }
        
        let requestModel = getRequestModel(betType: betType, times: times, bonusId: "")
        self.showProgressHUD()
        self.view.isUserInteractionEnabled = false
        weak var weakSelf = self
        _ = homeProvider.rx.request(.getBetInfo(requestModel: requestModel))
            .asObservable()
            .mapObject(type: FootballBetInfoModel.self)
            .subscribe(onNext: { (data) in
                self.view.isUserInteractionEnabled = true
                self.dismissProgressHud()
                weakSelf?.betInfo = data
               
                if (data.showMsg == nil || data.showMsg == "") && (data.maxLotteryMoney <= 20000 && data.betNum <= 10000 && data.betNum >= 0) {
                    weakSelf?.canPush = true
                }else {
                    weakSelf?.canPush = false
                    weakSelf?.showMsg = data.showMsg
                    weakSelf?.showHUD(message: data.showMsg)
                }
                
            }, onError: { (error) in
                self.view.isUserInteractionEnabled = true
                self.dismissProgressHud()
                weakSelf?.canPush = false
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
                    self.showMsg = msg
                default: break
                }
            }, onCompleted: nil, onDisposed: nil)
    }
}
