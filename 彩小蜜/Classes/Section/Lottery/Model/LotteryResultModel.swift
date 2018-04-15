//
//  LotteryResultModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import HandyJSON

struct LotteryResultModel : HandyJSON {
    var changci: String!
    var changciId: String!
    var firstHalf: String!
    var homeTeamAbbr: String!
    var homeTeamId: String!
    var homeTeamName: String!
    var leagueAddr: String!
    var leagueName: String!
    var matchId : String!
    var matchSn: String!
    var matchTime: String!
    var showTime: String!
    var visitingTeamAbbr: String!
    var visitingTeamId : String!
    var visitingTeamName: String!
    var whole : String!
}
