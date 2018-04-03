//
//  FootballMatchModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON
class FootballMatchData : HandyJSON {
    required init() { }
    
    var allMatchCount: String!
    var playList: [FootballMatchModel]!
    var hotPlayList: [FootballPlayListModel]!
    
}

class FootballMatchModel: HandyJSON {
    var isSpreading : Bool! = true
    var playList: [FootballPlayListModel]!
    var matchDay: String!
    var title: String!
    var allMatchCount: Int!
    
    required init() {
        
    }
}

class FootballPlayListModel:NSObject, HandyJSON {
    required override init() { }
    
    var changci: String!
    var changciId: String!
    var flatCell: FootballPlayCellModel!
    var homeCell: FootballPlayCellModel!
    var visitingCell: FootballPlayCellModel!
    var homeTeamAbbr: String!
    var homeTeamId: String!
    var homeTeamRank: String!
    var isHot : Bool!
    var leagueAddr: String!
    var leagueId: String!
    var leagueName: String!
    var matchDay: String!
    var matchTime: String!
    var playCode: String!
    var playContent: String!
    var playType: String!
    var visitingTeamAbbr: String!
    var visitingTeamId: String!
    var visitingTeamName: String!
    var visitingTeamRank: String!
    
    
}

class FootballPlayCellModel: HandyJSON {
    required init() { }
    var isSelected = false
    var cellCode: String!
    var cellName: String!
    var cellOdds: String!
}




