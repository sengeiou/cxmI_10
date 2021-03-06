//
//  FootballMatchModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON
class FootballMatchData :NSObject, HandyJSON {
    required override init() { }
    
    var allMatchCount: String!
    var playList: [FootballMatchModel]!
    var hotPlayList: [FootballPlayListModel]!
    var leagueInfos: [FilterModel]!
    var lotteryClassifyId: String!
    var lotteryPlayClassifyId: String!
}

class FootballMatchModel:NSObject, HandyJSON {
    var isSpreading : Bool! = true
    var playList: [FootballPlayListModel]!
    var matchDay: String!
    var title: String!
    var allMatchCount: Int!
    
    required override init() {
        
    }
}

class FootballPlayListModel:NSObject, HandyJSON {
    required override init() { }
    
    /// 是否停售
    var isShutDown : Bool! = false
    var changci: String!
    var changciId: String!
    var isDan : Bool! = false
    var homeTeamAbbr: String!
    var homeTeamId: String!
    /// 排名
    var homeTeamRank: String!
    var isHot : Bool!
    var leagueAddr: String!
    var leagueId: String!
    var leagueName: String!
    var matchDay: String!
    var matchTime: Int!
    var betEndTime : Int!
    var matchId: String!
    var playCode: String!
    var playContent: String!
    var playType: String!
    var visitingTeamAbbr: String!
    var visitingTeamId: String!
    var visitingTeamName: String!
    /// 排名
    var visitingTeamRank: String!
    var matchPlays : [FootballMatchPlay]!
    
    //var isSelected : Bool! = false
//    var selectedScore : [FootballPlayCellModel]!
//    var selectedBan : [FootballPlayCellModel]!
    var selectedHunhe : [FootballPlayCellModel] = [FootballPlayCellModel]()

}

class FootballMatchPlay : NSObject, HandyJSON {
    required override init() { }
    
    var fixedOdds: Int!
    var flatCell: FootballPlayCellModel!
    var homeCell: FootballPlayCellModel!
    var visitingCell: FootballPlayCellModel!
    var matchCells : [FootballPlayCellModel]!
    var playContent: String!
    var playType: String!
    /// 单关，1-单关，0不可以 
    var single: Bool!
    var isShow: Bool!
}

class FootballPlayCellModel: NSObject, NSCopying, HandyJSON {
    func copy(with zone: NSZone? = nil) -> Any {
        let model = FootballPlayCellModel()
        model.isSelected = isSelected
        model.cellCode = cellCode
        model.cellName = cellName
        model.cellOdds = cellOdds
        model.cellSons = cellSons
        model.isRang = isRang
        return model
    }
    
    required override init() { }
    var isSelected = false 
    var cellCode: String!
    var cellName: String!
    var cellOdds: String!
    var cellSons: [FootballPlayCellModel]!
    var isRang = false
}




