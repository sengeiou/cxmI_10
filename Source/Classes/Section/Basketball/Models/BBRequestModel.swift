//
//  BBRequestModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

import HandyJSON

struct BasketballRequestMode : HandyJSON {
    /// 该场次的玩法  几串几
    var betType: String!
    var bonusId: String!
    /// 彩票种类
    var lotteryClassifyId: String!
    /// 彩票玩法类别，
    var lotteryPlayClassifyId: String!
    
    var matchBetPlays: [BBMatchBetPlay]!
    
    /// 玩法 胜平负，让球胜平负 等
    var playType: String!
    /// 倍数
    var times: String!
}

struct BBMatchBetPlay: HandyJSON {
    var changci: String!
    var changciId: String!
//    var isDan: Bool! = false
    var isDan: Int!
    var lotteryClassifyId: String!
    var lotteryPlayClassifyId: String!
    var matchId: Int!
    /// 投注场次队名,如：中国VS日本 ,
    var matchTeam: String!
    /// 比赛时间
    var matchTime: Int!
    /// 投注赛事编码 ,
    var playCode: String!

    var matchBetCells: [BBMatchBetCell]!
}

struct BBMatchBetCell: HandyJSON {
    var betCells: [BBCellModel]!
    var playType : String!
    var single: Bool!
    var fixedOdds : String!
}

struct BBBetCell : HandyJSON {
    var cellName : String = ""
    var cellCode : String = ""
    var cellOdds : String = ""
}
