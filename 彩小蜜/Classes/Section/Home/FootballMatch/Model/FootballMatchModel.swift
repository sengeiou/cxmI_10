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
    
 
    var changci: String!
    var changciId: String!
    var isDan : Bool! = false
    var homeTeamAbbr: String!
    var homeTeamId: String!
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
    var visitingTeamRank: String!
    var matchPlays : [FootballMatchPlay]!
    
    //var isSelected : Bool! = false
    var selectedScore : [SonCellModel]!
    var selectedBan : [FootballPlayCellModel]!
    var selectedHunhe : [FootballPlayCellModel]!
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
    
}

class FootballPlayCellModel:NSObject, HandyJSON {
    required override init() { }
    var isSelected = false
    var cellCode: String!
    var cellName: String!
    var cellOdds: String!
    var cellSons: [SonCellModel]!
}

class SonCellModel: NSObject, HandyJSON {
    required override init() { }
    var isSelected = false
    var cellCode: String!
    var cellName: String!
    var cellOdds: String!
}


