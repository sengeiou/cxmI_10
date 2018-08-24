//
//  FootballBetInfoModel.swift
//  彩小蜜
//
//  Created by HX on 2018/4/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

class FootballBetInfoModel : HandyJSON{
    required init() { }
    
    var showMsg : String!
    
    var maxLotteryMoney: Double!
    var betCells: [BetCellModel]!
    var betNum: Int!
    var betType: String!
    var lotteryPrints: [LotteryPrintsModel]!
    var maxBonus: String!
    var minBonus: String!
    var money: String!
    var playType: String!
    var times: String!
    var userBetCellInfos:[BetCellInfoModel]!
}

class BetCellModel: HandyJSON {
    required init() { }
    
    var amount: String!
    var betContent: String!
    var betType: String!
    var playType: String!
    var times: String!
}

class LotteryPrintsModel: HandyJSON {
    required init() { }
    
    var betType: String!
    var issue: String!
    var money: String!
    var playType: String!
    var stakes: String!
    var times: String!
}
class BetCellInfoModel: HandyJSON {
    required init() { }
    
    var changci: String!
    var isDan: String! 
    var lotteryClassifyId: String!
    var lotteryPlayClassifyId: String!
    var matchId: String!
    var matchTeam: String!
    var matchTime: String!
    var ticketData: String!
}
